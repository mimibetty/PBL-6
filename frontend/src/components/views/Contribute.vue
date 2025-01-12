<template>
    <div class="titlte">
        <div class="container-fluid contribute">
            <p>Contribute</p>
        </div>
        <div class="d-flex gap-3">
            <button class="write-review" v-if="canReview" @click="writeReview(destination_id)">Write Review</button>
            <button class="write-review" @click="uploadPicture(destination_id)">Upload Picture</button>
        </div>
    </div>

    <div class="frame-evaluate-review">
        <!-- Evaluate -->
        <div class="frame-evaluate">
            <div class="container-fluid evaluate p-2">
                <h1 style="font-weight: 900;">Evaluate</h1>
            </div>
            <div class="rating">
                <h2>{{ rating }}</h2>
                <div class="circle-container">
                    <div v-for="(star, index) in stars" :key="index">
                        <img :src="star" alt="Star" class="star"/>
                    </div>
                </div>
            </div>
            <div class="container-fluid type-rating">
                <div class="container-fluid type-rating">
                <div class="row" v-for="(ratingInfo, label) in ratings" :key="label">
                    <!-- Rating Row -->
                    <div class="col-10 d-flex align-items-center">
                    <!-- Rating Label -->
                        <div class="col-5 rating-label">{{ label }}</div>
                        <!-- Rating Bar Container -->
                        <div class="col-5 rating-bar-container">
                            <div class="rating-bar" :style="{ width: ratingInfo.percentage + '%' }">
                            </div>
                        </div>
                    </div>
                    <!-- Count Rating -->
                    <div class="col-2 count-rating">{{ ratingInfo.count }}</div>
                </div>
            </div>
            </div>
            <div class="description-container" v-if="description">
                <h3 class="description-title">About the Place</h3>
                <span class="description-content">{{ description }}</span>
            </div>
        </div>
        <!-- Review -->
        <div class="frame-review">
            <div class="filter-bar-container">
                <select v-model="selectedRating" @change="filterComments" class="filter-select">
                    <option value="">All Ratings</option>
                    <option v-for="n in 5" :key="n" :value="n">{{ n }} Stars</option>
                </select>
            </div>

            <div v-if="filteredComments.length > 0" class="container-fluid comment-list">
                <div v-for="comment in filteredComments" :key="comment.id" class="comment">
                    <A_Comment :imageUrl="comment.user?.userInfo?.image?.url || ''"
                                :userName="comment.user?.username || 'Unknown User'"
                                :stars="generateStars(comment.rating)"
                                :title="comment.title"
                                :date_comment="comment.date_create"
                                :comment="comment.content"
                                :condition="comment.images"
                                :canedit="comment.user_id === user"
                                :id="comment.id"
                                :URL="comment.images"/>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import generateViewModel from '../viewModels/generate_ratingViewModel';
const { generateStars } = generateViewModel();
import A_Comment from './A_Comment.vue';

const writeReview = (id) => {
    window.location.assign(`/Review/Write/${id}`);
};
const uploadPicture = (id) => {
    window.location.assign(`/Review/Upload/${id}`);
};

const props = defineProps({
  rating: { type: Number, required: true },
  ratings: { type: Object, default: () => ({}) },
  stars: { type: Array, required: true },
  commentList: { type: Array, required: true },
  destination_id: { type: Number, required: true },
  user: { type: Number, required: true },
  description: { type: String, required: false },
  canReview: { type: Boolean }
});

const selectedRating = ref('');
const filteredComments = computed(() => {
    if (!selectedRating.value) return props.commentList;
    return props.commentList.filter(comment => comment.rating === parseInt(selectedRating.value));
});

const filterComments = () => {
    console.log('Filtering comments with rating: ', selectedRating.value);
};
</script>

<style scoped>
.titlte{
    margin-top: 30px;
    display: flex;
    flex-direction: column;
    gap: 30px;
}
.contribute p{
    font-size: 40px;
    font-weight: 900;
}
.container-fluid{
    color: #13357B;
}
.write-review{
    font-size: 20px;
    font-weight: bold;
    color: #13357B;
    background-color: transparent;
    border: 2px solid #13357B;
    border-radius: 40px;
    padding: 15px 55px;
    transition: all 0.5 ease-in-out;
}
.write-review:hover{
    background-color: #bde0fe;
    color: #13357B;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
    transform: translateY(-3px);
    transition: 0.25 ease-in-out;
}
.frame-evaluate-review{
    margin-top: 40px;
    display: grid;
    grid-template-columns: 32% 53%;
    gap: 15%;
}
.rating{
    display: flex;
    align-items: center;
    gap: 20px;
    margin-left: 10px;
    color: #13357B;
}
.rating h1{
    font-size: 30px;
    font-weight: bold;
}
.circle-container{
    display: flex;
    gap: 3px;
    margin-bottom: 10px;
}
.circle-container img{
    width: 20px;
    height: 20px;
}
.type-rating{
    display: flex;
    margin-top: 20px;
    flex-direction: column;
    gap: 15px;
    font-size: 25px;
}
.rating-row{
    display: flex;
    align-items: center;
}
.rating-label{
    font-weight: 800;
}
.rating-bar-container {
  width: 60%; 
  height: 20px; 
  background-color: #CAF0F8; 
  position: relative;
  border-radius: 10px; 
}
.rating-bar {
  height: 100%; 
  background-color: #13357B; 
  border-radius: 10px; 
  transition: width 0.3s ease; 
}
.search-bar{
    width: 100%;
    display: flex;
    align-items: center;
}
.search-bar input{
    width: 100%;
    padding: 10px 25px;
    border-radius: 25px;
    border: 2px solid #13357B;
    outline: none;
    color: #13357B
}
input::placeholder{
    color: #0077b6;
}
input:focus{
    background-color: #caf0f8;
    box-shadow: 0px 5px 10px rgba(19, 53, 123, 0.25)
}
.icon-search{
    border:none;
    background-color: transparent;
    margin-left: -55px;
}
.icon-search svg{
    stroke: #13357B;
}
.icon-search:hover svg{
    stroke: #0077b6;
}
.comment-list{
    margin-top: 50px;
}
.description-container {
    margin-top: 30px;
    background-color: #EDF6F9;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.15);
}
/* Tiêu đề của phần mô tả */
.description-title {
    font-size: 24px;
    font-weight: bold;
    color: #13357B;
    margin-bottom: 10px;
}

/* Nội dung mô tả */
.description-content {
    font-size: 18px;
    color: #24478f;
}

.filter-bar-container {
    display: flex;
    margin-bottom: 20px;
}
.filter-select {
    padding: 10px 20px;
    border-radius: 25px;
    border: 2px solid #13357B;
    color: #13357B;
    background-color: #fff;
    outline: none;
}
.filter-select:focus {
    background-color: #caf0f8;
    box-shadow: 0px 5px 10px rgba(19, 53, 123, 0.25);
}
.count-rating {
    font-size: 20px;
    font-weight: 800;
    
}

</style>