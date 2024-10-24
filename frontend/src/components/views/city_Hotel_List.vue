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
            <button class="name-of-destination">HaNoi</button>
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
                    <h1>Find your perfect Hotel to rest</h1>
                    <div class="search-bar">
                        <input type="text" placeholder="Attraction, activities or destination" v-model="searchQuery" />
                        <button class="search-button">Search</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="container">
            <div class="left-panel">
                <div class="filter-section">
                    <div class="filter-item" @click="toggleOptions('property-type-options')" :class="{ active: activeOption === 'property-type-options' }">
                        Property Type
                        <span class="arrow">&#9662;</span>
                    </div>
                    <div v-if="activeOption === 'property-type-options'" class="options">
                        <div class="option">
                            <input type="checkbox" id="hotels" />
                            <label for="hotels">Hotels</label>
                        </div>
                        <div class="option">
                            <input type="checkbox" id="bb-inns" />
                            <label for="bb-inns">B&Bs & Inns</label>
                        </div>
                        <div class="option">
                            <input type="checkbox" id="specialty-lodgings" />
                            <label for="specialty-lodgings">Specialty Lodgings</label>
                        </div>
                        <div class="option">
                            <input type="checkbox" id="hostels" />
                            <label for="hostels">Hostels</label>
                        </div>
                        <div class="option">
                            <input type="checkbox" id="condos" />
                            <label for="condos">Condos</label>
                        </div>
                        <div class="option">
                            <input type="checkbox" id="lodges" />
                            <label for="lodges">Lodges</label>
                        </div>
                        <div class="option">
                            <input type="checkbox" id="villa" />
                            <label for="villa">Villa</label>
                        </div>
                        <div class="option">
                            <input type="checkbox" id="resorts" />
                            <label for="resorts">Resorts</label>
                        </div>
                        <div class="option">
                            <input type="checkbox" id="motels" />
                            <label for="motels">Motels</label>
                        </div>
                        <div class="option">
                            <input type="checkbox" id="all-inclusives" />
                            <label for="all-inclusives">All-inclusives</label>
                        </div>
                        <div class="option">
                            <input type="checkbox" id="campgrounds" />
                            <label for="campgrounds">Campgrounds</label>
                        </div>
                        <div class="option">
                            <input type="checkbox" id="cottage" />
                            <label for="cottage">Cottage</label>
                        </div>
                        <div class="option">
                            <input type="checkbox" id="pensions" />
                            <label for="pensions">Pensions</label>
                        </div>
                        <div class="option">
                            <input type="checkbox" id="capsule-hotels" />
                            <label for="capsule-hotels">Capsule Hotels</label>
                        </div>
                    </div>


                    <div class="filter-item" @click="toggleOptions('price-options')" :class="{ active: activeOption === 'price-options' }">
                        Price
                        <span class="arrow">&#9662;</span>
                    </div>
                    <div v-if="activeOption === 'price-options'" class="options">
                        <div class="currency-options">
                            <label>
                                <input type="radio" name="currency" value="VND" checked @change="handleCurrencyChange('VND')" /> VNĐ
                            </label>
                            <label>
                                <input type="radio" name="currency" value="USD" @change="handleCurrencyChange('USD')" /> USD
                            </label>
                        </div>
                        <div class="price-inputs">
                            <input
                                type="number"
                                v-model="minPrice"
                                @input="updateSliderFromInput('min')"
                                :placeholder="currency === 'USD' ? 'Min Price (USD)' : 'Min Price (VNĐ)'"
                                min="0"
                            />
                            <span>-</span>
                            <input
                                type="number"
                                v-model="maxPrice"
                                @input="updateSliderFromInput('max')"
                                :placeholder="currency === 'USD' ? 'Max Price (USD)' : 'Max Price (VNĐ)'"
                                min="0"
                            />
                        </div>
                        <div id="price-slider" class="range-slider"></div>
                        <div class="price-labels">
                            <span>{{ new Intl.NumberFormat('vi-VN', { style: 'currency', currency }).format(minPrice) }}</span>
                            <span>-</span>
                            <span>{{ new Intl.NumberFormat('vi-VN', { style: 'currency', currency }).format(maxPrice) }}</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="right-panel">
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
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, watch, nextTick } from 'vue';
import destinationViewModel from '../viewModels/city_Hotel_ListViewModel';

