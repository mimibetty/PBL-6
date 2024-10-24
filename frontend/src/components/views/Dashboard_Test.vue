<template>
    <!-- Top Site Start -->
    <div class="container-fluid top_website">
        <!-- Navbar Start -->
        <div class="navbar navbar-expand-lg navbar-light px-4 px-lg-5 ">
            <!-- Phần 1: Logo và tên -->
            <div class="navbar-section logo-section">
                <img src="@/assets/images/company_image.png" alt="Logo" class="logo" />
                <span class="logo-text">Travel Tips</span>
            </div>

            <!-- Phần 2: Các nút điều hướng -->
            <div class="navbar-section navbar-buttons">
                <button class="navbar-button">Home</button>
                <button class="navbar-button">Your Proposal</button>
                <button class="navbar-button">Trips</button>
                <button class="navbar-button">Travel Itinerary</button>
            </div>

            <!-- Phần 3: Biểu tượng người dùng -->
            <div class="navbar-section user-icon">
                <div class="user-image"></div>
            </div>
        </div>
        <!-- Navbar End -->

        <!-- Carousel Start -->
        <div class="carousel-caption">
            <div class="p-3" style="max-width: 900px;">
                <h4 class="text-white text-uppercase fw-bold mb-4" style="letter-spacing: 3px;">Explore The World</h4>
                <h1 class="display-2 text-capitalize text-white mb-4">Let's The World Together!</h1>
            </div>
        </div>
        <!-- Carousel End -->

        <!-- Form Search Start -->
        <div class="footer_search">
            <div class="container">
                <div class="position-relative">
                    <input class="form-control" type="text" placeholder="Where do you want to go?">
                    <button type="button" class="btn btn-primary">Search</button>
                </div>
            </div>            
        </div>
        <!-- Form Search End -->
    </div>
    <!--Top Site End  -->

    <!-- Destination Start -->
    <div class="container-fluid destination py-5" style="width: 1210px;">
        <div class="container py-5">
            <div class="mx-auto text-center mb-5" style="max-width: 1000px;">
                <h5 class="section-title px-3 ">Destination</h5>
                <h1 class="mb-0">Popular Destination</h1>
            </div>
            <div class="tab-class text-center">
                <div class="owl-nav">
                    <button class="owl-prev" @click="prevSlide">
                        <svg class="bi bi-arrow-left" width="40" height="40" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M7.68473 7.33186C8.07526 6.94134 8.07526 6.30817 7.68473 5.91765C7.29421 5.52712 6.66105 5.52712 6.27052 5.91765L1.60492 10.5832C0.823873 11.3643 0.823872 12.6306 1.60492 13.4117L6.27336 18.0801C6.66388 18.4706 7.29705 18.4706 7.68757 18.0801C8.0781 17.6896 8.0781 17.0564 7.68757 16.6659L4.02154 12.9998L22 12.9998C22.5523 12.9998 23 12.5521 23 11.9998C23 11.4476 22.5523 10.9998 22 10.9998L4.01675 10.9998L7.68473 7.33186Z"/>
                        </svg>
                    </button>
                    <button class="owl-next" @click="nextSlide">
                        <svg class="bi bi-arrow-right" width="40px" height="40px" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M16.3153 16.6681C15.9247 17.0587 15.9247 17.6918 16.3153 18.0824C16.7058 18.4729 17.339 18.4729 17.7295 18.0824L22.3951 13.4168C23.1761 12.6357 23.1761 11.3694 22.3951 10.5883L17.7266 5.9199C17.3361 5.52938 16.703 5.52938 16.3124 5.91991C15.9219 6.31043 15.9219 6.9436 16.3124 7.33412L19.9785 11.0002L2 11.0002C1.44772 11.0002 1 11.4479 1 12.0002C1 12.5524 1.44772 13.0002 2 13.0002L19.9832 13.0002L16.3153 16.6681Z"/>
                        </svg>
                    </button>
                </div>
                <!-- Tab Button Start  -->
                <ul class="nav nav-pills d-inline-flex justify-content-center mb-5">
                    <li class = "nav-item">
                        <button class = "d-flex mx-3 py-2 border border-primary 
                        bg-light rounded-pill" 
                        :class="{ active: activeButton === 'all' }" 
                        @click="setActive('all')">
                            All
                        </button>
                    </li>
                    <li class = "nav-item">
                        <button class = "d-flex mx-3 py-2 border border-primary 
                        bg-light rounded-pill" 
                        :class="{ active: activeButton === 'northern-vietnam' }" 
                        @click="setActive('northern-vietnam')">
                            Northern Vietnam
                        </button>
                    </li>
                    <li class = "nav-item">
                        <button class = "d-flex mx-3 py-2 border border-primary
                        bg-light rounded-pill" 
                        :class="{ active: activeButton === 'central-vietnam' }" 
                        @click="setActive('central-vietnam')">
                            Central Vietnam
                        </button>
                    </li>
                    <li class = "nav-item">
                        <button class = "d-flex mx-3 py-2 border border-primary
                        bg-light rounded-pill"
                        :class="{ active: activeButton === 'southern-vietnam' }" 
                        @click="setActive('southern-vietnam')">
                            Southern Vietnam
                        </button>
                    </li>
                </ul>
                <!-- Tab Button End  -->

                <!-- List Items For Each Tab Start  -->
                <div class="tab-content">
                    <div id="tab-1" class="tab-pane fade show p-0 active">
                        <div class="row g-4">
                            <div class="col-lg-4"
                                v-for="(city, index) in visibleCities"
                                :key="city.id">
                                <div class="destination-img">
                                    <img v-if = "city.imageUrl" class="img-fluid rounded w-100"
                                        :src="city.imageUrl"
                                        alt="city.name"/>
                                    <div class = 'destination-overlay p-4'>
                                        <h4 class = 'text-white mb-2 mt-3'>{{ city.name }}</h4>
                                        <button class="text-white">View All Place
                                            <svg width="20px" height="20px" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
                                                <path d="M16.3153 16.6681C15.9247 17.0587 15.9247 17.6918 16.3153 18.0824C16.7058 18.4729 17.339 18.4729 17.7295 18.0824L22.3951 13.4168C23.1761 12.6357 23.1761 11.3694 22.3951 10.5883L17.7266 5.9199C17.3361 5.52938 16.703 5.52938 16.3124 5.91991C15.9219 6.31043 15.9219 6.9436 16.3124 7.33412L19.9785 11.0002L2 11.0002C1.44772 11.0002 1 11.4479 1 12.0002C1 12.5524 1.44772 13.0002 2 13.0002L19.9832 13.0002L16.3153 16.6681Z" fill="#EDF6F9"/>
                                            </svg>    
                                        </button >
                                    </div>  
                                    <div class="search-icon">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- List Items For Each Tab End  -->
            </div>
        </div>
    </div>
    <!-- Destination End -->
    
    <!-- Topic Start -->
    <div class="container-fluid topic py-0" style="width: 1210px;">
        <div class="container">
            <div class="mx-auto text-center mb-5" style="max-width: 1000px;">
                <h5 class="section-title px-3">WANNA TRY ?</h5>
                <h1 class="mb-0">Awesome Topic</h1>
            </div>
            <div class="tab-class text-center">
                <!-- List Items For Each Tab Start  -->
                <div class="tab-content">
                    <div id="tab-1" class="tab-pane fade show p-0 active">
                        <div class="row g-4">
                            <div class="col-lg-4"
                                v-for="(topic, index) in visibleTopics"
                                :key="topic.id">
                                <div class="topic-img">
                                    <img v-if = "topic.imageUrl" class="img-fluid rounded w-100"
                                        :src="topic.imageUrl"
                                        alt="topic.name"/>
                                    <div class = 'topic-overlay p-4'>
                                        <h4 class = 'text-white mb-2 mt-3'>{{ topic.name }}</h4>
                                        <a href="#" class="btn-hover text-white">
                                            Discovery
                                            <svg width="20px" height="20px" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
                                                <path d="M16.3153 16.6681C15.9247 17.0587 15.9247 17.6918 16.3153 18.0824C16.7058 18.4729 17.339 18.4729 17.7295 18.0824L22.3951 13.4168C23.1761 12.6357 23.1761 11.3694 22.3951 10.5883L17.7266 5.9199C17.3361 5.52938 16.703 5.52938 16.3124 5.91991C15.9219 6.31043 15.9219 6.9436 16.3124 7.33412L19.9785 11.0002L2 11.0002C1.44772 11.0002 1 11.4479 1 12.0002C1 12.5524 1.44772 13.0002 2 13.0002L19.9832 13.0002L16.3153 16.6681Z" fill="#EDF6F9"/>
                                            </svg>
                                        </a >
                                    </div>  
                                    <div class="search-icon">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- List Items For Each Tab End  -->
            </div>
        </div>
    </div>
    <!-- Topic End -->

    <!-- Tour Start -->
    <div class="container-fluid tour py-0" style="width: 1210px;">
        <div class="container">
            <div class="mx-auto text-center mb-5" style="max-width: 1000px;">
                <h5 class="section-title px-3">Tour proposal</h5>
                <h1 class="mb-0">Awesome Tour</h1>
            </div>

            <div class = "tour-carousel owl-carousel">
                <!-- Button side of the carousel -->
                <div class="owl-nav">
                    <button class="owl-prev" @click="prevTour">
                        <svg class="bi bi-arrow-left" width="40" height="40" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M7.68473 7.33186C8.07526 6.94134 8.07526 6.30817 7.68473 5.91765C7.29421 5.52712 6.66105 5.52712 6.27052 5.91765L1.60492 10.5832C0.823873 11.3643 0.823872 12.6306 1.60492 13.4117L6.27336 18.0801C6.66388 18.4706 7.29705 18.4706 7.68757 18.0801C8.0781 17.6896 8.0781 17.0564 7.68757 16.6659L4.02154 12.9998L22 12.9998C22.5523 12.9998 23 12.5521 23 11.9998C23 11.4476 22.5523 10.9998 22 10.9998L4.01675 10.9998L7.68473 7.33186Z"/>
                        </svg>
                    </button>
                    <button class="owl-next" @click="nextTour">
                        <svg class="bi bi-arrow-right" width="40px" height="40px" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M16.3153 16.6681C15.9247 17.0587 15.9247 17.6918 16.3153 18.0824C16.7058 18.4729 17.339 18.4729 17.7295 18.0824L22.3951 13.4168C23.1761 12.6357 23.1761 11.3694 22.3951 10.5883L17.7266 5.9199C17.3361 5.52938 16.703 5.52938 16.3124 5.91991C15.9219 6.31043 15.9219 6.9436 16.3124 7.33412L19.9785 11.0002L2 11.0002C1.44772 11.0002 1 11.4479 1 12.0002C1 12.5524 1.44772 13.0002 2 13.0002L19.9832 13.0002L16.3153 16.6681Z"/>
                        </svg>
                    </button>
                </div>  
                <Swiper :slidesPerView="3"
                        :spaceBetween="30"
                        :pagination="{
                        clickable: true,
                        }"
                        :modules="modules"
                        class="mySwiper">
                    <SwiperSlide class="tours-item"
                        v-for="(tour, index) in visibleTours"
                        :key="tour.id">
                        <div class="tours-img">
                            <img v-if="tour.imageUrl" :src="tour.imageUrl" 
                                :alt = "tour.name" 
                                class="img-fluid w-100 rounded-top">
                                <div class="tour-info d-flex border-start-0
                                    border-end-0 position-absolute" style="width: 100%;
                                    bottom: 0; left: 0; z-index: 5;">
                                    <small class="flex-fill text-center border-end py-2">
                                        <svg class ="fa me-2"
                                            width="30px" height="30px" 
                                            viewBox="0 0 24 24" fill="#caf0f8" 
                                            xmlns="http://www.w3.org/2000/svg">
                                            <path fill-rule="evenodd" clip-rule="evenodd" d="M12.2848 18.9935C12.1567 19.0875 12.0373 19.1728 11.9282 19.2493C11.8118 19.1721 11.6827 19.0833 11.5427 18.9832C10.8826 18.5109 10.0265 17.8176 9.18338 16.9529C7.45402 15.1792 6 12.9151 6 10.5C6 7.18629 8.68629 4.5 12 4.5C15.3137 4.5 18 7.18629 18 10.5C18 12.8892 16.4819 15.1468 14.6893 16.9393C13.8196 17.8091 12.9444 18.5099 12.2848 18.9935ZM19.5 10.5C19.5 16.5 12 21 12 21C11.625 21 4.5 16.5 4.5 10.5C4.5 6.35786 7.85786 3 12 3C16.1421 3 19.5 6.35786 19.5 10.5ZM13.5 10.5C13.5 11.3284 12.8284 12 12 12C11.1716 12 10.5 11.3284 10.5 10.5C10.5 9.67157 11.1716 9 12 9C12.8284 9 13.5 9.67157 13.5 10.5ZM15 10.5C15 12.1569 13.6569 13.5 12 13.5C10.3431 13.5 9 12.1569 9 10.5C9 8.84315 10.3431 7.5 12 7.5C13.6569 7.5 15 8.84315 15 10.5Z" fill="#currentColor"/>
                                        </svg>
                                        {{ tour.location }}
                                    </small>
                                    <small class="flex-fill text-center py-2">
                                        <svg class="fa me-2" 
                                            fill="#caf0f8" width="30px" 
                                            height="30px" viewBox="0 0 32 32" 
                                            xmlns="http://www.w3.org/2000/svg" 
                                            preserveAspectRatio="xMidYMid">
                                            <path d="M30.000,32.000 L2.000,32.000 C0.897,32.000 -0.000,31.103 -0.000,30.000 L-0.000,5.000 C-0.000,3.897 0.897,3.000 2.000,3.000 L10.000,3.000 L10.000,1.000 C10.000,0.448 10.448,-0.000 11.000,-0.000 C11.552,-0.000 12.000,0.448 12.000,1.000 L12.000,3.000 L20.000,3.000 L20.000,1.000 C20.000,0.448 20.448,-0.000 21.000,-0.000 C21.552,-0.000 22.000,0.448 22.000,1.000 L22.000,3.000 L30.000,3.000 C31.103,3.000 32.000,3.897 32.000,5.000 L32.000,30.000 C32.000,31.103 31.103,32.000 30.000,32.000 ZM22.000,5.000 L22.000,6.000 C22.000,6.552 21.552,7.000 21.000,7.000 C20.448,7.000 20.000,6.552 20.000,6.000 L20.000,5.000 L12.000,5.000 L12.000,6.000 C12.000,6.552 11.552,7.000 11.000,7.000 C10.448,7.000 10.000,6.552 10.000,6.000 L10.000,5.000 L2.000,5.000 L2.000,30.000 L29.997,30.000 L30.000,5.000 L22.000,5.000 ZM25.000,24.000 L23.000,24.000 C22.448,24.000 22.000,23.552 22.000,23.000 L22.000,21.000 C22.000,20.448 22.448,20.000 23.000,20.000 L25.000,20.000 C25.552,20.000 26.000,20.448 26.000,21.000 L26.000,23.000 C26.000,23.552 25.552,24.000 25.000,24.000 ZM25.000,16.000 L23.000,16.000 C22.448,16.000 22.000,15.552 22.000,15.000 L22.000,13.000 C22.000,12.448 22.448,12.000 23.000,12.000 L25.000,12.000 C25.552,12.000 26.000,12.448 26.000,13.000 L26.000,15.000 C26.000,15.552 25.552,16.000 25.000,16.000 ZM17.000,24.000 L15.000,24.000 C14.448,24.000 14.000,23.552 14.000,23.000 L14.000,21.000 C14.000,20.448 14.448,20.000 15.000,20.000 L17.000,20.000 C17.552,20.000 18.000,20.448 18.000,21.000 L18.000,23.000 C18.000,23.552 17.552,24.000 17.000,24.000 ZM17.000,16.000 L15.000,16.000 C14.448,16.000 14.000,15.552 14.000,15.000 L14.000,13.000 C14.000,12.448 14.448,12.000 15.000,12.000 L17.000,12.000 C17.552,12.000 18.000,12.448 18.000,13.000 L18.000,15.000 C18.000,15.552 17.552,16.000 17.000,16.000 ZM9.000,24.000 L7.000,24.000 C6.448,24.000 6.000,23.552 6.000,23.000 L6.000,21.000 C6.000,20.448 6.448,20.000 7.000,20.000 L9.000,20.000 C9.552,20.000 10.000,20.448 10.000,21.000 L10.000,23.000 C10.000,23.552 9.552,24.000 9.000,24.000 ZM9.000,16.000 L7.000,16.000 C6.448,16.000 6.000,15.552 6.000,15.000 L6.000,13.000 C6.000,12.448 6.448,12.000 7.000,12.000 L9.000,12.000 C9.552,12.000 10.000,12.448 10.000,13.000 L10.000,15.000 C10.000,15.552 9.552,16.000 9.000,16.000 Z"/>
                                        </svg>
                                        {{ tour.name }}
                                    </small>
                                </div>
                            </img>
                        </div>

                        <div class="tour-content bg-light">
                            <div class="p-4 pb-0">
                                <h5 class="mb-0" style="padding-bottom: 15px;">{{ tour.location }}</h5>
                                <small class='text-uppercase'>{{ tour.rating }}</small>
                                <div class="mb-3">
                                    <img class="fa star-icon" 
                                        v-for="star in generateStars(tour.rating)" 
                                        :src="star"/>
                                </div>
                                <small class='text-uppercase reviews'>{{ tour.reviewNumber }} reviews</small>
                                <p class="mb-4">{{ tour.description }} Some of description about this Tour (maybe generate by AI)</p>
                            </div>
                            <div class="row bg-primary rounded-bottom mx-0">
                                <div class="col-6 text-start px-0">
                                    <button class="btn-hover text-white py-3 px-4">Read more</button>
                                </div>
                                <div></div>
                            </div>
                        </div>
                    </SwiperSlide>
                </Swiper> 
            </div>
        </div>
    </div>
     <!-- Tour End  -->
