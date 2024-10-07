<template>
  <Suspense>
    <template #default>
      <div class="main-container">
        <div class="flex-row-bfc">
          <div class="rectangle">
            <a href="#" class="home" @click.prevent="() => alert('Đã nhấn Home')">Home</a>
          </div>
          <div class="rectangle-1">
            <div class="rectangle-2">
              <div class="image"></div>
              <button class="union" @click="toggleMenu"></button>
              <span class="travel-tips">Travel Tips</span>
              <a href="#" class="travel-itinerary" @click.prevent="() => alert('Đã nhấn')">Travel Itinerary</a>
              <a href="#" class="tour-proposal" @click.prevent="() => alert('Đã nhấn Proposal')">Tour Proposal</a>
              <a href="#" class="forum" @click.prevent="() => alert('Đã nhấn Forum')">Forum</a>
              <a href="#" class="trips" @click.prevent="() => alert('Đã nhấn Trip')">Trips</a>
            </div>

            <!-- Khung menu ẩn -->
            <div class="menu-container" v-if="isMenuVisible">
              <div class="menu-options">
                <button class="menu-button my-trips">My Trips</button>
                <button class="menu-button review">Review</button>
                <button class="menu-button my-favorite">My Favorite</button>
                <button class="menu-button logout">Logout</button>
              </div>
            </div>

            <div class="flex-row">
              <span class="explore-viet-nam">Explore Viet Nam</span>
              <button class="rectangle-4">
                <div class="line"></div>
              </button>
              <div class="rectangle-5">
                <div class="line-6"></div>
              </div>
            </div>
            <span class="you-like-to-go">You Like To Go?</span>
          </div>

          <div class="rectangle-7">
            <form class="search-container" @submit.prevent="search">
              <input type="text" class="search_form" placeholder="Where do you go ?">
              <button type="submit" class="search_button">Search</button>
            </form>
          </div>
        </div>
        <div class="flex-row-eff">
          <span class="destination">DESTINATION</span>
          <div class="line-9"></div>
          <div class="line-a"></div>
        </div>
        <span class="popular-destination">Popular Destination</span>
        <div class="flex-row-da">
          <button class="back" @click="prevSlide"></button>
          <button class="forward" @click="nextSlide"></button>
        </div>

        <div class="flex-row-cdd">
          <button 
            class="btn" 
            :class="{ active: activeButton === 'all' }" 
            @click="setActive('all')"
          >All</button>
          <button 
            class="btn" 
            :class="{ active: activeButton === 'northern-vietnam' }" 
            @click="setActive('northern-vietnam')"
          >Northern Vietnam</button>
          <button 
            class="btn" 
            :class="{ active: activeButton === 'central-vietnam' }" 
            @click="setActive('central-vietnam')"
          >Central Vietnam</button>
          <button 
            class="btn" 
            :class="{ active: activeButton === 'southern-vietnam' }" 
            @click="setActive('southern-vietnam')"
          >Southern Vietnam</button>
        </div>

        <!-- Grid chứa các thành phố -->
        <div class="grid-container-vietnam">
          <div
            v-for="(city, index) in visibleCities"
            :key="city.id"
            class="grid-item"
          >
            <img v-if="city.imageUrl" :src="city.imageUrl" :alt="city.name" />
            <p class="city-name">{{ city.name }}</p>
          </div>
        </div>

        <div class="flex-row-e">
          <span class="wanna-try">WANNA TRY?</span>
          <div class="line-f"></div>
          <div class="line-10"></div>
        </div>
        <span class="awesome-topics">Awesome Topics</span>
        <div class="flex-row-cfb">
          <button class="back" @click="prevTopic"></button>
          <button class="forward" @click="nextTopic"></button>
        </div>

        <div class="grid-container-topic">
          <div
            v-for="(topic, index) in visibleTopics"
            :key="topic.id"
            class="grid-item-topic"
          >
            <img v-if="topic.imageUrl" :src="topic.imageUrl" :alt="topic.name" />
            <p class="topic-name">{{ topic.name }}</p>
          </div>
        </div>

        <div class="tour-proposal-1b">
          <span class="line-1c">Tour Proposal</span>
          <div class="line-1d"></div>
          <div class="awesome-tour"></div>
        </div>
        <span class="awesome-tour-1e">Awesome Tour</span>
        <div class="tour-proposal-1f">
          <button class="back" @click="prevTour"></button>
          <button class="forward" @click="nextTour"></button>
        </div>
        <div class="grid-container-tour">
          <div
            v-for="(tour, index) in visibleTours"
              :key="tour.id"
              class="grid-item-tour"
          >
            <div class="image-container">
              <img v-if="tour.imageUrl" :src="tour.imageUrl" :alt="tour.name" />
              <p class="tour-location">{{ tour.location }}</p>
            </div>
            <div class="tour-details">
              <p class="tour-name">{{ tour.name }}</p>
              <p class="tour-review">{{ tour.reviewNumber }} reviews</p>
              <div class="tour-rating">
                <img v-for="star in generateStars(tour.rating)" :src="star" class="star-icon" />
                <p class="rating-value">{{ tour.rating }}</p>
              </div>
            </div>
          </div>
        </div>
        <div class="rectangle-43">
          <div class="image-44"></div>
          <div class="flex-column-bf">
            <span class="travel-company-co">2024 Travel Company.co All rights reserved.</span>
            <div class="term-of-use-contact-us">
              <span class="term-of-use">Term of use</span>
              <span class="empty"> </span>
              <span class="contact-us">Contact us</span>
            </div>
          </div>
        </div>
        <div class="carousal"></div>
        <div class="line-45"></div>
      </div>
    </template>
    <template #fallback>
      <div>Loading...</div>
    </template>
  </Suspense>
