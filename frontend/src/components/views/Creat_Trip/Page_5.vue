<template>
    <div class="container-fluid-1">
        <div class="container-fluid">
            <div class="container-fluid frame-title" style="width: 100vw;">
                <h1>Continue planning your trip</h1>
                <h5>Save your selections and get inspired with more more guidance</h5>
            </div>

            <div class="container frame-choice">
                <div class="container frame" @click="goCreate">
                    <div class="row create">
                        <div class="col-1">
                            <img class="img"  src="@/assets/svg/destination-1-svgrepo-com.svg" alt="">
                        </div>
                        <div class="col">
                            <h3>Create an itinerary</h3>
                            <h6>We’ll smartly organize your picks into a daily itinerary you can edit and add to.</h6>
                        </div>
                    </div>
                </div>
                <div class="container frame" @click="goSave">
                    <div class="row save">
                        <div class="col-1">
                            <img class="img" src="@/assets/svg/heart-alt-svgrepo-com.svg" alt="">
                        </div>
                        <div class="col">
                            <h3>Just save for now</h3>
                            <h6>We’ll keep all your selections together in a trip you can review, organize, and create an itinerary later.</h6>
                        </div>
                    </div>
                </div>
            </div>

            <div class="container-fluid frame-button px-5 -y-2">
                <button class="button back" @click="goBack" >Back</button>
            </div>
        </div>
    </div>
</template>

<script>
import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
import Calendar from './Calendar.vue';
export default {
    name: "Page_5",
    components: {
        Calendar,
    },
    
    methods: {
        // Method for 'Back' button (to go to the previous page)
        goBack() {
            this.$router.push({name: 'Page_4'}); // This will take the user to the previous page in the history
        },
        goCreate() {
            this.$router.push({name: 'Page_6_1'}); // This will take the user to the previous page in the history
        },
        goSave() {
            this.$router.push({name: 'Page_6_2'}); // This will take the user to the previous page in the history
        },
    }
}
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
    margin-top: 30px;
    color: #00B4D8;
}
.frame-title h1{
    font-weight: 900;
    font-size: 4vw;
}
.frame-title h5{
    color: #13357B;
}
.frame-choice{
    display: flex;
    flex-direction: column;
    gap: 20px;
    margin-top: 80px;
}
.frame {
    padding: 30px;
    border: 2px solid #00B4D8;
    border-radius: 20px;
    color: #13357B;
    box-shadow: 0px 5px 5px rgba(19, 53, 123, 0.25);
    background-color: #CAF0F8;
}
.img {
    width: 80px;
    height: 80px;
}
h3{
    font-weight: 700;
}
.create, .save {
    display: flex;
    gap: 50px;
    align-items: center;
}
.frame:hover {
    background-color: #00B4D8;
    transition: all 0.5s ease-in-out;
}
.frame-button {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 50px;
    margin-bottom: 35px;
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
</style>