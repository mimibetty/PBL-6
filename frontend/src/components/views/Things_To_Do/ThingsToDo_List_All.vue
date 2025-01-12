<template>
    <div class="container-fluid">
        <Header />
        <Top_Button />
    </div>

    <div class="container-fluid">
        <div class="container-fluid">
            <div class="container-fluid frame-overall">
                <div class="container-fluid overall">
                    <!-- Images -->
                    <div class="container-fluid frame-base-image">
                        <img src="@/assets/images/thingstodo_2.avif" alt="City 1" class="img-fluid">
                        <!-- Search -->
                        <div class="container-fluid search">
                            <div class="container">
                                <Form_Search :name_of_page="'Find Things to Do anywhere in Viet Nam'"
                                    :name="'Attraction, activities or destination'" />
                            </div>
                        </div>
                    </div>
                    <div v-if="loadingCities">
                        <div class="skeleton-loader" v-for="n in 10" :key="n"></div>
                    </div>

                    <div v-else class="container-fluid content d-flex gap-5">
                        <div class="title-content d-flex flex-column gap-4">
                            <p class="top-destinations">
                                Top destinations in Viet Nam
                            </p>
                            <div class="container-fluid context list-items">
                                <button @click="prevCity" class="carousel-control-prev" type="button">
                                    <span class="carousel-control-prev-icon"></span>
                                </button>

                                <Img_Card v-for="(city, index) in visibleCities" :key="index" :imageUrl="city.images[0]"
                                    :name="city.name" @click="navigateToThingsCity(city.id)" />

                                <button @click="nextCity" class="carousel-control-next" type="button">
                                    <span class="carousel-control-next-icon"></span>
                                </button>
                            </div>
                        </div>
                        <div v-if="loading">
                            <div class="skeleton-loader" v-for="n in 10" :key="n"></div>
                        </div>

                        <div v-if="!loading" class="title-content d-flex flex-column gap-4">
                            <p class="top-attractions">
                                Top attractions in Viet Nam
                            </p>
                            <div class="container-fluid context list-items-1">
                                <Card_Item v-for="(item, index) in paginatedList" :key="index" :destID="item.id"
                                    :imageUrl="item.images[0]?.url || '/blue-image.jpg'" :name="item.name"
                                    :stars="generateStars(item.rating)" :review-number="item.review_count"
                                    :tags="item.tag" @click="navigateToDetailPlace(item.id)" />
                            </div>
                            <!-- Pagination -->
                            <div class="pagination-container d-flex justify-content-center align-items-center mt-3">
                                <button class="btn-pagination prev" :disabled="currentPage === 1"
                                    @click="currentPage--">Previous</button>
                                <!-- Trang đầu -->
                                <button class="btn-pagination" :class="{ active: currentPage === 1 }"
                                    @click="currentPage = 1">
                                    1
                                </button>
                                <!-- Dấu ... trước trang hiện tại -->
                                <span class="dot" v-if="currentPage > 3">...</span>

                                <button v-for="page in pagesToShow" :key="page" class="btn-pagination"
                                    :class="{ active: page === currentPage }" @click="currentPage = page">
                                    {{ page }}
                                </button>

                                <!-- Dấu ... sau trang hiện tại -->
                                <span class="dot" v-if="currentPage < totalPages - 2">...</span>

                                <!-- Trang cuối -->
                                <button class="btn-pagination" :class="{ active: currentPage === totalPages }"
                                    @click="currentPage = totalPages">
                                    {{ totalPages }}
                                </button>
                                <button class="btn-pagination next" :disabled="currentPage === totalPages"
                                    @click="currentPage++">Next</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, watch, nextTick, computed } from 'vue';
import destinationViewModel from '../../viewModels/ThingToDo_ListViewModel';
import generateViewModel from '../../viewModels/generate_ratingViewModel';

const {
    isMenuVisible, toggleMenu,
    getImageUrl,
    liked, toggleLikeStatus,
    heartFull: heartFull, heartEmpty: heartEmpty,
    searchQuery,
    cities, visibleCities, prevCity, nextCity,
    attractions, visibleAttraction, prevAttraction, nextAttraction,
    loading,
    loadingCities, recommendations
} = destinationViewModel();

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
const navigateToThingsCity = (id) => {
    window.location.assign(`/ThingsToDo/${id}`);
};

const currentPage = ref(1);
const itemsPerPage = 12;

// Computed property to calculate paginated list
const paginatedList = computed(() => {
    const start = (currentPage.value - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    return attractions.value.slice(start, end);
});

// Tính tổng số trang
const totalPages = computed(() => {
    return Math.ceil(attractions.value.length / itemsPerPage);
});

// Tính danh sách các trang cần hiển thị
const pagesToShow = computed(() => {
    const pages = [];
    // Hiển thị các trang từ currentPage - 2 đến currentPage + 2
    for (let i = Math.max(2, currentPage.value - 1); i <= Math.min(totalPages.value - 1, currentPage.value + 1); i++) {
        pages.push(i);
    }
    return pages;
});

</script>

<script>
import Header from '../Header.vue';
import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
import Top_Button from '../Top_Button.vue';
import Form_Search from '../Form_Search.vue';
import Img_Card from '../Img_Card.vue';
import Card_Item from '../Card_Item.vue';
export default {
    name: "ThingsToDo_List",
    components: {
        Header, Scroll_Bar_Component, Top_Button, Form_Search,
        Img_Card, Card_Item,
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

.img-fluid {
    margin-top: 150px;
    width: 100vw;
    height: 600px;
    border-radius: 20px;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
}

.search {
    margin-top: -25%;
    margin-bottom: 15%;
}

.content {
    display: flex;
    flex-direction: column;
    color: #13357B;
    font-size: 28px;
    margin-top: 15px;
}

.content p {
    font-weight: 900;
    margin-top: 15px;
}

.list-items {
    position: relative;
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 30px;
    align-items: center;
    width: 95%;
    height: 100%;
}

.list-items-1 {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    /* 3 cột, mỗi cột có kích thước bằng nhau */
    gap: 40px;
    /* Khoảng cách giữa các phần tử */
    align-items: center;
    /* Căn giữa theo chiều dọc */
    justify-items: center;
    /* Căn giữa theo chiều ngang */
    width: 100%;
}

.carousel-control-prev,
.carousel-control-next {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    z-index: 10;
    background-color: #13357B;
    border-radius: 50%;
    width: 50px;
    height: 50px;
    cursor: pointer;
}

.carousel-control-prev-icon,
.carousel-control-next-icon {
    display: flex;
    width: 30px;
    height: 30px;
    align-items: center;
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