</template>

<script setup>
import dashboardViewModel from './viewModels/dashboardViewModel';

const {
  activeButton,
  setActive,
  cities,
  visibleCities,
  prevSlide,
  nextSlide,
  topics,
  visibleTopics,
  prevTopic,
  nextTopic,
  tours,
  visibleTours,
  prevTour,
  nextTour,
  isMenuVisible,
  toggleMenu,
  generateStars,
} = dashboardViewModel;

</script>



  
<style>
  :root {
  --default-font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
    Ubuntu, "Helvetica Neue", Helvetica, Arial, "PingFang SC",
    "Hiragino Sans GB", "Microsoft Yahei UI", "Microsoft Yahei",
    "Source Han Sans CN", sans-serif;
}

.main-container {
  position: absolute;
  top: 0;
  left: 0;
  width: fit-content;
  height: fit-content;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  box-sizing: border-box;
  background: #ffffff;
  border-radius: 20px;
}
.main-container * {
  box-sizing: border-box;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}


input,
select,
textarea,
button {
  outline: 0;
}


.flex-row-bfc {
  position: relative;
  width: 1440px;
  height: 674px;
  margin: -2px 0 0 0;
  z-index: 23;
}
.rectangle {
  position: absolute;
  width: 125px;
  height: 145px;
  top: 0;
  left: 650px;
  background: #13357b;
  z-index: 20;
}
.home {
  display: flex;
  align-items: flex-start;
  justify-content: center;
  position: absolute;
  width: 70px;
  height: 30px;
  top: 58px;
  left: 27px;
  color: #f4fff8;
  font-family: Poppins, var(--default-font-family);
  font-size: 20px;
  font-weight: 700;
  line-height: 30px;
  text-align: center;
  white-space: nowrap;
  z-index: 21;
}
.rectangle-1 {
  position: absolute;
  width: 1440px;
  height: 640px;
  top: 2px;
  left: 0;
  background: rgba(0, 15, 8, 0.4);
  z-index: 8;
  border-radius: 20px 20px 0 0;
}
.rectangle-2 {
  position: relative;
  width: 1440px;
  height: 143px;
  margin: 0 0 0 0;
  background: #000000;
}
.image {
  position: absolute;
  width: 120px;
  height: 120px;
  top: 13px;
  left: 15px;
  background: url(../assets/images/company_image.png)
    no-repeat center;
  background-size: cover;
  z-index: 27;
  border-radius: 70px;
}
.union {
  position: absolute;
  width: 4.00%;
  height: 30.28%;
  top: 30.08%;
  left: 93%;
  background: url(../assets/images/personal_logo.png) no-repeat center;
  background-size: 100% 100%;
  z-index: 12;
  cursor: pointer;
  border: none;
  background-color: transparent;
}

