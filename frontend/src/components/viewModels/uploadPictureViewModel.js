import { ref, computed } from 'vue';

import {  ImageModel } from '../models/uploadPictureModel.js';


const isMenuVisible = ref(false)
const toggleMenu = () => {
  isMenuVisible.value = !isMenuVisible.value;
  console.log(isMenuVisible);
}


const images = ref([]);
const fetchImages = async () => {
  images.value = await ImageModel.fetchImages();
};

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
      photos: photos.value,
    });
};

fetchImages();

export { 
  images,
  isMenuVisible,
  toggleMenu,
  photos,
  handlePhotoUpload,
  submitReview,
  photoPreviews,
};
