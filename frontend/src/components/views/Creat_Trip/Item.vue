<template>
    <div class="container-fluid cards">
        <div class="row p-2">
            <div class="col-sm-12 p-2 img-location position-relative">
                <img :src="imageUrl" alt="pic" class="img-location"/>
                <div class="position-absolute" style="top: 15px; right: 15px;">
                    <btn_Select :id="id"/>
                </div>
            </div>
        </div>
        <div class="container-fluid frame-rating">
            <div class="name-of-location">
                {{ name }}
            </div>
            <div class="rating">
                <img v-for="star in stars" :key="star" :src="star" alt="Circle" class="star"/>
            </div>
        </div>
    </div>
</template>

<script>
import btn_Select from './btn_Select.vue';
export default {
    name: "Item",
    components: {
        btn_Select
    },
    props: {
        imageUrl: String,
        name: String,
        stars: Array,
        id: Number,
    },
}
</script>

<style scoped>
img {
    width: 100%;
    height: 250px;
    object-fit: cover;
    border-radius: 20px;
}
.rating img {
    width: 18px;
    height: 18px;
}
.name-of-location{
    font-weight: 900;
    font-size: 18px;
    color: #13357B;
}
.cards{
    border-radius: 32px;
}
.cards:hover{
    cursor: pointer;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
    transition: 0.75s ease-in-out;
    border-radius: 32px;
    background-color: #8ecae6;
}
.frame-rating {
    display: flex;
    justify-content: space-between;
    gap: 10px;
    margin-bottom: 20px;
}
</style>
