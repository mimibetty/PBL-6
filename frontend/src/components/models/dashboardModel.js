// cityModel.js
import { ref } from 'vue';

// Initialize cities as a reactive reference
const cities = ref([]);
const topics = ref([]);
const tours = ref([]);

// Function to fetch cities from the API
export const fetchCities = async () => {
  try {
    const response = await fetch('http://localhost:3000/cities');
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();

    // Transform the data into a format usable by Vue
    cities.value = data.map(city => ({
      id: city.id,
      name: city.name,
      location: city.location,
      reviewNumber: city.reviewNumber,
      rating: city.rating,
      imageUrl: city.imageUrl,
    }));

    return cities.value;
  } catch (error) {
    console.error("Có lỗi xảy ra khi lấy dữ liệu thành phố:", error);
    return []; // Return an empty array or handle as needed
  }
};

// Function to get the current list of cities
export const getCities = () => cities.value;

// Function to fetch topic from the API
export const fetchTopics = async () => {
  try {
    const response = await fetch('http://localhost:3000/topics');
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();

    // Transform the data into a format usable by Vue
    topics.value = data.map(topic => ({
      id: topic.id,
      name: topic.name,
      imageUrl: topic.imageUrl,
    }));

    return topics.value;
  } catch (error) {
    console.error("Có lỗi xảy ra khi lấy dữ liệu chủ đề:", error);
    return []; // Return an empty array or handle as needed
  }
};

// Function to get the current list of topic
export const getTopics = () => topics.value;

// Function to fetch tours from the API
export const fetchTours = async () => {
  try {
    const response = await fetch('http://localhost:3000/tours');
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    const data = await response.json();

    // Transform the data into a format usable by Vue
    tours.value = data.map(tour => ({
      id: tour.id,
      name: tour.name,
      location: tour.location,
      reviewNumber: tour.reviewNumber,
      rating: tour.rating,
      imageUrl: tour.imageUrl,
    }));

    return tours.value;
  } catch (error) {
    console.error("Có lỗi xảy ra khi lấy dữ liệu tour:", error);
    return []; // Return an empty array or handle as needed
  }
};

// Function to get the current list of tours
export const getTours = () => tours.value;