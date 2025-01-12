<template>
    <div class="container-fluid">
        <Header />
        <Top_Button />
    </div>

    <div class="container-fluid">
        <div class="container-fluid frame-overall">
            <div class="container-fluid overall">
                <div class="container-fluid frame-list">
                    <div class="frame-filter">
                        <div class="frame-selection">
                            <div class="frame-select-location">
                                <h5>Location</h5>
                                <button class="dropdown-button" :class="{ 'active': dropdownVisibleRegion }"
                                    @click="toggleDropDownRegion">
                                    {{ selectedCityName }}
                                    <span class="arrow" :class="{ 'up': dropdownVisibleRegion }">
                                        <svg width="30px" height="30px" viewBox="0 0 24 24" fill="none"
                                            xmlns="http://www.w3.org/2000/svg">
                                            <path d="M19 9L14 14.1599C13.7429 14.4323 13.4329 
                                            14.6493 13.089 14.7976C12.7451 14.9459 12.3745 15.0225 
                                            12 15.0225C11.6255 15.0225 11.2549 14.9459 10.9109 
                                            14.7976C10.567 14.6493 10.2571 14.4323 10 14.1599L5 9"
                                                stroke="#currentColor" stroke-width="1.5" stroke-linecap="round"
                                                stroke-linejoin="round" />
                                        </svg>
                                    </span>
                                </button>
                                <!-- Dropdown danh sách các lựa chọn -->
                                <div class="dropdown-list" v-if="dropdownVisibleRegion">
                                    <!-- Tùy chọn tất cả tours -->
                                    <button class="dropdown-item" @click="selectCity(null)">
                                        Việt Nam
                                    </button>
                                    <!-- Tùy chọn các thành phố -->
                                    <button class="dropdown-item" v-for="city in cities" :key="city.id"
                                        @click="selectCity(city.id)">
                                        {{ city.name }}
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="frame-list-items">
                        <Tour_Item v-for="tour in filteredTours" :key="tour.id" :tour="tour"
                            :city="getCity(tour.city_id)" @click="navigateToDetailTour(tour.id)" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>


<script setup>
import TourViewModel from '../../../viewModels/TourViewModel';
import { ref, computed, onMounted } from 'vue';

const { loadCities, loadTours } = TourViewModel();

// Data binding
const tours = ref([]);
const cities = ref([]);
const selectedCityId = ref(null); // Giá trị mặc định (null = tất cả tours)
const dropdownVisibleRegion = ref(false); // Trạng thái hiển thị dropdown

// Load dữ liệu ban đầu
onMounted(async () => {
    tours.value = await loadTours();
    cities.value = await loadCities();
});

// Danh sách tours được lọc theo `selectedCityId`
const filteredTours = computed(() => {
    return selectedCityId.value
        ? tours.value.filter(tour => tour.city_id === selectedCityId.value)
        : tours.value;
});

// Tên thành phố hiển thị trên nút dropdown
const selectedCityName = computed(() => {
    if (!selectedCityId.value) return 'Việt Nam';
    const city = cities.value.find(c => c.id === selectedCityId.value);
    return city ? city.name : 'Việt Nam';
});

// Toggle trạng thái dropdown
const toggleDropDownRegion = () => {
    dropdownVisibleRegion.value = !dropdownVisibleRegion.value;
};

// Chọn thành phố
const selectCity = (cityId) => {
    selectedCityId.value = cityId; // Cập nhật ID thành phố được chọn
    dropdownVisibleRegion.value = false; // Đóng dropdown
};

// Lấy thông tin thành phố từ ID
const getCity = (city_id) => {
    return cities.value.find(city => city.id === city_id);
};

// Điều hướng đến chi tiết tour
const navigateToDetailTour = (tour_id) => {
    window.location.assign(`/tour/${tour_id}`);
};
</script>

<script>
import Header from '../../Header.vue';
import Top_Button from '../../Top_Button.vue';
import Tour_Item from './Tour_Item.vue';
import Scroll_Bar_Component from '../../Scroll_Bar_Component.vue';
export default {
    name: "List_Tour",
    components: {
        Header,
        Top_Button,
        Tour_Item,
    },
};
</script>



<style scoped>
.frame-overall {
    display: grid;
    grid-template-columns: 0% 96% 4%;
}

.overall {
    grid-column: 2/3;
}

.frame-list {
    width: 100%;
    /* Chiều rộng toàn màn hình */
    min-height: 100vh;
    /* Chiều cao tối thiểu toàn màn hình */
    margin-top: 200px;
    /* Giảm khoảng cách từ phía trên */
    display: grid;
    grid-template-columns: 20% 80%;
    /* Chỉnh lại tỷ lệ cột để hài hòa hơn */
    gap: 50px;
    padding: 20px;
    /* Thêm padding để tránh sát mép */
}

.frame-list-items {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    /* Đảm bảo responsive */
    gap: 50px;
    place-items: center;
    margin-bottom: 40px;
    /* Tăng một chút khoảng cách phía dưới */
}

.frame-list-items>* {
    max-height: 600px;
    /* Giảm chiều cao tối đa cho mỗi item */
    overflow: hidden;
    border-radius: 10px;
    /* Bo góc để giao diện mềm mại hơn */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    /* Thêm bóng để tạo chiều sâu */
}

.frame-selection {
    display: flex;
    flex-direction: column;
    color: #13357B;
    gap: 30px;
}

h5 {
    font-weight: 700;
    font-size: 22px;
}

.dropdown-button {
    min-width: 200px;
    padding: 10px;
    border-radius: 15px;
    border: none;
    margin: 20px 0;
    background-color: #CAF0F8;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
    color: #13357B;
    display: flex;
    justify-content: space-around;
    align-items: center;
    cursor: pointer;
    gap: 20px;
}

.dropdown-button svg {
    stroke: #13357B;
}

.dropdown-button.active {
    background-color: #13357B;
    color: #EDF6F9;
}

.dropdown-button.active svg {
    stroke: #EDF6F9;
    transform: rotate(180deg);
}

.dropdown-list {
    position: absolute;
    margin-top: 10px;
    min-width: 300px;
    height: 250px;
    overflow: hidden;
    border-radius: 10px;
    background-color: #EDF6F9;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
    z-index: 5;
    overflow-y: auto;
    padding: 15px 0px;
    display: flex;
    flex-direction: column;
    gap: 15px;
    scrollbar-width: thin;
    /* Chỉ áp dụng trên Firefox */
    scrollbar-color: #13357B #EDF6F9;
    /* Màu thanh cuộn và nền */
}

.dropdown-item {
    padding: 15px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.dropdown-item:hover {
    background-color: #13357B;
    color: #EDF6F9;
}
</style>