<template>
    <!-- Header Section -->
    <div class="header-container">
        <Header />
        <Top_Button v-if="cityDetails" :cityID="cityDetails.id" />
    </div>

    <div v-if="loading">
        <div class="skeleton-loader" v-for="n in 10" :key="n"></div>
    </div>

    <div v-else class="container-fluid">
        <div class="container-fluid">
            <div class="container-fluid overall-frame">
                <div class="container-fluid frame">
                    <!-- Carousel Section -->
                    <Carousel class="custom" :currentImage="currentImage" :images="images" />
                    <div class="container">
                        <Search_Btn_Big class="search" />
                    </div>
                    <!-- Discover Info Section -->
                    <div class="container-fluid">
                        <div class="container-fluid">
                            <div class="container-fluid d-flex flex-column gap-5">
                                <div class="info-destination d-flex flex-column gap-2">
                                    <p class="title">Discover</p>
                                    <!-- Destination Name -->
                                    <div class="row">
                                        <div class="col-1"></div>
                                        <div class="col-11 name-of-desstination">{{ cityDetails?.name }}</div>
                                    </div>
                                    <!-- Description Section -->
                                    <div class="row">
                                        <div class="col-1"></div>
                                        <div class="col-11">
                                            <p class="description">
                                                {{ isReadMore ? fullDescription : getTruncatedDescription }}
                                            </p>
                                        </div>
                                    </div>
                                    <!-- Read More/ Less Button -->
                                    <div class="row">
                                        <div class="col-1"></div>
                                        <div class="col-11">
                                            <button class="read-more-or-less" @click="toggleReadMore">{{ isReadMore ?
                                                'Read less' : 'Read more' }}</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="catagory">
                                    <!-- Category Section -->
                                    <p class="characteristic">Characteristic of {{ cityDetails?.name }}</p>
                                    <p class="title-catagory">Select a category to filter suggestion</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Category Buttons & Content Section -->
                    <div class="container-fluid content">
                        <div class="container-fluid mx-2 frame-button">
                            <div class="list-button d-flex gap-3 justify-content-flex-start flex-wrap px-5 py-4">
                                <button class="button-category d-flex align-items-center justify-content-around gap-1"
                                    v-for="item in buttons" :key="item.id"
                                    :class="{ selected: selectedIndices.includes(item.id) }"
                                    @click="selectButton(item.id)">
                                    <img :src="svgIcons[item.id - 1]" alt="icon" class="icon">
                                    {{ item.name }}
                                </button>
                            </div>
                        </div>

                        <!-- Things to do Section -->
                        <div class="title-content">
                            <p class="p-5 things-to-do">Things to do</p>
                            <div class="container-fluid context">
                                <Cards v-for="(item, index) in paginatedListThingsTodo" :key="index" :destID="item.id"
                                    :imageUrl="item.images[0]?.url || '/blue-image.jpg'" :name="item.name"
                                    :stars="generateStars(item.rating)" :rating="item.rating" :tags="item.tag"
                                    @click="navigateToDetailPlace(item.id)" />
                            </div>
                            <!-- Pagination -->
                            <div class="pagination-container d-flex justify-content-center align-items-center mt-3">
                                <button class="btn-pagination prev" :disabled="currentPageThingsToDo === 1"
                                    @click="currentPageThingsToDo--">Previous</button>
                                <!-- Trang đầu -->
                                <button class="btn-pagination" :class="{ active: currentPageThingsToDo === 1 }"
                                    @click="currentPageThingsToDo = 1">
                                    1
                                </button>
                                <!-- Dấu ... trước trang hiện tại -->
                                <span class="dot" v-if="currentPageThingsToDo > 3">...</span>

                                <button v-for="page in pagesToShowThingsTodo" :key="page" class="btn-pagination"
                                    :class="{ active: page === currentPageThingsToDo }"
                                    @click="currentPageThingsToDo = page">
                                    {{ page }}
                                </button>

                                <!-- Dấu ... sau trang hiện tại -->
                                <span class="dot" v-if="currentPageThingsToDo < totalPagesThingstodo - 2">...</span>

                                <!-- Trang cuối -->
                                <button class="btn-pagination"
                                    :class="{ active: currentPageThingsToDo === totalPagesThingstodo }"
                                    @click="currentPageThingsToDo = totalPagesThingstodo">
                                    {{ totalPagesThingstodo }}
                                </button>
                                <button class="btn-pagination next" :disabled="currentPageThingsToDo === totalPages"
                                    @click="currentPageThingsToDo++">Next</button>
                            </div>
                        </div>

                        <!-- Restaurants Section -->
                        <div class="title-content">
                            <p class="p-5 restaurants">Restaurants</p>
                            <div class="container-fluid context">
                                <Cards v-for="(item, index) in paginatedListRestaurants" :key="index" :destID="item.id"
                                    :imageUrl="item.images[0]?.url || '/blue-image.jpg'" :name="item.name"
                                    :stars="generateStars(item.rating)" :rating="item.rating" :tags="item.tag"
                                    @click="navigateToDetailRestaurant(item.restaurant_id)" />
                            </div>
                            <!-- Pagination -->
                            <div class="pagination-container d-flex justify-content-center align-items-center mt-3">
                                <button class="btn-pagination prev" :disabled="currentPageRestaurants === 1"
                                    @click="currentPageRestaurants--">Previous</button>
                                <!-- Trang đầu -->
                                <button class="btn-pagination" :class="{ active: currentPageRestaurants === 1 }"
                                    @click="currentPageRestaurants = 1">
                                    1
                                </button>
                                <!-- Dấu ... trước trang hiện tại -->
                                <span class="dot" v-if="currentPageRestaurants > 3">...</span>

                                <button v-for="page in pagesToShowRestaurants" :key="page" class="btn-pagination"
                                    :class="{ active: page === currentPageRestaurants }"
                                    @click="currentPageRestaurants = page">
                                    {{ page }}
                                </button>

                                <!-- Dấu ... sau trang hiện tại -->
                                <span class="dot" v-if="currentPageRestaurants < totalPagesRestaurants - 2">...</span>

                                <!-- Trang cuối -->
                                <button class="btn-pagination"
                                    :class="{ active: currentPageRestaurants === totalPagesRestaurants }"
                                    @click="currentPageRestaurants = totalPagesRestaurants">
                                    {{ totalPagesRestaurants }}
                                </button>
                                <button class="btn-pagination next"
                                    :disabled="currentPageRestaurants === totalPagesRestaurants"
                                    @click="currentPageRestaurants++">Next</button>
                            </div>
                        </div>

                        <!-- Resort & Hotels Section -->
                        <div class="title-content">
                            <p class="p-5 resorts">Resort & Hotels</p>
                            <div class="container-fluid context">
                                <Cards v-for="(item, index) in paginatedListHotels" :key="index" :destID="item.id"
                                    :imageUrl="item.images[0]?.url || '/blue-image.jpg'" :name="item.name"
                                    :stars="generateStars(item.rating)" :rating="item.rating" :tags="item.tag"
                                    @click="navigateToDetailHotel(item.hotel_id)" />
                            </div>
                            <!-- Pagination -->
                            <div class="pagination-container d-flex justify-content-center align-items-center mt-3">
                                <button class="btn-pagination prev" :disabled="currentPageHotels === 1"
                                    @click="currentPageHotels--">Previous</button>
                                <!-- Trang đầu -->
                                <button class="btn-pagination" :class="{ active: currentPageHotels === 1 }"
                                    @click="currentPageHotels = 1">
                                    1
                                </button>
                                <!-- Dấu ... trước trang hiện tại -->
                                <span class="dot" v-if="currentPageHotels > 3">...</span>

                                <button v-for="page in pagesToShowHotels" :key="page" class="btn-pagination"
                                    :class="{ active: page === currentPageHotels }" @click="currentPageHotels = page">
                                    {{ page }}
                                </button>

                                <!-- Dấu ... sau trang hiện tại -->
                                <span class="dot" v-if="currentPageHotels < totalPagesHotels - 2">...</span>

                                <!-- Trang cuối -->
                                <button class="btn-pagination"
                                    :class="{ active: currentPageHotels === totalPagesHotels }"
                                    @click="currentPageHotels = totalPagesHotels">
                                    {{ totalPagesHotels }}
                                </button>
                                <button class="btn-pagination next" :disabled="currentPageHotels === totalPagesHotels"
                                    @click="currentPageHotels++">Next</button>
                            </div>
                        </div>

                        <!-- Recommedations -->
                        <div v-if="user" class="title-content">
                            <p class="p-5 resorts">Recommedations</p>
                            <div class="container-fluid">
                                <Recomment_Destination :destinations="recommendations" :generate-stars="generateStars"
                                    :cities="cities" />
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
import destinationViewModel from '../../viewModels/destinationViewModel.js';
import generate_ratingViewModel from '@/components/viewModels/generate_ratingViewModel.js';
import TagViewModel from '../../viewModels/Tag_ViewModel/TagViewModel';
import { useRoute } from 'vue-router';

