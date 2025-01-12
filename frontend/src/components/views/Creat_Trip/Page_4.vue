<template>
    <div class="container-fluid-1">
        <div class="container-fluid">
            <div class="container-fluid">
                <div class="container-fluid">
                    <div class="container-fluid frame-title">
                        <h1>{{ tripStore.selectedDestination.name  }}</h1>
                    </div>
                    <div class="container-fluid line"></div>
                    <div class=" title desinations">
                        <span>Exploring the Lively Cultural Heritage and Natural Beauty of Central Viet Nam</span>
                        <div class="container-fluid context grid-items">
                            <Item v-for="(place, index) in destinations" :key="index"
                                :imageUrl="place.images[0]?.url"
                                :name="place.name"
                                :stars="generateStars(place.rating)"
                                :id="place.id"
                                @click="togglePickStatus(place.id, 'destination')"/>
                        </div>
                    </div>
                    <div class="container-fluid line"></div>
                    <div class="container-fluid title restaurants">
                        <span>Local Restaurant Picks</span>
                        <span class="description">Here are some local favorites.</span>
                        <div class="container-fluid grid-items">
                            <Item v-for="(place, index) in restaurants" :key="index"
                                :imageUrl="place.images[0]?.url"
                                :name="place.name"
                                :stars="generateStars(place.rating)"
                                :id="place.id"
                                @click="togglePickStatus(place.id, 'restaurant')"/>
                        </div>
                    </div>
                    <div class="container-fluid line"></div>
                    <div class="container-fluid title hotels">
                        <span>Places to stay</span>
                        <span class="description">We've also recommended some places to stay during your trip.</span>
                        <div class="container-fluid grid-items">
                            <Item v-for="(place, index) in hotels" :key="index"
                                :imageUrl="place.images[0]?.url"
                                :name="place.name"
                                :stars="generateStars(place.rating)"
                                :id="place.id"
                                @click="togglePickStatus(place.id, 'hotel')"/>
                        </div>
                    </div>

                    <div class="container-fluid frame-button">
                        <button class="button back" @click="goBack" >Back</button>
                        <button class="button next" @click="goNext" >Next</button>
                    </div>
                    <!-- Pick All Toggle -->
                    <div class="container frame">
                        <div class="float-button">
                            <label class="toggle-switch">
                                <input type="checkbox" v-model="isAllSelected">
                                <span class="slider"></span>
                            </label>
                            <label class="select-all-label">{{ isAllSelected ? 'Deselect All' : 'Select All' }}</label>
                            <label class="count-label">({{ selectedPlace.length }}/{{ places.length }})</label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { useTripStore } from '@/store/useTripStore';
import { ref, computed, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import CreateTrip from '../../viewModels/CreateTripViewModel';
import GenerateStars from '../../viewModels/generate_ratingViewModel';
import Item from './Item.vue';

const router = useRouter();
const tripStore = useTripStore();

const {
    getPlaceData,
    destinations,
    hotels,
    restaurants,
    places,
    togglePickStatus,
    updateDestinations,
    selectedPlace,
    isAllSelected,
    selectAll,
    picked
} = CreateTrip();

const { generateStars } = GenerateStars();

onMounted(async () => {
    await getPlaceData();
});

const goBack = () => {
    router.push({ name: 'Page_3' });
};

const goNext = () => {
    updateDestinations();
    router.push({ name: 'Page_5' });
};

watch(isAllSelected, (newValue) => {
    selectAll(newValue);
});
</script>

<style scoped>
.container-fluid-1 {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 100vw;
    min-height: 100vh;
    margin: 0;
    padding: 0;
    overflow: hidden;
}
.frame-title{
    margin-top: 50px;
    color: #13357B;
}
.frame-title h1{
    font-weight: 900;
    font-size: 60px;
}
.title {
    display: flex;
    flex-direction: column;
    gap: 25px;
    margin: 30px 0;
}
.title span {
    font-size: 25px;
    font-weight: 900;
    color: #13357B;
}
.grid-items{
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    justify-content: space-around;
    gap: 35px;
    align-items: center;
}
.line {
    width: 95%;
    height: 1px;
    background-color: #13357B;
    margin-top: 30px;
    border-radius: 20px;
}
.description {
    font-size: 20px !important;
    font-weight: 500 !important;
}
.frame-button {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 50px;
    margin-bottom: 80px;
}
.button {
    padding: 10px 50px;
    border: none;
    border-radius: 30px;
    background-color: #00B4D8;
    color: #EDF6F9;
    cursor: pointer;
    transition: background-color 0.3s ease;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.2);
}
button:hover {
    background-color: #13357B;
    color: #EDF6F9
}
.float-button {
    display: flex;
    padding: 15px;
    background-color: #13357B;
    border-radius: 10px;
    box-shadow: 0px -5px 10px rgba(19, 53, 123, 0.25);
    gap: 20px;
    width: 400px;
    align-items: center;
    justify-content: center;
    position: fixed; /* Fix the position of the button */
    bottom: 100px; /* Set the margin from the bottom of the screen */
    left: 50%; /* Center the button horizontally */
    transform: translateX(-50%); /* Adjust for centering */
}
.toggle-switch {
    position: relative;
    display: inline-block;
    width: 80px;
    height: 34px;
}

.toggle-switch input {
    opacity: 0;
    width: 0;
    height: 0;
}

.slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #EDF6F9;
    transition: .4s;
    border-radius: 34px;
}

.slider:before {
    position: absolute;
    content: "";
    height: 26px;
    width: 26px;
    left: 4px;
    bottom: 4px;
    background-color: #0077b6;
    transition: .4s;
    border-radius: 50%;
}

input:checked + .slider {
    background-color: #a3bcf9;
}

input:checked + .slider:before {
    transform: translateX(45px);
}

label {
    color: #EDF6F9;
    font-size: 18px;
    font-weight: 900;
}
</style>
