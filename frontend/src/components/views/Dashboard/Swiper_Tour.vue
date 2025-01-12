<template>
    <div class="tour">
        <div class="container">
            <Swiper :slidesPerView="3"
                    :spaceBetween="60"
                    :pagination="{ clickable: true }"
                    :navigation="true"
                    :modules="modules"
                    :draggable="false"
                    class="mySwiper">
                <SwiperSlide class="tour-item swiper-slide"v-for="(tour, index) in tours" 
                            :key="tour.id" @click="showDetail(tours)">
                    <div class="tour-img">
                        <img v-if="tour.destinations.find(dest => dest.images && dest.images.length)?.images[0]" 
                            :src="tour.destinations.find(dest => dest.images && dest.images.length)?.images[0].url" 
                            :alt="tour.id" 
                            class="w-100">
                        <img v-else :src="'/blue-image.jpg'">
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
                                {{ getCityName(tour.city_id) }}
                            </small>
                            <small class="flex-fill text-center py-2">
                                <svg class="fa me-2" 
                                    fill="#caf0f8" width="30px" 
                                    height="30px" viewBox="0 0 32 32" 
                                    xmlns="http://www.w3.org/2000/svg" 
                                    preserveAspectRatio="xMidYMid">
                                    <path d="M30.000,32.000 L2.000,32.000 C0.897,32.000 -0.000,31.103 -0.000,30.000 L-0.000,5.000 C-0.000,3.897 0.897,3.000 2.000,3.000 L10.000,3.000 L10.000,1.000 C10.000,0.448 10.448,-0.000 11.000,-0.000 C11.552,-0.000 12.000,0.448 12.000,1.000 L12.000,3.000 L20.000,3.000 L20.000,1.000 C20.000,0.448 20.448,-0.000 21.000,-0.000 C21.552,-0.000 22.000,0.448 22.000,1.000 L22.000,3.000 L30.000,3.000 C31.103,3.000 32.000,3.897 32.000,5.000 L32.000,30.000 C32.000,31.103 31.103,32.000 30.000,32.000 ZM22.000,5.000 L22.000,6.000 C22.000,6.552 21.552,7.000 21.000,7.000 C20.448,7.000 20.000,6.552 20.000,6.000 L20.000,5.000 L12.000,5.000 L12.000,6.000 C12.000,6.552 11.552,7.000 11.000,7.000 C10.448,7.000 10.000,6.552 10.000,6.000 L10.000,5.000 L2.000,5.000 L2.000,30.000 L29.997,30.000 L30.000,5.000 L22.000,5.000 ZM25.000,24.000 L23.000,24.000 C22.448,24.000 22.000,23.552 22.000,23.000 L22.000,21.000 C22.000,20.448 22.448,20.000 23.000,20.000 L25.000,20.000 C25.552,20.000 26.000,20.448 26.000,21.000 L26.000,23.000 C26.000,23.552 25.552,24.000 25.000,24.000 ZM25.000,16.000 L23.000,16.000 C22.448,16.000 22.000,15.552 22.000,15.000 L22.000,13.000 C22.000,12.448 22.448,12.000 23.000,12.000 L25.000,12.000 C25.552,12.000 26.000,12.448 26.000,13.000 L26.000,15.000 C26.000,15.552 25.552,16.000 25.000,16.000 ZM17.000,24.000 L15.000,24.000 C14.448,24.000 14.000,23.552 14.000,23.000 L14.000,21.000 C14.000,20.448 14.448,20.000 15.000,20.000 L17.000,20.000 C17.552,20.000 18.000,20.448 18.000,21.000 L18.000,23.000 C18.000,23.552 17.552,24.000 17.000,24.000 ZM17.000,16.000 L15.000,16.000 C14.448,16.000 14.000,15.552 14.000,15.000 L14.000,13.000 C14.000,12.448 14.448,12.000 15.000,12.000 L17.000,12.000 C17.552,12.000 18.000,12.448 18.000,13.000 L18.000,15.000 C18.000,15.552 17.552,16.000 17.000,16.000 ZM9.000,24.000 L7.000,24.000 C6.448,24.000 6.000,23.552 6.000,23.000 L6.000,21.000 C6.000,20.448 6.448,20.000 7.000,20.000 L9.000,20.000 C9.552,20.000 10.000,20.448 10.000,21.000 L10.000,23.000 C10.000,23.552 9.552,24.000 9.000,24.000 ZM9.000,16.000 L7.000,16.000 C6.448,16.000 6.000,15.552 6.000,15.000 L6.000,13.000 C6.000,12.448 6.448,12.000 7.000,12.000 L9.000,12.000 C9.552,12.000 10.000,12.448 10.000,13.000 L10.000,15.000 C10.000,15.552 9.552,16.000 9.000,16.000 Z"/>
                                </svg>
                                {{ Math.floor(tour.duration/24) }} days
                            </small>
                        </div>
                    </div>

                    <div class="tour-content bg-light">
                        <div class="p-4 pb-0">
                            <h5 class="tour-location" style="margin-bottom: 15px;">{{ tour.name }}</h5>
                            <div class="mb-3 rating">
                                <small class='text-uppercase number-rating'>{{ tour.rating }}</small>
                                <div class="col">
                                    <img class="fa icon-rating" 
                                        v-for="star in generateStars(tour.rating)" 
                                        :src="star"/>
                                </div>
                            </div>
                            <small class='text-uppercase reviews'>{{ tour.numOfReviews }} reviews</small>
                            <p class="mb-4">{{ tour.description }}</p>
                        </div>
                        <div class="row bg-primary rounded-bottom mx-0">
                            <div class="col-6 text-start py-4 px-4">
                                <button class="readmore px-4" @click="navigateToDetailTour(tour.id)">Read more</button>
                            </div>
                            <div></div>
                        </div>
                    </div>
                </SwiperSlide>
            </Swiper>
        </div>
    </div>
