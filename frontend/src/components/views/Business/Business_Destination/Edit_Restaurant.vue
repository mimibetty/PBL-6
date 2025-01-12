<template>
    <div class="header-container">
        <header_For_company/>
    </div>

    <!-- Main Content -->
     <!-- Set up grid layout for responsive -->
    <div class="container-fluid">
        <div class="container-fluid">
            <div class="container-fluid frame-overall">
                <div class="container-fluid overall">
                    <!-- Main Context -->
                    <div class="container-fluid frame-main d-flex flex-column justify-content-center align-items-center gap-3">
                        <div class="frame-title">
                            <h1>Update Restaurant</h1>
                        </div>
                        <div class="container-fluid frame-info">
                            <div class="frame-name dest-location d-flex justify-content-center ">
                                <!-- Name of destination -->
                                <div class="container-fluid">
                                    <div class="custom form-floating mt-3">
                                        <input disabled type="text" class="form-control disabled" id="tourName" placeholder="Tour Name" name="tourName" v-model="destination.name">
                                        <label class="form-label" for="tourName">Destination Name:</label>
                                    </div>
                                </div>
                            </div>
                            <!-- Feature -->
                            <div class="container-fluid">
                                <div class="description custom form-floating mt-3">
                                    <textarea type="text" class="form-control description" id="tourName" placeholder="Description" name="tourName" v-model="destination.restaurant.feature"/>
                                    <label class="form-label" for="tourName">Feature:</label>
                                </div>
                            </div>
                        </div>
                        <div class="frame-name container-fluid dest-location d-flex justify-content-center ">
                            <!-- Special Diet -->
                            <div class="container-fluid">
                                <div class="custom form-floating mt-3">
                                    <input type="text" class="form-control" id="tourName" placeholder="Tour Name" name="tourName" v-model="destination.restaurant.special_diet">
                                    <label class="form-label" for="tourName">Special Diet:</label>
                                </div>
                            </div>
                            <!-- Meak -->
                            <div class="container-fluid">
                                <div class="custom form-floating mt-3">
                                    <input type="text" class="form-control" id="tourName" placeholder="Tour Name" name="tourName" v-model="destination.restaurant.meal">
                                    <label class="form-label" for="tourName">Meal: </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class=" d-flex justify-content-around gap-4">
                        <button class="container-fluid button cancel submit" type="button"
                                @click="cancelUpdate">
                            Cancel
                        </button>
                        <button class="container-fluid button submit" type="button"
                                @click="updateRestaurant">
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
} =  Business_DestinationViewModel()

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
    color:#13357B !important;
    font-size: 18px;
    background-color: transparent !important;
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
    min-height: 80px;
}
.price, .address {
    font-weight: bold;
}
.optional {
    font-size: 16px;
    opacity: 0.8;
}
/* Drop Down */
.dropdown-button{
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

.frame-photo{
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
.remove-button{
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
.button{
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
.disabled {
    background-color: rgba(19, 53, 123, 0.12) !important;
}
</style>