.menu-container {
  position: absolute;
  top: 100px; /* Điều chỉnh để căn theo nhu cầu */
  right: 50px; /* Điều chỉnh để căn theo nhu cầu */
  background-color: rgba(0, 0, 0, 0.8); /* Khung nền mờ xung quanh menu */
  padding: 20px;
  border-radius: 10px;
  z-index: 9999; /* Đảm bảo menu nằm trên cùng */
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  width: 100%; /* Đặt chiều rộng cho khung bằng 100% so với container của nó */
  max-width: 400px; /* Đặt giới hạn chiều rộng tối đa */
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5); /* Hiệu ứng đổ bóng */
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
  font-size: 20px; /* Tăng kích thước chữ */
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



.travel-tips {
  display: flex;
  align-items: flex-start;
  justify-content: flex-start;
  position: absolute;
  height: 60px;
  top: 41px;
  left: 156px;
  color: #f4fff8;
  font-family: Poppins, var(--default-font-family);
  font-size: 40px;
  font-weight: 700;
  line-height: 60px;
  text-align: left;
  white-space: nowrap;
  z-index: 13;
}
.travel-itinerary {
  display: flex;
  align-items: flex-start;
  justify-content: flex-start;
  position: absolute;
  height: 30px;
  top: 56px;
  left: 1049px;
  color: #f4fff8;
  font-family: Poppins, var(--default-font-family);
  font-size: 20px;
  font-weight: 700;
  line-height: 30px;
  text-align: left;
  white-space: nowrap;
  z-index: 17;
}
.tour-proposal {
  display: flex;
  align-items: flex-start;
  justify-content: flex-start;
  position: absolute;
  height: 30px;
  top: 58px;
  left: 802px;
  color: #f4fff8;
  font-family: Poppins, var(--default-font-family);
  font-size: 20px;
  font-weight: 700;
  line-height: 30px;
  text-align: left;
  white-space: nowrap;
  z-index: 15;
}
.forum {
  display: flex;
  align-items: flex-start;
  justify-content: flex-start;
  position: absolute;
  height: 30px;
  top: 58px;
  left: 1234px;
  color: #f4fff8;
  font-family: Poppins, var(--default-font-family);
  font-size: 20px;
  font-weight: 700;
  line-height: 30px;
  text-align: left;
  white-space: nowrap;
  z-index: 18;
}
.trips {
  display: flex;
  align-items: flex-start;
  justify-content: flex-start;
  position: absolute;
  height: 30px;
  top: 58px;
  left: 971px;
  color: #f4fff8;
  font-family: Poppins, var(--default-font-family);
  font-size: 20px;
  font-weight: 700;
  line-height: 30px;
  text-align: left;
  white-space: nowrap;
  z-index: 16;
}
.flex-row {
  position: relative;
  width: 1440px;
  height: 211px;
  margin: 20px 0 0 0;
  z-index: 130;
}

