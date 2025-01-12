<template>
    <div class="container-fluid">
        <div class="container-fluid top-item">
            <div class="container-fluid p-2 image-container">
                <img :src="imageUrl" alt="Image" class="image">
            </div>
            <div class="container-fluid p-2 overall-info">
                <div class="row">
                    <div class="container-fluid col-8">
                        <div class="item-container">
                            <p class="item-number">{{index}}.</p>
                            <p class="item-name">{{ name }}</p>
                        </div>
                        <div class="location">
                            <svg width="30px" height="30px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd" clip-rule="evenodd" d="M12.2848 18.9935C12.1567 19.0875 12.0373 19.1728 11.9282 19.2493C11.8118 19.1721 11.6827 19.0833 11.5427 18.9832C10.8826 18.5109 10.0265 17.8176 9.18338 16.9529C7.45402 15.1792 6 12.9151 6 10.5C6 7.18629 8.68629 4.5 12 4.5C15.3137 4.5 18 7.18629 18 10.5C18 12.8892 16.4819 15.1468 14.6893 16.9393C13.8196 17.8091 12.9444 18.5099 12.2848 18.9935ZM19.5 10.5C19.5 16.5 12 21 12 21C11.625 21 4.5 16.5 4.5 10.5C4.5 6.35786 7.85786 3 12 3C16.1421 3 19.5 6.35786 19.5 10.5ZM13.5 10.5C13.5 11.3284 12.8284 12 12 12C11.1716 12 10.5 11.3284 10.5 10.5C10.5 9.67157 11.1716 9 12 9C12.8284 9 13.5 9.67157 13.5 10.5ZM15 10.5C15 12.1569 13.6569 13.5 12 13.5C10.3431 13.5 9 12.1569 9 10.5C9 8.84315 10.3431 7.5 12 7.5C13.6569 7.5 15 8.84315 15 10.5Z" fill="#13357B"/>
                            </svg>
                            <p class="location-name">{{ location }}</p>
                        </div>
                    </div>
                    <div class="container-fluid col-3 p-2">
                        <div class="container save">
                            <btn_heart :destID="destID" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="container-fluid p-2 rating">
                <div class="rating-icon">
                    <img v-for="(star, index) in stars" :key="index"
                        :src="star" alt="Star">
                    <span class="rating-count">{{ reviewNumber }}</span>
                </div> 
            </div>
            <div class="container-fluid p-2 description">
                <svg class="bling" width="1.25vw" height="1.25vw" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                    <title>bling_line</title>
                    <g id="页面-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                        <g id="Editor" transform="translate(-144.000000, 0.000000)" fill-rule="nonzero">
                            <g id="bling_line" transform="translate(144.000000, 0.000000)">
                                <path d="M24,0 L24,24 L0,24 L0,0 L24,0 Z M12.5934901,23.257841 L12.5819402,23.2595131 L12.5108777,23.2950439 L12.4918791,23.2987469 L12.4918791,23.2987469 L12.4767152,23.2950439 L12.4056548,23.2595131 C12.3958229,23.2563662 12.3870493,23.2590235 12.3821421,23.2649074 L12.3780323,23.275831 L12.360941,23.7031097 L12.3658947,23.7234994 L12.3769048,23.7357139 L12.4804777,23.8096931 L12.4953491,23.8136134 L12.4953491,23.8136134 L12.5071152,23.8096931 L12.6106902,23.7357139 L12.6232938,23.7196733 L12.6232938,23.7196733 L12.6266527,23.7031097 L12.609561,23.275831 C12.6075724,23.2657013 12.6010112,23.2592993 12.5934901,23.257841 L12.5934901,23.257841 Z M12.8583906,23.1452862 L12.8445485,23.1473072 L12.6598443,23.2396597 L12.6498822,23.2499052 L12.6498822,23.2499052 L12.6471943,23.2611114 L12.6650943,23.6906389 L12.6699349,23.7034178 L12.6699349,23.7034178 L12.678386,23.7104931 L12.8793402,23.8032389 C12.8914285,23.8068999 12.9022333,23.8029875 12.9078286,23.7952264 L12.9118235,23.7811639 L12.8776777,23.1665331 C12.8752882,23.1545897 12.8674102,23.1470016 12.8583906,23.1452862 L12.8583906,23.1452862 Z M12.1430473,23.1473072 C12.1332178,23.1423925 12.1221763,23.1452606 12.1156365,23.1525954 L12.1099173,23.1665331 L12.0757714,23.7811639 C12.0751323,23.7926639 12.0828099,23.8018602 12.0926481,23.8045676 L12.108256,23.8032389 L12.3092106,23.7104931 L12.3186497,23.7024347 L12.3186497,23.7024347 L12.3225043,23.6906389 L12.340401,23.2611114 L12.337245,23.2485176 L12.337245,23.2485176 L12.3277531,23.2396597 L12.1430473,23.1473072 Z" id="MingCute" fill-rule="nonzero"></path>
                                <path d="M10.077,2.61445 C10.414725,1.8547065 11.4559488,1.8167103 11.8639379,2.50048712 L11.9229,2.61445 L12.9649,4.95885 C13.8758895,7.00850053 15.3902729,8.72789543 17.3016897,9.89018275 L17.6239,10.0787 L19.4747,11.1197 C20.1230611,11.4844444 20.1590812,12.3862472 19.5827602,12.8105806 L19.4747,12.8803 L17.6239,13.9214 C15.6690053,15.0210105 14.0996795,16.6904482 13.1222832,18.702691 L12.9649,19.0412 L11.9229,21.3856 C11.58527,22.145315 10.544051,22.1833008 10.1359764,21.4995572 L10.077,21.3856 L9.03507,19.0412 C8.12411842,16.9915684 6.60968319,15.2721296 4.69823529,14.1099057 L4.37602,13.9214 L2.52521,12.8803 C1.87690556,12.51565 1.84087972,11.6138525 2.41715777,11.1894352 L2.52521,11.1197 L4.37602,10.0787 C6.33094316,8.97901368 7.90032427,7.3096169 8.87769233,5.2973616 L9.03507,4.95885 L10.077,2.61445 Z M11,5.46224 C9.75577,8.26169 7.71421,10.4956 5.03971,12 C7.71421,13.5044 9.75577,15.7384 11,18.5378 C12.2475,15.7308 14.29,13.5021 16.9602,12 C14.2857,10.4956 12.2442,8.26169 11,5.46224 Z M19.2205,2.12106 C19.719,3.24286 20.5603,4.19019 21.6347,4.79454 C21.7949,4.88467 21.7949,5.11536 21.6347,5.20549 C20.5603,5.80984 19.719,6.75718 19.2205,7.87897 C19.1356,8.07 18.8644,8.07 18.7795,7.87897 C18.281,6.75717 17.4397,5.80984 16.3653,5.20549 C16.2051,5.11536 16.2051,4.88467 16.3653,4.79454 C17.4397,4.1902 18.281,3.24286 18.7795,2.12106 C18.8644,1.93003 19.1356,1.93003 19.2205,2.12106 Z" id="形状" fill="#13357B"></path>
                            </g>
                        </g>
                    </g>
                </svg>
                <div class="container item-description">
                    <span class="text-break">{{ description }}</span>
                </div>
            </div>
            <div class="container-fluid p-2 quick-fact">
                <div class="container-fluid quick-fact-title"><p>Quick Fact</p></div>
                <div class="container-fluid fact">
                    <div class="tags">
                        <svg width="40px" height="40px" viewBox="0 0 512 512" version="1.1" xmlns="http://www.w3.org/2000/svg" 
                            xmlns:xlink="http://www.w3.org/1999/xlink">
                            <title>tag-filled</title>
                            <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                <g id="icon" fill="#currentColor" transform="translate(64.000000, 64.000000)">
                                    <path d="M192,0 L405.333333,213.333333 L213.333333,405.333333 L0,192 L0,0 L192,0 Z M96,64 C78.326888,64 64,78.326888 64,96 C64,113.673112 78.326888,128 96,128 C113.673112,128 128,113.673112 128,96 C128,78.326888 113.673112,64 96,64 Z" id="Combined-Shape"></path>
                                </g>
                            </g>
                        </svg>
                        <span v-for="(tag, index) in tags" :key="tag" class="tag">
                            {{ tag.name }}
                            <span v-if="index < tags.length - 1">, </span> <!-- Adds a comma between tags -->
                        </span>
                    </div>
                    <div class="price">
                        <svg width="40px" height="40px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M19 7.24997H18.75V4.99997C18.7474 4.53665 18.5622 4.09305 18.2345 3.76543C17.9069 3.43781 17.4633 3.25259 17 3.24997C16.9207 3.23552 16.8393 3.23552 16.76 3.24997L4.86 7.24997H4.75H4.59L4.42 7.30997H4.28L4.12 7.39997L4 7.56997L3.86 7.68997L3.75 7.78997L3.63 7.93997C3.598 7.96867 3.57097 8.00246 3.55 8.03997C3.51288 8.09779 3.47948 8.15791 3.45 8.21997L3.39 8.32997C3.36216 8.40179 3.33878 8.47526 3.32 8.54997C3.3245 8.5865 3.3245 8.62344 3.32 8.65997C3.30967 8.77307 3.30967 8.88687 3.32 8.99997V19C3.3221 19.4515 3.49765 19.8849 3.81034 20.2106C4.12303 20.5364 4.54895 20.7295 5 20.75H19C19.4633 20.7473 19.9069 20.5621 20.2345 20.2345C20.5622 19.9069 20.7474 19.4633 20.75 19V8.99997C20.7474 8.53665 20.5622 8.09305 20.2345 7.76543C19.9069 7.43781 19.4633 7.25259 19 7.24997ZM17.08 4.75997C17.1293 4.77814 17.1719 4.81078 17.2022 4.85362C17.2325 4.89646 17.2492 4.94748 17.25 4.99997V7.24997H9.62L17.08 4.75997ZM19.25 19C19.25 19.0663 19.2237 19.1299 19.1768 19.1767C19.1299 19.2236 19.0663 19.25 19 19.25H5C4.9337 19.25 4.87011 19.2236 4.82322 19.1767C4.77634 19.1299 4.75 19.0663 4.75 19V8.99997C4.75 8.93367 4.77634 8.87008 4.82322 8.82319C4.87011 8.77631 4.9337 8.74997 5 8.74997H19C19.0663 8.74997 19.1299 8.77631 19.1768 8.82319C19.2237 8.87008 19.25 8.93367 19.25 8.99997V19Z" fill="#13357B"/>
                            <path d="M16.5 15.25C17.1904 15.25 17.75 14.6904 17.75 14C17.75 13.3096 17.1904 12.75 16.5 12.75C15.8096 12.75 15.25 13.3096 15.25 14C15.25 14.6904 15.8096 15.25 16.5 15.25Z" fill="#000000"/>
                        </svg>
                        <span class="cost">
                            Price From: 
                            <span v-if="price === 0">Free for all</span>
                            <span v-else-if="price > 1000 && price % 100 === 0">{{ price }} VND</span>
                            <span v-else>{{ price }} USD</span>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import destinationViewModel from '../../viewModels/Topic_ListViewModel';

