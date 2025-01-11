<template>
  <div class="tour-management container">
    <h2 class="title-effect">Tour Management</h2>
    <div v-if="isLoading" class="spinner-container">
      <div class="spinner"></div>
    </div>

    <!-- Form Container -->
    <div class="form-container">
      <form @submit.prevent="submitUpdateTour" class="form-style">
        <!-- Tour Name -->
        <div class="form-floating mb-3">
          <input type="text" v-model="currentTour.name" placeholder=" " class="form-control" id="tourName" required />
          <label for="tourName">Tour Name</label>
        </div>

        <!-- Description -->
        <div class="form-floating mb-3">
          <input type="text" v-model="currentTour.description" placeholder=" " class="form-control" id="description" />
          <label for="description">Description</label>
        </div>

        <!-- User -->
        <div class="form-floating mb-3">
          <select v-model="currentTour.user_id" class="form-select" id="userSelect">
            <option v-for="user in users" :key="user.id" :value="user.id">
              {{ user.username }}
            </option>
          </select>
          <label for="userSelect">User</label>
        </div>

        <!-- City -->
        <div class="form-floating mb-3">
          <select v-model="currentTour.city_id" class="form-select" id="citySelect">
            <option v-for="city in cities" :key="city.id" :value="city.id">
              {{ city.name }}
            </option>
          </select>
          <label for="citySelect">City</label>
        </div>

        <!-- Destinations -->
        <div class="form-group mb-3">
          <label class="form-label">Destinations:</label>
          <div v-for="(destination, index) in currentTour.destination_ids" :key="index" class="input-group mb-2">
            <v-select
              v-model="currentTour.destination_ids[index]"
              :options="destinations"
              label="name" 
              :reduce="dest => dest.id" 
              placeholder="Search for a destination"
              class="form-select"
              required
            ></v-select>
            <button type="button" @click="removeDestinationUpdate(index)" class="btn btn-danger">-</button>
          </div>
          <button type="button" @click="addDestinationUpdate" class="btn btn-primary mt-2">
            + Add Destination
          </button>
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
  import TourManagementController from "@/controllers/TourManagementController";
  import { ref, onMounted } from "vue";
  import { useRoute } from "vue-router";
  const route = useRoute();
  const tourID = route.params.id; 
  
  const destinations = ref([]);
  const users = ref([]);
  const cities = ref([]);
  const isLoading = ref(true);
  
  const {
    updateTour,
    confirmUpdate,
    getDestination,
    fetchCities,
    fetchUsers,
  } = TourManagementController();
  
  
  const currentTour = ref({
    id: 0,
    name: "",
    description: "",
    user_id: "",
    city_id: "",
    destination_ids: [],
  });
  
  const currentTourDetail = ref({
    id: 0,
    name: "",
    description: "",
    user_id: "",
    city_id: "",
    destinations: [],
  });
  
  const fetchDestination = async () => {
    destinations.value = await getDestination();
  };
  
  
  const loadUsers = async () => {
    users.value = await fetchUsers();
  };
  
  const loadCity = async () => {
    cities.value = await fetchCities();
  };
  
  onMounted(async () => {
    await loadCity();
    await loadUsers();
    await fetchDestination();
    await showUpdateForm(tourID);
    isLoading.value = false;
  });
  
  
  const addDestinationUpdate = () => {
    currentTour.value.destination_ids.push("");
  };
  
  const removeDestinationUpdate = (index) => {
    currentTour.value.destination_ids.splice(index, 1);
  };
  
  
  const showUpdateForm = async (tourID) => {
    const tourData = await updateTour(tourID);
    Object.assign(currentTourDetail.value, tourData);
    Object.assign(currentTour.value, {
      id: currentTourDetail.value.id,
      name: currentTourDetail.value.name,
      description: currentTourDetail.value.description,
      user_id: currentTourDetail.value.user_id,
      city_id: currentTourDetail.value.city_id,
      destination_ids: currentTourDetail.value.destinations.map((d) => d.id),
    });
  };
  
  const submitUpdateTour = async () => {
    await confirmUpdate(currentTour.value);
  };
  
  const cancelAction = () => {
    window.history.back();
  };
  
  
  </script>
  
  <style scoped>
.tour-management {
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

.button-group .btn {
  width: 48%;
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
  