// Khởi tạo ViewModels
const tagViewModel = new TagViewModel();
const svgIcons = tagViewModel.getSvgIcons();

// Route Params
const route = useRoute();
const cityId = route.params.id;

// ViewModel Import & Initialization
const {
    fetchCityDetailsData,
    fetchTags,
    fetchDestinationsData,
    isMenuVisible,
    toggleMenu,
    currentImage,
    isHeartFilled,
    toggleHeart,
    getTruncatedDescription,
    toggleReadMore,
    isReadMore,
    fullDescription,
    buttons,
    selectedIndices,
    selectButton,
    images,
    liked,
    toggleLikeStatus,
    cityDetails,
    isLoading,
    destinations,
    hotels,
    restaurants,
    isDestinationsLoading,
    isHotelsLoading,
    isRestaurantsLoading,
    fetchAllData,
    user, token, loadUser, recommendations, cities, loadCities, getRecommendationsByCity,
} = destinationViewModel(cityId);


const loading = ref(true);

// Lifecycle Hook to Fetch Data on Mount
onMounted(async () => {
    await fetchCityDetailsData();
    await fetchDestinationsData();
    await fetchTags();
    await loadUser();
    await loadCities();
    loading.value = false;
});

watch(selectedIndices, async () => {
    await fetchDestinationsData();
});