const {
    entertainments, getImageUrl, truncatedDescription
} = destinationViewModel
</script>

<script>
import btn_heart from '../btn_heart.vue';
export default {
    name : "Topic_Item_1",
    components: {
        btn_heart
    },
    props: {
        destID: Number,
        imageUrl: String,
        index: Number,
        name: String,
        location: String,
        stars: Array,
        reviewNumber: Number,
        description: String,
        tags: Array,
        price: Number,
    },
}

</script>

<style scoped>
.top-item{
    color: #13357B;
    margin-top: 100px;
    border-radius: 30px;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
}
.top-item:hover{
    cursor: pointer;
    transition: 0.75s ease-in-out;
    background-color: #8ecae6;
}
.image {
    border-top-left-radius: 20px;
    border-top-right-radius: 20px;
    box-shadow: 5px 5px 10px rgba(19, 53, 123, 0.25);
    margin-top: 10px;
    width: 100%;
    height: 250px;
    object-fit: cover;
}
.item-container {
    display: flex;
    align-items: center;
    gap: 10px;
}

.item-number {
    font-size: 1.75vw;
}

.item-name {
    font-size: 1.75vw;
    font-weight: bold;
}
.location {
    display: flex;
    align-items: stretch;
    font-size: 1.5vw;
    text-decoration: underline #13357B;
    text-underline-offset: 10px;
    gap: 15px;
    margin-left: -10px;
}
.save {
    margin-top: 10px;
}
.rating-icon{
    display: flex;
    font-size: 1.25vw;
    align-items: center;
    margin-left: 20px;
}
.rating-icon img{
    width: 1.25vw;
}
.rating-icon span{
    margin-left: 1vw;
}
.description{
    display: flex;
    margin-left: 20px;
    margin-top: 10px;
    gap: 20px;
    align-items: flex-start;
}
.bling{
    transform: rotate(180deg);
}
.item-description{
    font-size: 1.25vw;
    padding-right: 3vw;
}
.quick-fact-title p{
    font-size: 1.3vw;
    font-weight: bold;
    margin: 10px 0 0 10px;
}
.fact{
    display: flex;
    margin: 10px 0;
    align-items: center;
    justify-content: space-between;
}
.tags, .price{
    padding: 10px 20px;
    min-width: 40%;
    display: flex;
    gap: 10px;
    align-items: center;
    border-radius: 30px;
    background-color: #CAF0F8;
    font-size: 1vw;
}
.tags svg #icon{
    fill: #13357B;
}
</style>