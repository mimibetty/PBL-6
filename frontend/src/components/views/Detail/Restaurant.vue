<template>
    <div class="container-fluid">
        <Header/>
        <Top_Button v-if="restaurant" :cityID="restaurant.address.city_id"/>
    </div> 
    <div class="container-fluid">
        <div class="container-fluid">
            <div class="container-fluid">
                <div class="container-fluid frame-overall">
                    <div class="container-fluid overall">
                        <div class="information d-flex flex-column gap-2">
                            <div class="name-of-place">{{ restaurant.name }}</div>
                            <div class="rating-review d-flex gap-3 align-items-center ">
                                <div class="rating d-flex gap-1">
                                    <img v-for="(star, index) in generateStars(restaurant.rating)" :key="index" 
                                         :src="star" alt="star" /> 
                                </div>
                                <span class="reviews">
                                    {{ restaurant.review_count }} Reviews
                                </span>
                                <div class="frame-button d-flex gap-3 align-items-center">
                                    <button v-if="token && restaurant.user_id == user?.id" 
                                            @click="navigateToUpdateDestination(restaurant.id)" 
                                            class="write-review" >
                                        Update Place 
                                    </button>
                                    <button v-if="token && restaurant.user_id == user?.id" 
                                            @click="navigateToUpdateRestaurant(restaurant.id)" 
                                            class="write-review">
                                        Update Restaurant Detail 
                                    </button>
                                </div>
                            </div>
                        </div>
                        <Carousel class="custom" :currentImage="currentImage" :images="computedImages"/>
                        <div class="info-hotel">
                            <div class="contact d-flex flex-column gap-5">
                                <div class="map">
                                    <Map :destinationID = "restaurant.id"/>  
                                </div>
                                <div class="location-phone">
                                    <div class="frame location">
                                        <i class="icon-location"></i>
                                        <p v-if="restaurant.address">{{ restaurant.address.street }}, {{ restaurant.address.ward }}, {{ restaurant.address.district }}, {{ city.name }}</p>
                                    </div>
                                    <div class="frame phone">
                                        <i class="icon-phone"></i>
                                        <!-- <p v-if="hotel.hotel.phone">{{ hotel.hotel.phone }}</p> -->
                                    </div>
                                </div>
                            </div>
                            <div class="details">
                                <div class="hotel-detail d-flex flex-column gap-4 p-4">
                                    <h3 class="section-title" style="font-weight: 900;">Details</h3>
                                    <div class="details-grid">
                                        <div class="detail-item">
                                            <h5>PRICE RANGE</h5>
                                            <p v-if="restaurant.price_bottom === 0 && restaurant.price_top === 0">
                                                    0 VND
                                            </p>
                                            <p v-else-if="(restaurant.price_bottom > 1000 || restaurant.price_top > 1000) && (restaurant.price_bottom % 100 === 0 || restaurant.price_top % 100 === 0)">
                                                    {{ formatPrice(restaurant.price_bottom) }} VND - {{ formatPrice(restaurant.price_top) }} VND
                                            </p>
                                            <p v-else>
                                                    {{ formatPrice(restaurant.price_bottom) }} USD - {{ formatPrice(restaurant.price_top) }} USD
                                            </p>
                                        </div>
                                        <div class="detail-item">
                                            <h5>SPECIAL DIETS</h5>
                                            <p>{{ restaurant.restaurant.special_diet || "N/A" }}</p>
                                        </div>
                                        <div class="detail-item">
                                            <h5>CUISINES</h5>
                                            <p>{{ restaurant.restaurant.cuisine || "N/A" }}</p>
                                        </div>
                                        <div class="detail-item">
                                            <h5>MEALS</h5>
                                            <p>{{ restaurant.restaurant.meal || "N/A" }}</p>
                                        </div>
                                    </div>
                                    <div class="detail-item full-width">
                                        <h5>FEATURES</h5>
                                        <p>{{ restaurant.restaurant.feature || "N/A" }}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <Contribute :rating="restaurant.rating"
                                    :ratings="ratings"
                                    :commentList="commentList"
                                    :destination_id="restaurant.id"
                                    :user="user?.id||0"
                                    :description="restaurant.description"
                                    :canReview="canReview"
                                    :stars = "generateStars(restaurant.rating)"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { useRoute } from 'vue-router';
import { ref, onMounted, watch, nextTick, computed } from 'vue';
import restaurantViewModel from '../../viewModels/detailLocation_RestaurantViewModel.js';
import generateViewModel from '../../viewModels/generate_ratingViewModel';
// import {  }

// Lấy thông tin từ route
const route = useRoute();
const restaurantID = route.params.id; // Lấy destinationID từ route params

// const {
//     getMapbyID,
// } = getMapbyID(destinationID);

// Destructure các giá trị từ destinationViewModel
const {
    commentList,
    images,
    token,
    currentImage,
    nextImage,
    prevImage,
    isDropdownVisible,
    toggleDropdown,
    isMenuVisible,
    toggleMenu,
    restaurant,
    city,
    isLoading,
    user,
    ratings,
    canReview,
} = restaurantViewModel(restaurantID);

const {
    generateStars,
} = generateViewModel();

onMounted( async() => {
    await fetchRatingDistribution(restaurant.id);
    // console.log("Hello",restaurant.id);
});

const navigateToUpdateDestination = (id) => {
    window.location.assign(`/Business/Destination/Update/${id}`);
};
const navigateToUpdateRestaurant = (id) => {
    window.location.assign(`/Business/Restaurant/Update/${id}`);
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
    name: "Restaurant",
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
    height: fit-content;
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .1), 0 6px 18px -1px rgba(19, 53, 123, .08) !important;
    border-radius: 15px;
}
.frame{
    display: flex;
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

