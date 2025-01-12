<template>
    <!-- Header Section -->
    <div class="header-container">
        <header_For_company/>
    </div>

    <div class="container-fluid">
        <div class="container-fluid">
            <div class="container-fluid">
                <div class="container-fluid">
                    
                    <!-- Category Buttons & Content Section -->
                    <div class="container-fluid content">
                        <!-- Things to do Section -->
                        <div class="title-content">
                            <p class="p-5 things-to-do">Things to do</p>
                            <div class="container-fluid context">
                                <Cards v-for="(item, index) in destinations"
                                        :key="index"
                                        :destID="item.id"
                                        :imageUrl="item.images[0]?.url || '/blue-image.jpg'"
                                        :name="item.name"
                                        :stars="generateStars(item.rating)"
                                        :rating="item.rating"
                                        :tags="item.tag"
                                        @click="navigateToDetailPlace(item.id)"/>
                            </div>
                        </div>

                        <!-- Restaurants Section -->
                        <div class="row title-content">
                            <p class="p-5 restaurants">Restaurants</p>
                            <div class="container-fluid context">
                                <Cards v-for="(item, index) in restaurants"
                                        :key="index"
                                        :destID="item.id"
                                        :imageUrl="item.images[0]?.url || '/blue-image.jpg'"
                                        :name="item.name"
                                        :stars="generateStars(item.rating)"
                                        :rating="item.rating"
                                        :tags="item.tag"
                                        @click="navigateToDetailRestaurant(item.restaurant_id)"/>
                            </div>
                        </div>

                        <!-- Resort & Hotels Section -->
                        <div class="row title-content">
                            <p class="p-5 resorts">Resort & Hotels</p>
                            <div class="container-fluid context">
                                <Cards v-for="(item, index) in hotels"
                                        :key="index"
                                        :destID="item.id"
                                        :imageUrl="item.images[0]?.url || '/blue-image.jpg'"
                                        :name="item.name"
                                        :stars="generateStars(item.rating)"
                                        :rating="item.rating"
                                        :tags="item.tag"
                                        @click="navigateToDetailHotel(item.hotel_id)"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
    import { ref, computed, onMounted, watch } from 'vue';
    import Business_View_DestinationViewModel from '@/components/viewModels/Business_View_DestinationViewModel';
    import generate_ratingViewModel from '@/components/viewModels/generate_ratingViewModel.js';

    // ViewModel Import & Initialization
    const {
        destinations,
        hotels,
        restaurants,
    } = Business_View_DestinationViewModel();

    // Rating Generation Function
    const { generateStars } = generate_ratingViewModel();

    // Navigation Functions
    const navigateToDetailPlace = (id) => window.location.assign(`/Detail/Place/${id}`);
    const navigateToDetailRestaurant = (restaurant_id) => window.location.assign(`/Detail/Restaurant/${restaurant_id}`);
    const navigateToDetailHotel = (hotel_id) => window.location.assign(`/Detail/Hotel/${hotel_id}`);
</script>

<script>
    import Header from '../Header.vue';
    import Scroll_Bar_Component from '../Scroll_Bar_Component.vue'; 
    import Top_Button from '../Top_Button.vue';
    
    import Cards from './Cards.vue';
    import Carousel from '../Carousel.vue';
    import header_For_company from '../Dashboard_For_Company/header_For_company.vue';

    export default {
        name: "Destination_View",
        components: {
            Header, Scroll_Bar_Component, Top_Button,
            Cards, Carousel, header_For_company,
        }
    }
</script>

<style scoped>
*,*::before,*::after{
    box-sizing: border-box;
}
body{
    background-color: #EDF6F9;
    justify-content: center; /* Căn giữa theo chiều ngang */
    align-items: center; /* Căn giữa theo chiều dọc */
}
.header-container {
    display: flex;
    flex-direction: column; /* Sắp xếp theo chiều dọc */
    z-index: 1;
    width: 100%;
}


.context {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    align-items: center;
    width: 100%;
    height: 100%;
    gap:30px;
}
.swiper {
    width: 100%;
    max-width: 1450px; /* Set a max-width to ensure enough space for 3 slides */
}

.swiper-slide {
    color: #13357B;
    background-color: #EDF6F9;
    text-align: center;
    margin: 20px 0; 
}

.button-category{
    color: #13357B;
    width: 80%;
    padding: 8px 16px;
    border: 1px solid #13357B;
    border-radius: 40px;
    cursor: pointer;
    background-color: #EDF6F9;
    transition: background-color 0.3s ease;
}

.button-category:hover {
    background-color: #0077b6;
    color: #EDF6F9 
}     
.button-category.selected {
    background-color: #13357B;
    color: #EDF6F9;
}
.content {
    margin-bottom: 30px;
    margin-top: 200px;
}
:deep(.custom .carousel-control-next .carousel-control-next-icon) {
    margin-right: -10vw; /* Giá trị mới */
}
:deep(.custom .carousel-control-prev .carousel-control-prev-icon) {
    margin-left: -10vw; /* Giá trị mới */
}
</style>

<style>
.swiper .swiper-scrollbar {
    background-color: #EDF6F9 !important;
    border: 1px solid #13357B !important;
    height: 8px !important;
}

.swiper .swiper-scrollbar-drag {
    background-color: #13357B !important;
}
</style>