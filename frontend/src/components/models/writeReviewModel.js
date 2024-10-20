import axios from 'axios';

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
  

