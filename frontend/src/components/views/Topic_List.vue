<template>
    <div class="main-container">
      <div class="flex-row-b">
        <div class="image"></div>
        <span class="travel-tips">Travel Tips</span>
        <button class="union" @click="toggleMenu"></button>
        <button class="home" @click="alert('Đã nhấn Home')">Home</button>
        <button class="travel-itinerary"  @click.prevent="alert('Đã nhấn')">Travel Itinerary</button>
        <button class="tour-proposal"  @click.prevent="alert('Đã nhấn Proposal')">Tour Proposal</button>
        <button class="forum"  @click.prevent="alert('Đã nhấn Forum')">Forum</button>
        <button class="trips"  @click.prevent="alert('Đã nhấn Trip')">Trips</button>
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
        <button class="thing-to-do">Things to do</button>
        <button class="restaurant">Restaurant</button>
        <button class="hotel">Resort & Hotel</button>
      </div>

      <div class="flex-row-aa">
        
        <div class="line-3"></div>
      </div>
      <div class="container">
        <div class="left-panel">
            <div class="dropdown">
                <!-- Button hiển thị tên quốc gia hoặc tỉnh thành được chọn -->
                <button 
                    class="dropdown-button" 
                    :class="{ 'active': dropdownVisible }" 
                    @click="toggleDropdown">
                    {{ selectedRegion }}
                    <span class="arrow" :class="{ 'up': dropdownVisible }">▼</span>
                </button>
                
                <!-- Dropdown danh sách các lựa chọn -->
                <div class="dropdown-list" v-if="dropdownVisible">
                    <button 
                        class="dropdown-item" 
                        v-for="region in regions" 
                            :key="region" 
                            @click="selectRegion(region)">
                            {{ region }}
                    </button>
                </div>

            </div>
        </div>
        <div class="right-panel">
            <button class="back" @click="prevButton"></button>
            <div class="button-grid">
                
                <button 
                    v-for="(item, index) in visibleButtons" 
                    :key="index" 
                    class="button-item" 
                    :class="{ selected: selectedIndex === (currentIndexButton + index) }"    
                    @click="selectButton(index)"
                >
                    {{ item }}
                </button>
                
            </div>
            <button class="forward" @click="nextButton"></button>
        </div>
      </div>
      
      
      <span class="thing-to-do-1">Top Attractions in HaNoi</span>
      <div class="flex-row-cff">
        <div v-for="(item, index) in entertainments" :key="index" class="picture">
          
          <img :src="getImageUrl(item.imageUrl)" alt="Entertainment Image" class="entertainment-img" />

        
          <div class="heart-button" @click="toggleLikeStatus(item.id)">
            <img :src="liked[item.id] ? heartFull : heartEmpty" alt="heart icon" class="heart-icon" />
          </div>

      
          <div class="info">
            <h3 class="item-name">{{ item.name }}</h3>
            <div class="rating">
              <img v-for="star in generateStars(item.rating)" :src="star" class="star" />
              <span class="rating-count">{{ item.reviewNumber }}</span>
            </div>
            <div class="tags">
              <span v-for="tag in item.tag" :key="tag" class="tag">{{ tag }}</span>
            </div>
            <div class="line-10"></div>
            <span class="item-description">{{ item.description }}</span>
          </div>
        </div>
      </div>
      
      
    </div>
  </template>

<script setup>
import destinationViewModel from '../viewModels/Topic_ListViewModel';

