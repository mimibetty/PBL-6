import 'dart:math';

Random random = Random();


class TravelDestination {
  final int id, price, review;
  final List<String>? image;
  final String name, description, category, location;
  final double rate;
  final String tag;

  TravelDestination({
    required this.name,
    required this.price,
    required this.id,
    required this.category,
    required this.description,
    required this.review,
    required this.image,
    required this.rate,
    required this.location,
    required this.tag,
  });
}

List<TravelDestination> myDestination = [
  TravelDestination(
    id: 1,
    name: "Dragon Bridge",
    category: 'popular',
    image: [
      "https://statics.vinwonders.com/dragon-bridge-1_1664459719.jpeg",
      "https://statics.vinwonders.com/dragon-bridge-2_1664459711.jpeg",
      "https://www.asme.org/getmedia/757bda08-e4d9-458f-8d68-46e3f364e4bb/dragon-bridge-breathes-fire-into-economy_hero.jpg.aspx?width=460&height=360&ext=.jpg",
      "https://preview.redd.it/v6ve4yrnyk591.jpg?auto=webp&s=c5482510b7f033aeea555c196e193303c354d5ca",
    ],
    location: "Da Nang , Viet Nam",
    review: random.nextInt(300) + 25,
    price: 0,
    tag : "Must-see Attractions",
    description: description,
    rate: 4.9,
  ),
  TravelDestination(
    id: 2,
    price: 10,
    name: "My Khe Beach",
    image: [
      "https://static.vinwonders.com/2022/09/My-khe-beach-1.jpeg",
      "https://phongnhalocals.com/wp-content/uploads/2022/06/my-khe-beach-da-nang-phong-nha-locals-9-1024x639.png",
      "https://centralvietnamguide.com/wp-content/uploads/2022/03/my-khe-beach-2.jpg",
      "https://vietnamdiscovery.com/wp-content/uploads/2020/10/My-Khe-services.jpg",
    ],
    review: random.nextInt(300) + 25,
    category: "popular",
    location: "Da Nang , Viet Nam",
    tag : "Must-see Attractions",
    description: description,
    rate: 4.8,

  ),
  TravelDestination(
    id: 3,
    name: "Linh Ung Pagoda",
    review: random.nextInt(300) + 25,
    price: 20,
    category: 'recomend',
    image: [
      "https://tiki.vn/blog/wp-content/uploads/2023/03/chua-linh-ung-da-nang.jpg",
      "https://banahills.sunworld.vn/wp-content/uploads/2024/01/chua-linh-ung-bai-but-13.jpg",
      "https://static.vinwonders.com/2022/03/chua-linh-ung-da-nang-01.jpg",
      "https://designs.vn/wp-content/images/01-12-2014/chua-linh-ung-1_resize.jpg",
    ],
    location: "Da Nang , Viet Nam",
    tag:"Culture",
    description: description,
    rate: 4.7,

  ),
  TravelDestination(
    id: 4,
    name: "Marble Moutains",
    review: random.nextInt(300) + 25,
    price: 30,
    category: "popular",
    image: [
      "https://danangsensetravel.com/view/at_ngu-hanh-son_28c756519df3a3e701e05302ca79903a.jpg",
      "https://www.arttravel.com.vn/upload/images/9(1).jpg",
      "https://huesmiletravel.com.vn/wp-content/uploads/2019/04/ngu-hanh-son-2020-1.jpg",
    ],
    location: "Da Nang , Viet Nam",
    description: description,
    tag:"Must-see Attractions",
    rate: 4.5,

  ),
  TravelDestination(
    id: 5,
    name: "Sun World Ba Na Hills",
    review: random.nextInt(300) + 25,
    price: 50,
    category: 'recomend',
    image: [
      "https://banahills.sunworld.vn/wp-content/uploads/2018/08/cap-treo-01-1-768x508.jpg",
      "https://upload.wikimedia.org/wikipedia/commons/2/27/Kali_Gandaki_Valley%2C_Road%2C_Mustang%2C_Nepal%2C_Himalaya.jpg",
      "https://static.toiimg.com/photo/54323153.cms",
      "https://www.nepalguideinfo.com/new/wp-content/uploads/2024/01/upper_mustang_mansoon-1024x517-1.jpg"
    ],
    location: "Da Nang , Viet Nam",
    tag:"Shopping",
    description: description,
    rate: 4.6,

  ),
  TravelDestination(
    id: 6,
    name: "Asia Park",
    review: random.nextInt(300) + 25,
    category: "popular",
    price: 40,
    image: [
      "https://cdn3.ivivu.com/2024/01/Asia-Park-ivivu.jpg",
      "https://res.klook.com/images/fl_lossy.progressive,q_65/c_fill,w_3000,h_1685,f_auto/w_80,x_15,y_15,g_south_west,l_Klook_water_br_trans_yhcmh3/activities/scjd7xbufij2grfywbjt/DaNangDowntownTicket(SunWorldAsiaPark)-Klook.jpg",
      "https://res.klook.com/images/fl_lossy.progressive,q_65/c_fill,w_1295,h_720/w_80,x_15,y_15,g_south_west,l_Klook_water_br_trans_yhcmh3/activities/ubhkeoxquhsqoysp8naw/DaNangDowntownTicket(SunWorldAsiaPark).jpg",
      "https://mia.vn/media/uploads/blog-du-lich/kham-pha-asia-park-da-nang-khu-vui-choi-giai-tri-hang-dau-viet-nam-9-1636361876.jpg",
    ],
    location: "Da Nang , Viet Nam",
    tag:"Great Food",
    description: description,
    rate: 4.7,

  ),
  TravelDestination(
    id: 7,
    name: "Han River Bridge",
    category: "popular",
    review: random.nextInt(300) + 25,
    price: 0,
    image: [
      "https://upload.wikimedia.org/wikipedia/commons/0/0c/Han_River_Bridge_Apr08.jpg",
      "https://halotravel.vn/wp-content/uploads/2021/07/cau-quay-song-han-1.jpg",
      "https://cdn3.ivivu.com/2022/09/cau-song-han-da-nang-ivivu-1.jpg",
      "https://homepage.momocdn.net/blogscontents/momo-upload-api-220826134351-637971182312865732.jpg",
    ],
    location: "Da Nang , Viet Nam",
    tag:"Culture",
    description: description,
    rate: 4.8,

  ),
  TravelDestination(
    id: 8,
    name: "Hot Spring Park",
    review: random.nextInt(300) + 25,
    category: "recomend",
    price:30,
    image: [
      "https://dulichkhampha24.com/wp-content/uploads/2020/01/gioi-thieu-ve-nui-than-tai-14.jpg",
      "https://katana.bdatrip.com/image/w=0/https://images.bdatrip.com/2022/7/6f12a9ce-53559970_543713052790724_3623039273342266783_n.webp",
      "https://drinkies.vn/wp-content/uploads/2022/08/nui-than-tai.jpg",
    ],
    location: "Da Nang , Viet Nam",
    description: description,
    tag:"Must-see Attractions",
    rate: 4.7,

  ),
];
const description =
    'Travel places offer a wide array of experiences, each with its own unique charm and appeal. From stunning natural landscapes to historic landmarks, there is something for every traveler. Coastal TravelDestinations like tropical beaches invite relaxation with crystal-clear waters, while mountainous regions offer adventurous hiking trails and breathtaking views.';