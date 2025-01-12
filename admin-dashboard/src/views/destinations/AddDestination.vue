<template>
  <div class="destination-management container">
    <h2 class="title">Destination Management</h2>
    <div v-if="isLoading" class="spinner-container">
        <div class="spinner"></div>
    </div>
    <div v-else class="form-container">
      <h3>Create Destination</h3>
      <form @submit.prevent="submitAddDestination" class="form-style">
        <!-- Basic Information -->
        <div class="form-floating mb-4">
          <input type="text" v-model="destination.name" id="destination-name" class="form-control" required placeholder=" " />
          <label for="destination-name">Destination Name</label>
        </div>
        <div class="form-floating mb-4">
          <select v-model="destination.user_id" id="user-select" class="form-select">
            <option v-for="user in users" :key="user.id" :value="user.id">
              {{ user.username }}
            </option>
          </select>
          <label for="user-select">User Create</label>
        </div>
        <div class="form-floating mb-4">
          <input type="text" v-model="destination.description" id="destination-description" class="form-control" placeholder=" " />
          <label for="destination-description">Description</label>
        </div>

        <!-- Toggleable Additional Information -->
        <button type="button" class="btn btn-link" @click="toggleMoreInfo">
          <span>{{ isMoreInfoVisible ? '▲' : '▼' }}</span> More Information
        </button>

        <div v-if="isMoreInfoVisible" class="additional-info">
          <div class="form-floating mb-4">
            <input type="number" v-model="destination.price_bottom" id="price-bottom" class="form-control" placeholder=" " />
            <label for="price-bottom">Price Bottom</label>
          </div>
          <div class="form-floating mb-4">
            <input type="number" v-model="destination.price_top" id="price-top" class="form-control" placeholder=" " />
            <label for="price-top">Price Top</label>
          </div>
          <div class="form-floating mb-4">
            <input type="number" v-model="destination.age" id="age" class="form-control" placeholder=" " />
            <label for="age">Age</label>
          </div>
          <div class="form-floating mb-4">
            <input type="time" v-model="destination.opentime" id="opentime" class="form-control" placeholder=" " />
            <label for="opentime">Open Time</label>
          </div>
          <div class="form-floating mb-4">
            <input type="number" v-model="destination.duration" id="duration" class="form-control" placeholder=" " />
            <label for="duration">Duration</label>
          </div>
          <div class="form-floating mb-4">
            <input type="date" v-model="destination.date_create" id="date-create" class="form-control" placeholder=" " />
            <label for="date-create">Date Created</label>
          </div>
          <div class="form-floating mb-4">
            <select v-model="destination.address.city_id" id="city-select" class="form-select">
              <option v-for="city in cities" :key="city.id" :value="city.id">
                {{ city.name }}
              </option>
            </select>
            <label for="city-select">City</label>
          </div>
          <div class="form-floating mb-4">
            <input type="text" v-model="destination.address.district" id="district" class="form-control" placeholder=" " />
            <label for="district">District</label>
          </div>
          <div class="form-floating mb-4">
            <input type="text" v-model="destination.address.ward" id="ward" class="form-control" placeholder=" " />
            <label for="ward">Ward</label>
          </div>
          <div class="form-floating mb-4">
            <input type="text" v-model="destination.address.street" id="street" class="form-control" placeholder=" " />
            <label for="street">Street</label>
          </div>

          <!-- Image Upload -->
          <div class="form-group">
            <label>Images:</label>
            <input type="file" @change="handleImageUpload" multiple class="form-control" />
            <div class="image-list mt-2">
              <div v-for="(img, index) in previewImages" :key="index" class="image-item d-inline-block me-2 position-relative" style="max-width: 150px; max-height: 150px;">
                <img :src="img" alt="Image Preview" class="img-fluid w-100 h-100 object-fit-cover" />
                <!-- Delete button -->
                <button type="button" @click.prevent="removeImage(index)" class="btn btn-danger btn-sm position-absolute top-0 end-0 translate-middle rounded-circle" style="z-index: 1; width: 30px; height: 30px; padding: 0; font-size: 18px; line-height: 20px; background-color: rgba(255, 0, 0, 0.7);">
                  -
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="d-flex justify-content-between">
          <button type="submit" class="btn btn-success">Create</button>
          <button type="button" @click="cancelAction" class="btn btn-danger">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</template>


<script setup>
import { onMounted, ref } from 'vue';
import DestinationManagementController from '@/controllers/DestinationManagementController';

const destinations = ref([]);
const images = ref([]);
const cities = ref([]);
const users = ref([]);
const previewImages = ref([]);
const isMoreInfoVisible = ref(false);
const isLoading = ref(true);

const { confirmCreate, fetchCities, fetchUsers } = DestinationManagementController();

const destination = ref({
  name: '',
  user_id: 0,
  price_bottom: 0,
  price_top: 0,
  age: 0,
  opentime: '',
  duration: 0,
  description: '',
  date_create: '',
  address: {
    city_id: 0,
    district: '',
    ward: '',
    street: '',
  },
  images: [],
});

onMounted(async () => {
  cities.value = await fetchCities();
  users.value = await fetchUsers();
  isLoading.value = false;
});

const submitAddDestination = async () => {
  await confirmCreate(destination.value, images.value);
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

const toggleMoreInfo = () => {
  isMoreInfoVisible.value = !isMoreInfoVisible.value;
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

.title {
  text-align: center;
  color: #333;
  font-size: 2rem;
  margin-bottom: 20px;
  font-weight: 700;
}

.form-container {
  padding: 20px;
}

h3 {
  font-size: 1.5rem;
  margin-bottom: 20px;
  font-weight: 700;
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

.btn-create {
  background-color: #28a745;
  color: white;
}

.btn-create:hover {
  background-color: #218838;
}

.btn-cancel {
  background-color: #dc3545;
  color: white;
}

.btn-cancel:hover {
  background-color: #c82333;
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

.image-list {
  display: flex;
  flex-wrap: wrap;
}

.image-item {
  position: relative;
  margin-right: 10px;
  margin-bottom: 10px;
}

.image-item img {
  width: 100px;
  height: 100px;
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
  