</template>
  
<script setup>
    import dashboardViewModel from '../viewModels/dashboardViewModel.js';
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
  
<script>
  // Import Swiper Vue.js components
  import { Swiper, SwiperSlide } from 'swiper/vue';

  // Import Swiper styles
  import 'swiper/css';

  import 'swiper/css/pagination';


  // import required modules
  import { Pagination } from 'swiper/modules';

  export default {
    components: {
      Swiper,
      SwiperSlide,
    },
    setup() {
      return {
        modules: [Pagination],
      };
    },
  };
</script>

<style>
:root {
--default-font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
    Ubuntu, "Helvetica Neue", Helvetica, Arial, "PingFang SC",
    "Hiragino Sans GB", "Microsoft Yahei UI", "Microsoft Yahei",
    "Source Han Sans CN", sans-serif;
}

.top_website {
    position: absolute;
    background: url('@/assets/images/background_picture.png');
    background-size: cover;
    width :100%;
    display: flex;
    height: 640px;
    top : 0;
    left: 0;
    flex-direction: column;
    align-items: center;
}    
.top_website::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(39, 45, 45, 0.48);
  z-index: 0;
}
.navbar {
    position: fixed;
    top : 0;
    left: 0;
    width :100%;
    height: 20%;
    display: flex;
    flex: 0 1 auto; /* Chiều cao tự động */
    justify-content: space-between; /* Chia đều không gian giữa các phần */
    align-items: center;
    border-bottom: 1px solid #13357B;
    padding: 0px 20px ; /* Đệm bên trong thanh điều hướng */
    z-index: 1;
}
.logo-section {
    display: flex;
    width :100%;
    align-items: center;
}
.logo {
    height: 70px;
    margin-right: 10px;
    border-radius: 50%;
    z-index: 8;
}
.logo-text {
    font-size: 20px;
    color: #EDF6F9;
    font-weight: bold;
    font-family: 'Roboto';

}
/* Phần các nút điều hướng */
.navbar-buttons {
    display: flex;
    align-items: center;
    height: 100%;
    width: 100%;
}
.navbar-button {
    position: relative;
    background: none;
    border: none;
    color: #EDF6F9;
    font-weight: bold;
    font-size: 16px;
    cursor: pointer;
    font-family: 'Roboto';
    padding: 60px 30px;
    height: 100%;
}
.navbar-button::before {
    position: absolute;
    content: "";
    width: 100%;
    height: 0;
    bottom: -1px;
    left: 0;
    background: #13357B;
    transition: .5s;
    z-index: -1;
}
.navbar-button:hover::before {
    height: calc(100% + 10px);
    left: 1px;
}
.navbar .user-icon {
    display: flex;
    align-items: center;
}
/* Phần biểu tượng người dùng */
.user-icon {
    display: flex;
    align-items: center;
    padding-right: 20px;
}
.user-image {
    background: url('@/assets/svg/user_icon_1.svg') no-repeat center;
    background-size: cover;
    width: 40px;
    height: 40px;
}
.carousel-caption {
    position: absolute;
    width: 100%;
    height: 100%;
    top: 0;
    left: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    color: #EDF6F9;
    font-family: 'Roboto';
    bottom: 1.25rem;
    padding-top: 5.25rem;
}

