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
        <div class="col-sm-12 rating p-2">
            <img v-for="star in stars" :key="star" :src="star" alt="Circle" class="star"/>
        </div>
        <div class=" row info-location p-2">
            <div class="tags p-2">
                <div class="tag-item" v-for="tag in tags" :key="tag">
                    <div class="tag">
                        <svg width="20px" height="20px" viewBox="0 0 512 512" version="1.1" xmlns="http://www.w3.org/2000/svg" 
                            xmlns:xlink="http://www.w3.org/1999/xlink">
                            <title>tag-filled</title>
                            <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                <g id="icon" fill="#currentColor" transform="translate(64.000000, 64.000000)">
                                    <path d="M192,0 L405.333333,213.333333 L213.333333,405.333333 L0,192 L0,0 L192,0 Z M96,64 C78.326888,64 64,78.326888 64,96 C64,113.673112 78.326888,128 96,128 C113.673112,128 128,113.673112 128,96 C128,78.326888 113.673112,64 96,64 Z" id="Combined-Shape"></path>
                                </g>
                            </g>
                        </svg>
                        <span>{{ tag }}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>

import btn_heart from '../btn_heart.vue';
export default {
    name: "Cards",
    components: {
        btn_heart
    },
    props: {
        imageUrl: String,
        destID: Number,
        name: String,
        rating: Number,
        tags: Array,
        stars: Array,
    },
}

</script>

<style scoped>
.container-fluid{
    display: grid;
    color: #13357B;
    height: 100%;
}

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
    margin: 0 0 0 -5px;
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
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    align-items: center;
}
.tags .tag svg #icon{
    fill: #13357B
}
.tags .tag {
    display: flex;
    gap: 5px;
    align-items: center;
    justify-content: center;
    padding: 5px;
    border-radius: 25px;
    width: 140px;
    background-color: #CAF0F8;
}
.cards{
    border-radius: 30px;
    transition: all 0.3s ease-in-out; 
}
.cards:hover{
    cursor: pointer;
    transform:  translateY(-5px);
    box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.2);
    transition: 0.75s ease-in-out;
    border-radius: 30px;
    background-color: #8ecae6;
}
</style>