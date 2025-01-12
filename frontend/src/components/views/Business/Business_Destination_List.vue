<template>
    <div class="header-container">
        <header_For_company/>
    </div>
    <div class="container-fluid p-5 frame-overall">
        <div class="container-fluid overall">
            <div class="container-fluid p-5 top-rating d-flex justify-content-center align-items-baseline">
                <div class="container name-of-table">
                    <h3>My Places</h3>
                </div>
                <button class="btn-add d-flex justify-content-around align-items-center"
                        @click="navigateToAddDestination">
                    <svg fill="#EDF6F9" width="20px" height="20px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512">
                        <path d="M352 240v32c0 6.6-5.4 12-12 12h-88v88c0 6.6-5.4 12-12 12h-32c-6.6 0-12-5.4-12-12v-88h-88c-6.6 0-12-5.4-12-12v-32c0-6.6 5.4-12 12-12h88v-88c0-6.6 5.4-12 12-12h32c6.6 0 12 5.4 12 12v88h88c6.6 0 12 5.4 12 12zm96-160v352c0 26.5-21.5 48-48 48H48c-26.5 0-48-21.5-48-48V80c0-26.5 21.5-48 48-48h352c26.5 0 48 21.5 48 48zm-48 346V86c0-3.3-2.7-6-6-6H54c-3.3 0-6 2.7-6 6v340c0 3.3 2.7 6 6 6h340c3.3 0 6-2.7 6-6z"/>
                    </svg>
                    Add New
                </button>
            </div>
            <table class="table table-responsive table-striped">
                <thead>
                    <tr>
                        <th class="number">Number</th>
                        <th>Photo</th>
                        <th>Name</th>
                        <th class="city">City</th>
                        <th class="rating">Rating</th>
                        <th class="type">Type</th>
                        <th class="view">View</th>
                        <th class="edit">Edit</th>
                        <th class="delete">Delete</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(tour, index) in paginatedList" :key="index">
                        <td class="number">{{ index + 1 + (currentPage - 1) * itemsPerPage }}</td>
                        <td>
                            <img class="img" 
                                :src="tour.images[0]?.url || '/blue-image.jpg'" 
                                :alt="tour.id">
                        </td>
                        <td>{{ tour.name }}</td>
                        <td class="city">{{ cities.name = cities.find(city => city.id === tour.address.city_id)?.name }}</td>
                        <td class="rating">{{ tour.rating }}</td>
                        <td class="type">{{ tour.hotel_id !== null && tour.restaurant_id === null ? "Hotel" 
                                             :tour.hotel_id === null && tour.restaurant_id !== null ? "Restaurant" 
                                             :"Place" }}</td>
                        <td class="view">
                            <button class="btn-view" @click="navigateToDetailDestination(tour)">
                                <svg fill="currentColor" width="22px" height="22px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512">
                                    <path d="M288 144a110.9 110.9 0 0 0 -31.2 5 55.4 55.4 0 0 1 7.2 27 56 56 0 0 1 -56 56 55.4 55.4 0 0 1 -27-7.2A111.7 111.7 0 1 0 288 144zm284.5 97.4C518.3 135.6 410.9 64 288 64S57.7 135.6 3.5 241.4a32.4 32.4 0 0 0 0 29.2C57.7 376.4 165.1 448 288 448s230.3-71.6 284.5-177.4a32.4 32.4 0 0 0 0-29.2zM288 400c-98.7 0-189.1-55-237.9-144C98.9 167 189.3 112 288 112s189.1 55 237.9 144C477.1 345 386.7 400 288 400z"/>
                                </svg>
                            </button>
                        </td>
                        <td class="edit dropdown">
                            <button class="btn-edit dropdown-toggle d-flex align-items-center justify-content-center" data-bs-toggle="dropdown">
                                <svg fill="currentColor" width="22px" height="22px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512">
                                    <path d="M402.6 83.2l90.2 90.2c3.8 3.8 3.8 10 0 13.8L274.4 405.6l-92.8 10.3c-12.4 1.4-22.9-9.1-21.5-21.5l10.3-92.8L388.8 83.2c3.8-3.8 10-3.8 13.8 0zm162-22.9l-48.8-48.8c-15.2-15.2-39.9-15.2-55.2 0l-35.4 35.4c-3.8 3.8-3.8 10 0 13.8l90.2 90.2c3.8 3.8 10 3.8 13.8 0l35.4-35.4c15.2-15.3 15.2-40 0-55.2zM384 346.2V448H64V128h229.8c3.2 0 6.2-1.3 8.5-3.5l40-40c7.6-7.6 2.2-20.5-8.5-20.5H48C21.5 64 0 85.5 0 112v352c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V306.2c0-10.7-12.9-16-20.5-8.5l-40 40c-2.2 2.3-3.5 5.3-3.5 8.5z"/>
                                </svg>    
                            </button>
                            <div class="dropdown-menu dropdown-menu-end m-0">
                                <button class="dropdown-item" @click="navigateToUpdateDestination(tour.id)">Update Destination</button>
                                <button v-if="tour.hotel_id !== null" class="dropdown-item" @click="navigateToUpdateHotel(tour.id)">Update Hotel Detail</button>
                                <button v-if="tour.restaurant_id !== null" class="dropdown-item" @click="navigateToUpdateRestaurant(tour.id)">Update Restaurant Detail</button>
                                <button v-if="tour.hotel_id === null && tour.restaurant_id === null" class="dropdown-item" @click="navigateToAddHotel(tour.id)">Add New Hotel</button>
                                <button v-if="tour.restaurant_id === null && tour.hotel_id === null" class="dropdown-item" @click="navigateToAddRestaurant(tour.id)">Add New Restaurant</button>
                            </div>
                        </td>
                        <td class="delete">
                            <button class="btn-delete" data-bs-toggle="modal" @click="deleteDestination1(tour.id)" data-bs-target="#del">
                                <svg fill="currentColor" width="22px" height="22px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512">
                                    <path d="M268 416h24a12 12 0 0 0 12-12V188a12 12 0 0 0 -12-12h-24a12 12 0 0 0 -12 12v216a12 12 0 0 0 12 12zM432 80h-82.4l-34-56.7A48 48 0 0 0 274.4 0H173.6a48 48 0 0 0 -41.2 23.3L98.4 80H16A16 16 0 0 0 0 96v16a16 16 0 0 0 16 16h16v336a48 48 0 0 0 48 48h288a48 48 0 0 0 48-48V128h16a16 16 0 0 0 16-16V96a16 16 0 0 0 -16-16zM171.8 50.9A6 6 0 0 1 177 48h94a6 6 0 0 1 5.2 2.9L293.6 80H154.4zM368 464H80V128h288zm-212-48h24a12 12 0 0 0 12-12V188a12 12 0 0 0 -12-12h-24a12 12 0 0 0 -12 12v216a12 12 0 0 0 12 12z"/>
                                </svg>
                            </button>
                            <!-- The Modal -->
                            <div class="modal fade" id="del">
                                <div class="modal-dialog modal-sm modal-dialog-centered">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <div class="modal-title warn">Warning</div>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <!-- Modal body -->
                                        <div class="modal-body">
                                            <h5>Are you sure you want to remove this?</h5>
                                        </div>
                                        <!-- Modal footer -->
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-info" data-bs-dismiss="modal"
                                                    @click="deleteDestination2()">
                                                Sure
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>

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
</template>

