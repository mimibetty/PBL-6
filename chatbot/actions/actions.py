# import requests
# from typing import Any, Text, Dict, List
# from rasa_sdk import Action, Tracker
# from rasa_sdk.executor import CollectingDispatcher
# from urllib.parse import quote

# class ActionGetDestinations(Action):
#     def name(self) -> Text:
#         return "action_get_destinations"

#     def normalize_city_name(self, city_name: str) -> str:
#         # Dictionary to normalize city names
#         city_mapping = {
#             'da nang': 'đà nẵng',
#             'danang': 'đà nẵng',
#             'đà nẵng': 'đà nẵng',
#             'ha noi': 'hà nội',
#             'hanoi': 'hà nội',
#             'hà nội': 'hà nội',
#             'ho chi minh': 'hồ chí minh',
#             'saigon': 'hồ chí minh',
#             'sai gon': 'hồ chí minh',
#             'sài gòn': 'hồ chí minh',
#             'hue': 'huế',
#             'huế': 'huế',
#             'nha trang': 'nha trang',
#             'da lat': 'đà lạt',
#             'dalat': 'đà lạt',
#             'đà lạt': 'đà lạt',
#             'vung tau': 'vũng tàu',
#             'vũng tàu': 'vũng tàu',
#             'hoi an': 'hội an',
#             'hội an': 'hội an',
#             'can tho': 'cần thơ',
#             'cần thơ': 'cần thơ',
#             'phu quoc': 'phú quốc',
#             'phú quốc': 'phú quốc',
#             'ha long': 'hạ long',
#             'halong': 'hạ long',
#             'hạ long': 'hạ long'
#         }
#         return city_mapping.get(city_name.lower(), city_name.lower())

#     def run(self, dispatcher: CollectingDispatcher,
#             tracker: Tracker,
#             domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

#         # Print all identified entities
#         print("All entities:", tracker.latest_message.get('entities'))
        
#         city = next(tracker.get_latest_entity_values("city"), None)
#         print("Extracted city:", city)

#         if not city:
#             dispatcher.utter_message(text="Sorry, I couldn't identify the city. Please try again.")
#             return []

#         # Normalize the city name
#         normalized_city = self.normalize_city_name(city)
#         print(f"Normalized city: {normalized_city}")

#         try:
#             # Encode normalized city parameter
#             encoded_city = quote(normalized_city)
#             url = f"http://127.0.0.1:8000/destination/destinations/by-city/{encoded_city}?limit=5"
#             print(f"Calling API URL: {url}")
                    
#             response = requests.get(url)
#             print(f"API Status Code: {response.status_code}")
#             print(f"API Response: {response.text}")
            
#             if response.status_code != 200:
#                 raise Exception(f"API returned status code {response.status_code}")
            
#             destinations = response.json()
            
#             # Debug print destinations
#             for dest in destinations:
#                 print("Destination:", dest)
                
#             if not destinations:
#                 dispatcher.utter_message(text=f"Sorry, I couldn't find any destinations in {normalized_city}")
#                 return []

#             # Format response
#             message = f"Here are the top recommended destinations in {normalized_city}:\n\n"
#             for i, dest in enumerate(destinations, 1):
#                 message += f"{i}. {dest['name']}\n"
#                 message += f"   Rating: {dest['rating']}/5 ({dest['review_count']} reviews)\n"
#                 message += f"   Address: {dest['address']}\n"
#                 message += f"   {dest['description']}\n\n"

#             dispatcher.utter_message(text=message)

#         except requests.exceptions.ConnectionError as e:
#             error_message = f"Could not connect to the API server: {str(e)}"
#             print(error_message)
#             dispatcher.utter_message(text="Sorry, I couldn't connect to the destination service.")
            
#         except Exception as e:
#             print(f"Error: {str(e)}")
#             dispatcher.utter_message(text=f"Sorry, I encountered an error: {str(e)}")
            
#         return []


import requests
from typing import Any, Text, Dict, List, Optional
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from urllib.parse import quote
from unidecode import unidecode
from fuzzywuzzy import fuzz

class ActionGetDestinations(Action):
    def name(self) -> Text:
        return "action_get_destinations"

    def get_cities(self) -> List[Dict[str, str]]:
        """Lấy danh sách thành phố từ API và tạo bản không dấu"""
        try:
            response = requests.post("http://127.0.0.1:8000/city/cities-name")
            # print(response)
            if response.status_code == 200:
                cities = response.json()
                return [
                    {
                        "original": city,
                        "normalized": unidecode(city.lower())
                    }
                    for city in cities
                ]
            return []
        except Exception as e:
            print(f"Error fetching cities: {e}")
            return []

    def find_best_match(self, user_input: str, cities: List[Dict[str, str]], threshold: int = 80) -> Optional[str]:
        """Tìm thành phố khớp nhất với input của user"""
        best_match = None
        highest_score = 0
        normalized_input = unidecode(user_input.lower())

        for city in cities:
            original_score = fuzz.partial_ratio(user_input.lower(), city["original"].lower())
            normalized_score = fuzz.partial_ratio(normalized_input, city["normalized"])
            
            score = max(original_score, normalized_score)
            
            if score > highest_score and score >= threshold:
                highest_score = score
                best_match = city["original"]
        print(f"Best match: {best_match}, Score: {highest_score}")
        # dispatcher.utter_message(text=f"Best match: {best_match}, Score: {highest_score}")

        return best_match

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        
        print("this is :     ",tracker.get_slot("city"))
        # Print all identified entities
        # print("All entities:", tracker.latest_message.get('entities'))
        
        # Lấy city từ entity
        city = next(tracker.get_latest_entity_values("city"), None)
        print("Extracted city  tttttttttttttt:", city)

        # Nếu không có entity city, thử tìm match từ tin nhắn mới nhất
        # if not city:
        user_message = tracker.latest_message.get('text', '')
        print(user_message)
        cities = self.get_cities()
            # if not cities:
            #     dispatcher.utter_message(text="Sorry, I couldn't access the city list at the moment.")
            #     return []
            
        city = self.find_best_match(user_message, cities)

        if not city:
            dispatcher.utter_message(text="Sorry, I couldn't identify the city. Please try again.")
            return []

        print(f"Matched city: {city}")

        try:
                        # Print all entities from latest message
            print("All entities:", tracker.latest_message.get('entities'))
            # Print specific entity values
            for entity in tracker.latest_message.get('entities', []):
                print(f"Entity: {entity['entity']}, Value: {entity['value']}")
            
            # Print all slots and their values
            print("All slots:", tracker.slots)

            # Print specific slot
            print("City slot:", tracker.get_slot('city'))

            # Print all slots in detail
            for slot_name, slot_value in tracker.slots.items():
                print(f"Slot {slot_name}: {slot_value}")



            # Encode city parameter
            encoded_city = quote(city)
            url = f"http://127.0.0.1:8000/destination/destinations/by-city/{encoded_city}?limit=5"
            # print(f"Calling API URL: {url}")
                    
            response = requests.get(url)
            # print(f"API Status Code: {response.status_code}")
            # print(f"API Response: {response.text}")
            
            if response.status_code != 200:
                raise Exception(f"API returned status code {response.status_code}")
            
            destinations = response.json()
            
            # Debug print destinations
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