h4{
    font-size: calc(1.275rem + 0.3vw);
    font-weight: bold;
    line-height: 2;    
    text-transform: uppercase !important;
    font-weight: 700;
}
h1 {
    display: block;
    margin-block-start: 0.67em;
    margin-block-end: 0.67em;
    font-weight: bold;
    unicode-bidi: isolate;
}
.display-2 {
    font-size: calc(1.575rem + 2.5vw);
    font-weight: 600;
    line-height: 1.2;
}
.mb-4 {
    margin-bottom: 0rem !important;
}

.footer_search{
    position: relative;
    top: 100%;
    width: 100%;
    text-align: center;
    padding-left: var(--bs-gutter-x, 0.75rem);
    padding-right: var(--bs-gutter-x, 0.75rem);
    margin-left: auto;
    margin-right: auto;
    transform: translateY(-50%);
}

div {
    display: block;
    unicode-bidi: isolate;
}

.container, .container-fluid, .container-lg, .container-md, .container-sm, .container-xl {
    width: 100%;
    padding-right: 0.75rem;
    padding-left: 0.75rem;
}
.position-relative {
    position: relative;
    background: rgba(19, 53, 123, 0.8);
    border-radius: 50rem;
    padding: 3rem;
    margin-right: auto;
    margin-left: auto;
    width: 100%;
}
.form-control {
    display: block;
    width: 100%;
    padding: 0.375rem 0.75rem;
    padding-left: 1.5rem;
    padding-right: 3rem;
    padding-top: 1rem;
    padding-bottom: 1rem;
    border: 0;
    font-size: 1rem;
    font-weight: 400;
    line-height: 1.5;
    color: #212529;
    background-color: #EDF6F9;
    background-clip: padding-box;
    border: 2px solid #EDF6F9;
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    border-radius: 30px;
    transition: border-color 0.15s ease-in-out, 
    box-shadow 0.15s ease-in-out;
}