const {
    isMenuVisible,
    toggleMenu,
    
    buttons,
    visibleButtons,
    prevButton,
    nextButton,
    selectedIndex,
    selectButton,
    currentIndexButton,
    entertainments,
    generateStars,
    getImageUrl,
    liked,
    toggleLikeStatus,
    heartFull: heartFull,
    heartEmpty: heartEmpty,

    // Các biến và hàm cho chức năng chọn tỉnh thành
    regions, // Danh sách tỉnh thành
    selectedRegion, // Tỉnh thành hiện tại
    dropdownVisible, // Trạng thái dropdown
    toggleDropdown, // Hàm bật/tắt dropdown
    selectRegion, // Hàm chọn tỉnh thành
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



.container { 
    position: relative;
    display: flex;
    align-items: center;
    background-color: #e8f4f8;
    padding: 40px;
    height: 200px;
    top: 50px;
    left: 10%;
    right: 10%;
    border-radius: 10px;
    width: 100%;
}

.left-panel {
  width: 20%;
  padding: 20px;
  border-radius: 10px;
  position: relative;
}

.right-panel {
  width: 70%;
  padding: 20px;
  position: relative;
  display: flex;
  justify-content: space-between; /* Căn chỉnh phần tử với khoảng cách đều */
  align-items: center; /* Căn giữa các phần tử theo chiều dọc */
  box-sizing: border-box;
}

.dropdown {
    position: relative;
    display: inline-block;
}

/* Container cho nút dropdown và danh sách */
.dropdown-container {
  position: relative;
  display: inline-block;
  
}

/* Nút dropdown */
.dropdown-button {
  background-color: #b3e5fc;
  color: #0d47a1;
  padding: 10px 20px;
  border: none;
  border-radius: 20px;
  font-size: 1.75vw;
  cursor: pointer;
  display: inline-flex;
  align-items: center;
  font-weight: bold;
}

/* Khi nút được nhấn (dropdownVisible === true) */
.dropdown-button.active {
  background-color: #0d47a1; /* Nền xanh đậm */
  color: white; /* Chữ trắng */
}

/* Mũi tên bên phải của nút */
.dropdown-button .arrow {
  margin-left: 10px;
  font-size: 12px;
  transition: transform 0.3s;
}

/* Khi mũi tên lộn ngược (dropdownVisible === true) */
.dropdown-button .arrow.up {
  transform: rotate(180deg);
}

/* Danh sách dropdown */
.dropdown-list {
  position: absolute;
  top: 40px;
  left: 0;
  background-color: #e3f2fd;
  border-radius: 10px;
  padding: 10px 0;
  width: 100%;
  box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.1);
  z-index: 1000;
  max-height: 400px; /* Giới hạn chiều cao */
  overflow-y: auto; /* Cho phép scroll dọc */
}
/* Tùy chỉnh scrollbar (chỉ hoạt động trên WebKit - Chrome, Safari) */
.dropdown-list::-webkit-scrollbar {
  width: 20px; /* Độ rộng của scrollbar */
}

.dropdown-list::-webkit-scrollbar-track {
  background: #e3f2fd; /* Màu nền của track */
  border-radius: 10px; /* Bo tròn track scrollbar */
}

.dropdown-list::-webkit-scrollbar-thumb {
  background-color: #0d47a1; /* Màu của thanh cuộn */
  border-radius: 10px; /* Bo tròn thanh cuộn */
  border: 2px solid #e3f2fd; /* Đường viền quanh thanh cuộn */
}

.dropdown-list::-webkit-scrollbar-thumb:hover {
  background-color: #1565c0; /* Màu thanh cuộn khi hover */
}
/* Từng mục trong dropdown */
.dropdown-item {
  background-color: transparent;
  color: #0d47a1;
  padding: 10px 20px;
  border: none;
  text-align: left;
  width: 100%;
  cursor: pointer;
  font-size: 1.5vw;
  transition: background-color 0.3s;
}

.dropdown-item:hover {
  background-color: #0d47a1;
  color: #e3f2fd;
}

/* Để tùy chỉnh thêm */
.dropdown-item:focus {
  outline: none;
}

button {
  border: none; /* Loại bỏ viền mặc định của nút */
  background-color: transparent; /* Nền trong suốt */
  cursor: pointer; /* Thay đổi con trỏ khi di chuột vào */
  padding: 0; /* Loại bỏ padding mặc định */
}

