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
            

            <!-- Add some photos -->
            <div class="photo-upload-section">
                <p class="question-title">Add some photos</p>
                <p class="optional-text">Optional</p>

                <!-- Photo upload box with overlapping preview images -->
                <div class="photo-upload-box">
                    <!-- Upload input -->
                    <input type="file" @change="handlePhotoUpload" multiple class="photo-input" />
                    <!-- Default Text (hidden when photos are uploaded) -->
                    <p class="photo-upload-text" v-if="!photoPreviews.length">
                        Click to add photos <br /> or drag and drop
                    </p>

                    <!-- Display image previews directly inside the box -->
                    <div class="photo-preview-wrapper" v-if="photoPreviews.length">
                        <div v-for="(photo, index) in photoPreviews" :key="index" class="photo-preview">
                            <img :src="photo" class="preview-img" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Submit Review Button -->
            <button class="submit-button" @click="submitReview">Submit Review</button>
        </div>
      </div>
    </div>
</template>
  
<script setup>
import ReviewViewModel from '../../viewModels/uploadPictureViewModel.js'
import { useRoute } from 'vue-router';

const route = useRoute();
const destinationID = route.params.id;
const {
  destination,
  handlePhotoUpload,
  submitReview,
  photoPreviews,
} = ReviewViewModel(destinationID) ;
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
html, body {
  height: 100%; /* Đảm bảo body và html đều chiếm chiều cao đầy đủ */
  margin: 0;
}

.main-container {
  position: relative; /* Đổi từ absolute thành relative */
  width: 100%;
  min-height: 100vh; /* Đảm bảo chiều cao tối thiểu bằng viewport */
  height: 100%;
  margin: 0 auto;
  background: none;
  overflow: hidden;
  border-radius: 20px;
  display: flex; /* Giúp container mở rộng bao quanh nội dung */
  flex-direction: column; /* Nội dung xếp dọc */
}
.review-container {
  display: flex;
  flex-direction: row;
  width: 100%;
  background-color: none;
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

.photo-upload-section {
  margin-bottom: 20px;
}

.optional-text {
  font-size: 0.9em;
  color: #555;
}

.photo-upload-box {
    border: 2px dashed #d9d9d9;
    padding: 10px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    position: relative;
    overflow: hidden; /* Ẩn các phần tràn ra ngoài */
}

.photo-upload-text {
    text-align: center;
    color: #003366;
    font-size: 1.1em;
}

.photo-input {
    position: absolute;
    opacity: 0;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    cursor: pointer;
}

.photo-preview-wrapper {
    display: flex;
    width: 100%;
    justify-content: flex-start; /* Căn chỉnh sang bên trái */
    flex-wrap: nowrap; /* Đảm bảo hình không bị xuống dòng */
    overflow-x: auto; /* Cho phép kéo ngang nếu có quá nhiều hình */
    padding: 10px 0; /* Khoảng cách bên trên và dưới */
}

.photo-preview {
    flex: 0 0 auto; /* Không cho phép co giãn và đảm bảo kích thước ổn định */
    margin: 5px;
    max-width: 150px; /* Đặt giới hạn kích thước tối đa cho mỗi hình */
    height: auto;
    overflow: hidden; /* Ẩn các phần tràn ra ngoài */
}

.preview-img {
    width: 100%;
    height: auto;
    border-radius: 5px;
    object-fit: cover; /* Đảm bảo hình ảnh giữ tỷ lệ khi hiển thị */
    transition: transform 0.2s; /* Hiệu ứng zoom khi hover */
}

.preview-img:hover {
    transform: scale(1.1); /* Zoom khi hover */
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
</style>