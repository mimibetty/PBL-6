<template>
    <div class="main-container">
      <div class="flex-row-cdcf">
        <div class="image"></div>
        <span class="travel-tips">Travel Tips</span>
        <button class="union" @click="toggleMenu"></button>
        <button class="home" @click="alert('Đã nhấn Home')">Home</button>
        <button class="travel-itinerary"  @click.prevent="alert('Đã nhấn')">Travel Itinerary</button>
        <button class="tour-proposal"  @click.prevent="alert('Đã nhấn Proposal')">Tour Proposal</button>
        <button class="forum"  @click.prevent="alert('Đã nhấn Forum')">Forum</button>
        <button class="trips"  @click.prevent="alert('Đã nhấn Trip')">Trips</button>
        <div class="menu-container" v-if="isMenuVisible">
              <div class="menu-options">
                <button class="menu-button my-trips">My Trips</button>
                <button class="menu-button review">Review</button>
                <button class="menu-button my-favorite">My Favorite</button>
                <button class="menu-button logout">Logout</button>
              </div>
        </div>
      </div>
      <div class="line"></div>
      
      <div class="line-1"></div>
      <div class="flex-row-c">
        <button class="name-of-destination">HaNoi</button>
        <button class="thing-to-do">Things to do</button>
        <button class="restaurant">Restaurant</button>
        <button class="hotel">Resort & Hotel</button>
      </div>
      <div class="flex-row-d">
        <div class="line-2"></div>
        <div class="line-3"></div>
        <div class="line-4"></div>
      </div>
      <div class="review-container">
        <!-- Left Section -->
        <div class="left-section">
            <div class="image-container">
                <img src="@/assets/images/background_picture.png" alt="Ho Tay Water Park" />
            </div>
            <p class="place-name">Ho Tay Water Park</p>
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
import {
  images,
  isMenuVisible,
  toggleMenu,
  photos,
  handlePhotoUpload,
  submitReview,
  photoPreviews,
} from '../viewModels/uploadPictureViewModel.js';
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
.flex-row-cdcf {
  position: relative;
  width: 100%;
  height: 145px;
  margin: -2px 0 0 0;
  z-index: 30;
}

.image {
  position: absolute;
  width: 8%;
  height: 82%;
  top: 9%;
  left: 1%;
  background: url('@/assets/images/company_image.png')
    no-repeat center;
  background-size: cover;
  z-index: 27;
  border-radius: 70px;
}
.travel-tips {
  display: flex;
  align-items: flex-start;
  justify-content: flex-start;
  position: absolute;
  height: 40%;
  top: 30%;
  left: 12%;
  color: #1836ba;
  font-family: Jost, var(--default-font-family);
  font-size: 3vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  white-space: nowrap;
  z-index: 11;
}
.union {
  position: absolute;
  top: 34%;
  right: 5%;
  width: 4%; /* Đặt kích thước logo phù hợp */
  height: 34%; /* Đặt kích thước logo phù hợp */
  background: url('@/assets/personal.svg') no-repeat center;
  background-size: contain; /* Hoặc cover nếu muốn ảnh bao phủ */
  z-index: 13;
  border: none; /* Đảm bảo không có viền bao quanh logo */
}
.menu-container {
  position: absolute;
  top: 69%; 
  right: 4%; 
  background-color: rgba(0, 0, 0, 0.8);
  padding: 20px;
  border-radius: 1vw;
  z-index: 9999; 
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  width: 100%; 
  max-width: 20%; 
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
  pointer-events: auto; /* Đảm bảo có thể tương tác với menu */
}






.menu-options {
  display: flex;
  flex-direction: column;
  gap: 15px; /* Tăng khoảng cách giữa các nút */
  width: 100%; /* Bảo đảm các nút nằm gọn trong khung */
}

.menu-button {
  background-color: #1877f2; /* Màu xanh đậm giống Facebook */
  color: white; /* Màu chữ trắng */
  font-family: Poppins, var(--default-font-family);
  font-size: 1vw; /* Tăng kích thước chữ */
  font-weight: 700;
  padding: 15px 20px; /* Tăng kích thước vùng bấm */
  border: none;
  border-radius: 6px;
  cursor: pointer;
  width: 100%; /* Đặt rộng 100% so với menu */
  text-align: center; /* Đặt chữ ở giữa */
  transition: background-color 0.3s ease; /* Hiệu ứng hover */
}

.menu-button:hover {
  background-color: #165bb7; /* Màu tối hơn khi hover */
}

.logout {
  background-color: #ff3b30; /* Màu đỏ cho nút Logout */
}

.logout:hover {
  background-color: #c73227; /* Màu đỏ tối hơn khi hover */
}
.travel-itinerary {
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  width: 14%;
  height: 100%;
  top: 0%;
  left: 68%;
  background: none;
  color: #13357b;
  font-family: Poppins, var(--default-font-family);
  font-size: 1.75vw;
  font-weight: 700;
  line-height: 150%;
  text-align: center;
  border: none;
  white-space: nowrap;
  z-index: 21;
}