.back, .forward {
  width: 5%;  /* Chiếm 5% chiều rộng */
  height: 50px; /* Điều chỉnh kích thước theo chiều cao */
  background-size: 100% 100%;
  background-repeat: no-repeat;
  border: none;
  cursor: pointer;
}

.back {
  background: url('@/assets/back-button.svg') center no-repeat; /* Icon cho nút back */
}

.forward {
  background: url('@/assets/forward-button.svg') center no-repeat; /* Icon cho nút forward */
}

.button-grid {
  width: 80%; 
  display: grid;
  grid-template-columns: repeat(3, 1fr); /* Chia 3 cột */
  grid-gap: 5%;  /* Khoảng cách giữa các nút */
  justify-items: center;  /* Căn giữa các nút */
}

.button-item {
  background-color: #e9eef0;
  color: #003366;
  border: 2px solid #003366;
  width: 100%;  /* Nút chiếm toàn bộ chiều rộng của cột */
  font-size: 1.75vw;
  font-weight: bold;
  border-radius: 20px;
  cursor: pointer;
  transition: background-color 0.3s, color 0.3s;
}

button.selected {
  background-color: #003366;
  color: white;
}
.thing-to-do-1 {
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
  height: calc(3 * 25%);
  margin: 0 6% 12% 0;
  border-radius: 20px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-between; /* Đảm bảo các phần tử nằm giữa */
  border: 1px solid #ccc; /* Thêm viền */
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Đổ bóng nhạt */
  transition: all 0.3s ease-in-out; /* Hiệu ứng hover */
}

.picture:hover {
  transform: translateY(-5px); /* Nổi lên khi hover */
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); /* Tăng độ nổi bóng khi hover */
  border-color: #888; /* Thay đổi màu viền khi hover */
}

.heart-button {
  position: absolute;
  width: 45px;
  height: 45px;
  top: 16px;
  right: 16px;
  background-color: #c5dff8; /* Màu xanh dương nhạt */
  border-radius: 50%; /* Giữ hình tròn */
  cursor: pointer;
  z-index: 99;
  display: flex;
  justify-content: center;
  align-items: center;
}

.heart-icon {
  width: 36px;
  height: 36px;
  margin: auto;
  background-size: 100% 100%;
  background-position: center;
  background-repeat: no-repeat;
}

/* Styling for the entertainment image */
.entertainment-img {
  width: 100%;
  height: 70%;
  object-fit: cover;
  border-radius: 20px 20px 0 0;
  flex-shrink: 0;
}

.info {
  width: 100%;
  text-align: left; /* Căn trái hoàn toàn */
  color: #003366;
  margin: 2px 0;
  font-size: 1.25vw;
  padding: 10px 5px;
}

.item-name {
  font-weight: bold; /* In đậm tên */
  font-size: 18px;
}

.rating img {
  width: 20px;
  height: 20px;
}

.tags {
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
  align-items: center;
  font-size: 14px;
  color: #003366;
}

.tag {
  display: inline-block;
  padding: 5px 10px;
  background-color: #e8f4f8;
  border-radius: 5px;
  position: relative;
  font-size: 0.8vw;
  margin-right: 5px; /* Khoảng cách giữa các tag */
}

.tag::after {
  content: "&"; /* Thêm ký tự & sau mỗi tag */
  position: absolute;
  right: -10px;
  color: #003366;
}

.tag:last-child::after {
  content: ""; /* Xóa ký tự & cho tag cuối cùng */
}

.line-10 {
  width: 100%; /* Dòng kẻ kéo dài toàn bộ chiều rộng */
  height: 1px; /* Độ dày của dòng kẻ */
  background-color: #061a46; /* Màu xanh đậm */
  margin: 10px 0; /* Khoảng cách trên và dưới dòng kẻ */
}

.item-description{
  display: inline-block;
  color: #003366;
  padding: 5px 5px;
  margin: 2px 0;
  font-size: 1vw;
  border-radius: 5px;
}

.rating-count{
  display: inline-block;
  color: #003366;
  padding: 0px 5px;
  margin: 2px 0;
  border-radius: 5px;
}



</style>