// cityModel.js
import { ref } from 'vue';

const topicsData = [
  {
    id: 1,
    name: "Culture",
    imageUrl: "/topics/culture.jpg",
    path: 'culture'
  },
  {
    id: 2,
    name: "Great Food",
    imageUrl: "/topics/food.jpg",
    path: 'great-food'
  },
  {
    id: 3,
    name: "Must See Attraction",
    imageUrl: "/topics/must-see-attraction.jpg",
    path: 'must-see-attraction'
  },
  {
    id: 4,
    name: "Shopping",
    imageUrl: "/topics/shopping.jpg",
    path: 'shopping'

  }
];

// Tạo một `ref` để lưu trữ dữ liệu
export const topics = ref(topicsData);

// Hàm để lấy danh sách `topics`
export const fetchTopics = () => topics.value;
