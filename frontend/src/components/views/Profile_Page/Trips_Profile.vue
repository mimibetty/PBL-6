<template>
    <div class="frame-trip">
        <div class="container d-flex justify-content-between mt-5">
            <p>My Trips</p>
            <div class="">
                <button @click="navigateToBuildTrip">
                    <svg width="50px" height="50px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M6 12H18M12 6V18" stroke="#currentColor" stroke-width="2" stroke-linecap="round"
                            stroke-linejoin="round" />
                    </svg>
                    Create a new trip
                </button>
            </div>
        </div>
        <div class="list-trip-items">
            <Trips_Item v-for="trip in trips" :key="trip.id" :trip="trip" />
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import TripViewModel from '../../viewModels/TripViewModel';
const { fetchTripByUser } = TripViewModel();
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
.frame-trip {
    width: 100%;
}

.container p {
    color: #13357B;
    font-size: 40px;
    font-weight: 900;
}

.sort {
    display: grid;
    grid-template-columns: 60% 40%;
}

.frame-sort {
    grid-column: 2/3;
    color: #13357B;
}

.select-selected {
    padding: 10px;
    background-color: #EDF6F9;
    border-radius: 10px;
    cursor: pointer;
    stroke: #13357B;
    border: 1px solid #13357B;
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .07), 0 6px 18px -1px rgba(19, 53, 123, .04) !important;
}

.select-selected:hover {
    background-color: #13357B;
    stroke: #CAF0F8;
}

.select-selected:hover {
    color: #CAF0F8;
}

.select-selected {
    font-weight: bold;
}

.select-items {
    display: block;
    width: 100%;
    background-color: #EDF6F9;
    border-radius: 10px;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.5);
    list-style-type: none;
    padding: 0;
    margin-top: 5px;
    z-index: 20;
}

.select-items li {
    padding: 10px;
    color: #13357B;
    cursor: pointer;
}

.select-items li:hover {
    background-color: #CAF0F8;
    border-radius: 10px;
}

.dropdown-icon {
    margin: 0px 0 0 50px;
}

/* CSS chỉ cho button trong container-fluid-1 */
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
    flex: 1;
    /* Để hai nút cách đều và chiếm cùng một khoảng rộng */
}

button:hover {
    background-color: #13357B;
    color: #CAF0F8;
    stroke: #CAF0F8;
}

.list-trip-items {
    display: flex;
    flex-direction: column;
    gap: 20px;
    align-items: center;
    width: 100%;
    height: 100%;
    margin-top: 0px
}
</style>