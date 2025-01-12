<template>
  <div class="destination-management container">

    <div v-if="isLoading" class="spinner-container">
      <div class="spinner"></div>
    </div>
    <!-- Create Review Form -->
    <div class="form-container">
      <h3 class="text-center">Create Review</h3>
      <form @submit.prevent="submitAddReview" class="form-style">
        
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
          <select v-model="review.language" class="form-select" id="companion">
            <option v-for="language in languages" :key="language" :value="language">
              {{ language }}
            </option>
          </select>
          <label for="lamguage">Language</label>
        </div>

        <!-- Images Section -->
        <div class="form-group mb-3">
          <label for="imageUpload">Images:</label>
          <input type="file" @change="handleImageUpload" multiple class="form-control" id="imageUpload" />
          <div class="image-list">
            <div v-for="(img, index) in previewImages" :key="index" class="image-item position-relative">
              <img :src="img" alt="Image Preview" class="img-thumbnail" />
              <button type="button" @click.prevent="removeImage(index)" class="btn btn-danger btn-sm position-absolute top-0 end-0 translate-middle rounded-circle" style="z-index: 1; width: 30px; height: 30px; padding: 0; font-size: 18px; line-height: 20px; background-color: rgba(255, 0, 0, 0.7);">
                  -
                </button>
            </div>
          </div>
        </div>

        <!-- Form Buttons -->
        <div class="button-group d-flex justify-content-between">
          <button type="submit" class="btn btn-success">Create</button>
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
const destinationID = route.params.id;
  
  const destinations = ref([]);
  const images = ref([]);
  const cities = ref([]);
  const users = ref([]);
  const previewImages = ref([]);
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
    confirmCreate,
    fetchDestinations,
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
    destination_id: destinationID,
    images: [],
  });
  
  const loadCity = async () => {
    cities.value = await fetchCities();
  };
  
  const loadUsers = async () => {
    users.value = await fetchUsers();
  };

  const loadDestinations = async () => {
    destinations.value = await fetchDestinations();
  };

  onMounted(async () => {
    await loadCity();
    await loadUsers();
    await loadDestinations();
    isLoading.value = false;
  });
  
  const submitAddReview = async () => {
    await confirmCreate(review.value, images.value);
  };
  
  const handleImageUpload = (event) => {
    const files = event.target.files;
    Array.from(files).forEach((file) => {
      images.value.push(file);
      previewImages.value.push(URL.createObjectURL(file));
    });
  };
  
  const removeImage = (index) => {
    images.value.splice(index, 1);
    URL.revokeObjectURL(previewImages.value[index]);
    previewImages.value.splice(index, 1);
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

.btn-success {
  background-color: #28a745;
  color: white;
}

.btn-success:hover {
  background-color: #218838;
}

.btn-danger {
  background-color: #dc3545;
  color: white;
}

.btn-danger:hover {
  background-color: #c82333;
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

  