<script>
import header_For_company from '../Dashboard_For_Company/header_For_company.vue';
import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
export default {
    name: "Business_Tour_List",
    components: {
        header_For_company
    }
}
</script>
<script setup>
import Business_View_DestinationViewModel from '@/components/viewModels/Business_View_DestinationViewModel';
import Business_DestinationViewModel from '@/components/viewModels/Business_DestinationViewModel';
import { ref, computed, onMounted } from 'vue';

const { 
    isLoading, cities,
    destinations, hotels, restaurants, places,
    deleteDestination
} = Business_View_DestinationViewModel();

const currentPage = ref(1);
const itemsPerPage = 10;

// Computed property to calculate paginated list
const paginatedList = computed(() => {
    const start = (currentPage.value - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    return places.value.slice(start, end);
});

// Tính tổng số trang
const totalPages = computed(() => {
    return Math.ceil(places.value.length / itemsPerPage);
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

const navigateToDetailDestination = (destination) => {
    if (destination.hotel_id !== null && destination.restaurant_id == null) {
        window.location.assign(`/Detail/Hotel/${destination.hotel_id}`);    
    }
    else if (destination.hotel_id == null && destination.restaurant_id !== null) {
        window.location.assign(`/Detail/Restaurant/${destination.restaurant_id}`);    
    } 
    else {
        window.location.assign(`/Detail/Place/${destination.id}`);    
    }
};

const navigateToUpdateHotel = (tour_id) => {
    window.location.assign(`/Business/Hotel/Update/${tour_id}`);
};

const navigateToUpdateRestaurant = (tour_id) => {
    window.location.assign(`/Business/Restaurant/Update/${tour_id}`);
};

const navigateToUpdateDestination = (tour_id) => {
    window.location.assign(`/Business/Destination/Update/${tour_id}`);
};

const navigateToAddDestination = () => {
    window.location.assign(`/business/destination/Add`);   
}

const navigateToAddHotel = (id) => {
    window.location.assign(`/Business/Hotel/Add/${id}`);
}

const navigateToAddRestaurant = (id) => {
    window.location.assign(`/Business/Restaurant/Add/${id}`);
}

const selectedIDtoDelete = ref();

const deleteDestination1 = (id) => {
    selectedIDtoDelete.value = id;
    console.log("ID selected to delete: ",id);
}
const deleteDestination2 = () => {
    deleteDestination(selectedIDtoDelete.value);
    setTimeout(() => {
        window.location.reload(); // Reload sau 3 giây
    }, 3000); // 3000ms = 3 giây
}
</script>


<style scoped>
.frame-overall {
    display: grid;
    grid-template-columns: 2% 96% 2%
}
.overall {
    grid-column: 2/3;
}
:deep(.table-striped>tbody>tr:nth-of-type(odd)>* ) {
    --bs-table-bg-type: rgba(202, 240, 248, 0.4);
}
:deep(.table) {
    table-layout: fixed;
    /* width: 100%; */
}
tbody {
    max-height: 200px ;
    width: 100%;
}
th {
    border-color: #13357B !important;
    color: #EDF6F9;
    background-color: #4AA4D9 !important;
    text-align: center; 
    font-size: 18px;
    font-weight: 900 !important;
}
tr {
    vertical-align: middle !important;
    text-align: center !important;
    border-color: rgba(19, 53, 123, 0.4) !important;
    font-size: 14px;
}
th.number, td.number, th.rating, td.rating, th.type, td.type,
th.view, td.view, th.edit, td.edit, th.delete, td.delete {
    width: 6.5%;
    text-align: center !important;
    place-items: center !important;
}
th.city, td.city  {
    width: 15%;
    text-align: center !important;
}
td {
    color: #13357B !important;
    font-size: 16px;
    background-color: #EDF6F9 !important;
}
.location {
    text-align: left !important;
}
.img {
    aspect-ratio: 16/9;
    object-fit: cover;
    height: 120px;
    border-radius: 10px;
}
tbody tr:hover td{
    background-color: #CAF0F8 !important ; /* Màu khi hover */
}
.btn-add {
    color: #EDF6F9;
    background-color: #4AA4D9 ;
    padding: 10px 20px;
    min-width: 150px;
    border: 1px solid #4AA4D9;
    border-radius: 5px;
    cursor: pointer;
}
.btn-view, .btn-edit, .btn-delete {
    border: none;
    background-color: transparent;
    cursor: pointer;
}
.btn-view {
    color: #747DC6;
}
.btn-edit {
    color: #4AA4D9;
}
.btn-delete {
    color: #EF3F3E;
}
.btn-view:hover, .btn-add:hover, .btn-edit:hover, .btn-delete:hover {
    opacity: 0.7;
}
.name-of-table h3 {
    font-weight: 900;
    color: #13357B;
}

.pagination-container {
    gap: 10px;
}
.btn-pagination {
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
.dropdown-menu {
    background-color: #EDF6F9;
    color: #13357B;
    border: 1px solid #4AA4D9;
    border-radius: 5px;
    cursor: pointer;
}
.dropdown-item{
    color: #13357B;
    transition: all 0.3s;
}
.dropdown-item:hover{
    background-color: #4AA4D9;
    color: #EDF6F9;
}
.btn {
    color: #EDF6F9;
}
.warn {
    font-size: 40px;
    font-weight: 900;
    color: #EF3F3E;
}
</style>