.btn-primary {
    top : 50%;
    right: 46px;
    transform: translateY(-50%);
    box-shadow: inset 0 0 0 0 #13357B;  
    border-radius: 50rem;
    font-weight: 600;
    transition: all 0.5s;
    position: absolute;
    color: #fff;
    background-color: #13357B;
    border: 0;
    border-color: #13357B;
    padding-top: .5rem;
    padding-bottom: .5rem;
    padding-left: 1.5rem;    
    padding-right: 1.5rem;
    margin-right: 1rem;
    display: inline-block;
    line-height: 1.5;
    text-align: center;
    vertical-align: middle;
}

button {
    justify-content: center;
    margin: 0;
    border: none;
    font-size: 100%;
    border-radius: 10px;
    text-transform: none;
    background-color: transparent;
    font-family: 'Roboto';
    color: #caf0f8;
}
.tour button:hover{
    color: #13357B !important; 
    background-color: #caf0f8;
    border-radius: 10px;
}

.btn-primary:hover {
    color: #13357B;
    background-color: #EDF6F9;  
    border: 2px solid #13357B;
}

input:focus, input:hover {
  outline: none;
  background-color: #caf0f8;
  color: #13357B;
  border: 2px solid #caf0f8;
}
.py-5 {
    width: 100%;
    padding-top: 25rem !important;
}
.py-0 {
    width: 100%;
    padding-top: 15rem !important;
}
.mx-auto {
    margin-right: auto !important;
    margin-left: auto !important;
    /* z-index: 10; */
}

