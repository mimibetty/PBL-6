<template>
  <div class="destination-management">
    <div class="form-container">
      <form @submit.prevent="submitUpdateRestaurant" class="form-style">
        <div class="form-floating mb-4">
          <input type="text" class="form-control" id="cuisine" v-model="currentDestination.restaurant.cuisine" placeholder=" " required />
          <label for="cuisine">Cuisine</label>
        </div>
        <div class="form-floating mb-4">
          <input type="text" class="form-control" id="specialDiet" v-model="currentDestination.restaurant.special_diet" placeholder=" " required />
          <label for="specialDiet">Special Diet</label>
        </div>
        <div class="form-floating mb-4">
          <input type="text" class="form-control" id="features" v-model="currentDestination.restaurant.feature" placeholder=" " required />
          <label for="features">Features</label>
        </div>
        <div class="form-floating mb-4">
          <input type="text" class="form-control" id="meal" v-model="currentDestination.restaurant.meal" placeholder=" " required />
          <label for="meal">Meal</label>
        </div>
        <div class="button-group">
          <button type="submit" class="btn btn-primary">Update</button>
          <button type="button" @click="cancelAction" class="btn btn-danger">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</template>
  
  <script setup>
  import { ref, onMounted, computed } from 'vue';
  import DestinationManagementController from '@/controllers/DestinationManagementController';
  import { useRoute } from "vue-router";
  const route = useRoute();
  const destinationID = route.params.id;  
  
  const {
    updateRestaurant,
    confirmUpdateRestaurant,
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
  
  
  onMounted(async () => {
    await showUpdateForm_restaurant(destinationID);
  });
  
  const showUpdateForm_restaurant = async (destinationID) => {
    const destinationData = await updateRestaurant(destinationID);
    currentDestination.value = { ...destinationData };
  };
  
  const submitUpdateRestaurant = async () => {
    await confirmUpdateRestaurant(currentDestination.value);
  };
  
  // Cancel action
  const cancelAction = () => {
    window.history.back();
  };
  
  
  </script>
  
  
  <style scoped>
  .destination-management {
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