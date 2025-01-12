<template>
    <div class="container-fluid">
        <Header/>
        <Top_Button v-if="destination" :cityID="destination.address.city_id"/>
    </div> 

    <div class="container-fluid">
        <div class="container-fluid">
            <div class="container-fluid frame-overall">
                <div class="container-fluid overall">
                    <div class="container-fluid info-place">
                        <div class="container-fluid top-info" v-if="isLoading">
                            <div class="information">
                                <div class="container name-of-place">{{ destination.name }}</div>
                                <div class="container rating-review">
                                    <div class="rating">
                                        <div v-for="(star, index) in generateStars(destination.rating)" :key="index" class="circle">
                                            <img :src="star" alt="Circle" /> 
                                        </div>
                                    </div>
                                    <div class="reviews">
                                        {{ destination.review_count }} Reviews
                                    </div>
                                </div>

                                <div class="button">
                                    <button v-if="token && destination.user_id === user?.id" 
                                            @click="navigateToUpdateDestination(destination.id)" 
                                            class="write-review" >
                                        Update Place 
                                    </button>
                                    <button v-if="token && destination.user_id == user?.id" 
                                            @click="navigateToCreateHotel(destination.id)" 
                                            class="write-review" >
                                        Create Hotel 
                                    </button>
                                    <button v-if="token && destination.user_id == user?.id" 
                                            @click="navigateToCreateRestaurant(destination.id)" 
                                            class="write-review" >
                                        Create Restaurant 
                                    </button>
                                </div>
                                
                                <div class="container-fluid info-about">
                                    <div class="row context">
                                        <h1 class="">About</h1>
                                        
                                        <p>{{ truncatedDescription}}</p>
                                        
                                        <button class="read-more-or-less" @click="toggleReadMore">{{ isReadMore ? 'Read less' : 'Read more' }}</button>
                                        
                                        <div class="duration">
                                            <div class="svg">
                                                <svg fill="#13357B" width="25px" height="25px" viewBox="0 0 24 24" id="Outline" xmlns="http://www.w3.org/2000/svg"><title>194 restore</title>
                                                    <path d="M12,6a1,1,0,0,0-1,1v5a1,1,0,0,0,.293.707l3,3a1,1,0,0,0,1.414-1.414L13,11.586V7A1,1,0,0,0,12,6Z
                                                    M23.812,10.132A12,12,0,0,0,3.578,3.415V1a1,1,0,0,0-2,0V5a2,2,0,0,0,2,2h4a1,1,0,0,0,0-2H4.827a9.99,9.99,0,1,1-2.835,7.878A.982.982,0,0,0,1,12a1.007,1.007,0,0,0-1,1.1,12,12,0,1,0,23.808-2.969Z"/>
                                                </svg>
                                            </div>
                                            <div class="duration-info">
                                                Duration: {{ destination.duration }} days
                                            </div>
                                        </div>

                                        <div class="container-fluid line-divide"></div>

                                        <div class="container-fluid price" style="font-size: 25px;">
                                            <p style="font-weight: 700;">Price from: 
                                                <span v-if="destination.price_bottom === 0 && destination.price_top === 0">
                                                    0 VND
                                                </span>
                                                <span v-else-if="(destination.price_bottom > 1000 || destination.price_top > 1000) && (destination.price_bottom % 100 === 0 || destination.price_top % 100 === 0)">
                                                    {{ formatPrice(destination.price_bottom) }} VND - {{ formatPrice(destination.price_top) }} VND
                                                </span>
                                                <span v-else>
                                                    {{ formatPrice(destination.price_bottom) }} USD - {{ formatPrice(destination.price_top) }} USD
                                                </span>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <Carousel class="custom" :currentImage="currentImage" :images="images"/>
                        </div>
                        <div class="container-fluid contribute">
                            <Contribute :rating="destination.rating"
                                        :ratings="ratings || {}"
                                        :commentList="commentList"
                                        :destination_id="destination.id"
                                        :user="user?.id||0"
                                        :canReview="canReview"
                                        :stars = "generateStars(destination.rating)"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
  import { useRoute } from 'vue-router';
  import { ref, onMounted, watch, nextTick } from 'vue';
  import destinationViewModel from '../../viewModels/detailLocation_AttractionViewModel.js';
  import generateViewModel from '../../viewModels/generate_ratingViewModel';

  // Lấy thông tin từ route
  const route = useRoute();
  const destinationID = route.params.id; // Lấy destinationID từ route params

  // Destructure các giá trị từ destinationViewModel
  const {
    images,
    currentImage,
    commentList,
    nextImage,
    prevImage,
    isDropdownVisible,
    toggleDropdown,
    isMenuVisible,
    toggleMenu,
    truncatedDescription,
    toggleReadMore,
    isReadMore,
    destination,
    isLoading,
    user,
    token,
    ratings,
    canReview,
  } = destinationViewModel(destinationID);

  const {
    generateStars,
  } = generateViewModel();

  const navigateToUpdateDestination = (id) => {
  window.location.assign(`/Business/Destination/Update/${id}`);
};
const navigateToCreateHotel = (id) => {
  window.location.assign(`/Business/Hotel/Add/${id}`);
};
const navigateToCreateRestaurant = (id) => {
  window.location.assign(`/Business/Restaurant/Add/${id}`);
};

