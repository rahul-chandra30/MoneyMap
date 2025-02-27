# chatbot_logic.py

from groq_connector import GroqConnector
import sys

class Chatbot:
    def __init__(self):
        self.connector = GroqConnector()

    def get_response(self, question, user_id):
        answer = self.connector.query_agent(question, user_id)
        budget_keywords = ["expense", "expenses", "spending", "budget", "spent", "income"]
        if any(kw in question.lower() for kw in budget_keywords):
            tip = " Try saving more next month!"
            return f"{answer}\nSavings Tip:{tip}"
        return answer

if __name__ == "__main__":
    question = sys.argv[1]
    user_id = sys.argv[2]
    bot = Chatbot()
    response = bot.get_response(question, user_id)
    print(response)