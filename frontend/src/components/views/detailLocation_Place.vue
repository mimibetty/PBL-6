<template>
    <div class="main-container">
      <div class="flex-row-cdcf">
        <div class="rectangle">
            <a href="#" class="home">Home</a>
          </div>
        <div class="image"></div>
        <span class="travel-tips">Travel Tips</span>
        <button class="union" @click="toggleMenu"></button>
        <a href="#" class="travel-itinerary" >Travel Itinerary</a>
        <a href="#" class="tour-proposal"  >Tour Proposal</a>
        <a href="#" class="forum"  >Forum</a>
        <a href="#" class="trips" >Trips</a>
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
      <span class="place-name">Ho Tay Water Park</span>
      <div class="flex-row-ba">
        <div v-for="(circle, index) in circles" :key="index" class="circle">
          <img :src="circle" alt="Circle" />
        </div>
        <span class="reviews">{{ totalRating }} Reviews</span>
      </div>
      <div class="flex-row-da">
        <div class="rectangle-a" v-for="image in images" :key="image.id">
            <img :src="currentImage" :alt="`Photo ${image.id}`" class="photo-image">
        </div>
        <span class="write-review">Write review</span>
        <div class="rectangle-f">
          <span class="peoples-opinion">People’s Opinion</span>
          <div class="review-info">
            <span class="review-name">“{{ commentList[0].title }}”<br /></span>
            <span class="review-day"><br />{{ commentList[0].day }}<br /></span>
            <span class="review-detail">
              {{ commentList[0].comment }}<br/></span>
          </div>
          <div class="avatar">
            <img :src="commentList[0].personalImage" alt="Avatar" />
          </div>
          <span class="avatar-user">By {{ commentList[0].user }}</span>
        </div>
        <div class="forward" @click="nextImage"></div>
        <div class="back" @click="prevImage"></div>
      </div>
      <span class="contribute">Contribute</span>
      <div class="flex-row-df">
        <button class="rectangle-1d">
          <span class="write-review-1e">Write Review</span></button
        ><button class="rectangle-1f">
          <span class="upload-photo">Upload a photo</span>
        </button>
      </div>
      <span class="evaluate">Evaluate</span>
      <div class="flex-container">
        <div class="rating-circle-container">
          <span class="rating">{{ rating }}</span>
          <div class="circle-row">
            <div v-for="(circle, index) in circles" :key="index" class="circle">
              <img :src="circle" alt="Circle" />
            </div>
          </div>
        </div>
        <div class="search-bar-container">
          <div class="search-bar">
          <!-- Input field -->
            <input type="text" placeholder="Search for reviews" class="search-input" />

          <!-- Nút tìm kiếm với icon -->
            <button class="search-button">
              <img src="@/assets/search.svg" alt="Search" />
            </button>
          </div>
        </div>        
      </div>
      <div class="review-container">
  
        <div class="rating-section">
          <div class="rating-row" v-for="(ratingInfo, label) in ratings" :key="label">
            <div class="rating-label">{{ label }}</div>
            <div class="rating-bar-container">
              <div
                class="rating-bar"
                :style="{ width: ratingInfo.percentage + '%' }"
              ></div>
            </div>
      
          </div>
        </div>

        <div class="comment-section">
          <!-- Sort Filter -->
          <div class="filter-container">
            
            <button class="filter-button" @click="toggleDropdown">
                Filter <span class="arrow">▼</span>
            </button>
            <div v-if="isDropdownVisible" class="dropdown-menu">
              <div class="menu-options">
                <button class="menu-button optionA">A</button>
                <button class="menu-button optionB">B</button>
                <button class="menu-button optionC">C</button>
                <button class="menu-button optionD">D</button>
              </div>
            </div>

            <button class="filter-button">Most Recent</button>
            <button class="filter-button">Highly Rated</button>
          </div>

          <!-- List of comments -->
          <div class="comment-list">
          <!-- Duyệt qua danh sách comment -->
            <div v-for="comment in commentList" :key="comment.user" class="comment">
              <img :src="comment.personalImage" alt="User Image" class="user-image" />
              <div class="comment-content">
                <h3>{{ comment.user }}</h3>
          
            <!-- Hiển thị rating bằng ngôi sao -->
                <div class="rating-stars">
                  <img v-for="star in generateCircle(comment.rating)" :src="star" :key="star" class="star-icon" />
                </div>
                <h4>{{ comment.title }}</h4>
                <p class="comment-date">{{ comment.day }}</p>
                <p class="comment-text">{{ comment.comment }}</p>

                <!-- Nếu có ảnh review thì hiển thị -->
                <img v-if="comment.picture" :src="comment.picture" alt="Review Image" class="review-image" />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
