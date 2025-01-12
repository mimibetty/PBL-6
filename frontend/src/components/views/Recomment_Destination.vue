<template>
    <div class="carousel">
        <VSlickCarousel v-bind="settings">
            <div class="tour-item p-2 d-flex flex-column" v-for="(destination, index) in destinations" :key="index">
                <div class="tour-img bg-light">
                    <img v-if="destination.images[0]" :src="destination.images[0].url" :alt="destination.id"
                        class="w-100">
                    <img v-else :src="'/blue-image.jpg'" class="w-100">

                    <btn_heart :destID="destination.id" class="btn-heart" />
                </div>
                <div class="tour-content bg-light">
                    <div class="p-4 pb-0">
                        <h5 class="tour-location text-truncate" style="margin-bottom: 15px;">{{ destination.name }}</h5>
                        <div class="mb-3 rating">
                            <small class='text-uppercase number-rating'>{{ destination.rating }}</small>
                            <div class="col">
                                <img class="fa icon-rating" v-for="star in generateStars(destination.rating)"
                                    :src="star" />
                            </div>
                        </div>
                        <div class="rating">
                            <svg fill="#13357B" width="20px" height="20px" xmlns="http://www.w3.org/2000/svg"
                                viewBox="0 0 384 512">
                                <path
                                    d="M172.3 501.7C27 291 0 269.4 0 192 0 86 86 0 192 0s192 86 192 192c0 77.4-27 99-172.3 309.7-9.5 13.8-29.9 13.8-39.5 0zM192 272c44.2 0 80-35.8 80-80s-35.8-80-80-80-80 35.8-80 80 35.8 80 80 80z" />
                            </svg>
                            <p class="mb-4 text-uppercase" v-if="destination.address">
                                {{ cities.find(city => city.id === destination.address.city_id)?.name }}
                            </p>
                        </div>
                        <p class="mb-4 text-truncate">{{ destination.description }}</p>
                    </div>
                    <div class="bg-primary rounded-bottom mx-0">
                        <div class="text-start py-4 px-4">
                            <button class="readmore px-4" @click="navigateToDetail(destination)">Read more</button>
                        </div>
                    </div>
                </div>
            </div>
        </VSlickCarousel>
    </div>
</template>

<script>
import btn_heart from './btn_heart.vue';
export default {
    name: "Recomment_Destination",
    components: {
        btn_heart
    }

}
</script>

<!-- Script cho v-slick-carousel không được đụng vào chỗ này -->
<script setup>
import 'v-slick-carousel/style.css'
import { VSlickCarousel } from 'v-slick-carousel'
import { ref, computed, watch } from 'vue'
const settings = {
    "dots": true,
    "infinite": true,
    "groupsToShow": 3,
    "groupsToScroll": 1,
    "slidesPerGroup": 1,
    "swipe": true,
    "swipeToSlide": true,
    "autoplay": true,
    "autoplaySpeed": 5000,
    "ignorePrefersReducedMotion": true,
}

const props = defineProps({
    destinations: {
        type: Array,
        required: true
    },
    generateStars: {
        type: Function,
        required: true,
    },
    cities: {
        type: Array,
    }
});

const navigateToDetail = (destination) => {
    console.log("hotel_id:", destination.hotel_id);
    console.log("restaurant_id:", destination.restaurant_id);
    console.log("destination_id:", destination.id);
    if (destination.hotel_id !== null && destination.restaurant_id === null) {
        window.location.assign(`/Detail/Hotel/${destination.hotel_id}`);
    }
    else if (destination.restaurant_id !== null) {
        window.location.assign(`/Detail/Restaurant/${destination.restaurant_id}`);
    }
    else {
        window.location.assign(`/Detail/Place/${destination.id}`);
    }
};

</script>

<style scoped>
.carousel {
    width: 100%;
    max-width: 1200px;
    padding: 0 40px;
    margin: 0 auto;
    /* Căn giữa carousel */
    overflow: hidden;
    /* Ngăn tràn nội dung */
}

.tour {
    cursor: pointer;
    margin-bottom: 30px
}

.tour .tours-item {
    color: #13357B !important;
    height: 100%;
    border: 1px solid #13357B;
    border-radius: 20px;
    overflow: hidden;
}

.tour-img {
    border-top-left-radius: 20px;
    border-top-right-radius: 20px;
    z-index: 1;
}

.w-100 {
    border-radius: 20px;
    width: 100%;
    height: 200px;
    object-fit: cover;
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .07), 0 6px 18px -1px rgba(19, 53, 123, .09) !important;
}

.tour .tour-item .tour-img .tour-info {
    border: 1px solid #EDF6F9;
    background: rgba(19, 53, 123, 0.6);
}

small,
small svg {
    color: #13357B !important;
    transition: 0.5s;
}

p {
    color: #13357B !important;
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
    fill: #89c2d9 !important;
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

.icon-rating {
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

:deep(.v-slick-arrow) {
    color: #EDF6F9 !important;
    transition: 0.5s;
    width: 40px !important;
    z-index: 16;
}

:deep(.v-slick-arrow.next::before) {
    font-size: 50px;
    color: #13357B;
}

:deep(.v-slick-arrow.prev::before) {
    font-size: 50px;
    color: #13357B;
    position: relative;
    left: -10px;
}

:deep(.v-slick-dots li.active button::before) {
    color: #13357B !important;
    border: none;
    transition: 0.5s;
    opacity: 1;
}

:deep(.v-slick-dots li button::before) {
    color: #8ECAE6 !important;
    border: none;
    transition: 0.5s;
    opacity: 1;
}

.tour-location {
    color: #13357B;
    font-weight: 900;
}

.text-truncate {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.btn-heart {
    position: relative;
    top: -30px;
    left: 250px;
    margin-bottom: -100px;
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .07), 0 6px 18px -1px rgba(19, 53, 123, .09) !important;
    z-index: 1000;
}
</style>