.h5, h5, .h1, h1, .h2, h2, .h3, h3, .h4, h4, .h6, h6  {
    margin-top: 0;
    margin-bottom: 0.5rem;
    font-weight: 500;
    line-height: 1.2;
    font-family: "Roboto", 'sans-serif';     
}
h5, .h5 {   
    font-size: 1.25rem;
}
h5 {
    margin-block-start: 1.67em;
    margin-block-end: 1.67em;
    margin-inline-start: 0px;
    margin-inline-end: 0px;
}

.section-title {
    position: relative;
    display: inline-block;
    color: #13357B;
    text-transform: uppercase;  
    /* font-size: 30px; */
    font-weight: 700;
}

.section-title::before {
    position: absolute;
    content: "";
    width: 100px;
    top: 50%;
    left: 0;
    border-radius: 5px;
    transform: translateY(-50%); 
    margin-left: -150px;   
    border: 2px solid #13357B;
}
.section-title::after{
    position: absolute;
    content: "";
    width: 100px;
    top: 50%;
    right: 0;
    border-radius: 5px;
    transform: translateY(-50%); 
    margin-right: -150px;   
    border: 2px solid #13357B;
}

.px-3 {
    padding-right: 1rem !important;
    padding-left: 1rem !important;
}
.container-fluid .destination {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    min-height: 100vh; /* Đảm bảo chiếm toàn bộ chiều cao màn hình */
    text-align: center;
    margin-left: auto;
    margin-right: auto;
}

