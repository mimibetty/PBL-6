<template>
    <div class="tour-management">
      <h2>Tag Management</h2>
      <div class="detail-destination">
        <div class="header-overlay">
          <button class="back-button" @click="goBack">
            <i class="icon-back"></i>
            <!-- Icon Font Awesome -->
          </button>
        </div>
  
        <div v-if="tag" class="destination-info">
          <section class="info-section destination-detail">
            <div class="section-header">
              <h2>Tag Detail</h2>
              <p>Explore key details about the tag.</p>
            </div>
            <div class="detail-card">
              <div class="detail-item">
                <i class="icon-dashboard"></i>
                <span><strong>Name:</strong>{{ tag.name || "N/A" }}</span>
              </div>
            </div>
            <div class="action-buttons">
              <button @click="showAddDesForm(tag.id)">
                <i class="icon-create"></i> Add Tag to Destination
              </button>
              <button @click="showUpdateForm(tag.id)">
                <i class="icon-update"></i> Update Tag
              </button>
            </div>
          </section>
  
          <section class="info-section">
            <div class="section-header">
              <h2>Destination get this tag</h2>
            </div>
            <div v-if="destinations" class="info-card">
              <div
                class="info-item"
                v-for="(destination, index) in destinations"
                :key="index"
              >
                <i class="icon-info"></i>
                <span>
                  <strong>Destination Name:</strong>
                  {{ destination.name || "N/A" }}
                </span>
              </div>
            </div>
          </section>
        </div>
  
        <div v-else class="loading">
          <p>Loading tag details...</p>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
import { ref, onMounted } from "vue";
import TagManagementController from "@/controllers/TagManagementController";
import { useRoute } from "vue-router";
  const route = useRoute();
  const tagID = route.params.id;  

const {
  getTag,
  getDestByTagID,
} = TagManagementController();

const destinations = ref([]);

const tag = ref({
  id: 0,
  name: "",
});


onMounted(async () => {
  tag.value = await getTag(tagID);
  destinations.value = await getDestByTagID(tagID);
});


const showUpdateForm = async (tagID) => {
  window.location.assign(`/tags/update${tagID}/`);
};


const showAddDesForm = async (tag_id) => {
  window.location.assign(`/tags/${tag_id}/add-destination`);
};

const goBack = () => {
  window.history.back();
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
  </style>
  