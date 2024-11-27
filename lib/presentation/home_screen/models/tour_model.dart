class Tour {
  final int id;
  final String name;
  final List<String> images;
  final double rating;
  final String location;
  final double price;
  final String tourCategory;
  final String about;

  Tour({
    required this.id,
    required this.name,
    required this.images,
    required this.rating,
    required this.location,
    required this.price,
    required this.tourCategory,
    required this.about,
  });
}
final List<Tour> mockTours = [
  Tour(
    id:1,
    name: "Da Nang City Tour",
    images: [
      "https://media-cdn.tripadvisor.com/media/attractions-splice-spp-720x480/10/49/0a/63.jpg"
    ],
    rating: 4.5,
    location: "Đà Nẵng",
    price: 21,
    tourCategory: "Day Trips",
    about:"Tour the caves and tunnels of Marble Mountain, and find out about the hidden underground spaces where the Viet Cong would camp out during the Vietnam War. ",
  ),
  Tour(
    id:2,
    name: "Hoi An Ancient Town",
    images: [
      "https://media-cdn.tripadvisor.com/media/attractions-splice-spp-720x480/10/0a/8f/a1.jpg"
    ],
    rating: 4.8,
    location: "Hội An",
    price: 22,
    tourCategory: "Historical Tours",
    about:"Tour the caves and tunnels of Marble Mountain, and find out about the hidden underground spaces where the Viet Cong would camp out during the Vietnam War. ",
  ),
  Tour(
    id:3,
    name: "Ba Na Hills Adventure",
    images: [
      "https://media-cdn.tripadvisor.com/media/attractions-splice-spp-720x480/09/34/0b/5e.jpg"
    ],
    rating: 4.7,
    location: "Đà Nẵng",
    price: 23,
    tourCategory: "Half - Day Tours",
    about:"Tour the caves and tunnels of Marble Mountain, and find out about the hidden underground spaces where the Viet Cong would camp out during the Vietnam War. ",
  ),
];
