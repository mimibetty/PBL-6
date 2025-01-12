<template>
    <div class="frame-item">
        <div class="frame-image">
            <img class="img" :src="destination?.images[0]?.url ? destination?.images[0]?.url : '/blue-image.jpg'"
                alt="">
        </div>
        <div class="container-fluid frame-info d-flex flex-column justify-content-start">
            <h5 class="name-of-destination">{{ destination?.name }}</h5>
            <div class="frame-rating">
                <div class="rating">
                    <img v-for="(star, index) in generateStars(destination?.rating)" :src="star" :key="index"
                        class="circle-icon" />
                </div>
                <div class="reviews">
                    <p>/{{ destination?.review_count }} {{ destination?.review_count > 1 ? 'reviews' : 'review' }}</p>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import generate_ratingViewModel from '@/components/viewModels/generate_ratingViewModel';
const { generateStars } = generate_ratingViewModel();
</script>
<script>
import btn_heart from '../../btn_heart.vue';
export default {
    name: "Itinerary_Item",
    components: {
        btn_heart
    },
    props: {
        destination: Object
    }
}
</script>

<style scoped>
.frame-item {
    display: flex;
    flex-direction: row;
    padding: 15px;
    gap: 15px;
    transition: 0.7ms ease-in-out;
}

.frame-item:hover {
    cursor: pointer;
    transition: 0.7ms ease-in-out;
    transform: translateY(-5px);
    background-color: #CAF0F8;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
    border-radius: 15px;
}

.frame-image {
    display: flex;
}

.img {
    width: 200px;
    height: 200px;
    object-fit: cover;
    border-radius: 10px;
}

.frame-info {
    color: #13357B;
    margin-bottom: 10px;
}

h5 {
    font-weight: 600;
}

.frame-rating {
    display: flex;
    gap: 10px;
    font-size: 20px;
    margin-top: -5px;
}

.frame-rating img {
    width: 20px;
    height: 20px;
}

.reviews {
    margin-top: 3px;
}

.frame-tags {
    margin-top: -10px;
}

.rating-stars {
    display: flex;
    gap: 3px;
}

.circle-icon {
    width: 20px;
    height: 20px;
}
</style>