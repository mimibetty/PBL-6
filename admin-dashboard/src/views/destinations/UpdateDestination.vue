<template>
  <div class="destination-management container">
    <h2 class="title">Destination Management</h2>
    <div class="form-container">
      <div v-if="isLoading" class="spinner-container">
        <div class="spinner"></div>
      </div>
      <form v-else @submit.prevent="submitUpdateDestination" class="form-style">
        <!-- Basic Information -->
        <div class="form-floating mb-4">
          <input type="text" v-model="currentDestination.name" id="destination-name" class="form-control" required placeholder=" " />
          <label for="destination-name">Destination Name</label>
        </div>
        <div class="form-floating mb-4">
          <select v-model="currentDestination.user_id" id="user-select" class="form-select">
            <option v-for="user in users" :key="user.id" :value="user.id">
              {{ user.username }}
            </option>
          </select>
          <label for="user-select">User Create</label>
        </div>
        <div class="form-floating mb-4">
          <input type="text" v-model="currentDestination.description" id="destination-description" class="form-control" placeholder=" " />
          <label for="destination-description">Description</label>
        </div>

        <!-- Toggleable Additional Information -->
        <button type="button" class="btn btn-link" @click="toggleMoreInfo">
          <span>{{ isMoreInfoVisible ? '▲' : '▼' }}</span> More Information
        </button>

        <div v-if="isMoreInfoVisible" class="additional-info">
          <div class="form-floating mb-4">
            <input type="number" v-model="currentDestination.price_bottom" id="price-bottom" class="form-control" placeholder=" " />
            <label for="price-bottom">Price Bottom</label>
          </div>
          <div class="form-floating mb-4">
            <input type="number" v-model="currentDestination.price_top" id="price-top" class="form-control" placeholder=" " />
            <label for="price-top">Price Top</label>
          </div>
          <div class="form-floating mb-4">
            <input type="number" v-model="currentDestination.age" id="age" class="form-control" placeholder=" " />
            <label for="age">Age</label>
          </div>
          <div class="form-floating mb-4">
            <input type="time" v-model="currentDestination.opentime" id="opentime" class="form-control" placeholder=" " />
            <label for="opentime">Open Time</label>
          </div>
          <div class="form-floating mb-4">
            <input type="number" v-model="currentDestination.duration" id="duration" class="form-control" placeholder=" " />
            <label for="duration">Duration</label>
          </div>
          <div class="form-floating mb-4">
            <input type="date" v-model="currentDestination.date_create" id="date-create" class="form-control" placeholder=" " />
            <label for="date-create">Date Created</label>
          </div>
          <div class="form-floating mb-4">
            <select v-model="currentDestination.address.city_id" id="city-select" class="form-select">
              <option v-for="city in cities" :key="city.id" :value="city.id">
                {{ city.name }}
              </option>
            </select>
            <label for="city-select">City</label>
          </div>
          <div class="form-floating mb-4">
            <input type="text" v-model="currentDestination.address.district" id="district" class="form-control" placeholder=" " />
            <label for="district">District</label>
          </div>
          <div class="form-floating mb-4">
            <input type="text" v-model="currentDestination.address.ward" id="ward" class="form-control" placeholder=" " />
            <label for="ward">Ward</label>
          </div>
          <div class="form-floating mb-4">
            <input type="text" v-model="currentDestination.address.street" id="street" class="form-control" placeholder=" " />
            <label for="street">Street</label>
          </div>

          <!-- Images Section -->
          <div class="form-group">
            <label>Current Images:</label>
            <div class="image-list mt-2">
              <div v-for="img in currentDestination.images" :key="img.id" class="image-item d-inline-block me-2 position-relative" style="max-width: 150px; max-height: 150px;">
                <img :src="img.url" alt="Existing Image" class="img-fluid w-100 h-100 object-fit-cover" />
                <button @click.prevent="removeExistingImage(img.id)" class="btn btn-danger btn-sm position-absolute top-0 end-0 translate-middle rounded-circle" style="z-index: 1; width: 30px; height: 30px; padding: 0; font-size: 18px; line-height: 20px; background-color: rgba(255, 0, 0, 0.7);">
                  -
                </button>
              </div>
            </div>
            <label>Upload New Images:</label>
            <input type="file" @change="handleNewImageUpload" multiple class="form-control" />
            <div class="image-list mt-2">
              <div v-for="(img, index) in previewNewImages" :key="index" class="image-item d-inline-block me-2 position-relative" style="max-width: 150px; max-height: 150px;">
                <img :src="img" alt="Image Preview" class="img-fluid w-100 h-100 object-fit-cover" />
                <button @click.prevent="removeNewImage(index)" class="btn btn-danger btn-sm position-absolute top-0 end-0 translate-middle rounded-circle" style="z-index: 1; width: 30px; height: 30px; padding: 0; font-size: 18px; line-height: 20px; background-color: rgba(255, 0, 0, 0.7);">
                  -
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div class="d-flex justify-content-between">
          <button type="submit" class="btn btn-success">Update</button>
          <button type="button" @click="cancelAction" class="btn btn-danger">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</template>


