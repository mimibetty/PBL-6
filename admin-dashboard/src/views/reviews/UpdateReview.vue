<template>
  <div class="destination-management container">

    <!-- Update Review Form -->
    <div v-if="isLoading" class="spinner-container">
      <div class="spinner"></div>
    </div>
    <div v-else class="form-container">
      <h3 class="text-center">Update Review</h3>
      <form @submit.prevent="submitUpdateReview" class="form-style">
        
        <!-- Destination Field (Disabled) -->
        <div class="form-floating mb-3">
          <select v-model="review.destination_id" required disabled class="form-select" id="destination">
            <option disabled value="">Select a destination</option>
            <option v-for="dest in destinations" :key="dest.id" :value="dest.id">
              {{ dest.name }}
            </option>
          </select>
          <label for="destination">Destination</label>
        </div>

        <!-- User Review -->
        <div class="form-floating mb-3">
          <select v-model="review.user_id" class="form-select" id="userReview">
            <option v-for="user in users" :key="user.id" :value="user.id">
              {{ user.username }}
            </option>
          </select>
          <label for="userReview">User Review</label>
        </div>

        <!-- Title -->
        <div class="form-floating mb-3">
          <input type="text" v-model="review.title" placeholder=" " class="form-control" id="title" />
          <label for="title">Title</label>
        </div>

        <!-- Content -->
        <div class="form-floating mb-3">
          <input type="text" v-model="review.content" placeholder=" " class="form-control" id="content" />
          <label for="content">Content</label>
        </div>

        <!-- Rating -->
        <div class="form-floating mb-3">
          <input type="number" v-model="review.rating" placeholder=" " class="form-control" id="rating" />
          <label for="rating">Rating</label>
        </div>

        <!-- Date Create -->
        <div class="form-floating mb-3">
          <input type="date" v-model="review.date_create" placeholder=" " class="form-control" id="dateCreate" />
          <label for="dateCreate">Date Create</label>
        </div>

        <!-- Companion -->
        <div class="form-floating mb-3">
          <select v-model="review.companion" class="form-select" id="companion">
            <option v-for="companion in companions" :key="companion.value" :value="companion.value">
              {{ companion.label }}
            </option>
          </select>
          <label for="companion">Companion</label>
        </div>

        <!-- Language -->
        <div class="form-floating mb-3">
          <select v-model="review.language" class="form-select" id="language">
            <option v-for="language in languages" :key="language" :value="language">
              {{ language }}
            </option>
          </select>
          <label for="language">Language</label>
        </div>

        <!-- Images Section -->
        <div class="form-group mb-3">
          <label>Current Images:</label>
          <div class="image-list">
            <div v-if="review && review.images" v-for="img in review.images" :key="img.id" class="image-item">
              <img :src="img.url" alt="Existing Image" class="img-thumbnail" />
              <button @click.prevent="removeExistingImage(img.id)" class="btn btn-danger btn-sm position-absolute top-0 end-0 translate-middle rounded-circle" style="width: 30px; height: 30px;">-</button>
            </div>
          </div>
          <label>Upload New Images:</label>
          <input type="file" @change="handleNewImageUpload" multiple class="form-control" />
          <div class="image-list mt-2">
            <div v-for="(img, index) in previewNewImages" :key="index" class="image-item position-relative">
              <img :src="img" alt="Image Preview" class="img-thumbnail" />
              <button @click.prevent="removeNewImage(index)" class="btn btn-danger btn-sm position-absolute top-0 end-0 translate-middle rounded-circle" style="width: 30px; height: 30px;">-</button>
            </div>
          </div>
        </div>

        <!-- Form Buttons -->
        <div class="button-group d-flex justify-content-between">
          <button type="submit" class="btn btn-primary">Update</button>
          <button type="button" @click="cancelAction" class="btn btn-danger">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</template>
  
  <script setup>
import ReviewManagementController from "@/controllers/ReviewManagementController";
import { ref, onMounted, computed } from "vue";
import { useRoute } from "vue-router";
const route = useRoute();
const reviewID = route.params.id;

const destinations = ref([]);
const cities = ref([]);
const users = ref([]);
const new_images = ref([]);
const image_ids_to_remove = ref([]);
const previewNewImages = ref([]);
const isLoading = ref(true);
const companions = [
  { value: 'Solo', label: 'Solo' },
  { value: 'Family', label: 'Family' },
  { value: 'Couple', label: 'Couple' },
  { value: 'Friends', label: 'Friends' },
  { value: 'Company', label: 'Company' },
  { value: 'Other', label: 'Other' },
];