.mb-0 {
    margin-bottom: 0 !important;
}
h1 {
    font-size: calc(1.375rem + 1.5vw);
    font-weight: 600;
}


/* Css for all */
body{
    margin: 0;
    font-family: "Roboto", sans-serif;
    font-size: 1rem;
    font-weight: 400;
    line-height: 1.5;
    color: #13357B;
    background-color: #EDF6F9;
    -webkit-text-size-adjust: 100%;
    -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
}

*, *::before, *::after {
    box-sizing: border-box;
}

.nav {
    display: flex;
    flex-wrap: wrap;
    padding-left: 0;
    margin-bottom: 0;
    list-style: none;
}

.mb-5 {
    margin-bottom: 3rem !important;
}

.justify-content-center {
    justify-content: center !important;
}

.d-inline-flex {
    display: inline-flex !important;
}

ol, ul,dl {
    margin-top: 0;
    margin-bottom: 1rem;
}

ol, ul {
    padding-left: 2em;
}

ul{
    display: block;
    list-style-type: disc;
    margin-block-start: 1em;
    margin-block-end: 1em;
    margin-inline-start: 0px;
    margin-inline-end: 0px;
    padding-inline-start: 40px;
    unicode-bidi: isolate;
}

.text-center {
    text-align: center !important;
}

.destination .tab-class .nav-item {
    padding: 0 0 20px 0;
}

li {
    text-align: -webkit-match-parent;
    display: list-item;
    unicode-bidi: isolate;
}

.rounded-pill {
    border-radius: 50rem !important;
}
.rounded-top{
    border-top-left-radius:10px !important;
    border-top-right-radius:10px !important
}
.bg-light {
    background-color: #EDF6F9 !important;
}

.py-2{
    padding: 0.5rem 0rem   !important;
}

.mx-3 {
    margin-right: 1rem !important;
    margin-left: 1rem !important;
}

.border-primary {
    border-color: #13357B !important;
}

.border {
    border: 2px solid #13357B !important;
}

.d-flex {
    display: flex !important;
}

.p-3{
    padding-top: 1rem !important;
}

/* Css for destination */
/* For tag button */
.nav-item button {
    display: flex;
    color: #13357B;
    text-decoration: none;
    width: 200px;
    font-family: 'Roboto';
}

.nav-item button:hover {
    color: #13357B;
    background-color: #caf0f8 !important;
    text-decoration: none;
}

.nav-item button.active {
    color: #caf0f8;
    background-color: #13357B !important;
    text-decoration: none;
}

/* For all list items */
.tab-content>.active {
    display: block;    
}

.tab-content>.tab-pane {
    /* display: none; */
}

.p-0 {
    padding: 0 !important;
}

.fade{
    transition: opacity 0.15s linear;
}

.row {
    --bs-gutter-x: 1.5rem;
    --bs-gutter-y: 0;
    display: flex;
    flex-wrap: wrap;
    padding: 15px;
    margin-top: calc(-1 * var(--bs-gutter-y));
    margin-right: calc(-0.5 * var(--bs-gutter-x));
    margin-left: calc(-0.5 * var(--bs-gutter-x));
}

.g-4, .gx-4 {
    --bs-gutter-x: 1.5rem;
}

.g-4, .gy-4 {
    --bs-gutter-y: 1.5rem;
}

.row>* {
    flex-shrink: 0;
    width: 100%;
    max-width: 100%;
    padding-right: calc(var(--bs-gutter-x) * .5);
    padding-left: calc(var(--bs-gutter-x) * .5);
    margin-top: var(--bs-gutter-y);
}

.rounded{
    border-radius: 10px !important;
}

.w-100{
    width: 100% !important;
}

.img-fluid {
    width: 100%;
    height: 250px;
}   
img, svg{
    vertical-align: middle;
}
img{
    overflow-clip-margin: content-box;
    overflow: clip;
}
.p-4{
    padding: 1.5rem !important;
}

.btn.btn-primary{
    box-shadow: inset 0 0 0 0 #13357B;
}
.btn{
    font-weight: 600;
    transition: all 0.5s;
}

.rounded-pill{
    border-radius: 50rem !important;
}
.text-white{
    color: #EDF6F9 !important;
}
.btn{
    display: inline-block;   
    font-weight: 400;
    line-height: 1.5;
    color: #caf0f8;
    font-family: 'roboto';
    text-align: center;
    vertical-align: middle;
    -webkit-user-select: none;
    -moz-user-select: none;
    user-select: none;
    padding: .375rem .75rem;
    font-size: 1rem;
    transition: color .15s ease-in-out,
                background-color .15s ease-in-out,
                border-color .15s ease-in-out,
                box-shadow .15s ease-in-out;
}

