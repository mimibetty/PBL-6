<template>
    <div class="container-fluid header">
        <Header />
        <Top_Button />
    </div>
    <div class="container-fluid">
        <div class="container-fluid">
            <div class="container-fluid frame-overall">
                <div class="container-fluid overall">
                    <div class="row">
                        <div class="d-flex justify-content-between">
                            <p class="container-fluid">My Trips</p>
                            <button class="button d-flex justify-content-center align-items-center"
                                @click="navigateToBuildTrip">
                                <svg width="50px" height="50px" viewBox="0 0 24 24" fill="none"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path d="M6 12H18M12 6V18" stroke="#currentColor" stroke-width="2"
                                        stroke-linecap="round" stroke-linejoin="round" />
                                </svg>
                                Create a new trip
                            </button>
                        </div>

                        <div class="list-trip-items">
                            <Trips_Item v-for="trip in trips" :key="trip.id" :trip="trip" class="custom" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</template>

<script setup>
import { ref, onMounted } from 'vue';
import TripViewModel from '../../viewModels/TripViewModel';
const { fetchTripByUser, deleteTripById } = TripViewModel();
const trips = ref([]);
onMounted(async () => {
    trips.value = await fetchTripByUser();
});
const navigateToDetailTrip = (trip_id) => {
    window.location.assign(`/Trip/${trip_id}`);
};
const navigateToBuildTrip = () => {
    window.location.assign('/Create_Trip/');
}
</script>

<script>
import Trips_Item from './Trips_Item.vue';
import Header from '../Header.vue';
import Trips_Item_no_date from './Trips_Item_no_date.vue';
import Tours_Item from './Tours_Item.vue';
import Top_Button from '../Top_Button.vue';
import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
import { onMounted } from 'vue';
export default {
    name: "Trips_Profile",
    components: {
        Trips_Item, Trips_Item_no_date,
        Tours_Item, Header, Top_Button
    },
    data() {
        return {
            isOpen: false,
            selectedOption: "Recently edited",
            options: ["Recently edited", "Recently created"]
        };
    },
    methods: {
        toggleDropdown() {
            this.isOpen = !this.isOpen;
        },
        selectOption(option) {
            this.selectedOption = option;
            this.isOpen = false;
        }
    }

};

</script>

<style scoped>
.frame-overall {
    display: grid;
    grid-template-columns: 5% 90% 5%;
}

.overall {
    grid-column: 2/3;
    margin-top: 180px;
}

p {
    color: #13357B;
    font-size: 40px;
    font-weight: 900;
}

.list-trip-items {
    display: flex;
    flex-direction: column;
    gap: 20px;
    align-items: center;
    width: 100%;
    height: 100%;
    margin-top: 0px;
}

/* Thay đổi cho button để căn giữa */
button {
    display: flex;
    gap: 10px;
    align-items: center;
    justify-content: center;
    padding: 15px 20px;
    border-radius: 15px;
    background-color: #EDF6F9;
    color: #13357B;
    stroke: #13357B;
    border: 1px solid #13357B;
    font-weight: bold;
    cursor: pointer;
    width: 100%;
    /* Để hai nút cách đều và chiếm cùng một khoảng rộng */
}

button:hover {
    background-color: #13357B;
    color: #CAF0F8;
    stroke: #CAF0F8;
}
</style>