const {
  isMenuVisible,
  toggleMenu,
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
  currency,
  minPrice,
  maxPrice,
  setupSlider,
  updatePrice,
  handleCurrencyChange,
  activeOption,
  toggleOptions,
  searchQuery,
  updateSliderFromInput
} = destinationViewModel();

// Khởi tạo slider khi component được mount
watch(activeOption, async (newValue) => {
  console.log('Active Option Changed:', newValue);
  if (newValue === 'price-options') {
    await nextTick(); // Đợi cho DOM cập nhật
    setupSlider();
  }
});
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
  left: 63%;
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


.container {
  display: flex;
  width: 100%;
}

.left-panel {
  width: 30%;
  padding: 20px;
  background-color: #f9fafc;
  border-radius: 10px;
}

.right-panel {
  width: 70%;
  padding: 20px;
}

.filter-section {
  background-color: #f1f5f7;
  border-radius: 10px;
  padding: 10px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.filter-item {
  background-color: #f7f9fc;
  color:#003366;
  font-weight: bold;
  padding: 10px;
  margin-bottom: 5px;
  cursor: pointer;
  border-radius: 5px;
  display: flex;
  font-size: 2vw;
  justify-content: space-between;
  align-items: center;
  transition: background-color 0.3s;
}

.filter-item:hover {
  background-color: #2f549e; /* Màu nền khi hover */
  color:#e0f7ff;
}

.filter-item.active {
  background-color: #13357b; /* Màu nền khi active */
  color:#e0f7ff;
}

.options {
  display: block; /* Đặt lại thành block để hiển thị */
  padding: 10px;
  background-color: #f2f5f7; /* Màu nền nhẹ */
  border-radius: 8px; /* Đường viền tròn hơn */
  margin-bottom: 15px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2); /* Đổ bóng để tạo hiệu ứng nổi */
  align-items: center;
}

/* Cấu trúc cơ bản của từng phần tử trong option */
.option {
  display: flex; /* Sử dụng flexbox để căn chỉnh */
  align-items: center; /* Căn giữa theo chiều dọc */
  background-color: #f6f8fa; /* Màu nền mặc định */
  border-radius: 8px; /* Bo góc cho khung */
  padding: 10px 15px; /* Khoảng cách padding trong khung */
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2); /* Hiệu ứng đổ bóng */
  cursor: pointer; /* Hiển thị con trỏ dạng pointer khi hover */
  transition: background-color 0.3s ease; /* Hiệu ứng chuyển màu nền */
  position: relative; /* Vị trí tương đối cho label và checkbox */
  margin-bottom: 10px; /* Khoảng cách giữa các option */
}

/* Màu nền thay đổi khi hover */
.option:hover {
  background-color: #b0e0ff; /* Đổi màu khi hover */
}

/* Ẩn checkbox mặc định */
.option input[type="checkbox"] {
  position: absolute;
  opacity: 0;
}

/* Khung tùy chỉnh cho checkbox chưa chọn */
.option input[type="checkbox"] + label::before {
  content: ''; /* Nội dung mặc định */
  display: inline-block;
  width: 25px;
  height: 25px;
  margin-right: 10px;
  background-color: transparent; /* Nền trong suốt khi chưa chọn */
  border: 2px solid #0056b3; /* Viền màu xanh lam */
  border-radius: 4px; /* Bo góc cho checkbox */
  transition: background-color 0.3s ease, border-color 0.3s ease; /* Hiệu ứng khi thay đổi */
}