.explore-viet-nam {
  display: flex;
  align-items: flex-start;
  justify-content: center;
  position: absolute;
  width: 304px;
  height: 43px;
  top: 106px;
  left: 560px;
  color: #ffffff;
  font-family: Jost, var(--default-font-family);
  font-size: 35px;
  font-weight: 700;
  line-height: 43px;
  text-align: center;
  white-space: nowrap;
  z-index: 11;
}
.rectangle-4 {
  position: absolute;
  width: 120px;
  height: 80px;
  top: 117px;
  left: 0;
  cursor: pointer;
  background: rgba(19, 53, 123, 0.75);
  border: none;
  z-index: 128;
  border-radius: 0 50px 50px 0;
}
.line {
  position: relative;
  width: 28.075px;
  height: 51.727px;
  margin: 13.64px 0 0 32.272px;
  background: url(../assets/images/back_picture.png)
    no-repeat center;
  background-size: cover;
  z-index: 129;
}
.rectangle-5 {
  position: absolute;
  width: 120px;
  height: 80px;
  top: 117px;
  left: 1320px;
  background: rgba(19, 53, 123, 0.75);
  z-index: 130;
  border-radius: 50px 0 0 50px;
}
.line-6 {
  position: relative;
  width: 28.075px;
  height: 51.727px;
  margin: 13.633px 0 0 60.153px;
  background: url(../assets/images/forward_picture.png)
    no-repeat center;
  background-size: cover;
  z-index: 131;
}
.you-like-to-go {
  display: flex;
  align-items: flex-start;
  justify-content: center;
  position: relative;
  width: 506px;
  height: 73px;
  margin: -9px 0 0 467px;
  color: #ffffff;
  font-family: Jost, var(--default-font-family);
  font-size: 60px;
  font-weight: 700;
  line-height: 73px;
  text-align: center;
  white-space: nowrap;
  z-index: 10;
}
.rectangle-7 {
  position: absolute;
  width: 800px;
  height: 65px;
  top: 609px;
  left: 310px;
  background: #d9d9d9cc;
  border: 30px solid rgba(19, 53, 123, 0.8);
  z-index: 23;
  border-radius: 60px;
  box-sizing: content-box;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.search-container {
  display: flex;
  align-items: center;
  border-radius: 60px;
  justify-content: space-between;
  background: #d9d9d9cc;
  width: 100%;
  margin-right: 20px;
}

.search_form {
  flex-grow: 1;
  height: 45px;
  padding: 0 15px;
  color: #6e69b8;
  font-family: Lato, var(--default-font-family);
  font-size: 20px;
  font-weight: 700;
  line-height: 45px;
  border: none;
  border-radius: 30px 0 0 30px;
  background: #e0e0e0; /* Màu xám */
  box-sizing: border-box;
}

.search_button {
  width: 110px;
  height: 40px;
  cursor: pointer;
  color: #ffffff;
  font-family: Lato, var(--default-font-family);
  font-size: 18px;
  font-weight: 700;
  background: #13357b;
  border: none;
  border-radius: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
  margin-left: -1px; /* Đảm bảo nút ôm sát form nhập */
}

.flex-row-eff {
  position: relative;
  width: 550px;
  height: 30px;
  margin: 91px 0 0 91px;
  z-index: 64;
}
.destination {
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  width: 250px;
  height: 30px;
  top: 0;
  left: 150px;
  color: #13357b;
  font-family: Jost, var(--default-font-family);
  font-size: 20px;
  font-weight: 400;
  line-height: 28.9px;
  text-align: center;
  white-space: nowrap;
  z-index: 64;
}
.line-9 {
  position: absolute;
  width: 150px;
  height: 1px;
  top: 14px;
  left: 0;
  background: url(../assets/images/blue_line.png)
    no-repeat center;
  background-size: cover;
  z-index: 62;
}
.line-a {
  position: absolute;
  width: 150px;
  height: 1px;
  top: 14px;
  left: 400px;
  background: url(../assets/images/blue_line.png)
    no-repeat center;
  background-size: cover;
  z-index: 63;
}
.popular-destination {
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  width: 350px;
  height: 53px;
  margin: 14px 0 0 100px;
  color: #000000;
  font-family: Jost, var(--default-font-family);
  font-size: 37px;
  font-weight: 400;
  line-height: 53px;
  text-align: center;
  white-space: nowrap;
  z-index: 65;
}
.flex-row-da {
  display: flex;
  align-items: center;
  justify-content: space-between;
  position: relative;
  width: 1081px;
  height: 45px;
  margin: 39px 0 0 30px;
  z-index: 53;
}

button {
  border: none; /* Loại bỏ viền mặc định của nút */
  background-color: transparent; /* Nền trong suốt */
  cursor: pointer; /* Thay đổi con trỏ khi di chuột vào */
  padding: 0; /* Loại bỏ padding mặc định */
}

.back {
  flex-shrink: 0;
  position: relative;
  width: 120px;
  height: 40px;
  background: url(../assets/images/back_option.png) no-repeat center;
  background-size: cover;
  z-index: 53;
}

.forward {
  flex-shrink: 0;
  position: relative;
  width: 120px;
  height: 40px;
  background: url(../assets/images/forward_option.png) no-repeat center;
  background-size: cover;
  z-index: 48;
}

.flex-row-cdd {
  position: relative;
  width: 1101px;
  height: 45px;
  margin: 50px 0 0 50px;
  z-index: 142;
  display: flex;
  justify-content: space-between;
}

button.btn {
  width: 130px;
  height: 45px;
  background: #f4fff8; /* Màu nền mặc định: trắng */
  color: #13357b; /* Màu chữ mặc định: xanh */
  border: 2px solid #13357b;
  border-radius: 25px;
  font-family: Jost, var(--default-font-family);
  font-size: 15px;
  font-weight: 400;
  line-height: 21.675px;
  cursor: pointer;
  transition: background-color 0.3s, color 0.3s;
}

button.btn.active {
  background: #13357b; /* Nút được chọn: xanh */
  color: #f4fff8; /* Chữ của nút được chọn: trắng */
}

button.btn:hover {
  opacity: 0.9; /* Hiệu ứng hover */
}

.grid-container-vietnam {
  padding-top: 20px;
  display: grid;
  align-items: center;
  justify-content: center; 
  grid-template-columns: repeat(4, 200px); 
  grid-template-rows: repeat(2, 220px); /* Chiều cao tăng lên để thêm tên thành phố */
  gap: 40px 80px; 
  overflow: hidden; 
  width: calc(4 * 200px + 3 * 80px); 
  margin: 0 auto; 
}

.grid-item {
  position: relative; /* Để chứa phần chữ có position absolute */
  background-color: rgb(225, 255, 0);
  color: rgb(53, 24, 219);
  font-size: 18px;
  width: 200px;
  height: 200px;
  overflow: hidden;
}

.grid-item img {
  width: 100%;
  height: 200px;
  object-fit: cover;
}

.grid-item .city-name {
  position: absolute;
  bottom: 0;
  left: 0;
  color: white; /* Màu chữ trắng */
  background-color: rgba(0, 0, 0, 0.5); /* Nền đen trong suốt để chữ dễ đọc hơn */
  padding: 5px;
  font-size: 14px; /* Kích thước chữ */
  font-weight: bold; /* Chữ in đậm */
  width: 100%; /* Để đảm bảo chữ trải dài theo chiều rộng của khung */
  text-align: left; /* Canh lề trái */
  box-sizing: border-box;
}


.flex-row-e {
  position: relative;
  width: 550px;
  height: 30px;
  margin: 106px 0 0 106px;
  z-index: 37;
}
.wanna-try {
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  width: 250px;
  height: 30px;
  top: 0;
  left: 150px;
  color: #13357b;
  font-family: Jost, var(--default-font-family);
  font-size: 20px;
  font-weight: 400;
  line-height: 28.9px;
  text-align: center;
  white-space: nowrap;
  z-index: 37;
}
.line-f {
  position: absolute;
  width: 150px;
  height: 1px;
  top: 14px;
  left: 0;
  background: url(../assets/images/blue_line.png)
    no-repeat center;
  background-size: cover;
  z-index: 35;
}
.line-10 {
  position: absolute;
  width: 150px;
  height: 1px;
  top: 14px;
  left: 400px;
  background: url(../assets/images/blue_line.png)
    no-repeat center;
  background-size: cover;
  z-index: 36;
}
.awesome-topics {
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  width: 270px;
  height: 53px;
  margin: 14px 0 0 60px;
  color: #000000;
  font-family: Jost, var(--default-font-family);
  font-size: 37px;
  font-weight: 400;
  line-height: 53px;
  text-align: center;
  white-space: nowrap;
  z-index: 38;
}
.flex-row-cfb {
  display: flex;
  align-items: center;
  justify-content: space-between;
  position: relative;
  width: 1083px;
  height: 45px;
  margin: 23px 0 0 23px;
  z-index: 45;
}

.grid-container-topic {
  padding-top: 20px;
  display: grid;
  align-items: center;
  justify-content: center; 
  grid-template-columns: repeat(4, 200px); 
  grid-template-rows: repeat(1, 200px); 
  gap: 40px 80px; 
  overflow: hidden; 
  width: calc(4 * 200px + 3 * 80px); 
  margin: 0 auto; 
}

.grid-item-topic {
  position: relative; /* Để chứa phần chữ có position absolute */
  background-color: rgb(225, 255, 0);
  color: rgb(53, 24, 219);
  font-size: 18px;
  width: 200px;
  height: 200px;
  overflow: hidden;
}

.grid-item-topic img {
  width: 100%;
  height: 200px;
  object-fit: cover;
}

.grid-item-topic .topic-name {
  position: absolute;
  bottom: 0;
  left: 0;
  color: white; /* Màu chữ trắng */
  background-color: rgba(0, 0, 0, 0.5); /* Nền đen trong suốt để chữ dễ đọc hơn */
  padding: 5px;
  font-size: 14px; /* Kích thước chữ */
  font-weight: bold; /* Chữ in đậm */
  width: 100%; /* Để đảm bảo chữ trải dài theo chiều rộng của khung */
  text-align: left; /* Canh lề trái */
  box-sizing: border-box;
}

.tour-proposal-1b {
  position: relative;
  width: 550px;
  height: 30px;
  margin: 106px 0 0 106px;
  z-index: 42;
}
.line-1c {
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  width: 250px;
  height: 30px;
  top: 0;
  left: 150px;
  color: #13357b;
  font-family: Jost, var(--default-font-family);
  font-size: 20px;
  font-weight: 400;
  line-height: 28.9px;
  text-align: center;
  white-space: nowrap;
  z-index: 42;
}
.line-1d {
  position: absolute;
  width: 150px;
  height: 1px;
  top: 14px;
  left: 0;
  background: url(../assets/images/blue_line.png)
    no-repeat center;
  background-size: cover;
  z-index: 40;
}
.awesome-tour {
  position: absolute;
  width: 150px;
  height: 1px;
  top: 14px;
  left: 400px;
  background: url(../assets/images/blue_line.png)
    no-repeat center;
  background-size: cover;
  z-index: 41;
}
.awesome-tour-1e {
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  width: 270px;
  height: 53px;
  margin: 14px 0 0 50px;
  color: #000000;
  font-family: Jost, var(--default-font-family);
  font-size: 37px;
  font-weight: 400;
  line-height: 53px;
  text-align: center;
  white-space: nowrap;
  z-index: 43;
}
.tour-proposal-1f {
  display: flex;
  align-items: center;
  justify-content: space-between;
  position: relative;
  width: 1083px;
  height: 45px;
  margin: 23px 0 0 23px;
  z-index: 95;
}

.grid-container-tour {
  padding-top: 20px;
  display: grid;
  align-items: center;
  justify-content: center;
  grid-template-columns: repeat(3, 200px);
  grid-template-rows: repeat(1, 300px);
  gap: 40px 150px;
  overflow: hidden;
  width: calc(3 * 200px + 2 * 150px);
  margin: 0 auto;
}

.grid-item-tour {
  position: relative; /* Vẫn giữ relative để vị trí tuyệt đối trong ảnh hoạt động */
  background-color: rgba(191, 189, 197, 0.815);
  font-size: 18px;
  width: 200px;
  height: 300px;
  overflow: hidden;
}

.image-container {
  position: relative;
  width: 100%;
  height: 200px;
}

.image-container img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.tour-location {
  position: absolute;
  bottom: 0;
  left: 0;
  color: white;
  background-color: rgba(0, 0, 0, 0.5);
  padding: 5px;
  font-size: 14px;
  font-weight: bold;
  width: 100%;
  text-align: left;
  box-sizing: border-box;
}

.tour-details {
  background-color: #f1f1f1;
  padding: 10px;
  text-align: center;
}

.tour-name {
  font-weight: bold;
  margin: 5px 0;
}

.tour-review {
  margin: 5px 0;
}

.tour-rating {
  display: flex;
  justify-content: center;
}

.star-icon {
  width: 16px;
  height: 16px;
  margin-right: 2px;
}


.rating-value {
  font-size: 14px;
  font-weight: bold;
  margin-left: 8px; /* Khoảng cách giữa sao và giá trị rating */
  color: #333;
}

.rectangle-43 {
  position: relative;
  width: 1440px;
  height: 179px;
  margin: 266px 0 0 0;
  background: #13357b;
  z-index: 4;
  border-radius: 0 0 20px 20px;
}
.image-44 {
  position: absolute;
  width: 140px;
  height: 140px;
  top: 20px;
  left: 20px;
  background: url(../assets/images/company_image.png)
    no-repeat center;
  background-size: cover;
  z-index: 5;
  border-radius: 70px;
}
.flex-column-bf {
  position: absolute;
  width: 685px;
  height: 90px;
  top: 55px;
  left: 179px;
  font-size: 0px;
  z-index: 7;
}
.travel-company-co {
  display: block;
  position: relative;
  height: 48px;
  margin: 0 0 0 0;
  color: #ffffff;
  font-family: Poppins, var(--default-font-family);
  font-size: 32px;
  font-weight: 700;
  line-height: 48px;
  text-align: left;
  white-space: nowrap;
  z-index: 6;
}
.term-of-use-contact-us {
  position: relative;
  width: 242px;
  height: 30px;
  margin: 12px 0 0 3px;
  font-family: Poppins, var(--default-font-family);
  font-size: 20px;
  font-weight: 700;
  line-height: 30px;
  text-align: left;
  text-overflow: initial;
  white-space: nowrap;
  z-index: 7;
}
.term-of-use {
  position: relative;
  color: #ffffff;
  font-family: Poppins, var(--default-font-family);
  font-size: 20px;
  font-weight: 600;
  line-height: 30px;
  text-align: left;
}
.empty {
  position: relative;
  color: #ffffff;
  font-family: Poppins, var(--default-font-family);
  font-size: 20px;
  font-weight: 700;
  line-height: 30px;
  text-align: left;
}
.contact-us {
  position: relative;
  color: #ffffff;
  font-family: Poppins, var(--default-font-family);
  font-size: 20px;
  font-weight: 500;
  line-height: 30px;
  text-align: left;
}
.carousal {
  position: absolute;
  width: 1440px;
  height: 640px;
  top: 0;
  left: 0;
  background: url(../assets/images/background_picture.png)
    no-repeat center;
  background-size: cover;
  z-index: 1;
  border-radius: 20px 20px 0 0;
}
.line-45 {
  position: absolute;
  width: 1440px;
  height: 2.004px;
  top: 143px;
  left: 0;
  background: url(../assets/images/white_line.png)
    no-repeat center;
  background-size: cover;
  z-index: 2;
}

</style>