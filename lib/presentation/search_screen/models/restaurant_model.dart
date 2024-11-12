import 'dart:math';

Random random = Random();
class Restaurant {
  String restaurantName;
  int restaurantId;
  String contactNumber;
  String website;
  String time;
  double rating;
  List<String> cuisines;
  List<String> meal;
  List<String> feature;
  String about;
  List<String> images;
  String restaurantLocation;
  int review;
  String priceRange;
  String type;
  String goodFor;
  Restaurant({
    required this.restaurantName,
    required this.restaurantId,
    required this.contactNumber,
    required this.website,
    required this.time,
    required this.rating,
    required this.cuisines,
    required this.meal,
    required this.feature,
    required this.about,
    required this.images,
    required this.restaurantLocation,
    required this.review,
    required this.priceRange,
    required this.type,
    required this.goodFor
  });
}

List<Restaurant> restaurantList = [
  Restaurant(
    restaurantName: "Bếp Cuốn Đà Nẵng",
    restaurantId: 1,
    contactNumber: "0123456789",
    website: "http://bepcuondanang.com",
    time: "10:00 AM - 10:00 PM",
    rating: 4.5,
    cuisines: ["Vietnamese", "Asian"],
    meal: ["Lunch", "Dinner"],
    feature: ["Vegetarian Options", "Outdoor Seating"],
    about: "A famous spot for delicious Vietnamese rolls and traditional dishes.",
    images: [
      "https://haisandathanh.com/uploads/image/images/z3322523752141_01855f72a7e3cc721cfc88e2853aeb2e.jpg",
      "https://media-cdn.tripadvisor.com/media/photo-s/19/5c/1a/c8/excellent-food.jpg",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/aa/9b/16/user-review-upload.jpg?w=1100&h=-1&s=1"

    ],
    restaurantLocation: "31-33 Trần Bạch Đằng, Phước Mỹ, Sơn Trà, Đà Nẵng ",
    review: random.nextInt(300) + 25,
    priceRange: "7.00\$-30.00\$",
    type : "Restaurant",
    goodFor :"Families with children"


  ),
  Restaurant(
    restaurantName: "La Maison 1888",
    restaurantId: 2,
    contactNumber: "0987654321",
    website: "http://lamaison1888.com",
    time: "12:00 PM - 11:00 PM",
    rating: 3.9,
    cuisines: ["French", "European"],
    meal: ["Dinner"],
    feature: ["Fine Dining", "Luxury", "Sea View"],
    about: "One of the top French fine dining restaurants in Asia, located at the InterContinental Danang Sun Peninsula Resort.",
    images: [
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0d/04/3b/49/la-maison-1888-terrace.jpg?w=1800&h=1000&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/1a/c2/e2/caption.jpg?w=1000&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/12/0e/fe/4a/sliced-roasted-challan.jpg?w=1100&h=600&s=1",
    ],
    restaurantLocation: "InterContinental Danang Sun Peninsula Resort, Bãi Bắc, Sơn Trà, Đà Nẵng",
        review: random.nextInt(300) + 25,
    priceRange: "5.00\$-10.00\$",
    type:"Restaurant",
    goodFor : "Large groups"


  ),
  Restaurant(
    restaurantName: "Nhà Hàng Hải Sản Bé Mặn",
    restaurantId: 3,
    contactNumber: "0912345678",
    website: "http://besanseafood.com",
    time: "9:00 AM - 10:30 PM",
    rating: 4.2,
    cuisines: ["Seafood", "Vietnamese"],
    meal: ["Lunch", "Dinner"],
    feature: ["Fresh Seafood", "Family Friendly"],
    about: "A popular seafood restaurant known for its fresh ingredients and casual dining atmosphere.",
    images: [
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/17/35/48/56/20190418-193738-largejpg.jpg?w=1400&h=800&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/18/b0/6b/4c/hai-san-be-man-a.jpg?w=1100&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/18/b0/6b/4a/hai-san-be-man-a.jpg?w=1100&h=-1&s=1",
    ],
    restaurantLocation: "Lô 8 Võ Nguyên Giáp, Mân Thái, Sơn Trà, Đà Nẵng",    
    review: random.nextInt(300) + 25,
    priceRange: "10.00\$-20.00\$",
    type:"Restaurant",
    goodFor:"Families with children"


  ),
  Restaurant(
    restaurantName: "Nhà Hàng Madame Lân",
    restaurantId: 4,
    contactNumber: "0778889999",
    website: "http://madamelan.com",
    time: "8:00 AM - 11:00 PM",
    rating: 4.6,
    cuisines: ["Vietnamese"],
    meal: ["Breakfast", "Lunch", "Dinner"],
    feature: ["Traditional Cuisine", "Outdoor Seating"],
    about: "Madame Lân offers a charming space to enjoy authentic Vietnamese dishes in a traditional setting.",
    images: [
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/25/91/f7/6d/madame-lan.jpg?w=1400&h=800&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/07/9a/60/caption.jpg?w=1400&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/07/9a/5c/caption.jpg?w=1400&h=-1&s=1",
    ],
    restaurantLocation: "04 Bạch Đằng, Thạch Thang, Hải Châu, Đà Nẵng",
        review: random.nextInt(300) + 25,
    priceRange: "20.00\$-35.00\$",
    type:"Coffee & Tea, Restaurant",
    goodFor:"Kids"



  ),
  Restaurant(
    restaurantName: "Sky 21 Bar & Bistro",
    restaurantId: 5,
    contactNumber: "0901234567",
    website: "http://sky21danang.com",
    time: "5:00 PM - 2:00 AM",
    rating: 5,
    cuisines: ["International", "Cocktails"],
    meal: ["Dinner", "Drinks"],
    feature: ["Rooftop Bar", "Live Music"],
    about: "A chic rooftop bar offering a panoramic view of the city, serving international dishes and creative cocktails.",
    images: [
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/24/45/c1/d5/enjoy-your-favourite.jpg?w=1400&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/23/be/ff/23/come-for-the-food-stay.jpg?w=1400&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/10/9f/4c/f2/sky21bar-belle-maison.jpg?w=2000&h=-1&s=1",
    ],
    restaurantLocation: "Belle Maison Parosand Danang, 216 Võ Nguyên Giáp, Phước Mỹ, Sơn Trà, Đà Nẵng ",
        review: random.nextInt(300) + 25,
    priceRange: "30.00\$-40.00\$",
    type:"Bar & Pubs",
    goodFor:"Romantic"


  ),
];
