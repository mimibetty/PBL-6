<template>
    <div class="content d-flex flex-column ">
        <!-- Info User Post like username activity, date post, avatar -->
        <div class="user-info p-3">
            <img :src="user?.user_info.image ? user.user_info.image.url : '/blue-image.jpg'" alt="Avatar" class="ava" />
            <div class="activity">
                <p>{{ user?.username }}</p>
                <span>wrote a review</span>
            </div>
            <div class="date-post">
                {{ review?.date_create }}
            </div>
        </div>

        <!-- Rating If is a review-->
        <div class="rating d-flex mx-3">
            <div v-for="(star, index) in generateStars(review?.rating)" :key="index">
                <img :src="star" alt="Star" class="star" />
            </div>
        </div>

        <!-- Title and Context Review -->
        <div class="title-content">
            <div class="title py-2 p-3">
                <p class="title-text">
                    {{ review?.title }}
                </p>
            </div>
            <span class="d-flex flex-wrap p-3">
                {{ review?.content }}
            </span>
            <div class="info-location p-3">
                <tag_location_review v-if="review?.destination_id" :destID="review?.destination_id"
                    :tourID="review?.tour_id" />
            </div>
        </div>

    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import generateViewModel from '../../viewModels/generate_ratingViewModel';

// Khai báo props
const props = defineProps({
    review: {
        type: Object,
        required: true,
    },
    user: {
        type: Object,
        required: true,
    },
});

const {
    generateStars,
} = generateViewModel();

</script>
<script>
import tag_location_review from './tag_location_review.vue';
export default {
    name: "Content_Review",
    components: {
        tag_location_review
    }

}
</script>

<style scoped>
.content {
    width: 100%;
    border-radius: 15px;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.3);
    z-index: 2;
}

.user-info {
    display: grid;
    grid-template-columns: 8% 90%;
    grid-template-areas: "avatar activity"
        "avatar date-post";
    align-items: center;
    color: #13357B;
    z-index: 5;
}

.user-info .ava {
    grid-area: avatar;
    width: 60px;
    height: 60px;
    border-radius: 50%;
}

.activity {
    grid-area: activity;
    display: flex;
    gap: 10px;
}

.user-info .activity p {
    font-weight: 700;
}

.user-info .date-post {
    grid-area: date-post;
}

.rating img {
    width: 20px;
    height: 20px;
}

.title-content {
    color: #13357B;
}

.title-content .title .title-text {
    font-size: 20px;
    font-weight: 700;
    text-decoration: underline;
}
</style>