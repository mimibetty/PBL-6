<template>
    <div class="header-container">
        <header_For_company />
    </div>

    <!-- Main Content -->
    <!-- Set up grid layout for responsive -->
    <div class="container-fluid">
        <div class="container-fluid">
            <div class="container-fluid frame-overall">
                <div class="container-fluid overall">
                    <!-- Main Context -->
                    <div
                        class="container-fluid frame-main d-flex flex-column justify-content-center align-items-center gap-3">
                        <div class="frame-title">
                            <h1>Create New Hotel</h1>
                        </div>
                        <div class="container-fluid frame-info">
                            <div class="frame-name dest-location d-flex justify-content-center ">
                                <!-- Name of destination -->
                                <div class="container-fluid">
                                    <div class="custom form-floating mt-3">
                                        <input disabled type="text" class="form-control disabled" id="tourName"
                                            placeholder="Tour Name" name="tourName" v-model="destination.name">
                                        <label class="form-label" for="tourName">Hotel Name:</label>
                                    </div>
                                </div>
                            </div>
                            <!-- Total -->
                            <div class="frame-name dest-location d-flex justify-content-center ">
                                <!-- Special Diet -->
                                <div class="container-fluid">
                                    <div class="custom form-floating mt-3">
                                        <input type="text" class="form-control" id="tourName" placeholder="Tour Name"
                                            name="tourName" v-model="hotel.hotel.hotel_class">
                                        <label class="form-label" for="tourName">Hotel Rating:</label>
                                    </div>
                                </div>
                                <!-- Meak -->
                                <div class="container-fluid">
                                    <div class="custom form-floating mt-3">
                                        <input type="text" class="form-control" id="tourName" placeholder="Tour Name"
                                            name="tourName" v-model="hotel.hotel.hotel_styles">
                                        <label class="form-label" for="tourName">Hotel Style: </label>
                                    </div>
                                </div>
                            </div>
                            <div class="container-fluid">
                                <div class="custom form-floating mt-3">
                                    <button class="dropdown-button" :class="{ 'active': dropdownVisibleLanguage }"
                                        @click="toggleDropDownLanguage">
                                        {{ selectedLanguageName }}
                                        <span class="arrow" :class="{ 'up': dropdownVisibleLanguage }">
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
                                    <div class="dropdown-list" v-if="dropdownVisibleLanguage">
                                        <!-- Tùy chọn các thành phố -->
                                        <button class="dropdown-item" v-for="(language, index) in languages"
                                            :key="index" @click="selectLanguage(language)">
                                            {{ language }}
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Service -->
                        <div class="frame container-fluid ">
                            <h5 class="title">Service</h5>
                            <!-- Special Diet -->
                            <div class="container-fluid left">
                                <div class="custom form-floating mt-3">
                                    <input type="text" class="form-control" id="tourName" placeholder="Tour Name"
                                        name="tourName" v-model="hotel.hotel.room_types">
                                    <label class="form-label" for="tourName">Room Type:</label>
                                </div>
                            </div>
                            <!-- Meak -->
                            <div class="container-fluid right">
                                <div class="custom form-floating mt-3">
                                    <input type="text" class="form-control" id="tourName" placeholder="Tour Name"
                                        name="tourName" v-model="hotel.hotel.room_features">
                                    <label class="form-label" for="tourName">Room Features: </label>
                                </div>
                            </div>
                            <!-- Meak -->
                            <div class="container-fluid end">
                                <div class="custom form-floating mt-3">
                                    <input type="text" class="form-control" id="tourName" placeholder="Tour Name"
                                        name="tourName" v-model="hotel.hotel.property_amenities">
                                    <label class="form-label" for="tourName">Property Amenities: </label>
                                </div>
                            </div>
                        </div>
                        <!-- Service -->
                        <div class="frame container-fluid ">
                            <h5 class="title">Info Contact</h5>
                            <!-- Special Diet -->
                            <div class="container-fluid left">
                                <div class="custom form-floating mt-3">
                                    <input type="text" class="form-control" id="tourName" placeholder="Tour Name"
                                        name="tourName" v-model="hotel.hotel.phone">
                                    <label class="form-label" for="tourName">Phone Number:</label>
                                </div>
                            </div>
                            <!-- Meak -->
                            <div class="container-fluid right">
                                <div class="custom form-floating mt-3">
                                    <input type="text" class="form-control" id="tourName" placeholder="Tour Name"
                                        name="tourName" v-model="hotel.hotel.email">
                                    <label class="form-label" for="tourName">Business Email: </label>
                                </div>
                            </div>
                            <!-- Meak -->
                            <div class="container-fluid end">
                                <div class="custom form-floating mt-3">
                                    <input type="text" class="form-control" id="tourName" placeholder="Tour Name"
                                        name="tourName" v-model="hotel.hotel.website">
                                    <label class="form-label" for="tourName">Link Website: </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class=" d-flex justify-content-around gap-4">
                        <button class="container-fluid button cancel submit" type="button" @click="cancelUpdate">
                            Cancel
                        </button>
                        <button class="container-fluid button submit" type="button" @click="addHotel">
                            Submit
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import header_For_company from '../../Dashboard_For_Company/header_For_company.vue';
import Scroll_Bar_Component from '../../Scroll_Bar_Component.vue';
export default {
    components: {
        header_For_company
    }
}
</script>

