<template>
    <div class="container-fluid">
      <Header />
      <Top_Button v-if="cityId" :cityID="parseInt(cityId, 10)"/>
    </div>
  
    <div class="container-fluid">
      <div class="container-fluid">
        <div class="container-fluid frame-overall">
          <div class="container-fluid overall">
            <div class="container-fluid frame-image-search">
              <img src="@/assets/images/tms-hotel-da-nang-beach.jpg" alt="City 1" class="img-fluid" />
              <div class="container-fluid search">
                <div class="container">
                  <Form_Search :name_of_page="'Find your perfect place to stay'" :name="'Attraction, activities or destination'" />
                </div>
              </div>
            </div>
            <div class="content">
              <div class="frame-flter">
                <div class="container left-panel">
                  <div class="filter-section">
                    <!-- Cuisine Filter -->
                    <div
                      class="filter-item"
                      @click="toggleOptions('amenities')"
                      :class="{ active: activeOptions.amenities }"
                    >
                      Amenities
                      <div class="icon"></div>
                    </div>
                    <div v-if="activeOptions.amenities" class="options">
                      <div v-for="option in amenities_options" :key="option" class="option">
                        <input
                          type="checkbox"
                          :id="`amenities-${option}`"
                          :checked="save_option_amenities.includes(option)"
                          @change="handleCheckboxChange(option, 'save_option_amenities')"
                        />
                        <label class="label" :for="`amenities-${option}`">{{ option }}</label>
                      </div>
                    </div>
        
                    <!-- Meal Filter -->
                    <div
                      class="filter-item"
                      @click="toggleOptions('hotel_star')"
                      :class="{ active: activeOptions.hotel_star }"
                    >
                      Hotel star
                      <div class="icon"></div>
                    </div>
                    <div v-if="activeOptions.hotel_star" class="options">
                      <div v-for="option in hotel_star_options" :key="option" class="option">
                        <input
                          type="checkbox"
                          :id="`hotel_star-${option}`"
                          :checked="save_option_hotel_star.includes(option)"
                          @change="handleCheckboxChange(option, 'save_option_hotel_star')"
                        />
                        <label class="label" :for="`hotel_star-${option}`">{{ option }}</label>
                      </div>
                    </div>
        
                    <!-- Special Diet Filter -->
                    <div
                      class="filter-item"
                      @click="toggleOptions('price_range')"
                      :class="{ active: activeOptions.price_range }"
                    >
                      Price Range
                      <div class="icon"></div>
                    </div>
                    <div v-if="activeOptions.price_range" class="options">
                      <div v-for="option in price_range_options" :key="option" class="option">
                        <input
                          type="checkbox"
                          :id="`priceRange-${option}`"
                          :checked="save_option_price_range.includes(option)"
                          @change="handleCheckboxChange(option, 'save_option_price_range')"
                        />
                        <label class="label" :for="`priceRange-${option}`">{{ option }}</label>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div v-if="loading">
                <div class="skeleton-loader" v-for="n in 10" :key="n"></div>
              </div>
              <div v-else class="frame-hotels">
                <div class="list-hotels">
                  <Card_Item  v-for="(item, index) in paginatedList"
                            :key="index"
                            :destID="item.id"
                            :imageUrl="item.images[0]?.url || '/blue-image.jpg'"
                            :name="item.name"
                            :stars="generateStars(item.rating)"
                            :rating="item.rating"
                            :reviewNumber="item.review_count"
                            :tags="item.tag"
                            @click="navigateToDetailHotel(item.hotel_id)" />
                </div>
                <!-- Pagination -->
                <div class="pagination-container d-flex justify-content-center align-items-center mt-3">
                    <button class="btn-pagination prev" :disabled="currentPage === 1" @click="currentPage--">Previous</button>
                    <!-- Trang đầu -->
                    <button class="btn-pagination" 
                            :class="{ active: currentPage === 1 }"
                            @click="currentPage = 1">
                        1
                    </button>
                    <!-- Dấu ... trước trang hiện tại -->
                    <span class="dot" v-if="currentPage > 3">...</span>

                    <button v-for="page in pagesToShow" 
                            :key="page" 
                            class="btn-pagination"
                            :class="{ active: page === currentPage }"
                            @click="currentPage = page">
                        {{ page }}
                    </button>

                    <!-- Dấu ... sau trang hiện tại -->
                    <span class="dot" v-if="currentPage < totalPages - 2">...</span>

                    <!-- Trang cuối -->
                    <button class="btn-pagination" 
                            :class="{ active: currentPage === totalPages }"
                            @click="currentPage = totalPages">
                        {{ totalPages }}
                    </button>
                    <button class="btn-pagination next" :disabled="currentPage === totalPages" @click="currentPage++">Next</button>
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
import destinationViewModel from '../../viewModels/Hotel_City_ListViewModel';
import generateViewModel from '../../viewModels/generate_ratingViewModel';
import { useRoute } from 'vue-router';

