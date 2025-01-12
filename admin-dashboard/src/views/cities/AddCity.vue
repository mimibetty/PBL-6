<template>
  <div class="city-management container">
    <div class="form-container">
      <form @submit.prevent="submitAddCity" class="form-style">
        <!-- City Name -->
        <div class="form-floating mb-3">
          <input type="text" class="form-control" id="cityName" v-model="city.name" required placeholder=" " />
          <label for="cityName">City Name</label>
        </div>

        <!-- Description -->
        <div class="form-floating mb-3">
          <input type="text" class="form-control" id="cityDescription" v-model="city.description" required placeholder=" " />
          <label for="cityDescription">Description</label>
        </div>

        <!-- Images -->
        <div class="mb-3">
          <label for="cityImages" class="form-label">Images:</label>
          <input type="file" id="cityImages" class="form-control" @change="handleImageUpload" multiple />
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

        <!-- Submit and Cancel Buttons -->
        <div class="d-flex justify-content-between">
          <button type="submit" class="btn btn-success">Create</button>
          <button type="button" @click="cancelAction" class="btn btn-danger">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</template>

  
  <script setup>
  import CityManagementController from "@/controllers/CityManagementController";
  import { ref, computed, onMounted } from "vue";
  
  
  // Image handling
  const images = ref([]);
  const previewImages = ref([]);
  
  // City data
  const city = ref({ name: "", description: "", images: [] });
  
  const {
    confirmCreate,
  } = CityManagementController();
  
  // CRUD operations
  
  const submitAddCity = async () => {
    await confirmCreate(city.value, images.value);
  };
  
  const cancelAction = () => {
    window.history.back();
  };
  
  // Image handling functions
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
  