.home {
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  width: 10%;
  height: 100%;
  top: 0%;
  left: 40%;
  background: #13357b;
  color: #f4fff8;
  font-family: Poppins, var(--default-font-family);
  font-size: 1.75vw;
  font-weight: 700;
  line-height: 150%;
  text-align: center;
  
  white-space: nowrap;
  z-index: 21;
}

.tour-proposal {
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  width: 12%;
  height: 100%;
  top: 0%;
  left: 50%;
  background: none;
  color: #13357b;
  font-family: Poppins, var(--default-font-family);
  font-size: 1.75vw;
  font-weight: 700;
  line-height: 150%;
  text-align: center;
  border: none;
  white-space: nowrap;
  z-index: 21;
}
.forum {
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  width: 6%;
  height: 100%;
  top: 0%;
  left: 82%;
  background: none;
  color: #13357b;
  font-family: Poppins, var(--default-font-family);
  font-size: 1.75vw;
  font-weight: 700;
  line-height: 150%;
  text-align: center;
  border: none;
  white-space: nowrap;
  z-index: 21;
}
.trips {
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  width: 6%;
  height: 100%;
  top: 0%;
  left: 62%;
  background: none;
  color: #13357b;
  font-family: Poppins, var(--default-font-family);
  font-size: 1.75vw;
  font-weight: 700;
  line-height: 150%;
  text-align: center;
  border: none;
  white-space: nowrap;
  z-index: 21;
}

.home:hover, 
.tour-proposal:hover, 
.trips:hover, 
.travel-itinerary:hover, 
.forum:hover {
  background-color: #8c9aec;
  color: #dbe4f5;
}
.line {
  position: absolute;
  width: 100%;
  height: 0.99px;
  margin: 0 0 0 0;
  background-color: #13357b;
  background-size: cover;
  z-index: 2;
}
.line-1 {
  position: relative;
  width: 100%;
  height: 0.99px;
  margin: -0.1% 0 0 0;
  background-color: #13357b;
  background-size: cover;
  z-index: 15;
}
.flex-row-c {
  display: flex; /* Đặt flexbox để các nút nằm cạnh nhau */
  justify-content: 10%; /* Tạo khoảng cách đều giữa các nút */
  align-items: center; /* Căn giữa các nút theo chiều dọc */
  width: 100%;
  height: 60px;
  margin: 7.01px 0 0 25px;
  z-index: 153;
}
.name-of-destination, 
.thing-to-do, 
.restaurant,
.hotel {
  width: 20%; /* Chiều rộng của mỗi nút */
  height: 60px; /* Chiều cao của mỗi nút */
  color: #13357b;
  font-family: Poppins, var(--default-font-family);
  font-size: 2vw;
  font-weight: 700;
  line-height: 100%;
  text-align: center;
  display: flex; /* Sử dụng Flexbox */
  justify-content: center; /* Căn giữa theo chiều ngang */
  align-items: center; /* Căn giữa theo chiều dọc */
  
  background-color: transparent; /* Nền trong suốt */
  border: none; /* Loại bỏ đường viền của nút */
  
  cursor: pointer; /* Con trỏ chuyển thành tay khi hover */
}

.name-of-destination:hover, 
.thing-to-do:hover, 
.restaurant:hover,
.hotel:hover {
  background-color: #f0f0f0; /* Hiệu ứng khi hover vào nút */
}
.flex-row-d {
  position: relative;
  width: 100%;
  height: 2%;
  margin: 9.004px 0 0 0;
  z-index: 20;
}
.line-2 {
  position: absolute;
  width: 100%;
  height: 1.996px;
  top: 0;
  left: 8px;
  background-color: #13357b;
  background-size: cover;
  z-index: 3;
}
.line-3 {
  position: absolute;
  width: 100%;
  height: 1.99px;
  top: 0px;
  left: 8px;
  background-color: #13357b;
  background-size: cover;
  z-index: 16;
}
.line-4 {
  position: absolute;
  width: 20%;
  height: 5px;
  top: -1.504px;
  left: 22%;
  background-color: #13357b;
  background-size: cover;
  z-index: 17;
}
.review-container {
  display: flex;
  flex-direction: row;
  width: 100%;
  background-color: #e3f2fd;
  padding: 20px;
}

/* Left Section */
.left-section {
  flex: 40%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 10px;
}

.image-container img {
  width: 100%;
  border-radius: 10px;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
}

.place-name {
  font-size: 1.5em;
  font-weight: bold;
  text-align: center;
  margin-top: 10px;
}

/* Right Section */
.right-section {
  flex: 60%;
  padding: 20px;
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