</template>

<script setup>
    import dashboardViewModel from '../../viewModels/dashboardViewModel';
    const{
        tours, visibleTours, prevTour, nextTour,generateStars, getCityName,
    } = dashboardViewModel;
    const navigateToDetailTour = (tour_id) => {
    window.location.assign(`/tour/${tour_id}`);
};

</script>
<script>
// Import Swiper Vue.js components
import { Swiper, SwiperSlide } from 'swiper/vue';
import { Navigation, Pagination, Scrollbar, A11y } from 'swiper/modules';
// Import Swiper styles
import 'swiper/css';
import 'swiper/css/navigation';
import 'swiper/css/scrollbar';

import 'swiper/css/pagination';

// import required modules
const modules = [Navigation, Pagination, Scrollbar, A11y];

export default {
    components: {
        Swiper,
        SwiperSlide,
    },
    setup() {
        return {
            modules: [Pagination, Navigation],
        };
    },
};
</script>

<style scoped>
.tour {
    cursor: pointer;
    margin-bottom: 30px
}

.tour .tours-item {
    border-radius: 20px;
    overflow: hidden;
}
.tour .tour-item .tour-img {
    position: relative;
    overflow: hidden;
    transition: 0.5s;
    border-top-right-radius: 20px;
    border-top-left-radius: 20px;
    z-index: 1; 
}
img {
    width: 100%;
    height: 200px;
    object-fit: cover;
}
.tour .tour-item .tour-img .tour-info {
    border: 1px solid #EDF6F9; 
    background: rgba(19, 53, 123, 0.6);
}
.tour .tour-item .tour-img .tour-info small,
.tour .tour-item .tour-img .tour-info small svg{
    color: #EDF6F9;
    transition: 0.5s;
}   
.tour .tour-item .tour-img::after {
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
.tour .tour-item .tour-img:hover .tour-img::after {
    width: 100%;
    height: 100%;
    border: 300px solid;
    border-color: rgba(19, 53, 123, 1) rgba(19, 53, 123, 0.6) rgba(19, 53, 123, 0.6) rgba(19, 53, 123, 0.6);
    visibility: visible;
}
.tour .tour-item .tour-img:hover small,
.tour .tour-item .tour-img:hover small svg {
    color: #89c2d9 !important;
    fill: #89c2d9!important;
    transition: 0.5s;
}
.tour .tour-item .tour-img img {
    transition: 0.5s;
}

.tour .tour-item .tour-img:hover img {
    transform: scale(1.3);
}
.rating {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
}
.icon-rating{
    width: 20px;
    height: 20px;
    margin: 0px 0 8px 0;
}
.rounded-bottom {
    border-bottom-right-radius: 20px !important;
    border-bottom-left-radius: 20px !important;
}
.bg-primary {
    background-color: #13357b !important;
}
.readmore {
    color: #EDF6F9;
    background-color: transparent;
    border: none;
    padding: 10px 20px;
    border-radius: 10px;
    transition: 0.5s;
}
.readmore:hover {
    color: #13357B;
    background-color: #EDF6F9;
    border: none;
    padding: 10px 20px;
    border-radius: 10px;
    transition: 0.5s;
}
:deep(.swiper-button-next),
:deep(.swiper-button-prev) {
    color: #13357B !important;
    border: none;
    position: absolute;
    margin-top: -60px;
    cursor: pointer;
}
:deep(.swiper-pagination-bullet-active) {
    background-color: #13357B !important;
}
:deep(.swiper-pagination-bullet) {
    background-color: #8ecae6;
    opacity: 1 !important;
}
.mySwiper {
    width: 100%;
    position: relative;
    padding: 0 55px;
}
</style>
  