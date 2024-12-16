# This files contains your custom actions which can be used to run
# custom Python code.

# See this guide on how to implement these action:
# https://rasa.com/docs/rasa/custom-actions


# This is a simple example for a custom action which utters "Hello World!"
import requests
from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from urllib.parse import quote

class ActionGetDestinations(Action):
    def name(self) -> Text:
        return "action_get_destinations"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        # In ra toàn bộ entities được nhận diện
        print("All entities:", tracker.latest_message.get('entities'))
        
        city = next(tracker.get_latest_entity_values("city"), None)
        print("Extracted city:", city)
        dispatcher.utter_message(text="i am here, test city entity {}".format(city))           

        if not city:
            dispatcher.utter_message(text="Sorry, I couldn't identify the city. Please try again.")
            return []

        try:
            # Encode city parameter đúng cách
            encoded_city = quote(city)
            url = f"http://127.0.0.1:8000/destination/destinations/by-city/{encoded_city}?limit=5"
            print(f"Calling API URL: {url}")
                    
            response = requests.get(url)
            print(f"API Status Code: {response.status_code}")
            print(f"API Response: {response.text}")
            
            # Kiểm tra status code
            if response.status_code != 200:
                raise Exception(f"API returned status code {response.status_code}")
            
            destinations = response.json()
            
            # In destinations để debug
            for dest in destinations:
                print("Destination:", dest)
                
            if not destinations:
                dispatcher.utter_message(text=f"Sorry, I couldn't find any destinations in {city}")
                return []

            # Format response
            message = f"Here are the top recommended destinations in {city}:\n\n"
            for i, dest in enumerate(destinations, 1):
                message += f"{i}. {dest['name']}\n"
                message += f"   Rating: {dest['rating']}/5 ({dest['review_count']} reviews)\n"
                message += f"   Address: {dest['address']}\n"
                message += f"   {dest['description']}\n\n"

            dispatcher.utter_message(text=message)

        except requests.exceptions.ConnectionError as e:
            error_message = f"Could not connect to the API server: {str(e)}"
            print(error_message)
            dispatcher.utter_message(text="Sorry, I couldn't connect to the destination service.")
            
        except Exception as e:
            print(f"Error: {str(e)}")
            dispatcher.utter_message(text=f"Sorry, I encountered an error: {str(e)}")
            
        return []
# class ActionHelloWorld(Action):

#     def name(self) -> Text:
#         return "action_hello_world"

#     def run(self, dispatcher: CollectingDispatcher,
#             tracker: Tracker,
#             domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

#         dispatcher.utter_message(text="Hello World!")

#         return []

