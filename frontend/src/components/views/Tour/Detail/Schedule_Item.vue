<template>
    <div class="cards">
        <div class="">
            <div class="img-location">
                <img :src="destination?.images && destination.images[0] ? destination.images[0].url : '/blue-image.jpg'"
                    alt="pic" class="img-location" />
            </div>
            <div class="p-2">
                <div class="btn-heart">
                    <btn_heart :destID="destination.id" />
                </div>
            </div>
        </div>
        <div class="frame-rating">
            <div class="rating">
                <div v-for="(star, index) in generateStars(destination?.average_rating)" :key="index">
                    <img :src="star" alt="Star" class="star" />
                </div>
            </div>
            <p class="review-number">/ {{ destination.review_count }} reivews</p>
        </div>
        <div class="info-location">
            <div class="description">
                <span>{{ destination.description }}</span>
            </div>
        </div>
    </div>
</template>
<script setup>
import generateViewModel from '../../../viewModels/generate_ratingViewModel';
const {
    generateStars,
} = generateViewModel();
</script>
<script>

import btn_heart from '../../../views/btn_heart.vue';
export default {
    name: "Info_Card",
    components: {
        btn_heart
    },
    props: {
        destination: {
            type: Object,
            default: () => { }
        },
        imageUrl: String,
        rating: Number,
        reviewNumber: Number,
        description: String
    },
}

</script>

<style scoped>
img {
    width: 100%;
    height: 350px;
    object-fit: cover;
    border-radius: 20px;
}

.btn-heart {
    text-align: right;
    margin: -350px 3px 0 0px;
}

.frame-rating {
    display: flex;
}

.rating {
    display: flex;
    margin: 0px 0 0 10px;
}

.rating img {
    width: 20px;
    height: 20px;
}

.review-number {
    margin-top: 2px;
}

.cards {
    width: 90%;
    margin: 20px 0;
}
</style>