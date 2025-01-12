<template>
    <div class="container-fluid">
      <header_For_company />
    </div>
    <div class="main-container">
      <div class="review-container">
        <h2>Destination Update for Business</h2>
        <div class="review-title-section">
            <p class="question-title">Destination Name</p>
            <input
              v-model="destination.name"
              type="text"
              class="title-input"
              placeholder="Which place do you need to add ?"
            />
        </div>
        <div class="review-title-section">
            <p class="question-title">Description</p>
            <textarea
              v-model="destination.description"
              class="review-text"
              placeholder="Please input some informtaion about this place ?"
              ></textarea>
        </div>
        <div class="review-title-section">
            <p class="question-title">Bottom Price</p>
            <input
              v-model="destination.price_bottom"
              type="number"
              class="title-input"
              placeholder="Please input the lowest price of this place or $0 if this free ?"
            />
        </div>
        <div class="review-title-section">
            <p class="question-title">Top Price</p>
            <input
              v-model="destination.price_top"
              type="number"
              class="title-input"
              placeholder="Please input the highest price of this place or $0 if this free ?"
            />
        </div>
        <div class="review-title-section">
            <p class="question-title">Age</p>
            <input
              v-model="destination.age"
              type="number"
              class="title-input"
              placeholder="Please input lowest age to go this place or 0 if it can for all people ?"
            />
        </div>
        <div class="review-title-section">
            <p class="question-title">Open time</p>
            <input type="time" v-model="destination.opentime" />
        </div>
        <div class="review-title-section">
            <p class="question-title">Duration</p>
            <input
              v-model="destination.duration"
              type="number"
              class="title-input"
            />
        </div>
          <!-- Date Picker -->
        <div>
            <p class="question-title">City</p>
            <select v-model="destination.address.city_id" class="form-control">
                <option v-for="city in cities" :key="city.id" :value="city.id">
                    {{ city.name }}
                </option>
            </select>
        </div>
        <div class="review-title-section">
            <p class="question-title">District</p>
            <input
              v-model="destination.address.district"
              type="text"
              class="title-input"
            />
        </div>
        <div class="review-title-section">
            <p class="question-title">Ward</p>
            <input
              v-model="destination.address.ward"
              type="text"
              class="title-input"
            />
        </div>
        <div class="review-title-section">
            <p class="question-title">Street</p>
            <input
              v-model="destination.address.street"
              type="text"
              class="title-input"
            />
        </div>
          <!-- Add some photos -->
            <div class="photo-upload-section">
                <p class="question-title">Photo</p>
                <p class="optional-text">Optional</p>
  
          
                <div class="photo-preview-wrapper">
                    <p>Current Image (Can Remove)</p>
                    <div v-for="photo in destination.images" :key="photo.id" class="photo-preview-row">
                        <img :src="photo.url" class="preview-img" />
                        <button class="remove-button" @click.stop="removeExistingImage(photo.id)">-</button>
                    </div>
                    <p>Add new Image</p>
                    <div v-for="(photo, index) in previewNewImages" :key="index" class="photo-preview-row">
                        <img :src="photo" class="preview-img" />
                        <button class="remove-button" @click.stop="removeNewImage(index)">-</button>
                    </div>
                </div>
  
            
                <div class="photo-upload-box">
                    <input type="file" @change="handleNewImageUpload" multiple class="photo-input" />
                    <p class="photo-upload-text">
                        Click to add photos <br /> or drag and drop
                    </p>
                </div>
            </div>
  
              <!-- Submit Review Button -->
          <button class="submit-button" @click="updateDestination">Update Destination</button>
      </div>
    </div>
  </template>
  
  <script setup>
  import BusinessViewModel from "../../viewModels/Business_DestinationViewModel.js"
  import VueDatePicker from '@vuepic/vue-datepicker';
  import '@vuepic/vue-datepicker/dist/main.css';
  import { ref, computed, onMounted, watch } from 'vue';
  import { useRoute } from 'vue-router';
  
  const route = useRoute();
  const destinationID = route.params.id;
  
  
  const {
    cities,
    fetchCities,
    fetchUsers,
    loadUser,
    destination,
    hotel,
    restaurant,
    getDestinationById,
    showAddDestination,
    addDestination,
    updateDestination,
    deleteDestination,
    addHotel,
    updateHotel,
    deleteHotel,
    addRestaurant,
    updateRestaurant,
    deleteRestaurant,
    previewImages,
    previewNewImages,
    handleImageUpload,
    removeImage,
    handleNewImageUpload,
    removeNewImage,
    removeExistingImage,
  } =  BusinessViewModel()

    onMounted(() => {
        fetchCities();
        getDestinationById(destinationID);
    });
  </script>
  
  <script>
      import Header from '../Header.vue';
      import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
      import Top_Button from '../Top_Button.vue';
      import Img_Card from '../Img_Card.vue';
      import Card_Item from '../Card_Item.vue';
      import header_For_company from '../Dashboard_For_Company/header_For_company.vue';
      export default {
          name: "ThingsToDo_List",
          components: {
              Header, Scroll_Bar_Component, Top_Button,
              Img_Card, Card_Item, header_For_company,
          }
      }
  </script>
  
  
    
  <style scoped>
  :root {
    --default-font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
      Ubuntu, "Helvetica Neue", Helvetica, Arial, "PingFang SC",
      "Hiragino Sans GB", "Microsoft Yahei UI", "Microsoft Yahei",
      "Source Han Sans CN", sans-serif;
  }
  
  .main-container {
    overflow: hidden;
  }
  
  .main-container,
  .main-container * {
    box-sizing: border-box;
  }
  
  input,
  select,
  textarea,
  button {
    outline: 0;
  }
  input[type="time"]{
    width: 100%;
    padding: 10px;
    font-size: 1.2em;
    border-radius: 5px;
    border: 1px solid #003366;
    margin-bottom: 20px;
  }
  
  .main-container {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: max-content;
    margin: 0 auto;
    background: #edf6f9;
    overflow: hidden;
    border-radius: 20px;
  }
  .review-container {
    display: flex;
  flex-direction: column;
  gap: 20px;
  padding: 20px;
  background-color: var(--secondary-color);
  border-radius: 10px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    margin-top: 160px;
    
  }
  
  
  .question-title {
    font-weight: bold;
    font-size: 1.2em;
    margin-bottom: 10px;
  }
  
  .rating-container {
    display: flex;
    gap: 2px;
    margin-bottom: 10px;
  }
  
  .rating-circle {
    width: 40px;
    height: 40px;
    cursor: pointer;
  }
  
  .rating-status {
    font-weight: bold;
    font-size: 1.1em;
    color: #003366;
    margin-left: 20px;
    margin-top: 10px;
  }
  
  /* Date Picker */
  .select-container {
    margin-bottom: 20px;
  }
  
  .date-picker {
    font-size: 1.2em;
    padding: 10px;
    font-family: Jost, var(--default-font-family);
    border-radius: 5px;
    border: 1px solid #003366;
  }
  
  /* Review Text */
  .review-text {
    width: 100%;
    height: 100px;
    padding: 10px;
    border-radius: 5px;
    font-family: Jost, var(--default-font-family);
    border: 1px solid #003366;
    font-size: 1.2em;
    resize: none;
  }
  .title-input {
    width: 100%;
    padding: 10px;
    font-size: 1.2em;
    border-radius: 5px;
    border: 1px solid #003366;
    margin-bottom: 20px;
  }
  
  
  .optional-text {
    font-size: 0.9em;
    color: #555;
  }
  
  .photo-upload-section {
    display: flex;
    flex-direction: column; /* Sắp xếp dọc */
    gap: 10px; /* Khoảng cách giữa các phần */
  }
  
  .photo-preview-wrapper {
    display: flex;
    flex-direction: column; /* Danh sách ảnh theo hàng dọc */
    gap: 10px;
  }
  
  .photo-preview-row {
    display: flex;
    align-items: center;
  }
  
  .preview-img {
    width: 100px;
    height: 100px;
    object-fit: cover;
    border-radius: 5px;
    margin-right: 10px;
  }
  
  .remove-button {
    background-color: #ff4d4f;
    color: white;
    border: none;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    font-size: 1.5rem;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
  }
  
  .remove-button:hover {
    background-color: #d9363e;
  }
  
  .photo-upload-box {
    border: 2px dashed #d9d9d9;
    padding: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    text-align: center;
    height: 100px;
  }
  
  .photo-input {
    position: absolute;
    opacity: 0;
    width: 100%;
    height: 100%;
    cursor: pointer;
  }
  
  .submit-button {
    width: 100%;
    padding: 15px;
    background-color: #003366;
    color: white;
    border: none;
    border-radius: 30px;
    font-size: 1.5em;
    font-weight: bold;
    cursor: pointer;
    text-align: center;
  }
  
  .submit-button:hover {
    background-color: #002244;
  }
  .companion-button-group {
    display: flex;
    gap: 1rem; /* Khoảng cách giữa các nút */
    justify-content: center; /* Căn giữa */
  }
  
  .companion-button {
    border: 1px solid #1e3a8a; /* Đường viền xanh */
    background-color: white;
    border-radius: 20px; /* Tạo nút bo tròn */
    padding: 0.5rem 1.5rem; /* Khoảng cách bên trong nút */
    color: #1e3a8a; /* Màu chữ xanh */
    cursor: pointer;
    transition: all 0.3s ease;
  }
  
  .companion-button:hover {
    background-color: #1e3a8a;
    color: white; /* Đổi màu khi hover */
  }
  
  .companion-button.active {
    background-color: #1e3a8a; /* Màu nền khi kích hoạt */
    color: white; /* Màu chữ khi kích hoạt */
    font-weight: bold;
  }
  
  .calendar {
      background-color: none; /* Màu nền xanh nhạt */
      color: #1a237e; /* Chữ xanh đậm */
      border-radius: 8px;
      width: 300px; /* Gọn gàng hơn */
      padding: 12px;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2); /* Tạo chiều sâu */
      font-family: Arial, sans-serif;
  }
  
  </style>