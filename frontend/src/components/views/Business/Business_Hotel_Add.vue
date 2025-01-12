<template>
    <div class="container-fluid">
      <header_For_company />
    </div>
    <div class="main-container">
      <div class="review-container">
        <h2>Hotel Create - For {{ destination.name }}</h2>
        <div class="review-title-section">
            <p class="question-title">Property Amenities</p>
            <input
              v-model="hotel.hotel.property_amenities"
              type="text"
              class="title-input"
            />
        </div>
        <div class="review-title-section">
            <p class="question-title">Room Features</p>
            <textarea
              v-model="hotel.hotel.room_features"
              class="review-text"
              ></textarea>
        </div>
        <div class="review-title-section">
            <p class="question-title">Room Type</p>
            <input
              v-model="hotel.hotel.room_types"
              type="text"
              class="title-input"
            />
        </div>
        <div class="review-title-section">
            <p class="question-title">Hotel Class</p>
            <input
              v-model="hotel.hotel.hotel_class"
              type="number"
              class="title-input"
            />
        </div>
        <div class="review-title-section">
            <p class="question-title">Hotel style</p>
            <input
              v-model="hotel.hotel.hotel_styles"
              type="text"
              class="title-input"
            />
        </div>
        <div class="review-title-section">
            <p class="question-title">Languages</p>
            <input
              v-model="hotel.hotel.Languages"
              type="text"
              class="title-input"
            />
        </div>
        <div class="review-title-section">
            <p class="question-title">Phone number</p>
            <input
              v-model="hotel.hotel.phone"
              type="text"
              class="title-input"
            />
        </div>
        <div class="review-title-section">
            <p class="question-title">Business Email</p>
            <input
              v-model="hotel.hotel.email"
              type="email"
              class="title-input"
            />
        </div>
        <div class="review-title-section">
            <p class="question-title">Website</p>
            <input
              v-model="hotel.hotel.website"
              type="text"
              class="title-input"
            />
        </div>
  
              <!-- Submit Review Button -->
          <button class="submit-button" @click="addHotel">Create Hotel</button>
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
        getDestinationById(destinationID).then(() => {
        // Đảm bảo destination.value đã sẵn sàng trước khi gán cho hotel.value
        if (destination.value && destination.value.id) {
            hotel.value.id = destination.value.id;
        } else {
            console.error("Destination chưa có giá trị hoặc id không tồn tại");
        }
    }).catch(error => {
        console.error("Lỗi khi lấy destination:", error);
    });
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
  
  
    
  <style>
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