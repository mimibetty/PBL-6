<template>
  <div class="destination-management">
    
    <div class="form-container">
      <form @submit.prevent="submitAddRestaurant" class="form-style">
        <div class="form-floating mb-4">
          <input type="text" class="form-control" id="cuisine" v-model="restaurant.restaurant.cuisine" placeholder=" " required />
          <label for="cuisine">Cuisine</label>
        </div>
        <div class="form-floating mb-4">
          <input type="text" class="form-control" id="specialDiet" v-model="restaurant.restaurant.special_diet" placeholder=" " required />
          <label for="specialDiet">Special Diet</label>
        </div>
        <div class="form-floating mb-4">
          <input type="text" class="form-control" id="features" v-model="restaurant.restaurant.feature" placeholder=" " required />
          <label for="features">Features</label>
        </div>
        <div class="form-floating mb-4">
          <input type="text" class="form-control" id="meal" v-model="restaurant.restaurant.meal" placeholder=" " required />
          <label for="meal">Meal</label>
        </div>
        <div class="button-group">
          <button type="submit" class="btn btn-success">Create</button>
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
    confirmCreateRestaurant,
    getDestination,
  } = DestinationManagementController();
  
  const restaurant = ref({
    id: 0,
    restaurant: {
      cuisine: '',
      special_diet: '',
      feature: '',
      meal: '',
      id: '',
    },
  });
  
  
  onMounted(async () => {
    await showCreateForm_restaurant(destinationID);
  });
  
  
  const showCreateForm_restaurant = async (destinationID) => {
    const destination = await getDestination(destinationID);
    restaurant.value.id = destination.id;
  };
  
  
  const submitAddRestaurant = async () => {
    await confirmCreateRestaurant(restaurant.value);
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
  