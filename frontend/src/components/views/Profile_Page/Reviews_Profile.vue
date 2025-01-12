<template>
    <div class="reviews">
        <Content_review v-for="review in reviewLists" :key="review.id" :review="review" :user="user" />
    </div>
</template>

<script setup>
import UserReviewViewModel from '../../viewModels/UserReviewViewModel';
import { ref, computed, onMounted, watch } from 'vue';
const {
    reviewList,
    user,
} = UserReviewViewModel();
const reviewLists = ref([]);
onMounted(async () => {
    reviewLists.value = await reviewList();
});
</script>

<script>
import Content_review from './Content_review.vue';
export default {
    name: "Reviews_Profile",
    components: {
        Content_review
    }
}
</script>

<style scoped>
.reviews {
    display: flex;
    flex-direction: column;
    gap: 20px;
    align-items: center;
    width: 100%;
    height: 100%;
    margin-top: 70px;
    margin-bottom: 50px;
}
</style>