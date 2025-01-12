<template>
    <div class="container-fluid">
        <Header />
        <Top_Button v-if="cityId" :cityID="parseInt(cityId, 10)" />
    </div>

    <div class="contaner-fluid-1">
        <div class="contaner-fluid frame-overall">
            <div class="contaner-fluid overall">
                <div class="contaner-fluid frame-1 d-flex flex-column gap-5">
                    <!-- Images -->
                    <div v-if="loading">
                        <div class="skeleton-loader" v-for="n in 10" :key="n"></div>
                    </div>
                    <div v-else class="overall1">
                        <div class="image-container">
                            <div class="base"></div>
                            <img :src="city?.images?.[0]?.url || '/blue-image.jpg'" alt="City 1" class="img-fluid">
                        </div>
                        <div class="overall-container p-5">
                            <div class="text-container p-5 d-flex flex-column">
                                <h1>Things to do in {{ city?.name || 'Loading...' }}</h1>
                                <p>Check out must-see sights and activities:</p>
                            </div>
                        </div>
                    </div>
                    <div class="container-fluid d-flex flex-column gap-5 ">
                        <div v-if="loading">
                            <div class="skeleton-loader" v-for="n in 10" :key="n"></div>
                        </div>
                        <div v-else class="container-fluid mx-2 frame-button">
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
                        <div v-if="loadingDestinations">
                            <div class="skeleton-loader" v-for="n in 10" :key="n"></div>
                        </div>
                        <div v-if="!loadingDestinations" class=" title-content">
                            <p class="title p-5">Top Attraction in {{ city?.name || 'Loading...' }}</p>
                            <div class="container-fluid list-items-1">
                                <Info_Card v-for="(item, index) in paginatedListHotels" :key="index" :destID="item.id"
                                    :imageUrl="item.images[0]?.url || '/blue-image.jpg'" :name="item.name"
                                    :stars="generateStars(item.rating)" :review-number="item.review_count"
                                    :tags="item.tag" :description="item.description"
                                    @click="navigateToDetailPlace(item.id)" />
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
                        <div v-if="!loadingDestinations && user" class=" title-content">
                            <p class="title p-5">Recommedations in {{ city?.name || 'Loading...' }}</p>
                            <div class="container-fluid">
                                <Recomment_Destination :destinations="recommendations" :generateStars="generateStars"
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
import destinationViewModel from '../../viewModels/ThingToDo_City_ListViewModel';
import generateViewModel from '../../viewModels/generate_ratingViewModel';
import { ref, computed, onMounted, watch } from 'vue';
import { useRoute } from 'vue-router';
import { Swiper, SwiperSlide } from 'swiper/vue';
import { Navigation, Pagination, Scrollbar, A11y } from 'swiper/modules';
import TagViewModel from '../../viewModels/Tag_ViewModel/TagViewModel';

import 'swiper/css';
import 'swiper/css/navigation';
import 'swiper/css/pagination';
import 'swiper/css/scrollbar';

const modules = [Navigation, Pagination, Scrollbar, A11y];

const route = useRoute();
const cityId = route.params.id; // Lấy cityId từ route params
const tagViewModel = new TagViewModel();
const svgIcons = tagViewModel.getSvgIcons();

const {
    isMenuVisible,
    toggleMenu,
    fetchCityDetailsData,
    fetchTags,
    fetchDestinationsData,
    buttons,
    selectedIndices,
    selectButton,

    destinations,
    filteredDestinations,
    city,
    liked,
    toggleLikeStatus,
    heartFull,
    heartEmpty,
    truncatedDescription,
    user, token, loadUser, recommendations, cities, loadCities, getRecommendationsByCity,
} = destinationViewModel(cityId);

const loading = ref(true);
const loadingDestinations = ref(true);

onMounted(async () => {
    await fetchCityDetailsData();
    await fetchTags();
    loading.value = false;
    await fetchDestinationsData();
    await loadUser();
    await loadCities();
    loadingDestinations.value = false;
});

const {
    circles,
    rating,
    ratings,
    generateCircle,
    generateStars,
    totalRating,
} = generateViewModel();
const navigateToDetailPlace = (id) => {
    window.location.assign(`/Detail/Place/${id}`);
};
const currentPageHotels = ref(1);
const itemsPerPage = 9;

// Pagination For Things To Do
// Computed property to calculate paginated list
const paginatedListHotels = computed(() => {
    const start = (currentPageHotels.value - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    return filteredDestinations.value.slice(start, end);
});

// Tính tổng số trang
const totalPagesHotels = computed(() => {
    return Math.ceil(filteredDestinations.value.length / itemsPerPage);
});

// Tính danh sách các trang cần hiển thị
const pagesToShowHotels = computed(() => {
    const pages = [];
    // Hiển thị các trang từ currentPage - 2 đến currentPage + 2
    for (let i = Math.max(2, currentPageHotels.value - 1); i <= Math.min(totalPagesHotels.value - 1, currentPageHotels.value + 1); i++) {
        pages.push(i);
    }
    return pages;
});
</script>

<script>
import Header from '../Header.vue';
import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
import Top_Button from '../Top_Button.vue';
import Info_Card from './Info_Card.vue';
import Btn_Catagory from './Btn_Catagory.vue';
import Recomment_Destination from '../Recomment_Destination.vue';
export default {
    name: "ThingsToDo_List",
    components: {
        Header, Scroll_Bar_Component,
        Top_Button, Info_Card, Btn_Catagory, Recomment_Destination
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

.container-fluid-1 {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 100vw;
    min-height: 100vh;
    margin: 0;
    padding: 0;
    overflow: hidden;
}

.overall1 {
    display: flex;
    margin-top: 200px;
    color: #13357B;
}

.image-container {
    display: flex;
}

.base {
    margin: 0 0 0 90px;
    min-width: 38vw;
    min-height: 38vw;
    background-color: #D5DEF7;
}

.img-fluid {
    position: absolute;
    margin: 25px 0 0 115px;
    width: 40vw;
    padding: 0px;
    height: 38vw;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
}

.text-container {
    gap: 50px;
    font-size: 2vw;
}

.text-container h1 {
    font-size: 3.5vw;
    font-weight: 900;
}

.title-content p {
    color: #13357B;
    font-size: 45px;
    font-weight: 900;
}

.list-items-1 {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 30px;
    align-items: center;
    width: 80vw;
    height: 100%;
    margin-bottom: 50px;
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

.pagination-container {
    gap: 10px;
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

<style>
.swiper .swiper-scrollbar {
    background-color: #EDF6F9 !important;
    border: 1px solid #13357B !important;
    height: 6px !important;
}

.swiper .swiper-scrollbar-drag {
    background-color: #13357B !important;
}
</style>
