<template>
    <div class="destination-management">
      <h2>Destination Management</h2>
      <div v-if="isLoading" class="spinner-container">
        <div class="spinner"></div>
      </div>
  
      <div v-else class="detail-destination">
        <div class="header-overlay">
          <button class="back-button" @click="goBack">
            <i class="icon-back"></i>
            <!-- Icon Font Awesome -->
          </button>
          <h1>Explore Destinations</h1>
          <p>Discover the best places to stay, eat, and visit.</p>
        </div>
  
        <div v-if="currentDestination" class="destination-info">
          <section class="info-section destination-detail">
            <div class="section-header">
              <h2>Destination Detail</h2>
              <p>Explore key details about this destination.</p>
            </div>
            <div class="detail-card">
              <div class="detail-item">
                <i class="icon-dashboard"></i>
                <span
                  ><strong>Name:</strong>
                  {{ currentDestination.name || "N/A" }}</span
                >
              </div>
              <div class="detail-item">
                <i class="icon-info"></i>
                <span
                  ><strong>Description:</strong>
                  {{
                    currentDestination.description || "No description available"
                  }}</span
                >
              </div>
              <div class="detail-item">
                <i class="icon-user"></i>
                <span
                  ><strong>User create:</strong>
                  {{
                    getUserName(currentDestination.user_id) || "No description available"
                  }}</span
                >
              </div>
              <div class="detail-item">
                <i class="icon-location"></i>
                <span
                  ><strong>Address:</strong>
                  {{ currentDestination.address.street || "N/A" }},
                  {{ currentDestination.address.ward || "N/A" }},
                  {{ currentDestination.address.district || "N/A" }},
                  {{ getCityName(currentDestination.address.city_id) || "N/A" }}
                </span>
              </div>
              <div class="detail-item">
                <i class="icon-price"></i>
                <span
                  ><strong>Price Range:</strong> ${{
                    currentDestination.price_bottom || 0
                  }}
                  - ${{ currentDestination.price_top || "N/A" }}</span
                >
              </div>
              <div class="detail-item">
                <i class="icon-duration"></i>
                <span
                  ><strong>Duration:</strong>
                  {{ currentDestination.duration || "N/A" }} hours</span
                >
              </div>
              <div class="detail-item">
                <i class="icon-duration"></i>
                <span
                  ><strong>Opening Time:</strong>
                  {{ currentDestination.opentime || "N/A" }}</span
                >
              </div>
            </div>
            <div class="action-buttons">
              <button @click="showUpdateForm(currentDestination.id)">
                <i class="icon-update"></i> Update destination
              </button>
            </div>
          </section>
  
          <section class="info-section">
            <div class="section-header">
              <h2>Hotel Information</h2>
              <p>Top-rated accommodations for your stay.</p>
            </div>
            <div v-if="currentDestination.hotel" class="info-card">
              <div class="info-item">
                <i class="icon-property-amenities"></i>
                <span
                  ><strong>Property Amenities:</strong>
                  {{ currentDestination.hotel.property_amenities || "N/A" }}</span
                >
              </div>
              <div class="info-item">
                <i class="icon-room-features"></i>
                <span
                  ><strong>Room Features:</strong>
                  {{ currentDestination.hotel.room_features || "N/A" }}</span
                >
              </div>
              <div class="info-item">
                <i class="icon-hotel-style"></i>
                <span
                  ><strong>Hotel Styles</strong>
                  {{ currentDestination.hotel.hotel_styles || "N/A" }}</span
                >
              </div>
              <div class="info-item">
                <i class="icon-hotel"></i>
                <span
                  ><strong>Class:</strong>
                  {{ currentDestination.hotel.hotel_class || "N/A" }} stars</span
                >
              </div>
              <div class="info-item">
                <i class="icon-room"></i>
                <span
                  ><strong>Room Types:</strong>
                  {{ currentDestination.hotel.room_types || "N/A" }}</span
                >
              </div>
              <div class="info-item">
                <i class="icon-language"></i>
                <span
                  ><strong>Languages</strong>
                  {{ currentDestination.hotel.Languages || "N/A" }}</span
                >
              </div>
              <div class="info-item">
                <i class="icon-phone"></i>
                <span
                  ><strong>Phone:</strong>
                  {{ currentDestination.hotel.phone || "N/A" }}</span
                >
              </div>
              <div class="info-item">
                <i class="icon-email"></i>
                <span
                  ><strong>Email:</strong>
                  {{ currentDestination.hotel.email || "N/A" }}</span
                >
              </div>
              <div class="info-item">
                <i class="icon-website"></i>
                <span
                  ><strong>Website:</strong>
                  <a :href="currentDestination.hotel.website" target="_blank">{{
                    currentDestination.hotel.website || "N/A"
                  }}</a></span
                >
              </div>
            </div>
            <div v-else>
              <p class="no-data">Place does not have hotel information.</p>
              <div class="action-buttons">
                <button @click="showCreateForm_hotel(currentDestination.id)">
                  <i class="icon-create"></i> Create hotel
                </button>
              </div>
            </div>
  
            <div v-if="currentDestination.hotel" class="action-buttons">
              <button @click="showUpdateForm_hotel(currentDestination.id)">
                <i class="icon-update"></i> Update hotel
              </button>
              <button @click="deleteHotel(currentDestination.hotel_id)">
                <i class="icon-delete"></i> Delete hotel
              </button>
            </div>
          </section>
  
          <section class="info-section">
            <!-- Restaurant Information -->
            <div class="section-header">
              <h2>Restaurant Information</h2>
              <p>Find the best cuisines and dining experiences.</p>
            </div>
            <div v-if="currentDestination.restaurant" class="info-card">
              <div class="info-item">
                <i class="icon-utensils"></i>
                <span
                  ><strong>Cuisine:</strong>
                  {{ currentDestination.restaurant.cuisine || "N/A" }}</span
                >
              </div>
              <div class="info-item">
                <i class="icon-diet"></i>
                <span
                  ><strong>Special Diet:</strong>
                  {{ currentDestination.restaurant.special_diet || "N/A" }}</span
                >
              </div>
              <div class="info-item">
                <i class="icon-utensils"></i>
                <span
                  ><strong>Features:</strong>
                  {{ currentDestination.restaurant.feature || "N/A" }}</span
                >
              </div>
              <div class="info-item">
                <i class="icon-diet"></i>
                <span
                  ><strong>Meal:</strong>
                  {{ currentDestination.restaurant.meal || "N/A" }}</span
                >
              </div>
            </div>
            <div v-else>
              <p class="no-data">Place does not have restaurant information.</p>
              <div class="action-buttons">
                <button @click="showCreateForm_restaurant(currentDestination.id)">
                  <i class="icon-create"></i> Create Restaurant
                </button>
              </div>
            </div>
  
            <div v-if="currentDestination.restaurant" class="action-buttons">
              <button @click="showUpdateForm_restaurant(currentDestination.id)">
                <i class="icon-update"></i> Update Restaurant
              </button>
              <button @click="deleteRestaurant(currentDestination.restaurant_id)">
                <i class="icon-delete"></i> Delete Restaurant
              </button>
            </div>
          </section>
  
          <!-- Image Gallery -->
          <section class="image-gallery">
            <div class="section-header">
              <h2>Gallery</h2>
              <p>Explore the beauty of this destination.</p>
            </div>
            <div class="gallery-grid">
              <div
                v-for="(image, index) in currentDestination.images"
                :key="index"
                class="gallery-item"
              >
                <img :src="image.url" alt="Destination Image" />
              </div>
            </div>
          </section>
        </div>
  
        <div v-else class="loading">
          <p>Loading destination details...</p>
        </div>
      </div> 
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted, computed } from 'vue';
  import DestinationManagementController from '@/controllers/DestinationManagementController';
  import { useRoute } from "vue-router";
  const route = useRoute();
  
  const cities = ref([]);
  const users = ref([]);
  const destinationID = route.params.id;
  const isLoading = ref(true);
  
  const {
    fetchCities,
    showDetailDestination,
    deleteHotel,
    deleteRestaurant,
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
  
  const loadCity = async () => {
    cities.value = await fetchCities();
  };
  
  const loadUsers = async () => {
    users.value = await fetchUsers();
  };
  
  onMounted(() => {
    loadUsers();
    loadCity();
    showDetail(destinationID);
    isLoading.value = false;
  });
  
  const getCityName = (city_id) => {
    const city = cities.value.find((c) => c.id === city_id);
    return city ? city.name : 'Unknown City';
  };
  
  const getUserName = (user_id) => {
    const user = users.value.find((c) => c.id === user_id);
    return user ? user.username : 'Unknown User';
  };
  
  const showCreateForm_hotel = (destinationID) => {
    window.location.assign(`/destinations/hotel/create/${destinationID}`);
  };
  
  const showCreateForm_restaurant = (destinationID) => {
    window.location.assign(`/destinations/restaurant/create/${destinationID}`);
  };
  
  

  
  const showUpdateForm = async (destinationID) => {
    window.location.assign(`/destinations/update/${destinationID}`);
  };
  
  const showUpdateForm_hotel = async (destinationID) => {
    window.location.assign(`/destinations/hotel/update/${destinationID}`);
  };
  
  const showUpdateForm_restaurant = async (destinationID) => {
    window.location.assign(`/destinations/restaurant/update/${destinationID}`);
  };
  
  const goBack = () => {
    window.location.assign(`/destinations`);
  };
  
  const showDetail = async (destinationID) => {
    const destinationData = await showDetailDestination(destinationID);
    currentDestination.value = { ...destinationData };
  };
  </script>
  
  
  <style scoped>
  * {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }
  
  .destination-management {
    padding: 20px;
    min-height: 90vh;
    background-color: #ffffff;
    color: #333;
  }
  
  h2 {
    margin-bottom: 20px;
    font-size: 24px;
    color: #333;
    text-align: center;
  }
  
  /* Bảng thông tin */
  .table-container {
    max-height: 85vh;
    overflow-y: auto;
    background-color: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    padding: 15px;
  }
  
  .table-container::-webkit-scrollbar {
    width: 8px;
  }
  
  .table-container::-webkit-scrollbar-thumb {
    background-color: #1877f2;
    border-radius: 10px;
  }
  
  .table-container::-webkit-scrollbar-thumb:hover {
    background-color: #145dbf;
  }
  
  .destination-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
  }
  
  .destination-table th,
  .destination-table td {
    padding: 12px;
    text-align: left;
    border-bottom: 1px solid #e5e7eb;
  }
  
  .destination-table th {
    background-color: #f3f4f6;
    font-weight: bold;
    color: #333;
  }
  
  .destination-table tr:nth-child(even) {
    background-color: #f9fafb;
  }
  
  .destination-table tr:hover {
    background-color: #e4e6eb;
  }
  
  button {
    padding: 8px 12px;
    font-size: 14px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
  }
  
  button:hover {
    background-color: #333333;
    color: #ffffff;
  }
  
  /* Nút hành động */
  .action-button {
    padding: 8px 12px;
    margin: 0 5px;
    border-radius: 6px;
    font-size: 14px;
    font-weight: 500;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s ease;
    margin: 10px;
    font-weight: 700;
  }
  
  .action-button:hover {
    filter: brightness(0.9);
  }
  
  .edit-button {
    background-color: #1877f2;
    color: #ffffff;
    border: none;
    padding: 8px 12px;
    border-radius: 4px;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
  }
  
  .add-button {
    background-color: #28a745;
    color: #ffffff;
    border: none;
    padding: 8px 12px;
    border-radius: 4px;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
  }
  
  .delete-button {
    background-color: #ec870b;
    color: #ffffff;
    border: none;
    padding: 8px 12px;
    border-radius: 4px;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
  }
  
  .view-button {
    background-color: #0fb6e0;
    color: #ffffff;
    border: none;
    padding: 8px 12px;
    border-radius: 4px;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
  }
  
  .edit-button:hover,
  .add-button:hover,
  .delete-button:hover,
  .view-button:hover {
    transform: scale(1.1); /* Phóng to 1.1 lần */
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); /* Tạo hiệu ứng nổi */
  }
  
  .button-group {
    display: flex;
    gap: 10px;
    justify-content: flex-end;
  }
  
  /* Form */
  .form-container {
    width: 100%;
    max-width: 600px;
    margin: 20px auto;
    padding: 20px;
    background-color: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  }
  
  .form-group {
    margin-bottom: 15px;
  }
  
  .form-group label {
    font-weight: 500;
    color: #333;
    margin-bottom: 8px;
    display: block;
  }
  
  input,
  select,
  textarea {
    width: 100%;
    padding: 10px;
    font-size: 14px;
    border: 1px solid #e5e7eb;
    border-radius: 6px;
    background-color: #f9fafb;
    color: #333;
    outline: none;
    transition: border-color 0.2s ease;
  }
  
  input:focus,
  select:focus,
  textarea:focus {
    border-color: #1877f2;
    box-shadow: 0 0 0 2px rgba(24, 119, 242, 0.2);
  }
  
  button:hover {
    filter: brightness(0.9);
  }
  
  /* Hình ảnh */
  .image-list {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
  }
  
  .image-item {
    position: relative;
    width: 100px;
    height: 100px;
  }
  
  .image-item img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border: 1px solid #e5e7eb;
    border-radius: 6px;
  }
  
  .image-item button {
    position: absolute;
    top: 5px;
    right: 5px;
    background: #dc3545;
    color: #ffffff;
    border: none;
    border-radius: 50%;
    cursor: pointer;
    padding: 5px;
    font-size: 12px;
    transition: transform 0.2s;
  }
  
  .image-item button:hover {
    transform: scale(1.1);
  }
  
  .pagination {
    margin-top: 20px;
    display: flex;
    justify-content: center;
    gap: 10px;
  }
  
  .pagination button {
    padding: 5px 10px;
    background-color: #007bff;
    border: none;
    color: white;
    cursor: pointer;
    border-radius: 5px;
  }
  
  .pagination button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
  }
  
  .pagination span {
    font-weight: bold;
  }
  
  .back-button {
    position: absolute;
    top: 10px; /* Điều chỉnh vị trí top */
    left: 10px; /* Điều chỉnh vị trí trái */
    background: transparent;
    border: none;
    color: white;
    font-size: 18px;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 5px; /* Khoảng cách giữa icon và text */
  }
  
  .back-button i {
    font-size: 20px; /* Kích thước icon */
  }
  
  .back-button:hover {
    color: #d4d4d4; /* Hiệu ứng hover */
  }
  
  .admin-header {
    position: relative;
    background: linear-gradient(
      to bottom,
      rgba(0, 123, 255, 0.7),
      rgba(0, 123, 255, 0.9)
    );
    color: #fff;
    padding: 20px;
    text-align: center;
    border-radius: 8px;
  }
  
  .header-overlay {
    background: rgba(0, 0, 0, 0.5);
    color: white;
    text-align: center;
    padding: 20px;
    border-radius: 10px;
  }
  
  .header-overlay h1 {
    font-size: 2.5rem;
    font-weight: bold;
  }
  
  .header-overlay p {
    font-size: 1.2rem;
  }
  
  .info-section {
    background: #f9f9f9;
    border-radius: 10px;
    padding: 20px;
    margin: 20px 0;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    position: relative;
  }
  
  /* Section Header */
  .section-header h2 {
    font-size: 1.8rem;
    color: #1e90ff;
    margin-bottom: 10px;
  }
  
  .section-header p {
    font-size: 1rem;
    color: #666;
    margin-bottom: 20px;
  }
  
  /* Info Card */
  .info-card {
    display: flex;
    flex-direction: column;
    gap: 15px;
  }
  
  .info-item {
    display: flex;
    align-items: center;
    background: #ffffff;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 15px;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }
  
  .info-item:hover {
    transform: scale(1.02);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  }
  
  .info-item i {
    font-size: 1.5rem;
    color: #1e90ff;
    margin-right: 15px;
  }
  
  .info-item span {
    font-size: 1rem;
    color: #333;
  }
  
  .info-item strong {
    color: #1e90ff;
  }
  
  /* No Data Message */
  .no-data {
    font-size: 1rem;
    color: #999;
    text-align: center;
    margin-top: 10px;
  }
  
  /* Gallery */
  .image-gallery .gallery-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 15px;
  }
  
  .gallery-item {
    position: relative;
  }
  
  .gallery-item img {
    width: 100%;
    height: 150px;
    object-fit: cover;
    border-radius: 8px;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }
  
  .gallery-item:hover img {
    transform: scale(1.05);
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
  }
  
  .gallery-item:hover img {
    transform: scale(1.5); /* Phóng to 1.5 lần khi hover */
  }
  
  .gallery-item:hover .image-overlay {
    opacity: 1;
  }
  
  .destination-detail {
    background: #f9f9f9;
    border-radius: 10px;
    padding: 20px;
    margin: 20px 0;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
  
  .section-header h2 {
    font-size: 1.8rem;
    color: #1e90ff;
    margin-bottom: 10px;
  }
  
  .section-header p {
    font-size: 1rem;
    color: #666;
    margin-bottom: 20px;
  }
  
  /* Detail Card */
  .detail-card {
    display: flex;
    flex-direction: column;
    gap: 15px;
  }
  
  .detail-item {
    display: flex;
    align-items: center;
    background: #ffffff;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 15px;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }
  
  .detail-item:hover {
    transform: scale(1.02);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  }
  
  .detail-item i {
    font-size: 1.5rem;
    color: #1e90ff;
    margin-right: 15px;
  }
  
  .detail-item span {
    font-size: 1rem;
    color: #333;
  }
  
  .detail-item strong {
    color: #1e90ff;
  }
  
  /* Cấu trúc chung cho icon */
  i {
    margin-right: 8px;
    font-size: 16px;
    display: inline-block;
    font-weight: 900;
    font-family: "Font Awesome 5 Free";
  }
  
  /* Icon cho Dashboard */
  .icon-dashboard:before {
    content: "\f015"; /* Mã Unicode cho icon 'fa-tachometer-alt' */
    color: #007bff; /* Màu xanh lam */
  }
  
  /* Icon cho Địa điểm */
  .icon-location:before {
    content: "\f3c5"; /* Mã Unicode cho icon 'fa-map-marker-alt' */
    color: #ff5733; /* Màu cam */
  }
  
  /* Icon cho Mô tả */
  .icon-info:before {
    content: "\f05a"; /* Mã Unicode cho icon 'fa-info-circle' */
    color: #17a2b8; /* Màu xanh biển nhạt */
  }
  
  /* Icon cho Địa chỉ */
  .icon-address:before {
    content: "\f279"; /* Mã Unicode cho icon 'fa-map' */
    color: #28a745; /* Màu xanh lá cây */
  }
  
  /* Icon cho Giá */
  .icon-price:before {
    content: "\f155"; /* Mã Unicode cho icon 'fa-dollar-sign' */
    color: #ffc107; /* Màu vàng */
  }
  
  /* Icon cho Thời gian */
  .icon-duration:before {
    content: "\f017"; /* Mã Unicode cho icon 'fa-clock' */
    color: #6c757d; /* Màu xám */
  }
  
  /* Icon cho Khách sạn */
  .icon-hotel:before {
    content: "\f594"; /* Mã Unicode cho icon 'fa-hotel' */
    color: #007bff; /* Màu xanh */
  }
  
  /* Icon cho Loại phòng */
  .icon-room:before {
    content: "\f236"; /* Mã Unicode cho icon 'fa-bed' */
    color: #6610f2; /* Màu tím đậm */
  }
  
  /* Icon cho Số điện thoại */
  .icon-phone:before {
    content: "\f095"; /* Mã Unicode cho icon 'fa-phone' */
    color: #dc3545; /* Màu đỏ */
  }
  
  /* Icon cho Email */
  .icon-email:before {
    content: "\f0e0"; /* Mã Unicode cho icon 'fa-envelope' */
    color: #17a2b8; /* Màu xanh biển nhạt */
  }
  
  /* Icon cho Website */
  .icon-website:before {
    content: "\f0ac"; /* Mã Unicode cho icon 'fa-globe' */
    color: #28a745; /* Màu xanh lá cây */
  }
  
  /* Icon cho Nhà hàng */
  .icon-utensils:before {
    content: "\f2e7"; /* Mã Unicode cho icon 'fa-utensils' */
    color: #ff5733; /* Màu cam */
  }
  
  /* Icon cho Chế độ ăn đặc biệt */
  .icon-diet:before {
    content: "\f6f0"; /* Mã Unicode cho icon 'fa-leaf' */
    color: #28a745; /* Màu xanh lá cây */
  }
  
  .icon-back:before {
    content: "\f104"; /* Mã Unicode cho icon 'fa-leaf' */
    color: #17a2b8; /* Màu xanh lá cây */
  }
  
  .icon-update:before {
    content: "\f044";
    color: #007bff;
  }
  
  .icon-delete:before {
    content: "\f2ed";
    color: #dc3545;
  }
  
  .icon-create:before {
    content: "\f0e7";
    color: #28a745;
  }
  
  .icon-property-amenities:before {
    content: "\f1ad"; /* Mã Unicode cho 'fa-concierge-bell' */
    color: #007bff; /* Màu xanh lam */
  }
  
  .icon-room-features:before {
    content: "\f236"; /* Mã Unicode cho 'fa-bed' */
    color: #6c757d; /* Màu xám */
  }
  
  .icon-hotel-style:before {
    content: "\f005"; /* Mã Unicode cho 'fa-star' */
    color: #ffc107; /* Màu vàng */
  }
  
  .icon-language:before {
    content: "\f1ab"; /* Mã Unicode cho 'fa-globe' */
    color: #28a745; /* Màu xanh lá */
  }
  
  .icon-user:before {
    content: "\f007";
    color: #007bff;
  }
  
  /* CSS cho các action button */
  .action-buttons {
    display: flex;
    justify-content: flex-end; /* Đẩy các nút về phía phải */
    gap: 10px; /* Khoảng cách giữa các nút */
    margin-top: 10px; /* Tạo khoảng cách giữa nút và phần phía trên */
  }
  
  .action-buttons button {
    background-color: transparent;
    border: 1px solid #007bff; /* Màu viền cho nút */
    color: #007bff; /* Màu chữ cho nút */
    padding: 10px 20px;
    font-size: 14px;
    border-radius: 5px; /* Bo tròn góc cho nút */
    cursor: pointer;
    display: flex;
    align-items: center;
  }
  
  .action-buttons button i {
    margin-right: 5px; /* Khoảng cách giữa icon và chữ */
  }
  
  .action-buttons button:hover {
    background-color: #007bff;
    color: #fff; /* Màu chữ khi hover */
  }
  
  /* Căn nút ở góc phải trong phần Hotel Information và Restaurant Information */
  .detail-card .action-buttons,
  .info-card .action-buttons {
    position: absolute; /* Vị trí tuyệt đối so với phần tử cha */
    right: 0;
    top: 10px;
    display: flex;
    gap: 10px;
  }
  
  /* Điều chỉnh nút khi không có dữ liệu */
  .no-data .action-buttons {
    justify-content: flex-end;
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
  