const formatPrice = (value) => {
    return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

  // Các hàm hoặc logic bổ sung có thể được thêm vào nếu cần
</script>

<script>
import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
import Top_Button from '../Top_Button.vue';
import Header from '../Header.vue';
import Carousel from '../Carousel.vue';
import Contribute from '../Contribute.vue';
import { onMounted } from 'vue';
export default {
    name: "Place",
    components: {
        Header, Scroll_Bar_Component, Top_Button, Carousel,
        Contribute,
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
.top-info {
    display: grid;
    grid-template-columns: 35% 60%;
    gap: 8%;
    margin-top: 150px;
}
.information{
    color: #13357B;
}
.name-of-place{
    font-size: 35px;
    font-weight: 900;
}
.rating-review{
    display: flex;
    gap: 20px;
    justify-content: left;
    align-items: baseline;
    margin: 20px 0;
}
.rating {
    display: flex;
    gap: 3px;
}
.rating img{
    width: 20px;
    height: 20px;
}
.info-about{
    margin-top: 50px;
    margin-left: 10px;
    font-size: 17px;
    text-align: justify;
    padding: 20px;
    border-radius: 15px;
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .3), 0 6px 18px -1px rgba(19, 53, 123, .04) !important;
}
.context{
    display: flex;
    flex-direction: column;
    gap: 18px;
}
.context h1{
    font-weight: 900
}
.read-more-or-less{
    color: #13357B;
    background: none;
    border: none;
    font-size: 18px;
    font-weight: 700;
    appearance: none;
    margin: 15px 0 0 5px;
    text-decoration: underline;
    transition: all 0.3s ease-in-out;
    text-align: left;
}
.read-more-or-less:hover{
    color: #729AE9;
}
:deep(.custom .carousel-control-next .carousel-control-next-icon) {
    margin-right: -3.2vw; /* Giá trị mới */
}
:deep(.custom .carousel-control-prev .carousel-control-prev-icon) {
    margin-left: -3.2vw; /* Giá trị mới */
}
:deep(.custom .carousel-header){
    margin-top: 0px;
}
.duration{
    display: flex;
    align-items: center;
    gap: 20px;
}
.line-divide{
    width: 95%;
    height: 3px;
    border-radius: 5px;
    background-color: #13357B;
}
.write-review{
    color: #13357B;
    background: none;
    border: none;
    font-size: 18px;
    font-weight: 700;
    appearance: none;
    margin: 15px 0 0 5px;
    text-decoration: underline;
    transition: all 0.3s ease-in-out;
    text-align: left;
    z-index: 10;
    position: relative;
}
.write-review:hover{
    color: #729AE9;
}
</style>