</template>
  
<script setup>
import { circles,rating, ratings, commentList, generateCircle, images, currentImage, nextImage, prevImage,totalRating, isDropdownVisible, toggleDropdown, isMenuVisible, toggleMenu } from '../viewModels/detailLocation_PlaceViewModel.js';

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
.place-name {
  display: block;
  position: relative;
  height: 60px;
  margin: 3% 0 0 5%;
  color: #13357b;
  font-family: Poppins, var(--default-font-family);
  font-size: 2.25vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  white-space: nowrap;
  z-index: 19;
}
.flex-row-ba {
  position: relative; /* Changed from absolute */
  display: flex;
  align-items: center;
  justify-content: center; /* Center stars and review text */
  width: 20%;
  height: 19px;
  margin: 0.5% 0 0 5%;
  flex-direction: row;
  z-index: 100;
  
}
.star {
  margin: 0 2px; /* Space between stars */
}

.star img {
  width: 20px; /* Adjust star size */
  height: 20px; /* Adjust star size */
  object-fit: contain; /* Maintain aspect ratio */
}
.reviews {
  margin-left: 10px; /* Ensure at least 20px space from the last star */
  
  color: #13357b;
  font-family: Inter, var(--default-font-family);
  font-size: 1.2vw;
  font-weight: 400;
  line-height: 100%;
  text-align: left;
  text-decoration: underline;
  white-space: nowrap;
  z-index: 36;
}
.flex-row-da {
  position: relative;
  width: 90%;
  height: 567px;
  margin: -0.2% 0 0 5.2%;
  z-index: 66;
}
.rectangle-a {
  position: absolute;
  width: 58%;
  height: 88%;
  top: 0;
  left: 40%;
  background-color: #023e8a;
  background-size: cover;
  z-index: 47;
  border-radius: 20px 20px 0 0;
}

.photo-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 20px;
}

.platter {
  flex-shrink: 0;
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 54;
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
  z-index: 55;
  backdrop-filter: blur(25px);
}

.write-review {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  position: absolute;
  width: 10%;
  height: 7%;
  top: 5%;
  left: 0.2%;
  color: #13357b;
  font-family: Inter, var(--default-font-family);
  font-size: 1.25vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  text-decoration: underline;
  z-index: 37;
}
.rectangle-f {
  position: absolute;
  width: 37%;
  height: 81%;
  top: 19%;
  left: 0;
  font-size: 0px;
  background: #edf6f9;
  z-index: 40;
  border-radius: 15px;
  box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.2); /* Hiệu ứng bóng nổi */
}
.peoples-opinion {
  display: block;
  position: relative;
  height: 10%;
  margin: 0.8% 0 0 4%;
  color: #023e8a;
  font-family: Inter, var(--default-font-family);
  font-size: 2vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  white-space: nowrap;
  z-index: 41;
}
.review-info {
  position: relative;
  width: 90%;
  height: auto;
  margin: 10% 0 0 3.5%;
  font-family: Inter, var(--default-font-family);
  font-size: 2.25vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  text-overflow: initial;
  white-space: nowrap;
  z-index: 44;
}
.review-name {
  position: relative;
  color: #023e8a;
  font-family: Inter, var(--default-font-family);
  font-size: 1.75vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
}
.review-day {
  position: relative;
  color: #023e8a;
  font-family: Inter, var(--default-font-family);
  font-size: 1.5vw;
  font-weight: 500;
  line-height: 100%;
  text-align: left;
}

