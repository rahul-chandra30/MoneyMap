# chatbot_logic.py
import sys
from groq_connector import GroqConnector

class Chatbot:
    def __init__(self):
        self.connector = GroqConnector()

    def get_response(self, question, user_id):
        return self.connector.query_agent(question, user_id)

if __name__ == "__main__":
    question = sys.argv[1]
    user_id = int(sys.argv[2])
    bot = Chatbot()
    response = bot.get_response(question, user_id)
    print(response)