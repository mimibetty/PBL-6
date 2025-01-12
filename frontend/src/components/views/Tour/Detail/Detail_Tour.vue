<template>
    <div class="container-fluid">
        <Header />
        <Top_Button />
    </div>
    <div class="container-fluid">
        <div class="container-fluid">
            <div class="container-fluid frame-overall">
                <div class="container-fluid overall">
                    <div class="container-fluid frame-detail">
                        <div class="frame-title d-flex justify-content-between">
                            <div class="left-info">
                                <div class="name-of-tour">
                                    <h2>{{ tour?.name }}</h2>
                                </div>
                                <div class="name-of-business">
                                    <p>By {{ user_create?.username }}</p>
                                </div>
                                <div class="frame-rating d-flex gap-3">
                                    <div class="rating">
                                        <div v-for="(star, index) in generateStars(tour?.rating)" :key="index">
                                            <img :src="star" alt="Star" class="star" />
                                        </div>
                                    </div>
                                    <div class="reviews">
                                        <p>/{{ tour?.numOfReviews }} reviews</p>
                                    </div>
                                </div>
                            </div>
                            <div class="btn-frame d-flex justify-content-between align-items-center gap-4">
                                <button v-if="token && tour?.user_id == user?.id" @click="navigateToEditTour(tour?.id)"
                                    class="btn-edit d-flex justify-content-center align-items-center gap-2">
                                    <svg fill="currentColor" width="18" height="18" xmlns="http://www.w3.org/2000/svg"
                                        viewBox="0 0 576 512">
                                        <path
                                            d="M402.6 83.2l90.2 90.2c3.8 3.8 3.8 10 0 13.8L274.4 405.6l-92.8 10.3c-12.4 1.4-22.9-9.1-21.5-21.5l10.3-92.8L388.8 83.2c3.8-3.8 10-3.8 13.8 0zm162-22.9l-48.8-48.8c-15.2-15.2-39.9-15.2-55.2 0l-35.4 35.4c-3.8 3.8-3.8 10 0 13.8l90.2 90.2c3.8 3.8 10 3.8 13.8 0l35.4-35.4c15.2-15.3 15.2-40 0-55.2zM384 346.2V448H64V128h229.8c3.2 0 6.2-1.3 8.5-3.5l40-40c7.6-7.6 2.2-20.5-8.5-20.5H48C21.5 64 0 85.5 0 112v352c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V306.2c0-10.7-12.9-16-20.5-8.5l-40 40c-2.2 2.3-3.5 5.3-3.5 8.5z" />
                                    </svg>
                                    Edit
                                </button>
                                <button v-if="token && tour?.user_id == user?.id" @click="navigateToDeleteTour(tour.id)"
                                    class="btn-delete d-flex justify-content-center align-items-center gap-2">
                                    <svg fill="currentColor" width="18" height="18" xmlns="http://www.w3.org/2000/svg"
                                        viewBox="0 0 448 512">
                                        <path
                                            d="M268 416h24a12 12 0 0 0 12-12V188a12 12 0 0 0 -12-12h-24a12 12 0 0 0 -12 12v216a12 12 0 0 0 12 12zM432 80h-82.4l-34-56.7A48 48 0 0 0 274.4 0H173.6a48 48 0 0 0 -41.2 23.3L98.4 80H16A16 16 0 0 0 0 96v16a16 16 0 0 0 16 16h16v336a48 48 0 0 0 48 48h288a48 48 0 0 0 48-48V128h16a16 16 0 0 0 16-16V96a16 16 0 0 0 -16-16zM171.8 50.9A6 6 0 0 1 177 48h94a6 6 0 0 1 5.2 2.9L293.6 80H154.4zM368 464H80V128h288zm-212-48h24a12 12 0 0 0 12-12V188a12 12 0 0 0 -12-12h-24a12 12 0 0 0 -12 12v216a12 12 0 0 0 12 12z" />
                                    </svg>
                                    Delete
                                </button>
                            </div>
                        </div>
                        <div class="frame-image">
                            <div class="item-1">
                                <img class="img-1" :src="images && images[0] ? images[0].url : '/blue-image.jpg'"
                                    alt="">
                            </div>
                            <div class="item-2">
                                <img class="img-2" :src="images && images[1] ? images[1].url : '/blue-image.jpg'"
                                    alt="">
                            </div>
                            <div class="item-3">
                                <img class="img-3" :src="images && images[2] ? images[2].url : '/blue-image.jpg'"
                                    alt="">
                            </div>
                        </div>
                        <div class="frame-info">
                            <div class="detail">
                                <Info_Card :maxAge="maxAge" :duration="tour?.duration"
                                    :totalbottom="totalPriceBottom" />
                            </div>
                            <div class="about">
                                <About :description="tour?.description" />
                            </div>
                        </div>
                        <div class="frame-tinerary">
                            <div class="frame-schedule">
                                <Schedule :destinations="tour?.destinations" />
                            </div>
                            <div class="frame-map">
                                <Map v-if="destListID.length > 0" :destinationID="destListID" />
                            </div>
                        </div>
                        <div class="frame-contribute">
                            <Contribute :commentList="reviews" :tour_id="Number(tourID)" :ratings="ratings || {}"
                                :rating="tour?.rating" :stars="generateStars(tour?.rating)" :user="user?.id || 0" />

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import TourViewModel from '../../../viewModels/TourViewModel';
import { ref, computed, onMounted, watch } from 'vue';
import { useRoute } from 'vue-router';
import generateViewModel from '../../../viewModels/generate_ratingViewModel';

