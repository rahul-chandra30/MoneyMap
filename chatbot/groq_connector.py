# groq_connector.py

import requests
import sqlite3
from datetime import datetime

class GroqConnector:
    def __init__(self):
        self.api_key = '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'  # Replace with your real key!
        self.api_url = 'https://api.groq.com/openai/v1/chat/completions'

    def query_agent(self, question, user_id):
        question_lower = question.lower()
        print(f"QUESTION: {question}")  # Debug input

        # Define intents with exact keywords
        budget_keywords = ["expense", "expenses", "spending", "budget", "spent", "income"]
        tip_keywords = ["tip", "tips", "saving", "savings"]
        needs_budget = any(kw in question_lower for kw in budget_keywords)
        wants_tip = any(kw in question_lower for kw in tip_keywords) and not needs_budget

        # Budget intent—fetch data
        if needs_budget:
            print("INTENT: Budget")  # Debug
            conn = sqlite3.connect('/Users/rahul/MoneyMap/moneymap/storage/development.sqlite3')
            cursor = conn.cursor()

            # Parse year and month
            year = None
            month = None
            for y in range(2025, 2031):
                if str(y) in question_lower:
                    year = y
                    break
            year = year or 2025

            month_names = {m.lower(): str(i+1) for i, m in enumerate(['january', 'february', 'march', 'april', 'may', 'june', 
                                                                      'july', 'august', 'september', 'october', 'november', 'december'])}
            for m_name, m_num in month_names.items():
                if m_name in question_lower:
                    month = m_num
                    break
            if not month:
                if "last month" in question_lower:
                    current = datetime(2025, 2, 25)
                    last_month = current.month - 1 if current.month > 1 else 12
                    year = current.year if current.month > 1 else current.year - 1
                    month = str(last_month)
                else:
                    month = '2'

            # Fetch expenses
            cursor.execute("SELECT category, amount_spent FROM expenses WHERE user_id = ? AND year = ? AND month = ?", 
                           (user_id, year, month))
            expenses = cursor.fetchall()
            conn.close()

            expense_text = "\n".join([f"{cat}: ₹{amt}" for cat, amt in expenses]) or "No expenses found."
            prompt = f"Answer this budget question in plain English: '{question}'. Data for {month_names.get(month, month)} {year}: {expense_text}. No greetings or extra chat."
            print(f"PROMPT: {prompt}")  # Debug
        # Tip intent—savings tips
        elif wants_tip:
            print("INTENT: Tips")  # Debug
            prompt = f"List 2-3 savings tips in plain English for: '{question}'. No budget data or greetings."
            print(f"PROMPT: {prompt}")  # Debug
        # Casual intent—chat naturally
        else:
            print("INTENT: Casual")  # Debug
            prompt = f"Reply naturally to: '{question}'. No budget data, tips, or offers to help—just a direct response."
            print(f"PROMPT: {prompt}")  # Debug

        # Call Groq API with single user prompt
        response = requests.post(
            self.api_url,
            headers={
                'Authorization': f'Bearer {self.api_key}',
                'Content-Type': 'application/json'
            },
            json={
                'model': 'mixtral-8x7b-32768',
                'messages': [{'role': 'user', 'content': prompt}],
                'max_tokens': 100
            }
        )
        print(f"RESPONSE: {response.status_code} {response.text}")  # Debug
        
        # Return answer
        if response.status_code == 200:
            data = response.json()
            try:
                return data['choices'][0]['message']['content']
            except KeyError:
                return "Error: Bad response format"
        return f"Error: Groq failed - {response.status_code}"

if __name__ == "__main__":
    connector = GroqConnector()
    answer = connector.query_agent("Hi bot", 4)
    print("Answer:", answer)