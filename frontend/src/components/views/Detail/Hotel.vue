<template>
    <div class="container-fluid">
        <Header/>
        <Top_Button v-if="hotel" :cityID="hotel.address.city_id"/>
    </div> 
    <div class="container-fluid">
        <div class="container-fluid">
            <div class="container-fluid">
                <div class="container-fluid frame-overall">
                    <div class="container-fluid overall">
                        <div class="information d-flex flex-column gap-2">
                            <div class="name-of-place">{{ hotel.name }}</div>
                            <div class="rating-review d-flex gap-3 align-items-center ">
                                <div class="rating d-flex gap-1">
                                    <img v-for="(star, index) in generateStars(hotel.rating)" :key="index" 
                                         :src="star" alt="star" /> 
                                </div>
                                <span class="reviews">
                                    {{ hotel.review_count }} Reviews
                                </span>
                                <div class="frame-button d-flex gap-3 align-items-center">
                                    <button v-if="token && hotel.user_id == user?.id" 
                                            @click="navigateToUpdateDestination(hotel.id)" 
                                            class="write-review" >
                                        Update Place 
                                    </button>
                                    <button v-if="token && hotel.user_id == user?.id" 
                                            @click="navigateToUpdateHotel(hotel.id)" 
                                            class="write-review">
                                        Update Hotel Detail 
                                    </button>
                                </div>
                            </div>
                        </div>
                        <Carousel class="custom" :currentImage="currentImage" :images="computedImages"/>
                        <div class="info-hotel">
                            <div class="contact d-flex flex-column gap-5">
                                <div class="map">
                                    <Map :destinationID = "hotel.id"/>
                                </div>
                                <div class="location-phone">
                                    <div class="frame location">
                                        <i class="icon-location"></i>
                                        <p v-if="hotel.address">{{ hotel.address.street }}, {{ hotel.address.ward }}, {{ hotel.address.district }}, {{ city.name }}</p>
                                    </div>
                                    <div class="frame phone">
                                        <i class="icon-phone"></i>
                                        <p v-if="hotel.hotel.phone">{{ hotel.hotel.phone }}</p>
                                    </div>
                                    <div class="frame phone">
                                        <i class="icon-location"></i>
                                        <p v-if="hotel.hotel.website" class="text-truncate">
                                            <a :href="hotel.hotel.website" target="_blank" rel="noopener noreferrer">
                                                {{ hotel.hotel.website }}
                                            </a>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <div class="details">
                                <div class="hotel-detail d-flex flex-column gap-4 p-4">
                                    <h3 class="section-title" style="font-weight: 900;">Details</h3>
                                    <div class="details-grid">
                                        <div class="detail-item">
                                            <h5>PRICE RANGE</h5>
                                            <p v-if="hotel.price_bottom === 0 && hotel.price_top === 0">
                                                    0 VND
                                            </p>
                                            <p v-else-if="(hotel.price_bottom > 1000 || hotel.price_top > 1000) && (hotel.price_bottom % 100 === 0 || hotel.price_top % 100 === 0)">
                                                    {{ formatPrice(hotel.price_bottom) }} VND - {{ formatPrice(hotel.price_top) }} VND
                                            </p>
                                            <p v-else>
                                                    {{ formatPrice(hotel.price_bottom) }} USD - {{ formatPrice(hotel.price_top) }} USD
                                            </p>
                                        </div>
                                        <div class="detail-item">
                                            <h5>HOTEL PROPERTY AMENITIES </h5>
                                            <p>{{ hotel.hotel.property_amenities || "N/A" }}</p>
                                        </div>
                                        <div class="detail-item">
                                            <h5>HOTEL ROOM FEATURES</h5>
                                            <p>{{ hotel.hotel.room_features || "N/A" }}</p>
                                        </div>
                                        <div class="detail-item">
                                            <h5>HOTEL STYLES</h5>
                                            <p>{{ hotel.hotel.hotel_styles || "N/A" }}</p>
                                        </div>
                                    </div>
                                    <div class="detail-item full-width">
                                        <h5>ROOM TYPES</h5>
                                        <p>{{ hotel.hotel.room_types || "N/A" }}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <Contribute :rating="hotel.rating"
                                    :ratings="ratings"
                                    :commentList="commentList"
                                    :destination_id="hotel.id"
                                    :user="user?.id||0"
                                    :description="hotel.description"
                                    :canReview="canReview"
                                    :stars = "generateStars(hotel.rating)"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { useRoute } from 'vue-router';