const route = useRoute();
const tourID = route.params.id;

const {
    loadCities,
    loadTours,
    loadTourById,
    loadTourByCityId,
    loadUser,
    loadReviewByTourId,
    loadCurrentUser,
    fetchRatingTour,
    ratings
} = TourViewModel();

const {
    generateStars,
} = generateViewModel();

const tour = ref();
const cities = ref([]);
const user_create = ref(null);
const images = ref([]);
const maxAge = ref(null);
const reviews = ref([]);
const user = ref(null);
const token = ref(null);
const totalPriceBottom = ref(0);
const destListID = ref([]);

const navigateToEditTour = (id) => {
    window.location.assign(`/Business/Tour/Update/${id}`);
};

onMounted(async () => {
    // Load data
    tour.value = await loadTourById(tourID);
    console.log('Tour:', tour.value.user_id);
    destListID.value = tour.value.destinations.map(dest => dest.id);
    console.log('Dest List:', destListID.value);

    cities.value = await loadCities();
    user_create.value = await loadUser(tour.value.user_id);
    console.log('User Create:', user_create.value);

    reviews.value = await loadReviewByTourId(tourID);
    user.value = await loadCurrentUser();
    console.log('Current User:', user.value.id);

    // Check token
    token.value = sessionStorage.getItem('access_token');
    console.log('Token:', token);

    // Add images from destinations to the images array
    if (tour.value?.destinations?.length) {
        totalPriceBottom.value = tour.value.destinations.reduce((sum, destination) => {
            return sum + (destination.price_bottom || 0); // Add price_bottom if it exists
        }, 0);
        tour.value.destinations.forEach(destination => {

            if (destination.images?.length) {
                destination.images.forEach(image => {
                    images.value.push(image); // Add each image to the global images array
                });
            }
            if (destination.age !== undefined) {
                maxAge.value = maxAge.value === null
                    ? destination.age
                    : Math.max(maxAge.value, destination.age);
            }

        });
    }
    await fetchRatingTour(tourID);
});

const getCity = (city_id) => {
    return cities.value.find(city => city.id === city_id);
};
</script>
<script>
import Header from '../../Header.vue';
import Top_Button from '../../Top_Button.vue';
import Scroll_Bar_Component from '../../Scroll_Bar_Component.vue';
import Info_Card from './Info_Card.vue';
import About from './About.vue';
import Schedule from './Schedule.vue';
import Contribute from './Contribute.vue';
import Map from '../../Map/Map.vue';
export default {
    name: "Detail_Tour",
    components: {
        Header, Top_Button, Info_Card, About, Schedule, Contribute,
        Map
    }
}
</script>

<style scoped>
.frame-overall {
    display: grid;
    grid-template-columns: 5% 90% 5%;
}

.overall {
    grid-column: 2/3;
}

.frame-detail {
    margin-top: 200px;
    color: #13357B;
}

.name-of-tour h2 {
    font-weight: 900;
}

.name-of-business p {
    text-decoration: underline;
    text-underline-offset: 2px;
}

.rating {
    display: flex;
    margin: 0px 0 0 10px;
}

.rating img {
    width: 20px;
    height: 20px;
}

.reviews p {
    font-size: 20px;
}

.frame-image {
    display: grid;
    overflow: hidden;
    grid-template-columns: 60% 40%;
    grid-template-rows: minmax(0, 315px) minmax(0, 315px);
    grid-template-areas:
        "left top"
        "left bottom";
    gap: 10px;
    border-radius: 15px;
}

.item-1 {
    grid-area: left;
    position: relative;
}

.img-1,
.img-2,
.img-3 {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.frame-info {
    display: grid;
    grid-template-columns: 45% 52.8%;
    gap: 30px;
}

.frame-tinerary {
    margin: 20px 0 30px 0;
    display: grid;
    grid-template-columns: 45% 52.8%;
    gap: 30px;
}

.frame-map {
    border-radius: 15px;
    background-color: #EDF6F9;
    color: #13357B;
    border-radius: 20px;
    padding: 10px;
    height: fit-content;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
    font-size: 50px;
}

.btn-edit,
.btn-delete {
    border-radius: 10px;
    width: 110px;
    padding: 10px 20px;
}

.btn-edit {
    background-color: #4AA4D9;
    color: #EDF6F9;
    border: 1px solid #4AA4D9;
}

.btn-delete {
    background-color: #EDF6F9;
    color: #13357B;
    border: 1px solid #4AA4D9;
}

.btn-delete:hover,
.btn-edit:hover {
    background-color: rgba(74, 164, 217, 0.8);
    color: #EDF6F9;
}
</style>