/* Dấu tích tùy chỉnh khi checkbox được chọn */
.option input[type="checkbox"]:checked + label::before {
  background-color: #5c7adf; /* Màu nền khi chọn */
  content: '✔'; /* Dấu tích */
  display: inline-block;
  text-align: center;
  color: white;
  line-height: 25px; /* Căn giữa dấu tích theo chiều dọc */
  font-size: 14px; /* Kích thước dấu tích */
}

/* Đổi màu nền và chữ khi checkbox được chọn */
.option input[type="checkbox"]:checked + label {
  background-color: #0056b3; /* Màu nền toàn bộ khi chọn */
  color: white; /* Đổi màu chữ khi chọn */
}

/* Căn chỉnh và định dạng cho label */
.option label {
  font-size: 1.5vw; /* Kích thước chữ */
  color: #0056b3; /* Màu chữ khi chưa chọn */
  flex-grow: 1; /* Làm cho label chiếm hết không gian còn lại */
  font-weight: bold;
  cursor: pointer; /* Con trỏ khi hover */
  display: flex; /* Sử dụng flex cho căn chỉnh */
  align-items: center; /* Căn giữa nội dung dọc */
  padding: 10px 0; /* Khoảng cách trên dưới */
  transition: background-color 0.3s ease, color 0.3s ease; /* Hiệu ứng chuyển đổi màu */
}

/* Hiệu ứng chuyển đổi cho label khi checkbox được chọn */
.option input[type="checkbox"]:checked + label {
  color: white; /* Đổi màu chữ khi được chọn */
  background-color: #0056b3; /* Đổi màu nền khi được chọn */
}

/* Đặt kích thước và căn chỉnh cho dấu tích */
input[type="checkbox"]:checked::after {
  content: ''; /* Chèn nội dung trống */
  display: block; /* Hiển thị khối */
  width: 8px; /* Kích thước dấu tích */
  height: 16px; /* Kích thước dấu tích */
  border: solid white; /* Màu dấu tích */
  border-width: 0 2px 2px 0; /* Định hình dấu tích */
  transform: rotate(45deg); /* Xoay dấu tích */
  margin-left: 8px; /* Khoảng cách bên trái cho dấu tích */
}








.price-inputs {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 10px 0;
}

.price-inputs input[type="number"] {
  width: 45%;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 5px;
  font-size: 14px;
}

.price-inputs span {
  margin: 0 10px;
  font-weight: bold;
  font-size: 20px;
}

.currency-options {
  display: flex;
  justify-content: space-around;
  margin-top: 10px;
}

.range-slider {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 10px 0;
}

.range-slider input[type="range"] {
  width: 45%; /* Đặt chiều rộng cho thanh slider */
}

.noUi-target {
  margin-top: 10px;
}

.noUi-base {
  background: #e0f7ff;
}

.noUi-connect {
  background: #b0d4ff;
}

.noUi-handle {
  background: #fff;
  border: 2px solid #b0d4ff;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  cursor: pointer;
}

.noUi-handle:before {
  content: '';
}

.arrow {
  transition: transform 0.3s ease;
}

.filter-item.active .arrow {
  transform: rotate(180deg);
}


/* Các thành phần trong right-panel */
.flex-row-cff {
  display: grid;
  grid-template-columns: repeat(2, 1fr); /* Mỗi hàng 2 cột */
  gap: 20px; /* Khoảng cách giữa các phần tử */
  width: 100%; /* Chiếm toàn bộ chiều rộng */
  margin: 4.5% 0 0 0;
  z-index: 125;
}

.picture {
  position: relative;
  width: 80%;
  height: calc(2 * 40%); /* Chiều cao tương ứng */
  margin: 0 6% 12% 0;
  border-radius: 20px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-between; /* Đảm bảo các phần tử nằm giữa */
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



</style>