<script setup>
import BusinessViewModel from "../../../viewModels/Business_DestinationViewModel.js"
import VueDatePicker from '@vuepic/vue-datepicker';
import '@vuepic/vue-datepicker/dist/main.css';
import { ref, computed, onMounted, watch } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();
const destinationID = route.params.id;

const cancelUpdate = () => {
    window.location.assign(`/Business/Destination`);
}

const {
    cities,
    fetchCities,
    fetchUsers,
    loadUser,
    destination,
    hotel,
    restaurant,
    getDestinationById,
    showAddDestination,
    addDestination,
    updateDestination,
    deleteDestination,
    addHotel,
    updateHotel,
    deleteHotel,
    addRestaurant,
    updateRestaurant,
    deleteRestaurant,
    previewImages,
    previewNewImages,
    handleImageUpload,
    removeImage,
    handleNewImageUpload,
    removeNewImage,
    removeExistingImage,
    selectedCityId,
    dropdownVisibleRegion,
    toggleDropDownRegion,
    selectCity,
    selectedCityName,
    selectedLanguage,
    dropdownVisibleLanguage,
    toggleDropDownLanguage,
    selectLanguage,
    selectedLanguageName,
    languages,
} = BusinessViewModel()

onMounted(() => {
    getDestinationById(destinationID);
});
</script>

<style scoped>
.frame-overall {
    display: grid;
    grid-template-columns: 2% 96% 2%
}

.overall {
    grid-column: 2/3;
    color: #13357B;
}

.frame-title h1 {
    margin-top: 100px;
    font-weight: 900;
}

/* Input */
.form-control {
    min-height: 80px;
    color: #13357B !important;
    font-size: 18px;
    background-color: transparent !important;
    border: 1px solid #13357B;
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .1), 0 6px 18px -1px rgba(19, 53, 123, .08) !important;
}

.form-label {
    color: #13357B !important;
    opacity: 0.75;
}

:deep(.form-floating>.form-control:not(:placeholder-shown)~label::after) {
    background-color: transparent !important;
}

:deep(.form-floating>.form-control:focus~label::after) {
    background-color: transparent !important;
}

/* Drop Down */
.dropdown-button {
    width: 100%;
    padding: 10px;
    border-radius: 10px;
    border: 1px solid #13357B;
    margin: 20px 0;
    background-color: transparent;
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .1), 0 6px 18px -1px rgba(19, 53, 123, .08) !important;
    color: #13357B;
    display: flex;
    justify-content: center;
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

.button {
    margin: 50px 0;
    padding: 10px 0px;
    border: none;
    border-radius: 10px;
    background-color: #00B4D8;
    color: #EDF6F9;
    cursor: pointer;
    transition: background-color 0.3s ease;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.2);
}

.button:hover {
    opacity: 0.8;
}

.cancel {
    background-color: #EF3F3E;
}

.disabled {
    background-color: rgba(19, 53, 123, 0.12) !important;
}

.frame {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    place-items: center;
    margin-top: 30px;
}

.title {
    grid-column: 1/3;
    font-weight: 900;
    color: #13357B;
    text-decoration: underline;
    text-underline-offset: 7px;
}

.end {
    grid-column: 1/3;
}
</style>