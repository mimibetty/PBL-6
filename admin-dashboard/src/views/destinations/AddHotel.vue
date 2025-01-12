<template>
  <div class="destination-management">
    <div class="form-container">
      <form @submit.prevent="submitAddHotel" class="form-style">
        <div class="form-floating mb-4">
          <input type="text" class="form-control" id="propertyAmenities" v-model="hotel.hotel.property_amenities" placeholder=" " required />
          <label for="propertyAmenities">Property Amenities</label>
        </div>
        <div class="form-floating mb-4">
          <input type="text" class="form-control" id="roomFeatures" v-model="hotel.hotel.room_features" placeholder=" " required />
          <label for="roomFeatures">Room Features</label>
        </div>
        <div class="form-floating mb-4">
          <input type="text" class="form-control" id="roomTypes" v-model="hotel.hotel.room_types" placeholder=" " required />
          <label for="roomTypes">Room Types</label>
        </div>
        <div class="form-floating mb-4">
          <input type="number" class="form-control" id="hotelClass" v-model="hotel.hotel.hotel_class" placeholder=" " required />
          <label for="hotelClass">Hotel Class</label>
        </div>
        <div class="form-floating mb-4">
          <input type="text" class="form-control" id="hotelStyles" v-model="hotel.hotel.hotel_styles" placeholder=" " required />
          <label for="hotelStyles">Hotel Styles</label>
        </div>
        <div class="form-floating mb-4">
          <input type="text" class="form-control" id="languages" v-model="hotel.hotel.languages" placeholder=" " required />
          <label for="languages">Languages</label>
        </div>
        <div class="form-floating mb-4">
          <input type="text" class="form-control" id="phoneNumber" v-model="hotel.hotel.phone" placeholder=" " required />
          <label for="phoneNumber">Phone Number</label>
        </div>
        <div class="form-floating mb-4">
          <input type="email" class="form-control" id="businessEmail" v-model="hotel.hotel.email" placeholder=" " required />
          <label for="businessEmail">Business Email</label>
        </div>
        <div class="form-floating mb-4">
          <input type="text" class="form-control" id="businessWebsite" v-model="hotel.hotel.website" placeholder=" " required />
          <label for="businessWebsite">Business Website</label>
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
import { ref, onMounted } from 'vue';
import DestinationManagementController from '@/controllers/DestinationManagementController';
import { useRoute } from "vue-router";

const route = useRoute();
const destinationID = route.params.id;

const { confirmCreateHotel, getDestination } = DestinationManagementController();

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

const hotel = ref({
  id: 0,
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
});

onMounted(async () => {
  await showCreateForm_hotel(destinationID);
});

const showCreateForm_hotel = async (destinationID) => {
  const destination = await getDestination(destinationID);
  hotel.value.id = destination.id;
};

const submitAddHotel = async () => {
  await confirmCreateHotel(hotel.value);
  destination.value = { name: '', description: '' };
};

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
