<template>
    <div class="header-container">
        <header_For_company/>
    </div>
    <div class="container-fluid frame-overall">
        <div class="container-fluid overall">
            <div class="container-fluid d-flex flex-column gap-5">
                <div class="frame-image d-flex justify-content-center">
                    <h1 class="title">Add New Tour</h1>
                </div>
                <div class="frame-input">
                    <div class="frame-tourName-City d-flex justify-content-center align-items-center">
                        <!-- Tour Name -->
                        <div class="container-fluid">
                            <div class="custom form-floating mt-3">
                                <input type="text" class="form-control" id="tourName" placeholder="Tour Name" name="tourName" v-model="tourName">
                                <label class="form-label" for="tourName">Tour Name</label>
                            </div>
                        </div>
                        <!-- Select Location -->
                        <div class="frame-select-location">
                            <button class="dropdown-button" 
                                    :class="{ 'active': dropdownVisibleRegion }" 
                                    @click="toggleDropDownRegion">
                                {{ selectedCityName }}
                                <span class="arrow" :class="{ 'up': dropdownVisibleRegion }">
                                    <svg width="30px" height="30px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
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
                                <!-- Tùy chọn các thành phố -->
                                <button class="dropdown-item" v-for="city in cities" 
                                        :key="city.id" @click="selectCity(city.id)">
                                    {{ city.name }}
                                </button>
                            </div>
                        </div>
                    </div>
                    <!-- Description -->
                    <div class="container-fluid">
                        <div class="description custom form-floating mt-3">
                            <textarea type="text" class="form-control description" id="tourName" placeholder="Tour Name" name="tourName" v-model="description"/>
                            <label class="form-label" for="tourName">Description</label>
                        </div>
                    </div>
                </div>
                <!-- Destinations -->
                <div class="container-fluid frame-dest-list d-flex flex-column gap-3">
                    <div>
                        <button class="btn-add d-flex justify-content-around align-items-center"
                                type="button" data-bs-toggle="modal" data-bs-target="#listDestination">
                            <svg fill="currentColor" width="20px" height="20px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512">
                                <path d="M352 240v32c0 6.6-5.4 12-12 12h-88v88c0 6.6-5.4 12-12 12h-32c-6.6 0-12-5.4-12-12v-88h-88c-6.6 0-12-5.4-12-12v-32c0-6.6 5.4-12 12-12h88v-88c0-6.6 5.4-12 12-12h32c6.6 0 12 5.4 12 12v88h88c6.6 0 12 5.4 12 12zm96-160v352c0 26.5-21.5 48-48 48H48c-26.5 0-48-21.5-48-48V80c0-26.5 21.5-48 48-48h352c26.5 0 48 21.5 48 48zm-48 346V86c0-3.3-2.7-6-6-6H54c-3.3 0-6 2.7-6 6v340c0 3.3 2.7 6 6 6h340c3.3 0 6-2.7 6-6z"/>
                            </svg>
                            Add New
                        </button>
                        <List_Destination :destList="destinations_2" 
                                          @addDestination = "handleAddDestination"/>
                    </div>
                    <table class="table table-responsive table-striped">
                        <thead>
                            <tr>
                                <th class="number">Number</th>
                                <th>Photo</th>
                                <th>Destination Name</th>
                                <th class="type">Type</th>
                                <th class="rating">Rating</th>
                                <th class="remove">Remove</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(destination, index) in paginatedList" :key="index">
                                <td class="number"> {{ index + 1 + (currentPage - 1) * itemsPerPage }} </td>
                                <td>
                                    <img class="img1" :src="destination.images[0]?.url || '/blue-image.jpg'" alt="">
                                </td>
                                <td>{{ destination.name }}</td>
                                <td class="type">{{ destination.hotel_id !== null && destination.restaurant_id === null 
                                        ? "Hotel" 
                                        : destination.hotel_id === null && destination.restaurant_id !== null
                                        ? "Restaurant" : "Place" }}</td>
                                <td class="rating">{{ destination.average_rating != null
                                        ? Number(destination.average_rating).toFixed(1)
                                        : 0 }}
                                </td>
                                <td class="remove">
                                    <button class="btn-delete"
                                            @click="removeDestination(destination.id)">
                                        <svg fill="currentColor" width="22px" height="22px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512">
                                            <path d="M416 208H32c-17.7 0-32 14.3-32 32v32c0 17.7 14.3 32 32 32h384c17.7 0 32-14.3 32-32v-32c0-17.7-14.3-32-32-32z"/>
                                        </svg>
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- Pagination -->
                    <div class="pagination-container d-flex justify-content-center align-items-center mt-3">
                        <button class="btn-pagination prev" :disabled="currentPage === 1" @click="currentPage--">Previous</button>
                        <button 
                            v-for="page in totalPages" 
                            :key="page" 
                            class="btn-pagination"
                            :class="{ active: page === currentPage }"
                            @click="currentPage = page">
                            {{ page }}
                        </button>
                        <button class="btn-pagination next" :disabled="currentPage === totalPages" @click="currentPage++">Next</button>
                    </div>
                </div>
                <!-- Submit -->
                <div class=" d-flex justify-content-center">
                    <button class="container-fluid button cancel" type="button"
                            @click="navigateListTour">
                        Cancel
                    </button>
                    <button class="container-fluid button submit" type="button"
                            @click="SendAddTour">
                        Submit
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import header_For_company from '../../Dashboard_For_Company/header_For_company.vue';
import Scroll_Bar_Component from '../../Scroll_Bar_Component.vue';
import List_Destination from './List_Destination.vue';
export default {
    name: "Business_Tour_Edit",
    components: {
        header_For_company
    }
}
</script>
<script setup>
// import TourViewModel from '@/components/viewModels/TourViewModel';
import Business_Tour_ViewModel from '@/components/viewModels/Business_Tour_ViewModel';
import { ref, computed, onMounted, watch } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();
const tourID = route.params.id;