const route = useRoute();
const cityId = route.params.id;

const {
    filterHotels,
    isMenuVisible,
    toggleMenu,
    hotels,
    liked,
    searchQuery,
    activeOptions,
    toggleOptions,
    feature_options,
    amenities_options,
    hotel_star_options,
    price_range_options,
    save_option_price_range,
    save_option_amenities,
    save_option_hotel_star,
    handleCheckboxChange,
} = destinationViewModel(cityId);

const loading = ref(true);
onMounted(async () => {
    await filterHotels();
    loading.value = false;
  });

  watch(
  [save_option_price_range, save_option_amenities, save_option_hotel_star],
  async () => {
    // Gọi hàm async bên trong mà không trả về Promise từ callback
    await filterHotels();
  }
);
const {
    circles,
    rating,
    ratings,
    generateCircle,
    generateStars,
    totalRating,
  } = generateViewModel();

const navigateToDetailHotel = (hotel_id) => {
        window.location.assign(`/Detail/Hotel/${hotel_id}`);
    };

    const currentPage = ref(1);
const itemsPerPage = 12;

// Computed property to calculate paginated list
const paginatedList = computed(() => {
    const start = (currentPage.value - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    return hotels.value.slice(start, end);
});

// Tính tổng số trang
const totalPages = computed(() => {
    return Math.ceil(hotels.value.length / itemsPerPage);
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
    import Filter_Option from '../Filter_Option.vue';
    export default {
        name: "ThingsToDo_List",
        components: {
            Header, Scroll_Bar_Component, Top_Button, Form_Search,
            Img_Card, Card_Item, Filter_Option,
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
    padding: 0px;
    height: 600px;
    border-radius: 25px;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
    margin-bottom: 50px;
}
.search{
    margin-top: -25%;
    margin-bottom: 250px;
}
.content{
  display: grid;
  grid-template-columns: 30% 65%;
  gap: 5%
}
.content p{
    font-weight: 900;
    margin-top: 15px; 
}
.list-hotels{
  display: grid;
  margin-top: 0px;
  grid-template-columns: repeat(2, 1fr);
  gap: 50px;
  align-items: center;
  height: 100%;
}
.left-panel{
    position: sticky;
    top: 140px;
}
.filter-section {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10px;
    width: 100%;
    margin-top: 0px;
    padding: 15px;
    border-radius: 25px;
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .07), 0 6px 18px -1px rgba(19, 53, 123, .04) !important;
}
.filter-item {
    position: sticky;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 20px;
    background-color: #CAF0F8;
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .3), 0 6px 18px -1px rgba(19, 53, 123, .04) !important;
    color: #13357B;
    font-weight: bold;
    cursor: pointer;
    border-radius: 15px;
    transition: background-color 0.3s;
    font-size: 20px;
    width: 100%;
}
.filter-item svg{
    stroke: #13357B;
}
.filter-item:hover {
    background-color: #13357B;
    color: #EDF6F9;
}
.filter-item:hover svg{
    stroke: #EDF6F9;
}
.filter-item.active {
    background-color: #13357B;
    color: #e7c6ff;
}
.filter-item.active svg{
    stroke: #e7c6ff;
    transform: rotate(180deg);
}
.options {
    display: flex;
    flex-direction: column;
    padding: 25px;
    background-color: #EDF6F9;
    border-radius: 8px;
    width: 100%;
    min-width: 400px;
    gap: 20px;
    max-height: 280px; /* Set a maximum height for the scroll area */
    overflow-y: auto;  /* Enable vertical scroll */
}
.option{
    display: flex;
    padding: 10px;
    gap: 10px;
    background-color: #EDF6F9;
    border-radius: 10px;
}
.option label{
    color: #13357B;
    font-size: 17px;
}
.option input[type="checkbox"]  {
    appearance: none;
    background-color: #EDF6F9;
    margin-right: 10px;
    border: 2px solid #13357B;
    width: 25px;
    height: 25px;
    border-radius: 25%;
    align-items: center; /* Căn giữa nội dung */
    position: relative; /* Để pseudo-element ::after hoạt động đúng */
}
.option input[type = "checkbox"]:checked { 
    background-color: #13357B;
}
.option input[type = "checkbox"]:checked +label { 
    font-weight: 900;
}
.option input[type = "checkbox"]:checked::after { 
    content: "\2714";
    color: #EDF6F9;
    font-size: 15px;
    font-weight: bold;
    position: absolute; /* Để kiểm soát vị trí của tick */
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%); /* Đưa dấu tick vào giữa checkbox */
}
.option:hover {
    background-color: #00b4d8;
}
.option:hover label{
    color: #EDF6F9;
    font-weight: 800;
}
.option.active {
    background-color: #13357B;
    font-weight: 800;
    color: #e7c6ff;
}
.option.active label{
    color: #e7c6ff;
    font-weight: 800;
}
.checked {
    /* Background color when checked */
    background-color: #CAF0F8;
}
.checked label{
    color: #13357B;
    font-weight: 900;
}

.icon {
    width: 25px;
    height: 25px;
    background-image: url("data:image/svg+xml;charset=UTF-8,<svg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%2313357B'><path d='M19 9L14 14.1599C13.7429 14.4323 13.4329 14.6493 13.089 14.7976C12.7451 14.9459 12.3745 15.0225 12 15.0225C11.6255 15.0225 11.2549 14.9459 10.9109 14.7976C10.567 14.6493 10.2571 14.4323 10 14.1599L5 9' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'/></svg>");
    background-repeat: no-repeat;
    background-size: contain;
    background-position: center;
}
.filter-item:hover .icon {
    background-image: url("data:image/svg+xml;charset=UTF-8,<svg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%23EDF6F9'><path d='M19 9L14 14.1599C13.7429 14.4323 13.4329 14.6493 13.089 14.7976C12.7451 14.9459 12.3745 15.0225 12 15.0225C11.6255 15.0225 11.2549 14.9459 10.9109 14.7976C10.567 14.6493 10.2571 14.4323 10 14.1599L5 9' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'/></svg>");
}
.filter-item.active .icon {
    background-image: url("data:image/svg+xml;charset=UTF-8,<svg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%23E7C6FF'><path d='M19 9L14 14.1599C13.7429 14.4323 13.4329 14.6493 13.089 14.7976C12.7451 14.9459 12.3745 15.0225 12 15.0225C11.6255 15.0225 11.2549 14.9459 10.9109 14.7976C10.567 14.6493 10.2571 14.4323 10 14.1599L5 9' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'/></svg>");
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
.prev, .next {
    min-width: 85px;
}
.dot {
    color: #13357B;
}
</style>

