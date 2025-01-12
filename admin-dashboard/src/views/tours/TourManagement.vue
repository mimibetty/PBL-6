<template>
  <div class="tour-management">
    <h2>Tour Management</h2>
    <div v-if="isLoading" class="spinner-container">
      <div class="spinner"></div>
    </div>
    <div v-else class="header-container">
      <button class="action-button add-button" @click="showCreateForm">
        Add New Tour
      </button>
      <div class="search-container">
        <input
          type="text"
          v-model="searchQuery"
          placeholder="Search by tour name or user create..."
          class="search-input"
        />
      </div>
      
    </div>
    <div class="table-container">
      <table class="tour-table">
        <thead>
          <tr>
            <th>Tour Name</th>
            <th>User Create</th>
            <th>City</th>
            <th>Duration</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="tour in paginatedTours" :key="tour.id">
            <td>{{ tour.name }}</td>
            <td>{{ getUserName(tour.user_id) }}</td>
            <td>{{ getCityName(tour.city_id) }}</td>
            <td>{{ tour.duration }}</td>
            <td>
              <div class="dropdown">
                <button 
                  class="action-button dropdown-toggle"
                  @click="toggleDropdown(tour.id)"
                >
                  ☰
                </button>
                <div class="dropdown-menu" v-if="activeDropdown === tour.id">
                  <button class="dropdown-item" @click="showUpdateForm(tour.id)">
                    Update Tour
                  </button>
                  <button class="dropdown-item" @click="showDetail(tour.id)">
                    Show Detail
                  </button>
                  <button class="dropdown-item" @click="deleteTour(tour.id)">
                    Delete Tour
                  </button>
                </div>
              </div>
            </td>
          </tr>
        </tbody>
      </table>

      <div class="pagination">
        <button :disabled="currentPage === 1" @click="prevPage" class="pagination-button">
          <span>&lt;</span>
        </button>
        <div class="pagination-numbers">
          <button 
            v-for="page in visiblePages" 
            :key="page" 
            @click="goToPage(page)" 
            :class="{ 'active': currentPage === page }"
          >
            {{ page }}
          </button>
          <span v-if="totalPages > maxVisiblePages && currentPage < totalPages - 2">...</span>
          <button 
            v-if="totalPages > maxVisiblePages" 
            @click="goToPage(totalPages)" 
            :class="{ 'active': currentPage === totalPages }"
          >
            {{ totalPages }}
          </button>
        </div>
        <button :disabled="currentPage === totalPages" @click="nextPage" class="pagination-button">
          <span>&gt;</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import TourManagementController from "@/controllers/TourManagementController";
import { ref, computed, onMounted } from "vue";

const tours = ref([]);
const users = ref([]);
const cities = ref([]);
const currentPage = ref(1);
const itemsPerPage = 5;
const activeDropdown = ref(null);
const searchQuery = ref(""); // Khai báo biến cho thanh tìm kiếm
const isLoading = ref(true);

const {
  fetchTours,
  deleteTour,
  fetchCities,
  fetchUsers,
} = TourManagementController();


const loadTours = async () => {
  tours.value = await fetchTours();
};

const loadUsers = async () => {
  users.value = await fetchUsers();
};

const loadCity = async () => {
  cities.value = await fetchCities();
};

onMounted( async () => {
  await loadCity();
  await loadUsers();
  await loadTours();
  isLoading.value = false;
});

const getCityName = (city_id) => {
  const city = cities.value.find((c) => c.id === city_id);
  return city ? city.name : "Unknown City";
};

const getUserName = (user_id) => {
  const user = users.value.find((c) => c.id === user_id);
  return user ? user.username : "Unknown User";
};

const showCreateForm = () => {
  window.location.assign(`/tours/create`);
};

const showUpdateForm = async (tourID) => {
  window.location.assign(`/tours/update/${tourID}`);
};

const showDetail = async (tourID) => {
  window.location.assign(`/tours/${tourID}`);
};

// Lọc tour theo tên và người tạo
const filteredTours = computed(() => {
  if (!searchQuery.value) {
    return tours.value;
  }

  return tours.value.filter((tour) => {
    const userName = getUserName(tour.user_id).toLowerCase();
    const tourName = tour.name.toLowerCase();
    return (
      userName.includes(searchQuery.value.toLowerCase()) ||
      tourName.includes(searchQuery.value.toLowerCase())
    );
  });
});

// Paginate tours
const paginatedTours = computed(() => {
  const startIndex = (currentPage.value - 1) * itemsPerPage;
  return filteredTours.value.slice(startIndex, startIndex + itemsPerPage);
});

const totalPages = computed(() => Math.ceil(filteredTours.value.length / itemsPerPage));

const prevPage = () => {
  if (currentPage.value > 1) currentPage.value--;
};

