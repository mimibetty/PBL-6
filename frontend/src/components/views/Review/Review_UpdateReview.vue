<template>
    <div class="container-fluid">
      <Header />
      <Top_Button />
    </div>
    <div class="main-container">
      <div class="review-container">
        <!-- Left Section -->
        <div class="left-section">
          <div class="image-container">
            <img :src="destination.images[0]?.url || '/blue-image.jpg'" alt="Image" />
            <p class="place-name">{{ destination?.name || 'Loading...' }}</p>
          </div>
        </div>
  
        <!-- Right Section -->
        <div class="right-section">
          <!-- Rating Section -->
          <p class="question-title">How would you rate your experience</p>
          <div class="rating-container">
            <img
              v-for="index in 5"
              :key="index"
              :src="index <= (hoveredRating || currentRating) ? fullStar : emptyStar"
              @mouseover="hoverRating(index)"
              @mouseleave="leaveRating"
              @click="setRating(index)"
              class="rating-circle"
              alt="rating circle"
            />
            <p class="rating-status">
            {{
              (hoveredRating > 0 && hoveredRating <= 5)
                ? statuses[hoveredRating - 1]
                : ratingStatus
            }}
          </p>
          </div>
          
  
          <!-- Date Picker -->
          <div>
            <p class="question-title">When did you go?</p>
            <div class="select-container">
              <VueDatePicker
                v-model="rawSelectedDate"
                color="primary"
                :format="'dd/MM/yyyy'"
                :enableTime="false"
                @update:modelValue="onDateChange"
                class="calendar"
                disabled
              />
            </div>
          </div>
  
          <p class="question-title">Who did you go with?</p>
            <div class="companion-button-group">
              <button
                v-for="option in companions"
                :key="option.value"
                :class="['companion-button', { active: selectedCompanion?.value === option.value }]"
                @click="selectCompanion(option.value)"
              >
              {{ option.label }}
            </button>
          </div>
  
          <!-- Review Section -->
          
          <div class="review-title-section">
          <p class="question-title">Language</p>
          <select v-model="review.language" class="language-dropdown">
            <option v-for="lang in languages" :key="lang" :value="lang">
              {{ lang }}
            </option>
          </select>
        </div>
  
          <div class="review-title-section">
            <p class="question-title">Title your review</p>
            <input
              v-model="review.title"
              type="text"
              class="title-input"
              placeholder="Give us the gist of your experience"
            />
          </div>
  
          <p class="question-title">Write your review</p>
          <textarea
            v-model="review.content"
            class="review-text"
            placeholder="Share your thoughts"
          ></textarea>
  
          <div class="photo-upload-section">
            <p class="question-title">Photo</p>
            <p class="optional-text">Optional</p>
  
          
            <div class="photo-preview-wrapper">
                <p>Current Image (Can Remove)</p>
                <div v-for="photo in review.images" :key="photo.id" class="photo-preview-row">
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
          <button class="submit-button" @click="submitReview">Submit Review</button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import ReviewViewModel from "../../viewModels/Review_UpdateViewModel.js"
  import VueDatePicker from '@vuepic/vue-datepicker';
  import '@vuepic/vue-datepicker/dist/main.css';
  import { useRoute } from 'vue-router';
  
  const route = useRoute();
  const reviewID = route.params.id;

  const languages = [
  'Korean',
  'Japanese',
  'English',
  'Vietnamese',
  'Thai',
  'Chinese',
  'French',
];
  
  const {
    destination,
    review,
    fullStar,
    halfStar,
    emptyStar,
    rawSelectedDate,
    onDateChange,
    currentRating,
    ratingStatus,
    hoverRating,
    leaveRating,
    setRating,
    hoveredRating,
    companions,
    selectedCompanion,
    selectCompanion,
    visitDate,
    previewNewImages,
    handleNewImageUpload,
    removeNewImage,
    removeExistingImage,
    submitReview,
  } =  ReviewViewModel(reviewID)
  
  const statuses = ['Terrible', 'Bad', 'Medium', 'Very Good', 'Excellent']; // Status labels for ratings
  </script>
  
  <script>
      import Header from '../Header.vue';
      import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
      import Top_Button from '../Top_Button.vue';
      import Img_Card from '../Img_Card.vue';
      import Card_Item from '../Card_Item.vue';
      export default {
          name: "ThingsToDo_List",
          components: {
              Header, Scroll_Bar_Component, Top_Button,
              Img_Card, Card_Item,
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
    flex-direction: row;
    width: 100%;
    background-color: #e3f2fd;
    padding: 20px;
    margin-top: 160px;
  }
  
  /* Left Section */
  .left-section {
    flex: 30%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 10px;
  }
  
  .image-container {
    width: 80%;
    padding: 40px;
    border: 3px solid #1a237e; /* Thêm khung viền xanh */
    border-radius: 10px; /* Làm bo tròn góc khung */
    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1); /* Hiệu ứng đổ bóng */
    justify-content: center;
  }
  
  .image-container img {
    width: 100%; /* Chiều rộng chiếm toàn bộ container */
    aspect-ratio: 4 / 5; /* Tỉ lệ 1.5 lần chiều rộng (2:3) */
    object-fit: cover; /* Đảm bảo hình không bị méo */
    border-radius: 10px; /* Làm bo tròn hình bên trong khung */
    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.3); /* Hiệu ứng nổi ảnh */
  }
  
  .place-name {
    font-size: 1.5em;
    font-weight: bold;
    text-align: center;
    margin-top: 20px;
    color: #1a237e; /* Đổi màu chữ */
    text-shadow: 0px 2px 4px rgba(0, 0, 0, 0.3); /* Hiệu ứng nổi chữ */
  }
  
  /* Right Section */
  .right-section {
    flex: 60%;
    padding: 20px;
    border-left: 2px solid #1a237e; /* Đường chia giữa */
    margin-left: 80px;
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

  .language-dropdown {
  width: 100%;
  padding: 10px 15px;
  font-size: 16px;
  font-weight: 500;
  border: 1px solid #ddd;
  border-radius: 8px;
  background-color: #f5f6f7; /* Nhẹ nhàng, giống nền Facebook */
  color: #1c1e21; /* Màu chữ tối */
  transition: all 0.3s ease;
  appearance: none; /* Loại bỏ giao diện mặc định */
  outline: none;
  cursor: pointer;
}

.language-dropdown:hover {
  background-color: #e4e6eb; /* Màu hover nhẹ */
  border-color: #ccd0d5;
}

.language-dropdown:focus {
  border-color: #1877f2; /* Màu xanh Facebook khi được chọn */
  box-shadow: 0 0 4px rgba(24, 119, 242, 0.6); /* Hiệu ứng ánh sáng */
}

.language-dropdown option {
  background-color: #ffffff;
  color: #1c1e21;
}

.language-dropdown:disabled {
  background-color: #ebedf0; /* Màu xám khi bị vô hiệu hóa */
  color: #9a9a9a;
  cursor: not-allowed;
}
  
  </style>