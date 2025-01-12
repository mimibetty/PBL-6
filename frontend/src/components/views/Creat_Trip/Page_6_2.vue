<template>
    <div class="container-fluid-1">
        <div class="container-fluid">
            <div class="container-fluid frame-title" style="width: 100vw;">
                <h1>Name your trip</h1>
                <h5>Organize your saves and create a custom your trip</h5>
            </div>

            <div class="container frame-name">
                <div class="container-fluid">
                    <form class="search-container" @submit.prevent="finishItinerary">
                        <input type="text"
                               v-model="itineraryName"
                               placeholder="Your itinerary name"
                               class="itinerary-input form-control" />
                    </form>
                </div>
            </div>

            <div id="loading-indicator" style="display: none; text-align: center; padding: 10px; color:blue; font-weight: 700;">
                <div class="spinner"></div>
                <span>Loading...</span>
            </div>

            <div class="container-fluid frame-button px-5">
                <button class="button back" @click="goBack" >Back</button>
                <button 
                        @click="finishItinerary"
                        class="button next-button">Create</button>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: "Page_6_2",
    methods: {
        // Method for 'Back' button (to go to the previous page)
        goBack() {
            this.$router.push({name: 'Page_5'}); // This will take the user to the previous page in the history
        },
        goCreate() {
            this.$router.push({name: 'Page_7'});
        }
    }
}
</script>

<script setup>
import CreateTrip from '../../viewModels/CreateTripViewModel';


const {
    itineraryName, 
    finishItinerary,
} = CreateTrip();

</script>

<style scoped>
.container-fluid-1 {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 100vw;
    height: 100vh;
    margin: 0;
    padding: 0;
    overflow: hidden;
}
.frame-title{
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    margin-top: 50px;
    color: #00B4D8;
}
.frame-title h1{
    font-weight: 900;
    font-size: 60px;
}
.frame-title h5{
    color: #13357B;
}
.frame-name{
    margin-top: 150px;
}
.search-container {
    display: flex;
    align-items: center;
    flex-direction: column;
    justify-content: center;
    margin-top: 100px;
    gap: 20px;
}
.itinerary-input{
    flex: 1;
    padding: 1.5vh;
    height: 80px;
    border: 1px solid #00B4D8;
    border-radius: 100px;
    background-color: #CAF0F8;
    color: #13357B;
    padding-left: 50px;
    font-size: 25px;
}
.itinerary-input::placeholder {
    color: #00B4D8;
    opacity: 0.7;
}
.itinerary-input:focus {
    background-color: #90e0ef;
}
.itinerary-input:focus::placeholder {
    color: #13357B;
}
.frame-button {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 200px;
    margin-bottom: 66.8px;
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
/* Spinner Effect */
.spinner {
    width: 40px;
    height: 40px;
    border: 4px solid rgba(19, 53, 123, 0.2);
    border-top: 4px solid #13357B;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin: 10px auto;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}
</style>