.review-detail {
  position: relative;
  color: #023e8a;
  font-family: Inter, var(--default-font-family);
  font-size: 1.25vw;
  font-weight: 500;
  line-height: 100%;
  text-align: left;
  max-width: 100%; /* Set max-width to trigger wrapping */
  white-space: normal; /* Allow wrapping */
  overflow-wrap: break-word; /* Break words if necessary */
}
.avatar {
  position: absolute;
  width: 10%;
  height: 12%;
  top: 10%;
  left: 4%;
  z-index: 135;
  overflow: hidden;
  border-radius: 9999px;
}

.avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 9999px;
}

.avatar-user {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  position: absolute;
  height: 5.8%;
  top: 12%;
  left: 15%;
  color: #023e8a;
  font-family: Inter, var(--default-font-family);
  font-size: 2vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  white-space: nowrap;
  z-index: 43;
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
  left: 38%; 
  background: url('@/assets/back.svg') center; /* Hình nền cho nút back */
  z-index: 99;
}

.forward {
  position: absolute;
  top: 50%; 
  transform: translateY(-50%);
  right: 0%; 
  background: url('@/assets/forward.svg') center; /* Hình nền cho nút forward */
  z-index: 99;
}



.contribute {
  display: block;
  position: relative;
  height: 12%;
  margin: 7.7% 0 0 5.3%;
  color: #13357b;
  font-family: Jost, var(--default-font-family);
  font-size: 4vw;
  font-weight: 700;
  line-height: 100%;
  text-align: left;
  white-space: nowrap;
  z-index: 71;
}
.flex-row-df {
  display: flex;
  align-items: center;
  justify-content: space-between;
  position: relative;
  width: 40%;
  height: 60px;
  margin: 3% 0 0 5%;
  z-index: 73;
}
.rectangle-1d {
  flex-shrink: 0;
  position: relative;
  width: 40%;
  height: 100%;
  cursor: pointer;
  background: transparent;
  border: 2px solid #13357b;
  z-index: 72;
  border-radius: 30px;
  box-sizing: content-box;
}
.write-review-1e {
  display: flex;
  align-items: center;
  justify-content: center; /* Center horizontally */
  position: absolute;
  top: 50%; /* Start centering vertically */
  left: 50%; /* Start centering horizontally */
  transform: translate(-50%, -50%); /* Adjust to center the element */
  
  color: #13357b;
  font-family: Roboto, var(--default-font-family);
  font-size: 2vw;
  font-weight: 700;
  line-height: 100%;
  white-space: nowrap;
  z-index: 74;
}

.rectangle-1f {
  flex-shrink: 0;
  position: relative;
  width: 40%;
  height: 100%;
  cursor: pointer;
  background: transparent;
  border: 2px solid #13357b;
  z-index: 73;
  border-radius: 30px;
  box-sizing: content-box;
}
.upload-photo {
  display: flex;
  align-items: center;
  justify-content: center; /* Center horizontally */
  position: absolute;
  top: 50%; /* Start centering vertically */
  left: 50%; /* Start centering horizontally */
  transform: translate(-50%, -50%); /* Adjust to center the element */
  color: #13357b;
  font-family: Roboto, var(--default-font-family);
  font-size: 2vw;
  font-weight: 700;
  line-height: 100%;
  white-space: nowrap;
  z-index: 74;
}
.evaluate {
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  width: 18%;
  height: 56px;
  margin: 2.8% 0 0 3.2%;
  color: #13357b;
  font-family: Roboto, var(--default-font-family);
  font-size: 4vw;
  font-weight: 700;
  line-height: 100%;
  text-align: center;
  white-space: nowrap;
  z-index: 82;
}
.flex-container {
  display: flex;
  width: 100%;
  justify-content: space-between; /* Đẩy các phần về hai phía */
  padding-left: 7%; /* Thụt vào 10% từ bên trái */
  padding-right: 5%; /* Thụt vào 10% từ bên phải */
}

/* Cụm div Rating và Circles chiếm 50% bên trái */
.rating-circle-container {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  width: 50%;
  margin-right: 5%; /* Tạo khoảng cách giữa 2 cụm */
  gap: 20px; /* Khoảng cách giữa rating và các circles */
}