a {
    font-family: 'Roboto';
    color: #13357B;
    text-decoration: none;
}
.mb-2 {
    margin-bottom: .5rem !important;
}
.mt-3 {
    margin-top: 1rem !important;
}
.btn-hover{
    transition: all 0.5s;
}
.ms-2 {
    margin-left: .5rem !important;
}
.fa .fas {
    font-weight: 900;
}

.fa, .fab, .fad, .fal, .far, .fas {
    -moz-osx-font-smoothing: grayscale;
    -webkit-font-smoothing: antialiased;
    display: inline-block;
    font-style: normal;
    font-variant: normal;
    text-rendering: auto;
    line-height: 1;
}
 
/* Destination */
.destination .tab-class .tab-content .tab-pane .destination-img {
    position: relative;
    overflow: hidden;
    border-radius: 10px;
    z-index: 1;
}

.destination .tab-class .tab-content .destination-img img {
    transition: 0.5s;
}

.destination .tab-class .tab-content .tab-pane .destination-img {
    position: relative;
    overflow: hidden;
    border-radius: 10px;
    z-index: 1;
}

.destination .tab-class .tab-content .tab-pane .destination-img .destination-overlay {
    position: absolute;
    bottom: -100%;
    left: 0px;
    text-align: left;
    z-index: 3;
    transition: 0.5s;
}

.destination .tab-class .tab-content .tab-pane .destination-img .search-icon {
    position: absolute;
    width: 100%;
    height: 100%;
    top: 0;
    right: 0;
    display: flex;
    justify-content: end;
    padding: 20px 20px 0 0;
    background: rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    transition: 0.5s;
}

.destination .tab-class .tab-content .tab-pane .destination-img .search-icon a i {
    opacity: 0;
    transition: 0.5s;
}

.destination .tab-class .nav-item {
    padding: 0 0 20px 0;
}
.destination .tab-class .nav-item a.active {
    background: var(--bs-primary) !important;
}

.destination .tab-class .nav-item a.active span {
    color: var(--bs-white) !important;
}

.destination .tab-class .tab-content .destination-img:hover .search-icon {
    background: rgba(19, 53, 123, 0.4);
}

.destination .tab-class .tab-content .destination-img:hover .destination-overlay {
    bottom: 0;
}

.destination .tab-class .tab-content .destination-img:hover .search-icon a i {
    opacity: 1;
}

.destination .tab-class .tab-content .destination-img img {
    transition: 0.5s;
}

.destination .tab-class .tab-content .destination-img:hover img {
    transform: scale(1.2);
}

@media (min-width: 992px) {
    .col-lg-4 {
        flex: 0 0 auto;
        width: 33.3333333333%;
    }
    h4, .h4 {
            font-size: 1.5rem;
    }
}

/* Topic */
.topic .tab-class .tab-content .tab-pane .topic-img {
    position: relative;
    overflow: hidden;
    align-items: center;
    border-radius: 10px;
    z-index: 1;
}

.topic .tab-class .tab-content .topic-img img {
    transition: 0.5s;
}

.topic .tab-class .tab-content .tab-pane .topic-img {
    position: relative;
    overflow: hidden;
    border-radius: 10px;
    display: flex;
    align-items: end;
    justify-content: center;
    z-index: 1;
}

.topic .tab-class .tab-content .tab-pane .topic-img .topic-overlay {
    position: absolute;
    bottom: 100%;
    z-index: 3;
    text-align: center;
    transition: 0.5s;
}

.topic .tab-class .tab-content .tab-pane .topic-img .search-icon {
    position: absolute;
    width: 100%;
    height: 100%;
    top: 0;
    right: 0;
    display: flex;
    padding: 20px 20px 0 0;
    background: rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    transition: 0.5s;
}

.topic .tab-class .tab-content .tab-pane .topic-img .search-icon a i {
    opacity: 0;
    transition: 0.5s;
}

.topic .tab-class .nav-item {
    padding: 0 0 20px 0;
}
.topic .tab-class .nav-item a.active {
    background: var(--bs-primary) !important;
}

.topic .tab-class .nav-item a.active span {
    color: var(--bs-white) !important;
}

.topic .tab-class .tab-content .topic-img:hover .search-icon {
    background: rgba(19, 53, 123, 0.4);
}

.topic .tab-class .tab-content .topic-img:hover .topic-overlay {
    bottom: 0;
}

.topic .tab-class .tab-content .topic-img:hover .search-icon a i {
    opacity: 1;
}

.topic .tab-class .tab-content .topic-img img {
    transition: 0.5s;
}

.topic .tab-class .tab-content .topic-img:hover img {
    transform: scale(1.2);
}

/* Tùy chỉnh thanh cuộn cho toàn bộ website */
::-webkit-scrollbar {
    width: 10px; /* Độ rộng của thanh cuộn dọc */
    height: 10px; /* Độ rộng của thanh cuộn ngang */
}