const nextPage = () => {
  if (currentPage.value < totalPages.value) currentPage.value++;
};

const maxVisiblePages = 5; // Số trang hiển thị trước và sau trang hiện tại

const visiblePages = computed(() => {
  const pages = [];
  const startPage = Math.max(1, currentPage.value - 2);
  const endPage = Math.min(totalPages.value, currentPage.value + 2);

  for (let i = startPage; i <= endPage; i++) {
    pages.push(i);
  }

  if (pages[0] !== 1) {
    pages.unshift(1); // Thêm trang 1 nếu không nằm trong dải hiển thị
  }

  if (pages[pages.length - 1] !== totalPages.value) {
    pages.push(totalPages.value); // Thêm trang cuối nếu không nằm trong dải hiển thị
  }

  return pages;
});

const goToPage = (page) => {
  currentPage.value = page;
};

const toggleDropdown = (tourId) => {
  activeDropdown.value = activeDropdown.value === tourId ? null : tourId;
};
</script>
  
  <style scoped>
  /* Global styles */
  * {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }
  
  body {
    background-color: #ffffff;
    color: #333333;
    line-height: 1.6;
    font-size: 16px;
  }
  
  /* Tour Management Section */
  .tour-management {
    padding: 20px;
    min-height: 100vh;
    background-color: #ffffff;
  }
  
  h2 {
    margin-bottom: 20px;
    color: #222222;
    font-size: 24px;
    font-weight: bold;
    border-bottom: 2px solid #eaeaea;
    padding-bottom: 10px;
    text-align: center;
  }
  
  /* Table Container */
  .table-container {
    max-height: 85vh;
    overflow-y: auto;
    background-color: #f9f9f9;
    border-radius: 8px;
    padding: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }
  
  /* Custom Scrollbar */
  .table-container::-webkit-scrollbar {
    width: 8px;
  }
  
  .table-container::-webkit-scrollbar-thumb {
    background-color: #cccccc;
    border-radius: 10px;
  }
  
  .table-container::-webkit-scrollbar-track {
    background: #f0f0f0;
  }
  
  /* Modern Table Styling */
  .tour-table {
    width: 100%;
    margin-top: 20px;
    border-collapse: collapse;
    border: 1px solid #dddddd;
  }
  
  .tour-table th,
  .tour-table td {
    padding: 12px 16px;
    text-align: left;
  }
  
  .tour-table th {
    background-color: #f0f0f0;
    font-weight: bold;
    color: #222222;
  }
  
  .tour-table tr:nth-child(even) {
    background-color: #fafafa;
  }
  
  .tour-table tr:nth-child(odd) {
    background-color: #ffffff;
  }
  
  .tour-table tr:hover {
    background-color: #e9f4ff;
  }
  
  .tour-table td {
    color: #555555;
    font-size: 14px;
  }
  
  /* Form Styles */
  .form-container {
    max-width: 600px;
    margin: 20px auto;
    padding: 20px;
    background-color: #ffffff;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
  
  .form-group {
    margin-bottom: 15px;
  }
  
  .form-group label {
    font-size: 14px;
    font-weight: bold;
    margin-bottom: 5px;
    display: block;
  }
  
  input[type="text"],
  input[type="email"],
  input[type="password"],
  input[type="number"],
  input[type="time"],
  input[type="date"],
  textarea,
  select {
    width: 100%;
    padding: 12px;
    font-size: 14px;
    border: 1px solid #cccccc;
    border-radius: 4px;
    background-color: #ffffff;
    color: #333333;
    transition: border-color 0.2s ease-in-out;
  }
  
  input[type="text"]:focus,
  input[type="email"]:focus,
  input[type="password"]:focus,
  input[type="number"]:focus,
  textarea:focus,
  select:focus {
    border-color: #1877f2;
    box-shadow: 0 0 4px rgba(24, 119, 242, 0.2);
    outline: none;
  }
  
  textarea {
    resize: vertical;
    min-height: 100px;
  }
  
  /* Action Buttons */
  button {
    display: inline-block;
    padding: 10px 20px;
    font-size: 14px;
    font-weight: bold;
    color: #ffffff;
    background-color: #0078d4;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.2s ease;
  }
  
  button:hover {
    background-color: #0056b3;
    transform: scale(1.05);
  }
  
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
    background-color: #dc3545;
    color: #ffffff;
    border: none;
    padding: 8px 12px;
    border-radius: 4px;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
  }
  
  .edit-button:hover,
  .add-button:hover,
  .delete-button:hover {
    transform: scale(1.1); /* Phóng to 1.1 lần */
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); /* Tạo hiệu ứng nổi */
  }
  
  .button-group {
    display: flex;
    justify-content: space-between;
    gap: 10px;
    margin-top: 20px;
  }
  
  /* Dropdown Styling */
  select {
    appearance: none;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='6' viewBox='0 0 10 6'%3E%3Cpath fill='%239ca3af' d='M0 0l5 5 5-5H0z'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 12px center;
    background-size: 10px 6px;
  }
  
  select::-webkit-scrollbar {
    width: 8px;
  }
  
  select::-webkit-scrollbar-thumb {
    background-color: #1877f2;
    border-radius: 4px;
  }
  
  select::-webkit-scrollbar-track {
    background: #f5f5f5;
  }
  
  /* Ensure the form container takes up 100% width */
  .destination-group {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 10px;
    width: 100%; /* Ensure it takes full width of the parent */
  }
  
  /* Style for dropdown with custom scroll and font size */
  .destination-group select {
    flex: 7; /* 70% width */
    padding: 12px;
    font-size: 16px;
    color: #333;
    border: 1px solid #d1d5db;
    border-radius: 6px;
    background-color: #f3f4f6;
    outline: none;
    transition: border-color 0.2s ease;
    appearance: none;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='6' viewBox='0 0 10 6'%3E%3Cpath fill='%239ca3af' d='M0 0l5 5 5-5H0z'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 12px center;
    background-size: 10px 6px;
    height: auto; /* Allow height to adjust with the option list */
    overflow-y: auto; /* Enable vertical scroll */
  }
  
  /* Custom scroll style for dropdown */
  .destination-group select::-webkit-scrollbar {
    width: 10px;
  }
  .destination-group select::-webkit-scrollbar-thumb {
    background-color: #0078d4; /* Dark blue scrollbar */
    border-radius: 4px;
  }
  .destination-group select::-webkit-scrollbar-track {
    background: #f3f4f6;
  }
  
  /* Limit dropdown to display a maximum of 10 items before scrolling */
  .destination-group select option {
    max-height: 3.5vh; /* Approximate height per item for visibility */
  }
  .destination-group select {
    max-height: calc(3.5vh * 10); /* Max height to show 10 items */
  }
  
  /* Style for the remove button, taking up 30% of the container width */
  .destination-group .remove-button {
    flex: 3; /* 30% width */
    padding: 10px;
    font-size: 14px;
    color: white;
    background-color: #d9534f; /* Red background for remove button */
    border: none;
    border-radius: 6px;
    cursor: pointer;
    transition: background-color 0.2s ease;
  }
  
  /* Hover and focus effect for the remove button */
  .destination-group .remove-button:hover {
    background-color: #c9302c; /* Darker red on hover */
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
  .icon-city:before {
    content: "\f1ad";
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

  .pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 1rem;
}

.pagination-button {
  background: blue;
  border: none;
  font-size: 1.2rem;
  cursor: pointer;
  padding: 0.5rem 1rem;
  margin: 0 0.5rem;
  border-radius: 50%;
  transition: background-color 0.3s;
}

.pagination-button:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

.pagination-numbers {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.pagination-numbers button {
  background: none;
  border: 1px solid #ccc;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
  color: #020729;
  transition: background-color 0.3s;
}

.pagination-numbers button.active {
  background-color: #000;
  color: #fff;
}

.pagination-numbers button:hover {
  background-color: #0f13e6;
  color: #fff;
}

  .dropdown {
  position: relative;
  display: inline-block;
}

.dropdown-toggle {
  background: blue;
  border: none;
  cursor: pointer;
  font-size: 18px;
}

.dropdown-menu {
  position: absolute;
  top: 100%;
  left: 0;
  z-index: 1000;
  display: flex;
  flex-direction: column;
  background: rgb(0, 238, 255);
  border: 1px solid #ccc;
  border-radius: 4px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
  min-width: 150px;
}

.dropdown-item {
  padding: 8px 16px;
  cursor: pointer;
  text-align: left;
  background: none;
  color: #333;
  border: none;
  width: 100%;
}

.dropdown-item:hover {
  background: #0056b3;
  color: white;
}

.header-container {
  display: flex;
  justify-content: space-between; /* Chia đều không gian giữa 2 phần tử */
  align-items: center; /* Căn chỉnh theo chiều dọc */
  width: 100%;
}

.search-container {
  margin-bottom: 20px;
  text-align: right;
  width: 40%; /* Điều chỉnh chiều rộng của thanh tìm kiếm */
  margin-left: auto; /* Tự động căn trái để thanh tìm kiếm nằm bên phải */
  margin-right: 20px;
}



.search-input {
  padding: 8px 12px;
  border-radius: 4px;
  border: 1px solid #ddd;
  font-size: 14px;
  width: 300px;
  outline: none;
}

.search-input:focus {
  border-color: #1877f2;
  box-shadow: 0 0 0 2px rgba(24, 119, 242, 0.2);
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
  