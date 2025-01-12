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
                            <h1>Update Destination</h1>
                        </div>
                        <div class="container-fluid frame-info">
                            <div class="frame-name dest-location d-flex justify-content-center ">
                                <!-- Name of destination -->
                                <div class="container-fluid">
                                    <div class="custom form-floating mt-3">
                                        <input type="text" class="form-control" id="tourName" placeholder="Tour Name"
                                            name="tourName" v-model="destination.name">
                                        <label class="form-label" for="tourName">Destination Name:</label>
                                    </div>
                                </div>
                                <!-- Age -->
                                <div class="container-fluid">
                                    <div class="custom form-floating mt-3">
                                        <input type="number" class="form-control" id="tourName" placeholder="Tour Name"
                                            name="tourName" v-model="destination.age">
                                        <label class="form-label" for="tourName">Age: </label>
                                    </div>
                                </div>
                            </div>
                            <!-- Description -->
                            <div class="container-fluid">
                                <div class="description custom form-floating mt-3">
                                    <textarea type="text" class="form-control description" id="tourName"
                                        placeholder="Description" name="tourName" v-model="destination.description" />
                                    <label class="form-label" for="tourName">Description:</label>
                                </div>
                            </div>
                        </div>
                        <div
                            class="container-fluid frame-price d-flex justify-content-between align-items-center gap-1 mt-3">
                            <h5 class="price container-fluid">Price (VND): </h5>
                            <div class="price-input d-flex justify-content-center align-items-center gap-1">
                                <div class="container-fluid min">
                                    <div class="custom form-floating">
                                        <input type="text" class="form-control" id="tourName" placeholder="Tour Name"
                                            name="tourName" v-model="destination.price_bottom">
                                        <label class="form-label" for="tourName">Min</label>
                                    </div>
                                </div>
                                <p> - </p>
                                <div class="container-fluid max">
                                    <div class="custom form-floating">
                                        <input type="text" class="form-control" id="tourName" placeholder="Tour Name"
                                            name="tourName" v-model="destination.price_top">
                                        <label class="form-label" for="tourName">Max</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="container-fluid frame-time d-flex align-items-center mt-3">
                            <!-- Durations -->
                            <div class="container-fluid">
                                <div class="custom form-floating mt-3">
                                    <input type="number" class="form-control" id="tourName" placeholder="Tour Name"
                                        name="tourName" v-model="destination.duration">
                                    <label class="form-label" for="tourName">Duration:</label>
                                </div>
                            </div>
                            <!-- Open Time -->
                            <div class="">
                                <div class="custom container-fluid form-floating mt-3">
                                    <input type="time" class="form-control" id="tourName" placeholder="Tour Name"
                                        name="tourName" v-model="destination.opentime">
                                    <label class="form-label mx-3" for="tourName">Opening Time:</label>
                                </div>
                            </div>
                        </div>
                        <div class="container-fluid frame-address">
                            <div class="frame-1 d-flex justify-content-around align-items-center mt-3">
                                <h5 class="address">Address: </h5>
                            </div>
                            <!-- Distric & Ward -->
                            <div class="frame-2 d-flex">
                                <!-- Select Location -->
                                <div class="frame-select-location">
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
                                        <!-- Tùy chọn các thành phố -->
                                        <button class="dropdown-item" v-for="city in cities" :key="city.id"
                                            @click="selectCity(city.id)">
                                            {{ city.name }}
                                        </button>
                                    </div>
                                </div>
                                <!-- District -->
                                <div class="container-fluid">
                                    <div class="custom form-floating mt-3">
                                        <input type="text" class="form-control" id="tourName" placeholder="Tour Name"
                                            name="tourName" v-model="destination.address.district">
                                        <label class="form-label" for="tourName">District:</label>
                                    </div>
                                </div>
                            </div>
                            <!-- Street -->
                            <div class="frame-3 d-flex justify-content-around align-items-center">
                                <!-- Ward -->
                                <div class="container-fluid">
                                    <div class="custom form-floating mt-3">
                                        <input type="text" class="form-control" id="tourName" placeholder="Tour Name"
                                            name="tourName" v-model="destination.address.ward">
                                        <label class="form-label" for="tourName">Ward: </label>
                                    </div>
                                </div>
                                <!-- Ward -->
                                <div class="container-fluid">
                                    <div class="custom form-floating mt-3">
                                        <input type="text" class="form-control" id="tourName" placeholder="Tour Name"
                                            name="street" v-model="destination.address.street">
                                        <label class="form-label" for="tourName">Street: </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="frame-1 d-flex justify-content-around align-items-center mt-5">
                            <h5 class="address d-flex gap-2 align-items-baseline">Photo: <p class="optional">(Optional)
                                </p>
                            </h5>
                        </div>
                        <div class="frame-photo d-flex flex-column gap-5">
                            <!-- Current Image -->
                            <div class="frame-image d-flex justify-content-center align-items-center flex-column gap-3">
                                <h6 class="image">Current Image</h6>
                                <div class="current-image grid">
                                    <div v-for="photo in destination.images" :key="photo.id" class="image-item d-flex">
                                        <img class="img" :src="photo.url" alt="">
                                        <button class="remove-button" @click.stop="removeExistingImage(photo.id)">
                                            <svg fill="currentColor" width="12px" height="12px"
                                                xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512">
                                                <path
                                                    d="M416 208H32c-17.7 0-32 14.3-32 32v32c0 17.7 14.3 32 32 32h384c17.7 0 32-14.3 32-32v-32c0-17.7-14.3-32-32-32z" />
                                            </svg>
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- New Image -->
                            <div
                                class="frame-image d-flex justify-content-center align-items-center flex-column gap-3 mt-5">
                                <h6 class="image">Add New Image</h6>
                                <div class="new-image grid">
                                    <div v-for="(photo, index) in previewNewImages" :key="index"
                                        class="image-item d-flex ">
                                        <img class="img" :src="photo" alt="">
                                        <button class="remove-button" @click.stop="removeNewImage(index)">
                                            <svg fill="currentColor" width="12px" height="12px"
                                                xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512">
                                                <path
                                                    d="M416 208H32c-17.7 0-32 14.3-32 32v32c0 17.7 14.3 32 32 32h384c17.7 0 32-14.3 32-32v-32c0-17.7-14.3-32-32-32z" />
                                            </svg>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="container-fluid photo-upload-box">
                        <input type="file" @change="handleNewImageUpload" multiple
                            class="container-fluid photo-input" />
                        <p class="photo-upload-text">
                            Click to add photos <br /> or drag and drop
                        </p>
                    </div>

                    <div class=" d-flex justify-content-center gap-5">
                        <button class="container-fluid button cancel submit" type="button" @click="cancelUpdate">
                            Cancel
                        </button>
                        <button class="container-fluid button submit" type="button" @click="updateDestination">
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
// import Business_Dest_ViewModel from '@/components/viewModels/Business_Dest_ViewModel';
import Business_DestinationViewModel from '@/components/viewModels/Business_DestinationViewModel';
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
    selectedCityName
} = Business_DestinationViewModel()

