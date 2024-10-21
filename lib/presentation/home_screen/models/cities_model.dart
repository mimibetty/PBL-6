import 'dart:math';

Random random = Random();

class City {
  final int id, population;
  final List<String>? images;
  final String name, description, country, bestSeason;
  final double rating;

  City({
    required this.id,
    required this.name,
    required this.country,
    required this.bestSeason,
    required this.description,
    required this.images,
    required this.rating,
    required this.population,
  });
  // Phương thức để tạo đối tượng City từ JSON
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      bestSeason: json['bestSeason'],
      description: json['description'],
      images: List<String>.from(json['images']),
      rating: json['rating'].toDouble(),
      population: json['population'],
    );
  }
}

List<City> myCities = [
  City(
    id: 1,
    name: "Da Nang",
    country: "Vietnam",
    bestSeason: "Spring",
    images: [
     "https://encrypted-tbn0.gstatic.com/licensed-image?q=tbn:ANd9GcTK5fU829cTV6v4hsIBrZkfYD06AInXVXbwl2uXtckuLbPhq_qqG0Qrwpcb3Vg3JRljQpO9JQtGZqX71TKyRqfcPFU8qd5VWZSxgC6dnA",
     "https://tourism.danang.vn/wp-content/uploads/2023/02/cau-rong-da-nang.jpeg",
     "https://drt.danang.vn/content/images/size/w1024/format/avif/2024/01/cay-cau-da-nang.jpeg",
    ],
    population: 1135000,
    description: description,
    rating: 4.8,
  ),
  City(
    id: 2,
    name: "Hanoi",
    country: "Vietnam",
    bestSeason: "Autumn",
    images: [
     "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1b/33/f7/12/caption.jpg?w=1400&h=1400&s=1",
     "https://hoanghamobile.com/tin-tuc/wp-content/uploads/2024/04/anh-ha-noi.jpg",
     "https://encrypted-tbn3.gstatic.com/licensed-image?q=tbn:ANd9GcSkvIRJAxyaFKaZyTN5DkBpVngaFr0tTCwxmsngyAGtz9fMBBCjUy0K4WtFeqp1y32v6JoU4BWqX0QsA3l7USa5vaCN9m5mnFbFTxpDdw",
    ],
    population: 8000000,
    description: description,
    rating: 4.6,
  ),
  City(
    id: 3,
    name: "Ho Chi Minh City",
    country: "Vietnam",
    bestSeason: "Dry Season",
    images: [
     "https://tphcm.dangcongsan.vn/DATA/72/IMAGES/2023/11/tao-da-de-tphcm-phat-trien-thanh-do-thi-thong-minh1517188897.jpg",
      "https://www.visithcmc.vn/uploads/0000/6/2021/08/22/hcmc-1120046774-1.jpg",
      "https://file1.dangcongsan.vn/data/0/images/2021/06/30/maipq/quan-1.jpeg",
    ],
    population: 9000000,
    description: description,
    rating: 4.7,
  ),
];



const description =
    'Cities across the world offer a wide variety of experiences, blending history, culture, and modernity. From ancient landmarks to bustling markets, every city has its own story to tell. Whether you’re looking for adventure, relaxation, or cultural immersion, there’s a city waiting for you to explore.';
