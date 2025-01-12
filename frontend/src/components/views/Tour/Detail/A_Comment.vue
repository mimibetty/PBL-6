<template>
    <div class="container-fluid">
        <div class="container row info ">
            <div class="col-1">
                <img :src="imageUrl ? imageUrl : '/blue-image.jpg'" alt="User Image" class="user-image" />
            </div>

            <div class="col-6">
                <div class="container">
                    <div class="comment-content">
                        <h3>{{ userName }}</h3>
                    </div>
                    <div class="col rating-stars">
                        <img v-for="(star, index) in stars" :src="star" :key="index" class="circle-icon" />
                    </div>
                </div>
            </div>
            <div class="col-2 d-flex justify-content-end align-items-center update-container" v-if="canedit">
                <i class="icon-update" @click="updateReview(id)"></i>
                <i class="icon-delete" @click="deleteReview(id)"></i>
            </div>
        </div>
        <div class="container content-comment">
            <h4 class="title">{{ title }}</h4>
            <p>{{ date_comment }}</p>
            <h6>{{ comment }}</h6>
        </div>
        <div class="container img">
            <img v-if="condition" v-for="(img, index) in URL" :src="img.url" :key="index" alt="Review Image"
                class="review-image" />
        </div>
    </div>

    <div class="container-fluid line"></div>
</template>
<script setup>
import DeleteReview from '../../../viewModels/Review_DeleteViewModel'
const {
    deleteReview
} = DeleteReview();
const updateReview = (id) => {
    window.location.assign(`/Review/Tour/Update/${id}`);
};
</script>

<script>
export default {
    name: "A_Comment",
    props: {
        imageUrl: String,
        userName: String,
        stars: Array,
        title: String,
        date_comment: String,
        comment: String,
        condition: String,
        canedit: Boolean,
        URL: Array,
        id: Number
    }
}
</script>

<style>
.info {
    display: flex;
    align-items: center;
}

.user-image {
    width: 40px;
    height: 40px;
}

.rating-stars {
    display: flex;
    gap: 3px;
}

.circle-icon {
    width: 20px;
    height: 20px;
}

.content-comment {
    margin-top: 30px;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.review-image {
    margin-top: 20px;
    width: 250px;
    border-radius: 15px;
    margin-bottom: 20px;
}

.review-image:hover {
    cursor: pointer;
    transform: scale(1.2);
    max-width: 120%;
}

.line {
    margin: 20px 0;
    height: 2px;
    background-color: #13357B;
    border-radius: 5px;
}

i {
    margin-right: 8px;
    font-size: 16px;
    display: inline-block;
    font-weight: 900;
    font-family: "Font Awesome 5 Free";
}

.icon-update:before {
    content: "\f044";
    color: #007bff;
}

.update-container {
    display: flex;
    justify-content: flex-end;
    /* Căn icon sang phải */
    align-items: center;
}

.icon-update {
    font-size: 18px;
    color: #007bff;
    cursor: pointer;
    transition: transform 0.2s, color 0.2s ease;
}

.icon-update:hover {
    color: #0056b3;
    /* Màu khi hover */
    transform: scale(1.2);
    /* Phóng to nhẹ khi hover */
}

.icon-update:active {
    transform: scale(1);
    /* Trả về kích thước ban đầu khi nhấn */
}

.icon-delete:before {
    content: "\f2ed";
    color: #dc3545;
}

.icon-delete {
    font-size: 18px;
    color: #f84109;
    cursor: pointer;
    transition: transform 0.2s, color 0.2s ease;
}

.icon-delete:hover {
    color: #a90d05;
    /* Màu khi hover */
    transform: scale(1.2);
    /* Phóng to nhẹ khi hover */
}

.icon-delete:active {
    transform: scale(1);
    /* Trả về kích thước ban đầu khi nhấn */
}
</style>