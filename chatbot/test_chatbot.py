from chatbot_logic import Chatbot

def test_chatbot_responses():
    bot = Chatbot()
    
    # Test budget query
    print("\nTesting budget query:")
    print("-" * 50)
    response = bot.get_response("What were my expenses in February 2025?", 1)
    print(response)
    
    # Test savings tips
    print("\nTesting savings tips:")
    print("-" * 50)
    response = bot.get_response("Give me savings tips", 1)
    print(response)
    
    # Test general greeting
    print("\nTesting general greeting:")
    print("-" * 50)
    response = bot.get_response("Hi", 1)
    print(response)

if __name__ == "__main__":
    test_chatbot_responses()