<template>
  <div class="city-management container">
    <h2 class="text-center mb-4">City Management</h2>
    <div class="form-container">
      <h3 class="text-center mb-4">Update City Info</h3>
      <form @submit.prevent="submitUpdateCity" class="form-style">
        <!-- ID Field (Disabled) -->
        <div class="form-floating mb-3">
          <input type="text" class="form-control" id="cityId" v-model="currentCity.id" disabled placeholder=" " />
          <label for="cityId">ID:</label>
        </div>

        <!-- City Name -->
        <div class="form-floating mb-3">
          <input type="text" class="form-control" id="cityName" v-model="currentCity.name" required placeholder=" " />
          <label for="cityName">City Name:</label>
        </div>

        <!-- Description -->
        <div class="form-floating mb-3">
          <input type="text" class="form-control" id="cityDescription" v-model="currentCity.description" required placeholder=" " />
          <label for="cityDescription">Description:</label>
        </div>

        <!-- Current Images -->
        <div class="mb-3">
          <label for="currentImages" class="form-label">Current Images:</label>
          <div class="d-flex flex-wrap mt-2">
            <div v-for="img in currentCity.images" :key="img.id" class="position-relative me-2 mb-2" style="max-width: 150px; max-height: 150px;">
              <img :src="img.url" alt="Existing Image" class="img-fluid w-100 h-100 object-fit-cover" />
              <!-- Nút xóa hình tròn ở góc trên bên phải -->
              <button type="button" @click.prevent="removeExistingImage(img.id)" class="btn btn-danger btn-sm position-absolute top-0 end-0 translate-middle rounded-circle" style="z-index: 1; width: 30px; height: 30px; padding: 0; font-size: 18px; line-height: 20px; background-color: rgba(255, 0, 0, 0.7);">
                -
              </button>
            </div>
          </div>
        </div>

        <!-- Upload New Images -->
        <div class="mb-3">
          <label for="newImages" class="form-label">Upload New Images:</label>
          <input type="file" id="newImages" class="form-control" @change="handleNewImageUpload" multiple />
          <div class="d-flex flex-wrap mt-2">
            <div v-for="(img, index) in previewNewImages" :key="index" class="position-relative me-2 mb-2" style="max-width: 150px; max-height: 150px;">
              <img :src="img" alt="Image Preview" class="img-fluid w-100 h-100 object-fit-cover" />
              <!-- Nút xóa hình tròn ở góc trên bên phải -->
              <button type="button" @click.prevent="removeNewImage(index)" class="btn btn-danger btn-sm position-absolute top-0 end-0 translate-middle rounded-circle" style="z-index: 1; width: 30px; height: 30px; padding: 0; font-size: 18px; line-height: 20px; background-color: rgba(255, 0, 0, 0.7);">
                -
              </button>
            </div>
          </div>
        </div>

        <!-- Submit and Cancel Buttons -->
        <div class="d-flex justify-content-between">
          <button type="submit" class="btn btn-primary">Update</button>
          <button type="button" @click="cancelAction" class="btn btn-danger">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</template>


  
  <script setup>
  import CityManagementController from "@/controllers/CityManagementController";
  import { ref, computed, onMounted } from "vue";
  import { useRoute } from "vue-router";
  const route = useRoute();
  const cityID = route.params.id;
  
  // Image handling
  const new_images = ref([]);
  const image_ids_to_remove = ref([]);
  const previewNewImages = ref([]);
  
  // City data
  const currentCity = ref({ id: "", name: "", description: "", images: [] });
  
  const {
    updateCity,
    confirmUpdate,
  } = CityManagementController();
  
  
  // CRUD operations
  
  const showUpdateForm = async (cityID) => {
    const cityData = await updateCity(cityID);
    currentCity.value = { ...cityData };
  };

  onMounted(async () => {
    await showUpdateForm(cityID);
  });
  
  const submitUpdateCity = async () => {
    await confirmUpdate(
      currentCity.value,
      new_images.value,
      image_ids_to_remove.value
    );
    previewNewImages.value = [];
    image_ids_to_remove.value = [];
    loadCities();
  };
  
  const cancelAction = () => {
    window.history.back();
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
    currentCity.value.images = currentCity.value.images.filter(
      (img) => img.id !== id
    );
  };
  
  // Return exposed values and methods
  </script>
  
  
  <style scoped>
  .city-management {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  background: #ffffff;
  border-radius: 10px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.form-container {
  padding: 20px;
}

h2, h3 {
  text-align: center;
  color: #333;
}

.form-floating label {
  transition: all 0.3s ease;
}

.form-floating input:focus + label,
.form-floating input:not(:placeholder-shown) + label {
  transform: translateY(-1.5rem);
  font-size: 0.8rem;
  color: #0b31f0;
}

.button-group {
  display: flex;
  justify-content: space-between;
}
  </style>
  