const { 
    tour, tourId, description, tourName, 
    loadTourbyID, selectCity, selectedCityName, 
    selectedCityId, cities, destListID, destList, destinations_2,
    dropdownVisibleRegion, toggleDropDownRegion, loadCities, 
    SendUpdateTour, SendAddTour,
    loadDestinations, destinations, loadUser, user, removeDestination, handleAddDestination
} = Business_Tour_ViewModel();

const images = ref([]);

const currentPage = ref(1);
const itemsPerPage = 10;

// Computed property to calculate paginated list
const paginatedList = computed(() => {
    const start = (currentPage.value - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    return destList.value.slice(start, end);
});

// Total pages calculation
const totalPages = computed(() => {
    return Math.ceil(destList.value.length / itemsPerPage);
});

onMounted(async () => {
    await loadCities();
    await loadUser();
    console.log('User:', user.value);
    if(user.value) {
        await loadDestinations();
        console.log('Tour Name:', tourName.value);
        console.log('List Destination:', destinations.value);
    console.log('Cities:', cities.value);
    }
    
});

const navigateListTour = () => {
    window.location.assign(`/Business/Tour`);
}
</script>


<style scoped>
.frame-image {
    margin-top: 100px;
}
.frame-overall {
    display: grid;
    grid-template-columns: 10% 80% 10%;
}
.overall {
    grid-column: 2/3;
}
.title {
    font-weight: 900;
    color: #4AA4D9;
}
.img {
    border-radius: 10px;
    aspect-ratio: 27/9;
    margin: 0 auto;
    height: 300px;
    object-fit: cover;
}
/* Drop Down */
.dropdown-button{
    min-width: 200px;
    padding: 10px;
    border-radius: 30px;
    border: none;
    margin: 20px 0;
    background-color: #CAF0F8;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
    color: #13357B;
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
    gap: 5%;
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
/* Input */
.form-control {
    min-height: 80px;
    color:#13357B !important;
    font-size: 18px;
    background-color: transparent;
    border:1px solid #13357B;
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .1), 0 6px 18px -1px rgba(19, 53, 123, .08) !important;
}
.form-label {
    color:#13357B !important;
    opacity: 0.75;
}
:deep(.form-floating>.form-control:not(:placeholder-shown)~label::after) {
    background-color: transparent !important;
}
:deep(.form-floating>.form-control:focus~label::after) {
    background-color: transparent !important;
}
.description {
    min-height: 100px;
}

/* Table list Dest */
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
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .1), 0 6px 18px -1px rgba(19, 53, 123, .08) !important;
}
th {
    border-color: #13357B !important;
    color: #EDF6F9;
    background-color: #4AA4D9 !important;
    text-align: center; 
    padding: .5rem 1.5rem;
    font-weight: 900 !important;
}
tr {
    vertical-align: middle !important;
    text-align: center !important;
    border-color: rgba(19, 53, 123, 0.4) !important;
    font-size: 14px;
}
th.remove, td.remove, th.number, td.number, th.rating, td.rating, th.type, td.type {
    width: 10%;
    text-align: center;
}
td {
    color: #13357B !important;
    background-color: #EDF6F9 !important;
}
.img1 {
    aspect-ratio: 16/9;
    object-fit: cover;
    height: 120px;
    border-radius: 10px;
}
.btn-delete {
    border: none;
    background-color: transparent;
    cursor: pointer;
    color: #EF3F3E;
}
.btn-delete:hover, .btn-add:hover {
    opacity: 0.7;
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
/* Pagination */
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

/* Submit */
.button {
    color: #EDF6F9;
    background-color: #4AA4D9 ;
    padding: 10px 20px;
    min-width: 150px;
    border: 1px solid #4AA4D9;
    border-radius: 5px;
    cursor: pointer;
    margin-bottom: 50px;
}
.cancel {
    background-color: #EF3F3E;
}
.button:hover {
    opacity: 0.7;
}
</style>