/* Cụm div Search Bar chiếm 50% bên phải */
.search-bar-container {
  display: flex;
  align-items: center;
  justify-content: flex-end; /* Canh phải cho search bar */
  width: 50%;
  margin-left: 5%; /* Tạo khoảng cách giữa 2 cụm */
}

/* Tạo style cho thanh tìm kiếm */
.search-bar {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
  height: 85%;
  background: #caf0f8;
  border-radius: 28px;
  padding: 0 10px;
}

/* Style cho ô input tìm kiếm */
.search-input {
  flex-grow: 1;
  border: none;
  outline: none;
  background: transparent;
  font-size: 16px;
  padding-left: 10px;
  color: #13357b;
}

.search-input::placeholder {
  color: #777;
}

/* Style cho nút tìm kiếm */
.search-button {
  background-color: transparent;
  border: none;
  cursor: pointer;
  display: flex;
  align-items: center;
}

.search-button img {
  width: 20px;
  height: 20px;
}

/* Cụm circles */
.circle-row {
  display: flex; /* Hiển thị circles theo chiều ngang */
  gap: 5px; /* Khoảng cách giữa các circles */
}

.circle img {
  width: 20px;
  height: 20px;
  object-fit: contain;
}

.rating {
  font-size: 1.5vw;
  font-weight: 700;
  color: #13357b;
}
.review-container {
  display: flex;
  justify-content: space-between;
  padding: 20px;
}

.rating-section {
  width: 50%; /* Điều chỉnh lại thành 40% */
}

.comment-section {
  width: 50%; /* Điều chỉnh lại thành 60% */
}

.rating-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.rating-label {
  width: 25%; /* Chiều rộng cho phần label */
  font-size: 2vw; /* Cỡ chữ */
  font-weight: 700; /* In đậm */
  color: #002366; /* Màu chữ xanh dương */
}

.rating-bar-container {
  width: 60%; /* Chiều rộng cho phần thanh đánh giá */
  height: 20px; /* Chiều cao của thanh đánh giá */
  background-color: #d4f0ff; /* Màu nền cho thanh */
  position: relative;
  border-radius: 10px; /* Bo tròn các góc */
}

.rating-bar {
  height: 100%; /* Chiều cao của thanh đánh giá */
  background-color: #002366; /* Màu xanh đậm cho phần đánh giá */
  border-radius: 10px; /* Bo tròn các góc */
  transition: width 0.3s ease; /* Hiệu ứng khi thay đổi chiều rộng */
}


.filter-container {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.filter-button {
  padding: 10px 20px;
  background-color: #f1f1f1;
  border: 2px solid #002366;
  border-radius: 20px;
  font-size: 1.2em;
  font-weight: 700;
  color: #002366;
  margin-right: 10px;
  transition: background-color 0.3s ease;
  cursor: pointer;
}

.filter-button:hover {
  background-color: #e0e0e0;
}

.arrow {
  margin-left: 5px;
}

.dropdown-menu {
  position: absolute;
  top: 72%; 
  right: 18%; 
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

.dropdown-menu ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.dropdown-menu li {
  padding: 8px;
  cursor: pointer;
  color: #002366;
}

.dropdown-menu li:hover {
  background-color: #f0f0f0;
}

.comment {
  display: flex;
  margin-bottom: 20px;
}

.user-image {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  margin-right: 10px;
}

.comment-content {
  display: flex;
  flex-direction: column;
}

.rating-stars {
  display: flex;
}

.star-icon {
  width: 20px;
  height: 20px;
  margin-right: 4px;
}

.comment-date {
  font-size: 0.9em;
  color: #888;
}

.comment-text {
  margin-top: 8px;
}


.review-image {
  max-width: 50%; /* Đảm bảo ảnh luôn nằm trong vùng chứa */
  height: auto; 
  transition: transform 0.3s ease, max-width 0.3s ease; /* Hiệu ứng zoom và điều chỉnh kích thước */
  cursor: pointer;
}

.review-image:hover {
  transform: scale(1.2); /* Tự zoom khi hover */
  max-width: 120%; /* Cho phép tăng kích thước tối đa */
}

</style>