import { ref, onMounted, watch, nextTick, computed } from 'vue';
import hotelViewModel from '../../viewModels/detailLocation_HotelViewModel.js';
import generateViewModel from '../../viewModels/generate_ratingViewModel';

// Lấy thông tin từ route
const route = useRoute();
const destinationID = route.params.id; // Lấy destinationID từ route params

// Destructure các giá trị từ destinationViewModel
const {
    commentList,
    images,
    currentImage,
    nextImage,
    prevImage,
    isDropdownVisible,
    toggleDropdown,
    isMenuVisible,
    toggleMenu,
    hotel,
    city,
    isLoading,
    user,
    token,
    ratings,
    canReview,
} = hotelViewModel(destinationID);

const {
    generateStars,
} = generateViewModel();

const navigateToUpdateDestination = (id) => {
    window.location.assign(`/Business/Destination/Update/${id}`);
};
const navigateToUpdateHotel = (id) => {
    window.location.assign(`/Business/Hotel/Update/${id}`);
};

const formatPrice = (value) => {
    return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

const computedImages = computed(() => {
    return images.value.length > 0 ? images.value : ['/blue-image.jpg'];
});
// Các hàm hoặc logic bổ sung có thể được thêm vào nếu cần
</script>

<script>
import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
import Top_Button from '../Top_Button.vue';
import Header from '../Header.vue';
import Carousel from '../Carousel.vue';
import Contribute from '../Contribute.vue';
import Map from '../Map/Map.vue';
export default {
    name: "Hotel",
    components: {
        Header, Scroll_Bar_Component, Top_Button, Carousel,
        Contribute, Map
    }
}

</script>

<style scoped>
.frame-overall {
    display: grid;
    grid-template-columns: 5% 90% 5%;
}
.overall {
    grid-column: 2/3;
}
.information{
    margin-top: 180px;
    margin-bottom: -160px;
    color: #13357B;
    font-size: 18px;
}
.name-of-place{
    font-size: 35px;
    font-weight: 900;
}
.rating img{
    width: 20px;
    height: 20px;
}
.write-review{
    color: #13357B;
    background: none;
    border: none;
    font-weight: 700;
    text-decoration: underline;
    transition: all 0.3s ease-in-out;
    cursor: pointer;
}
.write-review:hover{
    color: #729AE9;
}
:deep(.custom .carousel-control-next .carousel-control-next-icon) {
    margin-right: -8.4vw; /* Giá trị mới */
}
:deep(.custom .carousel-control-prev .carousel-control-prev-icon) {
    margin-left: -8.4vw; /* Giá trị mới */
}
.info-hotel {
    display: grid;
    margin-top: 2%;
    grid-template-columns: 30% 68%;
    gap: 2%;
}
.contact{
    padding: 20px;
    color: #13357B;
    border-radius: 20px;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
    margin-bottom: 50px;
}
.map{
    border-radius: 15px;
    height: fit-content;
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .1), 0 6px 18px -1px rgba(19, 53, 123, .08) !important;
}
.frame{
    display: grid;
    grid-template-columns: 5% 90%;
    gap:15px;
}
.icon-location::before {
  content: "📍";
}
.icon-phone::before {
  content: "📞";
}
.details-grid{
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
}
.detail-item {
    padding: 30px;
    font-size: 20px;
    border-radius: 15px;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
}
.detail-item h5 {
    font-weight: bolder;
    font-size: 16px;
}
.details {
    padding: 20px;
    color: #13357B;
    border-radius: 20px;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
    margin-bottom: 50px;
}
</style>