const languages = [
  'Korean',
  'Japanese',
  'English',
  'Vietnamese',
  'Thai',
  'Chinese',
  'French',
];

const {
  fetchCities,
  fetchUsers,
  fetchDestinations,
  updateReview,
  confirmUpdate,
} = ReviewManagementController();


const review = ref({
  id: 0,
  title: "",
  content: "",
  rating: "",
  language: "",
  date_create: "",
  companion: "",
  user_id: 0,
  destination_id: 0,
  images: [],
});

const loadDestinations = async () => {
  destinations.value = await fetchDestinations();
};

const loadCity = async () => {
  cities.value = await fetchCities();
};

const loadUsers = async () => {
  users.value = await fetchUsers();
};

onMounted(async () => {
    await showUpdateForm(reviewID);
    await loadCity();
    await loadUsers();
    await loadDestinations();
    isLoading.value = false;
  });


const showUpdateForm = async (reviewID) => {
  const reviewData = await updateReview(reviewID);
  if (reviewData) {
    review.value = { ...reviewData };
  }
};

const handleNewImageUpload = (event) => {
  const files = event.target.files;
  Array.from(files).forEach((file) => {
    new_images.value.push(file);
    previewNewImages.value.push(URL.createObjectURL(file));
  });
};

const removeNewImage = (index) => {
  new_images.value.splice(index, 1);
  URL.revokeObjectURL(previewNewImages.value[index]);
  previewNewImages.value.splice(index, 1);
};

const removeExistingImage = (id) => {
  image_ids_to_remove.value.push(id);
  review.value.images = review.value.images.filter((img) => img.id !== id);
};

const submitUpdateReview = async () => {
  await confirmUpdate(
    review.value,
    new_images.value,
    image_ids_to_remove.value
  );
};

const cancelAction = () => {
  window.history.back();
};

</script>
  
<style scoped>
.destination-management {
  max-width: 900px;
  margin: 0 auto;
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 10px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}

.title-effect {
  text-align: center;
  color: #343a40;
  font-size: 2.5rem;
  margin-bottom: 20px;
  font-weight: 700;
  text-transform: capitalize;
  letter-spacing: 1px;
  transition: transform 0.3s ease, color 0.3s ease;
}

.title-effect:hover {
  transform: scale(1.05);
  color: #007bff;
}

.title-effect::first-letter {
  color: #0b31f0;
  font-weight: bold;
}

.form-container {
  padding: 20px;
}

h3 {
  font-size: 1.5rem;
  margin-bottom: 20px;
  font-weight: 700;
  text-align: center;
}

.form-floating {
  position: relative;
}

.form-floating input, 
.form-floating select {
  border-radius: 8px;
  border: 1px solid #ddd;
  padding: 10px;
  width: 100%;
  font-size: 1rem;
}

.form-floating label {
  position: absolute;
  top: 50%;
  left: 10px;
  transform: translateY(-50%);
  font-size: 1rem;
  color: #6c757d;
  pointer-events: none;
  transition: all 0.3s ease;
}

.form-floating input:focus + label,
.form-floating input:not(:placeholder-shown) + label,
.form-floating select:focus + label,
.form-floating select:not(:placeholder-shown) + label {
  top: 0;
  transform: translateY(-45%);
  font-size: 0.75rem;
  color: #007bff;
}

.form-group {
  margin-bottom: 1.5rem;
}

.button-group {
  display: flex;
  justify-content: space-between; /* Đảm bảo nút nằm hai bên */
  margin-top: 20px;
}

.btn {
  border-radius: 8px;
  padding: 10px 20px;
  font-size: 1rem;
  transition: background-color 0.3s ease;
  width: 48%; /* Mỗi nút chiếm 48% chiều rộng */
}


.image-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.image-item {
  position: relative;
  width: 150px;
  height: 150px;
}

.image-item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 8px;
}

.image-item button {
  position: absolute;
  top: 5px;
  right: 5px;
  background-color: rgba(255, 0, 0, 0.5);
  color: white;
  border: none;
  border-radius: 50%;
  padding: 5px;
  cursor: pointer;
}

.additional-info {
  margin-top: 20px;
  background-color: #f0f0f0;
  padding: 20px;
  border-radius: 8px;
}

button[type="button"].btn-link {
  color: #007bff;
  text-decoration: none;
  font-weight: 600;
}

button[type="button"].btn-link:hover {
  text-decoration: underline;
}
.spinner-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.spinner {
  width: 50px;
  height: 50px;
  border: 5px solid #f3f3f3;
  border-top: 5px solid #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
</style>
  