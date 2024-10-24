import axios from 'axios';
export class RatingModel {
    constructor(excellent, veryGood, medium, bad, terrible) {
      this.excellent = excellent;
      this.veryGood = veryGood;
      this.medium = medium;
      this.bad = bad;
      this.terrible = terrible;
    }
  
    // Tính tổng số đánh giá
    getTotal() {
      return (
        this.excellent + this.veryGood + this.medium + this.bad + this.terrible
      );
    }
  
    // Tính phần trăm cho mỗi loại đánh giá
    getPercentage(value) {
      return ((value / this.getTotal()) * 100).toFixed(2);
    }
  
    // Tính tổng rating
    getAverageRating() {
      const total =
        this.excellent * 5 +
        this.veryGood * 4 +
        this.medium * 3 +
        this.bad * 2 +
        this.terrible;
      return (total / this.getTotal()).toFixed(1);
    }
  }
  
  export class Comment {
    constructor(personalImage, user, rating, title, day, comment, picture) {
      this.personalImage = personalImage;
      this.user = user;
      this.rating = rating;
      this.title = title;
      this.day = day;
      this.comment = comment;
      this.picture = picture;
    }
  }
  export class ImageModel {
    constructor(id, imageUrl) {
        this.id = id; // ID của hình ảnh
        this.imageUrl = imageUrl; // Đường dẫn hình ảnh
    }

    // Phương thức lấy hình ảnh
    static async fetchImages() {
        try {
            const response = await axios.get('http://localhost:3000/images');
            return response.data.map(image => new ImageModel(image.id, image.imageUrl));
        } catch (error) {
            console.error('Error fetching images:', error);
            return [];
        }
    }
}
  
  export const mockComments = [
    new Comment(
        new URL('@/assets/personal.svg', import.meta.url).href,
      'Linh L',
      3,
      'Chuyến đi chơi siêu đáng iu',
      'August 2024',
      'That interesting place to do',
      ''
    ),
    new Comment(
      new URL('@/assets/personal.svg', import.meta.url).href,
      'Dương L',
      5,
      'Chuyến đi chơi hấp dẫn',
      'August 2024',
      'Riding a motorbike late at night on the lake is quite fun. That interesting place to do',
      new URL('@/assets/images/background_picture.png', import.meta.url).href
    ),
  ];