<script setup>
import { ref, onMounted } from 'vue';
import DestinationManagementController from '@/controllers/DestinationManagementController';
import { useRoute } from "vue-router";
const route = useRoute();
const destinationID = route.params.id;  

const cities = ref([]);
const users = ref([]);
const new_images = ref([]);
const image_ids_to_remove = ref([]);
const previewNewImages = ref([]);
const isMoreInfoVisible = ref(false);
const isLoading = ref(true);

const {
  updateDestination,
  confirmUpdate,
  fetchCities,
  fetchUsers,
} = DestinationManagementController();

const currentDestination = ref({
  id: 0,
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
  hotel_id: 0,
  hotel: {
    property_amenities: '',
    room_features: '',
    room_types: '',
    hotel_class: 0,
    hotel_styles: '',
    languages: '',
    phone: '',
    email: '',
    website: '',
    id: '',
  },
  restaurant_id: 0,
  restaurant: {
    cuisine: '',
    special_diet: '',
    feature: '',
    meal: '',
    id: '',
  },
});

const toggleMoreInfo = () => {
  isMoreInfoVisible.value = !isMoreInfoVisible.value;
};

const loadCity = async () => {
  cities.value = await fetchCities();
};

const loadUsers = async () => {
  users.value = await fetchUsers();
};

onMounted(async () => {
  await loadUsers();
  await loadCity();
  await showUpdateForm(destinationID);
  isLoading.value = false;
});

const showUpdateForm = async (destinationID) => {
  const destinationData = await updateDestination(destinationID);
  currentDestination.value = {
    ...destinationData,
    address: destinationData.address || { city_id: null, district: '', ward: '', street: '' },
  };
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
  currentDestination.value.images = currentDestination.value.images.filter(
    (img) => img.id !== id
  );
};

const submitUpdateDestination = async () => {
  await confirmUpdate(
    currentDestination.value,
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
  font-size: 0.75rem;
  transform: translateY(-45%);
  color: #022e5a;
}

.form-control {
  padding: 10px;
  margin: 5px 0;
  font-size: 1rem;
}

.form-select {
  padding: 10px;
  border-radius: 8px;
  font-size: 1rem;
  margin-top: 5px;
}

.additional-info {
  margin-top: 20px;
}

.btn-link {
  color: #007bff;
  text-decoration: none;
}

.image-list {
  display: flex;
  gap: 10px;
  margin-top: 10px;
}

.image-item {
  position: relative;
}

.image-item img {
  width: 100px;
  height: 100px;
  object-fit: cover;
  border-radius: 8px;
}

.image-item button {
  position: absolute;
  top: 0;
  right: 0;
  background: rgba(255, 0, 0, 0.7);
  color: white;
  border: none;
  border-radius: 50%;
  padding: 5px;
  cursor: pointer;
}

.btn {
  padding: 10px 20px;
  border-radius: 8px;
  font-size: 1rem;
  cursor: pointer;
}

.btn {
  border-radius: 8px;
  padding: 10px 20px;
  font-size: 1rem;
  transition: background-color 0.3s ease;
  width: 48%; /* Mỗi nút chiếm 48% chiều rộng */
}

.btn-create {
  background-color: #240def;
  color: white;
}

.btn-create:hover {
  background-color: #150280;
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
  