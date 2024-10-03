class Topic {
  final String name;
  final String image; // Thêm thuộc tính cho đường dẫn hình ảnh

  Topic(this.name, this.image); // Cập nhật constructor
}

class TopicModel {
  static List<Topic> getTopics() {
    return [
      Topic('Culture', 'https://www.letsroam.com/explorer/wp-content/uploads/sites/10/2022/01/cultural-travel.jpg'),
      Topic('Shopping', 'https://www.fabulousmomlife.com/wp-content/uploads/2021/10/best-shopping-destinations.jpg'),
      Topic('Must-see Attractions', 'https://www.mrlinhadventure.com/UserFiles/image/Pierre/Halong-Bay(2).jpg'),
      Topic('Great Food', 'https://d2e5ushqwiltxm.cloudfront.net/wp-content/uploads/sites/86/2020/02/18033728/mi-quang-noodles-dac-san-da-nang-mon-ngon-da-nang-mon-an-dia-phuong-o-da-nang-pullman-danang-pullman-danang-beach-resort.jpg'),
    ];
  }
}
