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

// DescriptionModel mới với hàm getDescription và getTruncatedDescription
export class DescriptionModel {
    constructor(fullDescription) {
        this.fullDescription = fullDescription;
    }

    getTruncatedDescription() {
        return this.fullDescription.split(' ').slice(0, 40).join(' ') + '...';
    }

    getDescription(isReadMore) {
        return isReadMore.value ? this.fullDescription : this.getTruncatedDescription();
    }
}

// Tạo instance cho DescriptionModel với nội dung chi tiết
const fullDescription = `The Temple of Literature (Văn Miếu Quốc Tử Giám) in Hanoi is a historic and cultural symbol of Vietnam, founded in 1070 during the reign of Emperor Lý Thánh Tông. Originally dedicated to Confucius, it became Vietnam's first national university, Quốc Tử Giám, in 1076, serving as a prestigious center for scholars and intellectuals. This revered site consists of five courtyards with tranquil gardens, ancient trees, and steles engraved with the names of scholars who passed royal examinations. The traditional Vietnamese architecture, with its red-tiled roofs, stone pillars, and grand entranceways, reflects the nation's deep respect for learning and intellectual achievement. Today, the Temple of Literature is a major tourist attraction, symbolizing Vietnam's educational heritage and its centuries-old commitment to Confucian values. Visitors come to explore its serene beauty and historical significance, making it a must-see destination in Hanoi.`;

export const descriptionModel = new DescriptionModel(fullDescription);

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
