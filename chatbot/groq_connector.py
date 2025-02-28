# groq_connector.py
import requests
import sqlite3
import logging
import time

# Setup logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

class GroqConnector:
    def __init__(self):
        self.api_key = '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'
        self.api_url = 'https://api.groq.com/openai/v1/chat/completions'

    def query_agent(self, question, user_id):
        logger.debug(f"Processing question: {question} for user_id: {user_id}")

        # Fetch fresh SQLite data
        conn = sqlite3.connect('/Users/rahul/MoneyMap/moneymap/storage/development.sqlite3', check_same_thread=False)
        cursor = conn.cursor()
        
        # Fetch expenses
        cursor.execute("SELECT category, amount_spent, year, month FROM expenses WHERE user_id = ?", (user_id,))
        expenses = cursor.fetchall()
        expense_text = "\n".join([f"{cat}: ₹{amt} (Year: {yr}, Month: {m})" for cat, amt, yr, m in expenses]) or "No expenses recorded."
        logger.debug(f"Expense text: {expense_text}")
        
        # Fetch expenditures (income) - using 'income' column
        try:
            cursor.execute("SELECT income, year, month FROM expenditures WHERE user_id = ?", (user_id,))
            incomes = cursor.fetchall()
            income_text = "\n".join([f"Income: ₹{amt} (Year: {yr}, Month: {m})" for amt, yr, m in incomes]) or "No income recorded."
        except sqlite3.Error as e:
            logger.error(f"Expenditures query failed: {e}")
            income_text = "No income data available—check expenditures table."
        logger.debug(f"Income text: {income_text}")
        
        # Fetch users and experts count
        cursor.execute("SELECT COUNT(*) FROM users")
        user_count = cursor.fetchone()[0]
        cursor.execute("SELECT COUNT(*) FROM experts")
        expert_count = cursor.fetchone()[0]
        logger.debug(f"Users: {user_count}, Experts: {expert_count}")
        
        conn.close()

        main_prompt = f"""You are a budget assistant for Rahul (User ID {user_id}). Use this fresh SQLite data:
        - Expenses: {expense_text}
        - Income: {income_text}
        - Users in system: {user_count}
        - Experts in system: {expert_count}

        Respond naturally to budget-related sub prompts—keep it concise, personalized, and based on the latest data. Wrap your answer in ### marks internally (e.g., ###Answer###)—no ### in the final output:
        - Greetings (e.g., 'hi', 'hello'): "Hello! How can I help you with your budget today?"
        - Expense queries (e.g., 'expenses', 'spending', or typos like 'epenses'): List matching data as "Category: ₹Amount\nCategory: ₹Amount..."—say "No data found" if none matches; default to Feb 2025 if unspecified.
        - Income queries (e.g., 'income', 'earnings'): List matching income as "Income: ₹Amount"—say "No income recorded" if none.
        - Savings tips (e.g., 'savings', 'tips'): Give 3 tips based on latest patterns (e.g., max spend {max([amt for _, amt, _, _ in expenses]) if expenses else 0}, avg ~₹{int(sum([amt for _, amt, _, _ in expenses]) / len(expenses)) if expenses else 0}).
        - Other budget Qs (e.g., 'total spend'): Analyze data concisely.
        - Non-budget Qs: "Ask me about your budget!"

        Focus on Rahul’s latest spending/income—no extra chatter unless asked.
        """

        logger.debug(f"Main prompt: {main_prompt}")
        logger.debug(f"Sub prompt: {question}")

        retries = 3
        for attempt in range(retries):
            try:
                response = requests.post(
                    self.api_url,
                    headers={
                        'Authorization': f'Bearer {self.api_key}',
                        'Content-Type': 'application/json'
                    },
                    json={
                        'model': 'mixtral-8x7b-32768',
                        'messages': [
                            {'role': 'system', 'content': main_prompt},
                            {'role': 'user', 'content': question}
                        ],
                        'max_tokens': 300,
                        'temperature': 0.7
                    },
                    timeout=10
                )
                logger.debug(f"API response status: {response.status_code}")
                logger.debug(f"API response: {response.text}")

                if response.status_code == 200:
                    data = response.json()
                    content = data['choices'][0]['message']['content']
                    start = content.find('###') + 3
                    end = content.rfind('###')
                    if start > 2 and end > start:
                        return content[start:end].strip()
                    return content.strip()
                elif response.status_code == 429:
                    logger.warning(f"Rate limit hit (429) - Retry {attempt + 1}/{retries}")
                    if attempt < retries - 1:
                        time.sleep(5)  # Wait 5 seconds before retry
                        continue
                    return "I’m getting too many requests—try again in a minute!"
                else:
                    logger.error(f"API failed with status: {response.status_code}")
                    return f"API error: {response.status_code}"
            except requests.RequestException as e:
                logger.error(f"API request failed: {str(e)}")
                return f"API request failed: {str(e)}"
        return "Rate limit exceeded—please wait and retry!"

if __name__ == "__main__":
    connector = GroqConnector()
    answer = connector.query_agent("Expenses in February 2025", 1)
    print("Answer:", answer)