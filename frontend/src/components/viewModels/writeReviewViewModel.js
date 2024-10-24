import { ref, computed } from 'vue';

import {  ImageModel } from '../models/writeReviewModel.js';


const isMenuVisible = ref(false)
const toggleMenu = () => {
  isMenuVisible.value = !isMenuVisible.value;
  console.log(isMenuVisible);
}

const fullCircle = new URL('@/assets/circle-full.svg', import.meta.url).href;
const halfCircle = new URL('@/assets/circle-half.svg', import.meta.url).href;
const emptyCircle = new URL('@/assets/circle-none.svg', import.meta.url).href;
const currentRating = ref(0);
const hoveredRating = ref(0);
const visitDate = ref('');
const reviewText = ref('');

const ratingStatus = computed(() => {
    const statuses = ['Terrible', 'Bad', 'Medium', 'Very Good', 'Excellent'];
    return currentRating.value > 0 ? statuses[currentRating.value - 1] : '';
  });

const hoverRating = (index) => {
    hoveredRating.value = index;
  };

const leaveRating = () => {
    hoveredRating.value = 0;
  };

const setRating = (index) => {
    currentRating.value = index;
  };
const images = ref([]);
const fetchImages = async () => {
  images.value = await ImageModel.fetchImages();
};

const reviewTitle = ref('');
const photos = ref([]);
const photoPreviews = ref([]);
const handlePhotoUpload = (event) => {
    const files = Array.from(event.target.files);
    
    files.forEach((file) => {
      photos.value.push(file);
  
      // Generate preview URL for the uploaded file
      const reader = new FileReader();
      reader.onload = (e) => {
        photoPreviews.value.push(e.target.result);  // Add the image preview URL
      };
      reader.readAsDataURL(file);
    });
  };
const submitReview = () => {
    console.log({
      title: reviewTitle.value,
      photos: photos.value,
      rating: currentRating.value,
      visitDate: visitDate.value,
      review: reviewText.value,
    });
};

fetchImages();

export {
  fullCircle,
  halfCircle,
  emptyCircle,  
  images,
  isMenuVisible,
  toggleMenu,
  visitDate,
  reviewText,
  currentRating,
  ratingStatus,
  hoverRating,
  leaveRating,
  setRating,
  hoveredRating,
  reviewTitle,
  photos,
  handlePhotoUpload,
  submitReview,
  photoPreviews,
};
