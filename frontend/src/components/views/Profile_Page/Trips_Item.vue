<template>
    <div class="trip-item">
        <div class="row w-100" @click="navigateToDetailTrip(trip.id)">
            <!-- Image Section (30%) -->
            <div class="col-3 p-2">
                <img src="@/assets/images/tms-hotel-da-nang-beach.jpg" alt="Avatar" class="ava"/>
            </div>
            
            <!-- Trip Name & Month Time Section (60%) -->
            <div class="col-7 p-2 d-flex flex-column">
                <!-- Name of Trip Section (50% Height) -->
                <div class="name-of-trip flex-grow-1">
                    <span>{{ trip?.name }}</span>
                </div>

                <!-- Month Time Section (50% Height) -->
                <div class="month-time flex-grow-1">
                    <div class="row info-of-trip">
                        <div class="col-sm-12 date-of-trip">
                            <svg fill="#13357B" width="30px" height="30px" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid">
                                <path d="M30.000,32.000 L2.000,32.000 C0.897,32.000 -0.000,31.103 -0.000,30.000 L-0.000,5.000 C-0.000,3.897 0.897,3.000 2.000,3.000 L10.000,3.000 L10.000,1.000 C10.000,0.448 10.448,-0.000 11.000,-0.000 C11.552,-0.000 12.000,0.448 12.000,1.000 L12.000,3.000 L20.000,3.000 L20.000,1.000 C20.000,0.448 20.448,-0.000 21.000,-0.000 C21.552,-0.000 22.000,0.448 22.000,1.000 L22.000,3.000 L30.000,3.000 C31.103,3.000 32.000,3.897 32.000,5.000 L32.000,30.000 C32.000,31.103 31.103,32.000 30.000,32.000 ZM22.000,5.000 L22.000,6.000 C22.000,6.552 21.552,7.000 21.000,7.000 C20.448,7.000 20.000,6.552 20.000,6.000 L20.000,5.000 L12.000,5.000 L12.000,6.000 C12.000,6.552 11.552,7.000 11.000,7.000 C10.448,7.000 10.000,6.552 10.000,6.000 L10.000,5.000 L2.000,5.000 L2.000,30.000 L29.997,30.000 L30.000,5.000 L22.000,5.000 ZM25.000,24.000 L23.000,24.000 C22.448,24.000 22.000,23.552 22.000,23.000 L22.000,21.000 C22.000,20.448 22.448,20.000 23.000,20.000 L25.000,20.000 C25.552,20.000 26.000,20.448 26.000,21.000 L26.000,23.000 C26.000,23.552 25.552,24.000 25.000,24.000 ZM25.000,16.000 L23.000,16.000 C22.448,16.000 22.000,15.552 22.000,15.000 L22.000,13.000 C22.000,12.448 22.448,12.000 23.000,12.000 L25.000,12.000 C25.552,12.000 26.000,12.448 26.000,13.000 L26.000,15.000 C26.000,15.552 25.552,16.000 25.000,16.000 ZM17.000,24.000 L15.000,24.000 C14.448,24.000 14.000,23.552 14.000,23.000 L14.000,21.000 C14.000,20.448 14.448,20.000 15.000,20.000 L17.000,20.000 C17.552,20.000 18.000,20.448 18.000,21.000 L18.000,23.000 C18.000,23.552 17.552,24.000 17.000,24.000 ZM17.000,16.000 L15.000,16.000 C14.448,16.000 14.000,15.552 14.000,15.000 L14.000,13.000 C14.000,12.448 14.448,12.000 15.000,12.000 L17.000,12.000 C17.552,12.000 18.000,12.448 18.000,13.000 L18.000,15.000 C18.000,15.552 17.552,16.000 17.000,16.000 ZM9.000,24.000 L7.000,24.000 C6.448,24.000 6.000,23.552 6.000,23.000 L6.000,21.000 C6.000,20.448 6.448,20.000 7.000,20.000 L9.000,20.000 C9.552,20.000 10.000,20.448 10.000,21.000 L10.000,23.000 C10.000,23.552 9.552,24.000 9.000,24.000 ZM9.000,16.000 L7.000,16.000 C6.448,16.000 6.000,15.552 6.000,15.000 L6.000,13.000 C6.000,12.448 6.448,12.000 7.000,12.000 L9.000,12.000 C9.552,12.000 10.000,12.448 10.000,13.000 L10.000,15.000 C10.000,15.552 9.552,16.000 9.000,16.000 Z"/>
                            </svg>
                            <span>{{ trip?.month_time }}</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Delete Button Section (10%) -->
            <div class="col-2 p-2 d-flex justify-content-end align-items-center">
                <button class="btn btn-danger delete-btn" @click.stop="deleteTripById(trip.id)">
                    <svg fill="#F60F0F" width="40px" height="40px" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid">
                        <path d="M12 4v-2h8v2h6v2h-1l-1 20h-16l-1-20h-1v-2h6z"/>
                    </svg>
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import TripViewModel from '../../viewModels/TripViewModel';
const { deleteTripById } = TripViewModel();
const navigateToDetailTrip = (trip_id) =>{
        window.location.assign(`/Trip/${trip_id}`);
};
</script>

<script>
export default {
    name: "Trip_Item",
    props: {
        trip: Object,
    }
}
</script>

<style scoped>
.trip-item {
    display: flex;
    margin: 20px 0;
    background-color: #CAF0F8;
    width: 99%;
    color: #13357B;
    border-radius: 10px;
    outline: 2px solid #13357B;
}

.trip-item:hover {
    cursor: pointer;
    transition: 0.7ms ease-in-out;
    transform: translateY(-5px);
    background-color: #CAF0F8;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
}

img {
    display: flex;
    width: 200px;
    height: 200px;
    object-fit: cover;
    border-radius: 10px;
}

.ava {
    display: flex;
    margin-top: -13px;
    margin-left: -0.8px;
    margin-bottom: -3px;
}

.col-sm-10 {
    display: grid;
    width: 100%;
    align-items: center;
    margin-left: 220px;
    margin-top: -200px;
}

.name-of-trip span {
    font-size: 30px;
    font-weight: 800;
}

.date-of-trip {
    display: inline-flex;
    align-items: center;
    margin: 0px 0 0 0px;
}

.date-of-trip span {
    font-size: 18px;
    gap: 10px;
    margin-left: 10px;
}

.date-of-trip button {
    font-size: 18px;
    font-weight: 800;
    color: #13357B;
    background-color: transparent;
    border: none;
    border-radius: 10px;
    padding: 10px 10px;
    text-decoration: underline;
    margin: 0 0 0 10px;
}

.date-of-trip button:hover {
    color: #CAF0F8;
    background-color: #13357B;
}

.delete-btn {
    background: none;
    border: none;
    cursor: pointer;
    padding: 5px;
}

.delete-btn svg {
    transition: transform 0.3s;
}

.delete-btn:hover svg {
    transform: scale(1.2);
}
</style>
