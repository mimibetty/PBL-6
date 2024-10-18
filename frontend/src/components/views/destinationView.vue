<template>
    <div class="main-container">
      <div class="flex-row-b">
        <div class="rectangle">
            <a href="#" class="home"  @click.prevent="alert('Đã nhấn Home')">Home</a>
          </div>
        <div class="image"></div>
        <span class="travel-tips">Travel Tips</span>
        <button class="union" @click="toggleMenu"></button>
        <a href="#" class="travel-itinerary"  @click.prevent="alert('Đã nhấn')">Travel Itinerary</a>
        <a href="#" class="tour-proposal"  @click.prevent="alert('Đã nhấn Proposal')">Tour Proposal</a>
        <a href="#" class="forum"  @click.prevent="alert('Đã nhấn Forum')">Forum</a>
        <a href="#" class="trips"  @click.prevent="alert('Đã nhấn Trip')">Trips</a>
        <div class="line"></div>

        <div class="menu-container" v-if="isMenuVisible">
              <div class="menu-options">
                <button class="menu-button my-trips">My Trips</button>
                <button class="menu-button review">Review</button>
                <button class="menu-button my-favorite">My Favorite</button>
                <button class="menu-button logout">Logout</button>
              </div>
        </div>
      </div>
      <div class="line-1"></div>
      <div class="flex-row-bf">
        <button class="name-of-destination">HaNoi</button>
        <button class="thing-to-do">Things to do</button>
        <button class="restaurant">Restaurant</button>
        <button class="hotel">Resort & Hotel</button>
      </div>

      <div class="flex-row-aa">
        
        <div class="line-3"></div>
        <div class="line-4"></div>
      </div>
      <div class="flex-row">
        <div class="image-list" v-for="image in images" :key="image.id">
          <img :src="currentImage" :alt="`City ${image.id}`" class="city-image">
        </div>
        <button class="back" @click="prevImage"></button>
        <button class="forward" @click="nextImage"></button>
      </div>
      <div class="flex-row-ba">
        <div class="rectangle-8">
          <span class="save">Save</span>
          <!-- Bổ sung @click để chuyển màu khi nhấn -->
          <div class="heart" @click="toggleHeart">
            <img :src="isHeartFilled ? heartFull : heartEmpty" alt="Heart Icon" class="icon" />
          </div>
        </div>
        <span class="discover">Discover</span>
      </div>

      <span class="destination">Ha Noi</span>
      <span class="description">{{ truncatedDescription }}</span>
      <div class="read-more" @click="toggleReadMore">
        <span class="line-9">{{ isReadMore ? 'Read less' : 'Read more' }}</span>
        
      </div>
      <span class="filter-suggestion">Characteristic of Ha Noi</span>
      <span class="option-category">Select a category to filter suggestion</span>
      <div class="slider">
        <button 
          v-for="(item, index) in buttons" 
            :key="index" 
          class="button-item" 
          :class="{ selected: selectedIndices.includes(index) }" 
          @click="selectButton(index)"
        >
          {{ item }}
        </button>
      </div>
      
      <span class="entertainment-1d">Entertainment</span>
      <div class="flex-row-cff">
        <div v-for="(item, index) in entertainments" :key="index" class="picture">
          
          <img :src="getImageUrl(item.imageUrl)" alt="Entertainment Image" class="entertainment-img" />

        
          <div class="heart-button" @click="toggleLikeStatus(item.id)">
            <div class="heart-icon"></div>
          </div>

      
          <div class="info">
            <h3>{{ item.name }}</h3>
            <div class="rating">
              <img v-for="star in generateStars(item.rating)" :src="star" class="star" />
            </div>
            <div class="tags">
              <span v-for="tag in item.tag" :key="tag" class="tag">{{ tag }}</span>
            </div>
          </div>
        </div>
      </div>
      <span class="food-drink">Food & Drink</span>
      <div class="flex-row-cff1">
        <div v-for="(item, index) in entertainments" :key="index" class="picture">
          
          <img :src="getImageUrl(item.imageUrl)" alt="Entertainment Image" class="entertainment-img" />

        
          <div class="heart-button" @click="toggleLikeStatus(item.id)">
            <div class="heart-icon"></div>
          </div>

      
          <div class="info">
            <h3>{{ item.name }}</h3>
            <div class="rating">
              <img v-for="star in generateStars(item.rating)" :src="star" class="star" />
            </div>
            <div class="tags">
              <span v-for="(tag, i) in item.tag" :key="i" class="tag">{{ tag }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import destinationViewModel from '../viewModels/destinationViewModel';

const {
  images,
  isMenuVisible,
  toggleMenu,
  currentImage,
  nextImage,
  prevImage,
  isHeartFilled,
  toggleHeart,
  truncatedDescription,
  toggleReadMore,
  buttons,
  selectedIndices,
  selectButton,
  entertainments,
  generateStars,
  getImageUrl,
  liked,
  toggleLikeStatus,
  heartFull,
  heartEmpty,
} = destinationViewModel();


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

.flex-row-b {
  position: relative;
  width: 100%;
  height: 145px;
  margin: -2px 0 0 0;
  z-index: 30;
}
.rectangle {
  position: absolute;
  width: 9%;
  height: 100%;
  top: 0;
  left: 40%;
  background: #13357b;
  z-index: 20;
}
.home {
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  width: 5%;
  height: 20%;
  top: 40%;
  left: 50%;
  color: #f4fff8;
  font-family: Poppins, var(--default-font-family);
  font-size: 1.75vw;
  font-weight: 700;
  line-height: 150%;
  text-align: center;
  
  white-space: nowrap;
  z-index: 21;
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

/* Cho các phần tử khác */
.other-elements {
  pointer-events: none; /* Ngăn không cho phần tử khác chặn menu */
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
  align-items: flex-start;
  justify-content: flex-start;
  position: absolute;
  height: 20%;
  top: 40%;
  left: 70%;
  color: #1836ba;
  font-family: Poppins, var(--default-font-family);
  font-size: 1.5vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  white-space: nowrap;
  z-index: 17;
}
.tour-proposal {
  display: flex;
  align-items: flex-start;
  justify-content: flex-start;
  position: absolute;
  height: 20%;
  top: 40%;
  left: 52%;
  color: #1836ba;
  font-family: Poppins, var(--default-font-family);
  font-size: 1.5vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  white-space: nowrap;
  z-index: 15;
}
.forum {
  display: flex;
  align-items: flex-start;
  justify-content: flex-start;
  position: absolute;
  height: 20%;
  top: 40%;
  left: 83%;
  color: #1836ba;
  font-family: Poppins, var(--default-font-family);
  font-size: 1.5vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  white-space: nowrap;
  z-index: 18;
}
.trips {
  display: flex;
  align-items: flex-start;
  justify-content: flex-start;
  position: absolute;
  height: 20%;
  top: 40%;
  left: 65%;
  color: #1836ba;
  font-family: Poppins, var(--default-font-family);
  font-size: 1.5vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  white-space: nowrap;
  z-index: 16;
}
.line {
  position: absolute;
  width: 100%;
  height: 2%;
  top: 99%;
  left: 0;
  background-color: #13357b;
  z-index: 15;
}
.line-1 {
  position: relative;
  width: 100%;
  height: 1%;
  margin: 0 0 0 8px;
  background-color: #13357b;
  z-index: 2;
}
.flex-row-bf {
  display: flex; /* Đặt flexbox để các nút nằm cạnh nhau */
  justify-content: 10%; /* Tạo khoảng cách đều giữa các nút */
  align-items: center; /* Căn giữa các nút theo chiều dọc */
  width: 100%; /* Tổng chiều rộng của container */
  margin: 8.01px 0 0 33px;
  z-index: 154;
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
.flex-row-aa {
  position: relative;
  width: 100%;
  height: 2%;
  margin: 9.004px 0 0 0;
  z-index: 20;
}

.line-3 {
  position: absolute;
  width: 100%;
  height: 1.99px;
  top: 0px;
  left: 0;
  background-color: #13357b;
  background-size: cover;
  z-index: 16;
}
.line-4 {
  position: absolute;
  width: 16%;
  height: 5px;
  top: -1%;
  left: 4%;
  background-color: #061a46;
  background-size: cover;
  z-index: 150;
}
.flex-row {
  position: relative;
  width: 90%;
  height: 468px;
  margin: 8% 0 0 5%;
  z-index: 22;
}

.image-list {
  position: absolute;
  width: 95%;
  height: 100%;
  top: 0;
  left: 2.4%;
  background: black no-repeat center;
  background-size: cover;
  z-index: 19;
  border-radius: 20px;
}

.frame {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-wrap: nowrap;
  gap: 8px;
  position: relative;
  width: 5.6%;
  margin: 92% 0 0 39%;
  padding: 8px 12px 8px 12px;
  z-index: 24;
  border-radius: 50px;
  backdrop-filter: blur(20px);
}

.platter {
  flex-shrink: 0;
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 25;
  overflow: hidden;
  border-radius: 100px;
}

.ultrathin {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  background: rgba(189, 224, 254, 0.75);
  z-index: 26;
  backdrop-filter: blur(25px);
}

.city-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 20px;
}

/* Điều chỉnh nút back và forward */
.back, .forward {
  width: 50px; /* Kích thước chiều rộng của nút dựa trên phần tử cha */
  height: 50px; /* Kích thước chiều cao của nút */
  background-size: 100% 100%; /* Bắt buộc SVG thay đổi kích thước theo khung */
  background-repeat: no-repeat; /* Tránh lặp lại hình ảnh */
  border: none;
}

.back {
  position: absolute;
  top: 50%; 
  transform: translateY(-50%);
  left: 2%; 
  background: url('@/assets/back.svg') center; /* Hình nền cho nút back */
  z-index: 21;
}

.forward {
  position: absolute;
  top: 50%; 
  transform: translateY(-50%);
  right: 2%; 
  background: url('@/assets/forward.svg') center; /* Hình nền cho nút forward */
  z-index: 22;
}


.flex-row-ba {
  position: relative;
  width: 46%;
  height: 57px;
  margin: 2% 0 0 7.7%;
  z-index: 39;
}

.rectangle-8 {
  position: absolute;
  width: 30%;
  height: 100%;
  top: 0;
  left: 80%;
  border: 2px solid #13357b;
  z-index: 39;
  border-radius: 20px; /* Bo góc vừa phải */
  box-sizing: content-box;
}

.save {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  position: absolute;
  height: 75%;
  top: 14%;
  left: 40%;
  color: #13357b;
  font-family: Jost, var(--default-font-family);
  font-size: 2vw;
  font-weight: 700;
  line-height: 100%;
  text-align: center;
  white-space: nowrap;
  z-index: 40;
}

.heart {
  position: absolute;
  width: 40%;
  height: 70%;
  top: 18%;
  left: 15%;
  z-index: 152;
  overflow: hidden;
}
.icon {
  width: 38.839px; /* Đặt chiều rộng cho icon */
  height: 34.386px; /* Đặt chiều cao cho icon */
  margin: 2.997px 0 0 0.58px;
}


.discover {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  position: absolute;
  top: 24%;
  right: 36%;
  bottom: 0.5%;
  left: 0;
  color: #13357b;
  font-family: Jost, var(--default-font-family);
  font-size: 2vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  white-space: nowrap;
  z-index: 37;
}
.destination {
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  width: 11.5%;
  height: 64px;
  margin: 3% 0 0 7%;
  color: #13357b;
  font-family: Roboto, var(--default-font-family);
  font-size: 3vw;
  font-weight: 700;
  line-height: 100%;
  text-align: center;
  white-space: nowrap;
  z-index: 36;
}

.description {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  position: relative;
  width: 70%;
  height: auto;
  margin: 1% 0 0 8%;
  color: #13357b;
  font-family: Jost, var(--default-font-family);
  font-size: 1.5vw;
  font-weight: 400;
  line-height: 100%;
  text-align: left;
  z-index: 32;
}

.read-more {
  position: relative;
  display: flex;
  align-items: center;
  width: 12%; /* Điều chỉnh kích thước để phù hợp với văn bản và mũi tên */
  height: 29px;
  margin: 1% 0 0 8%;
  z-index: 35;
  cursor: pointer;
}

.line-9 {
  display: inline-flex;
  align-items: center;
  color: #13357b;
  font-family: Jost, var(--default-font-family);
  font-size: 1.5vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  text-decoration: underline;
  white-space: nowrap;
}

.line-9::after {
  content: '';
  display: inline-block;
  width: 18px; /* Điều chỉnh kích thước mũi tên */
  height: 18px;
  margin-left: 8px; /* Khoảng cách giữa văn bản và mũi tên */
  background: url('@/assets/images/read-more-arrow.png') no-repeat center;
  background-size: cover;
}

.filter-suggestion {
  display: block;
  position: relative;
  height: 50px;
  margin: 3% 0 0 8%;
  color: #13357b;
  font-family: Jost, var(--default-font-family);
  font-size: 2.5vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  white-space: nowrap;
  z-index: 68;
}

.option-category {
  display: block;
  position: relative;
  height: 29px;
  margin: 0 0 0 8%;
  color: #13357b;
  font-family: Jost, var(--default-font-family);
  font-size: 1.75vw;
  font-weight: 400;
  line-height: 100%;
  text-align: left;
  white-space: nowrap;
  z-index: 69;
}

.slider {
    position: relative; /* Hoặc absolute, tùy vào cách bố trí */
    left: 8%; /* Căn chỉnh lề trái */
    display: flex; 
    overflow-x: auto; 
    white-space: nowrap; 
    padding: 10px; 
    
    border-radius: 15px; 
    max-width: 100%; 
}


.button-item {
    background-color: transparent;
    color: #003366;
    border: 2px solid #003366;
    width: 15%;
    height: 40px;
    font-size: 1.75vw;
    font-weight: bold;
    border-radius: 20px; /* Bo góc vừa phải */
    cursor: pointer;
    transition: background-color 0.3s, color 0.3s;
    flex-shrink: 0;
    margin-right: 4%; /* Khoảng cách giữa các nút */
}

.button-item:last-child {
    margin-right: 0; /* Không thêm khoảng cách cho nút cuối cùng */
}

button.selected {
    background-color: #003366; 
    color: white; 
}
.entertainment-1d {
  display: block;
  position: relative;
  height: 53px;
  margin: 4.5% 0 0 8%;
  color: #000000;
  font-family: Poppins, var(--default-font-family);
  font-size: 2.5vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  white-space: nowrap;
  z-index: 149;
}
.flex-row-cff {
  display: flex;
  flex-wrap: wrap;
  width: calc(84% + 3.5% * 2); 
  margin: 4.5% 0 0 8%;
  z-index: 125;
}

.picture {
  position: relative;
  width: 25%;
  height: calc(2 * 25%);
  margin: 0 6% 12% 0;
  background-color: #ffffff;
  border-radius: 20px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  align-items: center;
}


.heart-button {
  position: absolute;
  width: 45px;
  height: 45px;
  top: 16px;
  right: 16px;
  background: url('@/assets/images/circle.png') no-repeat center;
  background-size: cover;
  border-radius: 50%;
  cursor: pointer;
  z-index: 99;
}

.heart-icon {
  width: 36px;
  height: 36px;
  margin: auto;
  background-size: 100% 100%;
  background-position: center;
  background-repeat: no-repeat;
  background-image: url('@/assets/heart-none.svg');
}

.heart-button.active .heart-icon {
  background-image: url('@/assets/heart-full.svg');
}

/* Styling for the entertainment image */
.entertainment-img {
  width: 100%;
  height: 70%;
  object-fit: cover;
  border-radius: 20px 20px 0 0;
}

.info {
  margin-top: 10px;
  text-align: center;
}

.rating img {
  width: 20px;
  height: 20px;
}

.tags {
  margin-top: 10px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.tag {
  display: inline-block;
  background-color: #f4f6f7; /* Màu xanh dương */
  color: rgb(56, 21, 232);
  padding: 5px 10px;
  margin: 5px 0;
  border-radius: 5px;
}

.food-drink {
  display: block;
  position: relative;
  height: 53px;
  margin: 4.5% 0 0 8%;
  color: #000000;
  font-family: Poppins, var(--default-font-family);
  font-size: 2.5vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  white-space: nowrap;
  z-index: 311;
}
.flex-row-cff1 {
  display: flex;
  flex-wrap: wrap;
  width: calc(84% + 3.5% * 2); 
  margin: 4.5% 0 0 8%;
  z-index: 125;
}





</style>