::-webkit-scrollbar-track {
    background: #EDF6F9; /* Màu nền của đường dẫn */
    border-radius: 10px; /* Độ bo góc */
}

::-webkit-scrollbar-thumb {
    background: #13357B; /* Màu của thanh trượt */
    border-radius: 10px; /* Độ bo góc */
}
.destination .tab-class .owl-nav {
    position: relative;
    top: 7px;
}
.destination .tab-class .owl-nav .owl-prev {
    position: absolute;
    left: 0px;
    padding: 5px 30px;
    border: 2px solid #13357B;
    border-radius: 30px;
    transition: .5s;
}
.destination .tab-class .owl-nav .owl-next {
    position: absolute;
    right: 0px;
    padding: 5px 30px;
    border: 2px solid #13357B;
    border-radius: 30px;
    transition: .5s;
}

.owl-nav button:hover{
    background-color: #13357B;
}
.owl-nav button svg {
    fill: #13357B;
}
.owl-nav button:hover svg {
    fill: #EDF6F9;
}






/* Tour */
.container-fluid .tour {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    min-height: 100vh; /* Đảm bảo chiếm toàn bộ chiều cao màn hình */
    text-align: center;
    margin-left: auto;
    margin-right: auto;
}
.tour .tour-carousel .owl-nav button{
    position: relative;
    top: 3480px;
}
.tour .tour-carousel .owl-nav .owl-prev{
    position: absolute;
    left: 370px;
    padding: 5px 30px;
    border: 2px solid #13357B;
    border-radius: 30px;
    transition: .5s;
}

.tour .tour-carousel .owl-nav .owl-next{
    position: absolute;
    padding: 5px 30px;
    right: 370px;
    border: 2px solid #13357B;
    border-radius: 30px;
    transition: .5s;
}

.tour .tours-item .tours-img {
    position: relative;
    overflow: hidden;
    transition: 0.5s;
    border-top-right-radius: 20px;
    border-top-left-radius: 20px;
    z-index: 1; 
}

.tour .tours-item .tours-img .tour-info {
    border: 1px solid #EDF6F9; 
    background: rgba(19, 53, 123, 0.6);
}

.tour .tours-item .tours-img .tours-info small,
.tour .tours-item .tours-img .tours-info small svg{
    color: #EDF6F9;
    transition: 0.5s;
}   

.tour .tours-item .tours-img::after {
    position: absolute;
    content: "";
    top: 50%;
    left: 50%;
    width: 0;
    height: 0;
    transform: translate(-50%, -50%);
    border: 0px solid;
    border-radius: 10px !important;
    visibility: hidden;
    transition: 0.7s;
    z-index: 3;
}
.tour .tours-item .tours-img:hover .tours-img::after {
    width: 100%;
    height: 100%;
    border: 300px solid;
    border-color: rgba(19, 53, 123, 1) rgba(19, 53, 123, 0.6) rgba(19, 53, 123, 0.6) rgba(19, 53, 123, 0.6);
    visibility: visible;
}
.tour .tours-item .tours-img small,
.tour .tours-item .tours-img small svg {
    font-family: 'Roboto';
    font-size: 20px;
    align-content: center ;
    color: #EDF6F9;
    transition: 0.5s;
}
.tour .tours-item .tours-img:hover small,
.tour .tours-item .tours-img:hover small svg {
    color: #caf0f8 !important;
    fill: #caf0f8 !important;
    transition: 0.5s;
}
.tour .tours-item .tours-img img {
    transition: 0.5s;
}

.tour .tours-item .tours-img:hover img {
    transform: scale(1.3);
}

.position-absolute{
    position:absolute !important
}
.flex-fill{
    flex:1 1 auto !important
}
.border-end{
    border-right:1px solid #caf0f8 !important
}
.me-2{
    margin-right: .5rem !important;
}
.border-end-0 {
    border-right:0 !important
}
.border-start-0 {
    border-left:0 !important
}
.text-uppercase {
    font-family: 'Roboto';
    font-size: 25px;
    text-transform:uppercase !important
}
.top_website .carousel-caption .p-3 .text-uppercase{
    font-family: 'Roboto';
    font-size: 30px;
    padding-bottom: 50px;
    font-weight: bold;
    text-transform:uppercase !important

}
.mb-3{
    position:  relative;
    top: -30px;
}

.star-icon {
    width: 20px;
    height: 20px;
    margin-right: 2px;
    position: relative;
    left: 40px;
    bottom: 2px;
}
.mb-4 {
    margin-bottom: 1.5rem !important;
}

.rounded-bottom {
    border-bottom-right-radius: 20px !important;
    border-bottom-left-radius: 20px !important;
}
.bg-primary {
    background-color: #13357b !important;
}
.mx-0 {
    margin-right: 0 !important;
    margin-left: 0 !important;
}
.text-start {
    text-align: left !important;
}
.px-0 {
    padding-right: 0 !important;
    padding-left: 0 !important;
}
.col-6 {
    flex: 0 0 auto;
    width: 50%;
}
.px-4{
    padding: 1rem 1.5rem !important;
}
.tour .mySwiper {
    padding-bottom: 100px;
}
.tour .tours-item .tour-content small {
    padding-top: 100px;
}
</style>