onMounted(() => {
    fetchCities();
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

.description {
    min-height: 80px;
}

.price,
.address {
    font-weight: bold;
}

.optional {
    font-size: 16px;
    opacity: 0.8;
}

/* Drop Down */
.dropdown-button {
    min-width: 180px;
    padding: 10px;
    border-radius: 30px;
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

.img {
    aspect-ratio: 1/1;
    height: 150px;
    border-radius: 10px;
}

.frame-photo {
    margin-bottom: 50px;
}

.grid {
    display: grid;
    gap: 30px;
    grid-template-columns: repeat(5, 1fr);
}

.image {
    text-decoration: underline;
    text-underline-offset: 7px;
    font-weight: 900;
}

.remove-button {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 30px;
    height: 30px;
    background-color: #EDF6F9;
    border: none;
    border-radius: 50%;
    color: #13357B;
    cursor: pointer;
    transition: background-color 0.3s ease;
    position: relative;
    margin-top: 6px;
    margin-left: -38px;
    /* z-index: 20;     */
}

.remove-button:hover {
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

.photo-upload-box {
    margin-top: 30px;
    border: 2px dashed #CAF0F8;
    padding: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    text-align: center;
    height: 100px;
}

.photo-input {
    position: absolute;
    opacity: 0;
    width: 100%;
    height: 100%;
    cursor: pointer;
}
</style>