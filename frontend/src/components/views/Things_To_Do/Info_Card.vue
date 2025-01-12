<template>
    <div class="container-fluid cards">
        <div class="row p-2">
            <div class="col-sm-12 p-2 img-location">
                <img :src="imageUrl" alt="pic" class="img-location"/>
            </div>

            <div class="col-sm-12 p-2">
                <div class="btn-heart"> 
                    <btn_heart :destID="destID" />
                </div>
            </div>   
        </div>
        <div class="row name-of-location p-3">
            {{ name }}
        </div>
        <div class="row p-2">
            <div class="col-sm-4 rating">
                <img v-for="star in stars" :key="star" :src="star" alt="Circle" class="star"/>
            </div>
            <div class="col-sm-6 review-number">
                / {{ reviewNumber }} reivews
            </div>
        </div>
        <div class=" row info-location p-2">
            <div class="row tags p-2">
                <div class="col tag" v-for="tag in tags" :key="tag">
                    <span>{{ tag }}</span>
                </div>
            </div>
        </div>
        <div class="line"></div>
        <div class="info-location p-1">
            <div class="description">
                {{ description}}
            </div>
        </div>
    </div>
</template>

<script>

import btn_heart from '../../views/btn_heart.vue';
export default {
    name: "Info_Card",
    components: {
        btn_heart
    },
    props: {
        imageUrl: String,
        destID: Number,
        name: String,
        stars: Array,
        reviewNumber: Number,
        tags: Array,
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
.btn-heart{
    text-align: right;
    margin: -350px 15px 0 0px;
}
.rating{
    display: flex;
    margin: 0 0 0 -5px;
    gap:3px;
    align-items: center;
}
.rating img {
    width: 20px;
    height: 20px;
}
.name-of-location{
    font-weight: 900;
    font-size: 20px;
}
.tags{
    margin-bottom: 15px;
}
.tag::after{
    content: '&';
    margin-left: 25px;
}
.tag:last-child::after {
  content: ""; /* Xóa ký tự & cho tag cuối cùng */
}
.cards{
    color: #13357B;
    height: 100%;
    border-radius: 30px;
    transition: all 0.3s ease-in-out; 
}
.cards:hover{
    cursor: pointer;
    transform:  translateY(-5px);
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
    transition: 0.5s ease-in-out;
    border-radius: 30px;
    background-color: #8ecae6;
}
.tags span{
    font-size: 20px;
}
.line{
    width: 100%;
    height: 2px;
    border-radius: 10px;
    background-color: #13357B;
    margin: 20px 0;
}
.description {
    margin-bottom: 20px;
}
</style>