// Rating Generation Function
const { generateStars } = generate_ratingViewModel();

const currentPageThingsToDo = ref(1);
const currentPageRestaurants = ref(1);
const currentPageHotels = ref(1);
const itemsPerPage = 9;

// Pagination For Things To Do
// Computed property to calculate paginated list
const paginatedListThingsTodo = computed(() => {
    const start = (currentPageThingsToDo.value - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    return destinations.value.slice(start, end);
});

// Tính tổng số trang
const totalPagesThingstodo = computed(() => {
    return Math.ceil(destinations.value.length / itemsPerPage);
});

// Tính danh sách các trang cần hiển thị
const pagesToShowThingsTodo = computed(() => {
    const pages = [];
    // Hiển thị các trang từ currentPage - 2 đến currentPage + 2
    for (let i = Math.max(2, currentPageThingsToDo.value - 1); i <= Math.min(totalPagesThingstodo.value - 1, currentPageThingsToDo.value + 1); i++) {
        pages.push(i);
    }
    return pages;
});

// Pagination For Restaurants
// Computed property to calculate paginated list
const paginatedListRestaurants = computed(() => {
    const start = (currentPageRestaurants.value - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    return restaurants.value.slice(start, end);
});

// Tính tổng số trang
const totalPagesRestaurants = computed(() => {
    return Math.ceil(restaurants.value.length / itemsPerPage);
});

// Tính danh sách các trang cần hiển thị
const pagesToShowRestaurants = computed(() => {
    const pages = [];
    // Hiển thị các trang từ currentPageRestaurants - 2 đến currentPageRestaurants + 2
    for (let i = Math.max(2, currentPageRestaurants.value - 1); i <= Math.min(pagesToShowRestaurants.value - 1, currentPageRestaurants.value + 1); i++) {
        pages.push(i);
    }
    return pages;
});
// Pagination For Hotels
// Computed property to calculate paginated list
const paginatedListHotels = computed(() => {
    const start = (currentPageHotels.value - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    return hotels.value.slice(start, end);
});

// Tính tổng số trang
const totalPagesHotels = computed(() => {
    return Math.ceil(hotels.value.length / itemsPerPage);
});

// Tính danh sách các trang cần hiển thị
const pagesToShowHotels = computed(() => {
    const pages = [];
    // Hiển thị các trang từ currentPageHotels - 2 đến currentPageHotels + 2
    for (let i = Math.max(2, currentPageHotels.value - 1); i <= Math.min(pagesToShowHotels.value - 1, currentPageHotels.value + 1); i++) {
        pages.push(i);
    }
    return pages;
});

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
import Search_Btn_Big from '../Search_Btn_Big.vue';
import Recomment_Destination from '../Recomment_Destination.vue';

export default {
    name: "Destination_View",
    components: {
        Header, Scroll_Bar_Component, Top_Button,
        Search_Btn_Big, Cards, Carousel, Recomment_Destination,
    }
}
</script>

<style scoped>
.overall-frame {
    display: grid;
    grid-template-columns: 5% 90% 5%;
}

.frame {
    grid-column: 2/3;
    place-items: center;
}

:deep(.search .position-relative) {
    padding: 1rem;
    background-color: #13357B;
}

.search {
    position: relative;
    top: -63px;
    width: 80%;
    display: flex;
    justify-content: center;
    align-items: center;
}

.info-destination {
    display: flex;
    justify-content: center;
    color: #13357B;
}

.title {
    font-size: 30px;
    font-weight: 900;
}

.name-of-desstination {
    font-size: 50px;
    font-weight: 700;
}

.read-more-or-less {
    color: #13357B;
    background: none;
    border: none;
    margin-left: -0.5%;
    font-size: 18px;
    font-weight: 700;
    appearance: none;
    text-decoration: underline;
    transition: all 0.3s ease-in-out;
}

.read-more-or-less:hover {
    color: #729AE9;
}

.characteristic {
    color: #13357B;
    font-size: 30px;
    font-weight: 900;
}

.title-catagory {
    color: #13357B;
    font-size: 20px;
}

.title-content p {
    color: #13357B;
    font-size: 48px;
    font-weight: 900;
}

.context {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    align-items: center;
    place-items: center;
    width: 100%;
    height: 100%;
    gap: 30px;
}

.frame-button {
    display: grid;
    grid-template-columns: 5% 90% 5%;
}

.list-button {
    grid-column: 2/3;
}

.button-category {
    color: #13357B;
    width: fit-content;
    padding: 10px 15px;
    border: 1px solid #13357B;
    border-radius: 40px;
    cursor: pointer;
    background-color: #EDF6F9;
    transition: background-color 0.3s ease;
}

.icon {
    width: 20px;
    height: 20px;
    color: #13357B !important;
}

.button-category:hover {
    background-color: #CAF0F8;
}

.button-category.selected {
    background-color: #48cae4;
}

.content {
    margin-bottom: 30px;
}

:deep(.custom .carousel-control-next .carousel-control-next-icon) {
    margin-right: -8.5vw;
    /* Giá trị mới */
}

:deep(.custom .carousel-control-prev .carousel-control-prev-icon) {
    margin-left: -8.5vw;
    /* Giá trị mới */
}

.skeleton-loader {
    height: 200px;
    margin: 10px;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: skeleton-loading 1.5s infinite;
}

@keyframes skeleton-loading {
    from {
        background-position: 200% 0;
    }

    to {
        background-position: -200% 0;
    }
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

.pagination-container {
    gap: 10px;
    margin-bottom: 50px;
}

.btn-pagination {
    font-size: 18px;
    padding: 8px 16px;
    border: 1px solid #4AA4D9;
    background-color: #EDF6F9;
    color: #13357B;
    cursor: pointer;
    border-radius: 5px;
    transition: all 0.3s;
}

.btn-pagination:hover {
    background-color: #4AA4D9;
    color: #EDF6F9;
}

.btn-pagination:disabled {
    background-color: #CAF0F8;
    cursor: not-allowed;
}

.btn-pagination.active {
    background-color: #4AA4D9;
    color: #EDF6F9;
    font-weight: bold;
}

.prev,
.next {
    min-width: 85px;
}

.dot {
    color: #13357B;
}
</style>