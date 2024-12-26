class Business {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final String description;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final List<String> businessUnits;
  final List<String> type;
  final String website;
  final String logoUrl;

  Business({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.description,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.businessUnits,
    required this.type,
    required this.website,
    required this.logoUrl,
  });
}

final List<Business> mockBusinessDatabase = [
  Business(
    id: "A1",
    name: "Sun Group",
    address: "123 Beach Road, Da Nang",
    phoneNumber: "09054567890",
    description: "A big group with good services.",
    type: ['Hotel', 'Restaurant', 'Thing to do'],
    images: [
      "https://sungroupthanhhoa.info/uploads/sun-thanh-hoa-tt-dai-lo-01-1536x864.jpg",
      "https://sunhome.com.vn/wp-content/uploads/2021/12/La-Festa-20211226.jpg"
    ],
    rating: 4.5,
    reviewCount: 150,
    website: 'congphaxulitinhieuso.com',
    businessUnits: ['1,2,3', '101,102,103'],
    logoUrl:
        "https://inkythuatso.com/uploads/thumbnails/800/2021/10/logo-vinfast-inkythuatso-21-11-22-46.jpg",
  ),
  Business(
    id: "A2",
    name: "Vin Group",
    address: "456 Hill Street, Da Nang",
    phoneNumber: "123 555-7890",
    description: "A huge companies in the mountains with panoramic views.",
    images: [
      "https://ircdn.vingroup.net/storage/public/2019/07/DJI_0030-fixed2-mini-20190727T100030844048.jpg",
      "https://maisonoffice.vn/wp-content/uploads/2023/12/2-vingroup-la-tap-doan-kinh-te-co-von-dieu-le-lon-nhat-thi-truong-viet-nam.jpg"
    ],
    website: 'congphaxulitinhieuso.com',
    rating: 4.2,
    type: ['Hotel', 'Restaurant', 'Thing to do'],
    logoUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_3oNME3dOzDakJ-vgAQa2eS5ifAmL2zHi6g&s",
    reviewCount: 85,
    businessUnits: ['2', '102,104'],
  ),
];
