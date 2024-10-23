<template>
    <div class="main-container">
        <div class="flex-row-b">
            <div class="image"></div>
            <span class="travel-tips">Travel Tips</span>
            <button class="union" @click="toggleMenu"></button>
            <button class="home" @click="alert('Đã nhấn Home')">Home</button>
            <button class="travel-itinerary" @click.prevent="alert('Đã nhấn')">Travel Itinerary</button>
            <button class="tour-proposal" @click.prevent="alert('Đã nhấn Proposal')">Tour Proposal</button>
            <button class="forum" @click.prevent="alert('Đã nhấn Forum')">Forum</button>
            <button class="trips" @click.prevent="alert('Đã nhấn Trip')">Trips</button>
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
            <div class="line-4"></div>
        </div>

        <div class="search-section">
            <div class="search-background">
                <div class="overlay">
                    <div class="search-bar">
                        <input type="text" placeholder="Attraction, activities or destination" v-model="searchQuery" />
                        <button class="search-button">Search</button>
                    </div>
                </div>
            </div>
        </div>

        <h1 class="title-cities">Top destination in Vietnam</h1>
        <div class="flex-row-cff">
            <button class="back" @click="prevCity"></button>

            <div class="picture-container">
                <div v-for="(item, index) in visibleCities" :key="index" class="picture">
                    <img :src="getImageUrl(item.imageUrl)" alt="City Image" class="city-img" />


                    <div class="info">
                        <h3 class="item-name">{{ item.name }}</h3>
                    </div>
                </div>
            </div>

            <button class="forward" @click="nextCity"></button>
        </div>
        <h1 class="title-cities">Top attractions in Vietnam</h1>
        <div class="flex-row-cff1">
            <button class="back" @click="prevAttraction"></button>

            <div class="picture-container">
                <div v-for="(item, index) in visibleAttraction" :key="index" class="picture">
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
                    </div>
                </div>
            </div>

            <button class="forward" @click="nextAttraction"></button>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, watch, nextTick } from 'vue';
import destinationViewModel from '../viewModels/ThingToDo_ListViewModel';

const {
    isMenuVisible,
    toggleMenu,
    
    
    generateStars,
    getImageUrl,
    liked,
    toggleLikeStatus,
    heartFull: heartFull,
    heartEmpty: heartEmpty,
    searchQuery,
    cities,
    visibleCities,
    prevCity,
    nextCity,
    attractions,
    visibleAttraction,
    prevAttraction,
    nextAttraction,
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
.line-4 {
  position: absolute;
  width: 16%;
  height: 5px;
  top: -1%;
  left: 5%;
  background-color: #061a46;
  background-size: cover;
  z-index: 150;
}

.search-section {
  width: 100%;
  height: 500px;
  position: relative;
  margin-top: 50px;
}

.search-background {
  background-image: url('@/assets/images/hotel_background.jpg');
  background-size: cover;
  background-position: center;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.overlay {
  background-color: rgba(0, 0, 0, 0.4);
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  color: white;
}

h1 {
  font-size: 2.5vw;
  margin-bottom: 20px;
}

.search-bar {
  position: relative;
  width: 40%;
}

.search-bar input {
  width: 100%;
  padding: 15px;
  border-radius: 25px;
  border: none;
  font-size: 1.5vw;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

.search-bar .search-button {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  padding: 10px 20px;
  border: none;
  border-radius: 25px;
  background-color: #0d3b9e;
  color: white;
  font-size: 1.5vw;
  cursor: pointer;
}

.search-bar .search-button:hover {
  background-color: #0a337a;
}


.title-cities{
  font-size: 2.5vw;
  margin-top: 50px;
  margin-left: 20px;
  font-weight: bold;
  color: #0a337a;
  margin-bottom: 20px;
}


.flex-row-cff {
  display: flex;
  justify-content: space-between; /* Căn đều các phần tử */
  align-items: center; /* Căn giữa theo chiều dọc */
  width: 90%;
  margin-left: 5%;
  margin-right: 5%;
  position: relative;
}

.flex-row-cff1 {
  display: flex;
  justify-content: space-between; /* Căn đều các phần tử */
  align-items: center; /* Căn giữa theo chiều dọc */
  width: 90%;
  margin-left: 5%;
  margin-right: 5%;
  position: relative;
}

.picture-container {
  display: grid;
  grid-template-columns: repeat(4, 1fr); /* Hiển thị 4 cột */
  margin-left:10%;
  margin-right:10%;
  gap: 20px;
  flex-grow: 1; /* Đảm bảo khối hình ảnh chiếm phần lớn không gian */
  margin: 0 20px;
}

.picture {
  position: relative;
  width: 100%; /* Đảm bảo mỗi hình ảnh chiếm toàn bộ ô lưới */
  height: 300px;
  border-radius: 20px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  border: 1px solid #ccc;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease-in-out;
}

.picture:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
  border-color: #888;
}

.heart-button {
  position: absolute;
  width: 45px;
  height: 45px;
  top: 16px;
  right: 16px;
  background-color: #c5dff8;
  border-radius: 50%;
  cursor: pointer;
  z-index: 99;
  display: flex;
  justify-content: center;
  align-items: center;
}

.heart-icon {
  width: 36px;
  height: 36px;
}

.entertainment-img {
  width: 100%;
  height: 60%;
  object-fit: cover;
  border-radius: 20px 20px 0 0;
  flex-shrink: 0;
}

.city-img {
  width: 100%;
  height: 80%;
  object-fit: cover;
  border-radius: 20px 20px 0 0;
  flex-shrink: 0;
}

.info {
  width: 100%;
  text-align: left;
  color: #003366;
  margin: 2px 0;
  font-size: 1.25vw;
  padding: 10px 5px;
}

.item-name {
  font-weight: bold;
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
  font-size: 0.8vw;
  margin-right: 5px;
}



.rating-count {
  color: #003366;
  padding: 0px 5px;
  margin: 2px 0;
  border-radius: 5px;
}

button {
  border: none; /* Loại bỏ viền mặc định của nút */
  background-color: transparent; /* Nền trong suốt */
  cursor: pointer; /* Thay đổi con trỏ khi di chuột vào */
  padding: 0; /* Loại bỏ padding mặc định */
}

/* Điều chỉnh nút back và forward */
.back, .forward {
  width: 70px; /* Kích thước chiều rộng của nút dựa trên phần tử cha */
  height: 70px; /* Kích thước chiều cao của nút */
  background-size: 100% 100%; /* Bắt buộc SVG thay đổi kích thước theo khung */
  background-repeat: no-repeat; /* Tránh lặp lại hình ảnh */
  border: none;
}

.back {
  position: absolute;
  top: 50%; 
  transform: translateY(-50%);
  left: 2%; 
  background: url('@/assets/back-button.svg') center; /* Hình nền cho nút back */
  z-index: 21;
}

.forward {
  position: absolute;
  top: 50%; 
  transform: translateY(-50%);
  right: 2%; 
  background: url('@/assets/forward-button.svg') center; /* Hình nền cho nút forward */
  z-index: 22;
}

</style>