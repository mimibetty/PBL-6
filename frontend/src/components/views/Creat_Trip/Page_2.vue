<template>
    <div class="container-fluid">
        <div class="container-fluid frame-title mx-3">
            <h1>When are you going?</h1>
            <h5>Choose a day range, up to 7 days</h5>
        </div>
        <Calendar class="p-2"/>
        <div class="container-fluid frame-dates">
            <p class="linked" @click="goMonth">I don't know my dates yet</p>
        </div>
        <div class="container-fluid frame-button px-5">
            <button class="back" @click="goBack" >Back</button>
            <button class="next" @click="goNext" >Next</button>
        </div>
    </div>
</template>

<script>
import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
import Calendar from './Calendar.vue';
export default {
    name: "Page_2",
    components: {
        Calendar,
    },
    methods: {
        // Method for 'Back' button (to go to the previous page)
        goBack() {
            this.$router.push({name: 'Page_1'}); // This will take the user to the previous page in the history
        },
        // Method for 'Next' button (to navigate to the next page)
        goNext() {
            this.$router.push({ name: 'Page_3' }); // Replace 'next-page' with the name of your target route
        },
        // Method for don't know day
        goMonth() {
            this.$router.push({name: 'Page_2_1'});
        },
    }
}
</script>

<script setup>
import CreateTripViewModel from '../../viewModels/Create_Trip_ViewModel/CreateTripViewModel';
const {
    searchQuery,
        suggestedDestinations,
        searchDestinations
} = CreateTripViewModel();
</script>

<style scoped>
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
.calendar {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 15px
}
.frame-button {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 50px;
    margin-bottom: 40px;
}
button {
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
}
.frame-dates {
    display: flex;
    align-items: center;
    justify-content: center;
    color: #13357B;
    font-size: 20px;
    text-decoration: underline;
    text-underline-offset: 7px;
    cursor: pointer;
}
.frame-dates:hover {
    color: #00B4D8;
}
</style>