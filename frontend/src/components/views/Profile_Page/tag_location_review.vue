<template>
    <div class="container-fluid-1">
        <img v-if="destination" :src="destination?.images && destination.images[0] ? destination.images[0].url : '/blue-image.jpg'" alt="pic" class="img-location"/>
        <div class="name-of-location">
            <span>{{ destination?.name || tour?.name }}</span>
        </div>

        <div class="rating d-flex">
            <div v-for="(star, index) in generateStars(destination?.rating)" v-if="destination" :key="index">
                <img :src="star" alt="Star" class="star"/>
            </div>
            <div v-for="(star, index) in generateStars(tour?.rating)" v-if="tour" :key="index">
                <img :src="star" alt="Star" class="star"/>
            </div>
        </div>

        <div class="">
            <div class="address-of-location">
                <span v-if="destination">{{ destination?.address?.district }}, {{ city?.name }}</span>
                <span v-if="tour">{{ city?.name }}</span>
            </div>
        </div>
    </div>
</template>
<script setup>
import { ref, onMounted } from 'vue';
import UserReviewViewModel from '../../viewModels/UserReviewViewModel';
import TourViewModel from '../../viewModels/TourViewModel';
import generateViewModel from '../../viewModels/generate_ratingViewModel';


// Khai báo props
const props = defineProps({
  destID: {
    type: Number,
  },
  tourID: {
    type: Number,
  },
});

const { loadDestination, loadCity } = UserReviewViewModel();
const { loadTourById } = TourViewModel();
const {
    generateStars,
  } = generateViewModel();
const destination = ref(null);
const tour = ref(null);
const city = ref(null);

// Tải dữ liệu khi component được mount
onMounted(async () => {
    // Sử dụng props.destID thay vì destID
    if(props.destID != null){
        destination.value = await loadDestination(props.destID);
    }
    if(props.tourID != null){
        tour.value = await loadTourById(props.tourID);
    }
    if(destination.value != null){
        city.value = await loadCity(destination.value.address.city_id);
    } else {
        city.value = await loadCity(tour.value.city_id);
    }
    
});
</script>
<script>
export default {
    name: "tag_location_review",

}
</script>

<style scoped>
.container-fluid-1{
    background-color: #CAF0F8;
    width: fit-content;
    color: #13357B;
    border-radius: 10px;
    border: 1px solid #13357B;
    gap:10px;   
    display: grid;
    padding: 10px;
    grid-template-areas: "img name-of-location"
                         "img rating"
                         "img location";
}
.img-location {
    grid-area: img;
    justify-content: center;
    width: 110px;
    height: 110px;
    border-radius: 10px;
}
.name-of-location {
    grid-area: name-of-location;
}
.name-of-location span{
    font-size: 15px;
    font-weight: 700;
}
.rating {
    grid-area: rating;
}
.rating img{
    width: 10px;
    height: 10px;
    margin-right: 2px;
}
</style>