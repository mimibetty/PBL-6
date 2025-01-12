import { ref } from 'vue';
import { getDestinationById } from '../models/destinationModel.js';
import { addImage } from '../models/ReviewModel';

export default function(destinationID) {
  const destination = ref();
  const loadDestination = async () => {
    try {
      destination.value = await getDestinationById(destinationID);
    } catch (error) {
      console.error("Có lỗi xảy ra khi lấy dữ liệu destination:", error);
    }
  };

  loadDestination();
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

  const submitReview = async () => {
    console.log({
      place: destination.value.name,
      photos: photos.value,
    });
    for (let image of photos.value) {
      const result = await addImage(destination.value.id, image);
      console.log(result);
    }
      window.history.back();
  };

  return {
    destination,
    photos,
    photoPreviews,
    handlePhotoUpload,
    submitReview,
  };
}

