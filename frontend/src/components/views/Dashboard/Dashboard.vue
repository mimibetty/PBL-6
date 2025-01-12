<template>
    <div class="container-fluid">
        <Header />
        <Top_Button v-if="isTopButtonVisible" />
    </div>

    <Carousel_For_Dashboard />

    <div class="container-fluid">
        <div class="container-fluid frame-overall">
            <div class="container-fluid overall">
                <div class="container-fluid search-btn">
                    <Search_Btn_Big />
                </div>
                <!-- Popular Destination -->
                <div class="container-fluid frame destination">
                    <div class="container">
                        <div class="mx-auto text-center mb-5 title">
                            <h5 class="section-title px-3 ">Destination</h5>
                            <h1 class="mb-0">Popular Destination</h1>
                        </div>
                    </div>

                    <div class="container tag">
                        <div class="container tag-button">
                            <Tag_Button />
                        </div>
                    </div>
                    <div class="container-fluid destination-list">
                        <button class="control-button owl-prev" @click="prevSlide">
                            <svg class="bi bi-arrow-left" width="25" height="25" viewBox="0 0 24 24"
                                fill="currentColor">
                                <path
                                    d="M7.68473 7.33186C8.07526 6.94134 8.07526 6.30817 7.68473 5.91765C7.29421 5.52712 6.66105 5.52712 6.27052 5.91765L1.60492 10.5832C0.823873 11.3643 0.823872 12.6306 1.60492 13.4117L6.27336 18.0801C6.66388 18.4706 7.29705 18.4706 7.68757 18.0801C8.0781 17.6896 8.0781 17.0564 7.68757 16.6659L4.02154 12.9998L22 12.9998C22.5523 12.9998 23 12.5521 23 11.9998C23 11.4476 22.5523 10.9998 22 10.9998L4.01675 10.9998L7.68473 7.33186Z" />
                            </svg>
                        </button>
                        <div class="list-items">
                            <div class="item" v-for="(city, index) in visibleCities" :key="city.id">
                                <Img_Card_2 :condition="city.images && city.images.length > 0"
                                    :imageUrl='city.images[0]' :name_picture="city.name" :name="city.name"
                                    @click="navigateToDestination(goToDestination(city.id))" />
                            </div>
                        </div>
                        <button class="control-button owl-next" @click="nextSlide">
                            <svg class="bi bi-arrow-right" width="25px" height="25px" viewBox="0 0 24 24"
                                fill="currentColor">
                                <path
                                    d="M16.3153 16.6681C15.9247 17.0587 15.9247 17.6918 16.3153 18.0824C16.7058 18.4729 17.339 18.4729 17.7295 18.0824L22.3951 13.4168C23.1761 12.6357 23.1761 11.3694 22.3951 10.5883L17.7266 5.9199C17.3361 5.52938 16.703 5.52938 16.3124 5.91991C15.9219 6.31043 15.9219 6.9436 16.3124 7.33412L19.9785 11.0002L2 11.0002C1.44772 11.0002 1 11.4479 1 12.0002C1 12.5524 1.44772 13.0002 2 13.0002L19.9832 13.0002L16.3153 16.6681Z" />
                            </svg>
                        </button>
                    </div>
                </div>
                <!-- Topic -->
                <div class="container-fluid frame topic">
                    <div class="container">
                        <div class="mx-auto text-center mb-5 title">
                            <h5 class="section-title px-3 ">WANNA TRY ?</h5>
                            <h1 class="mb-0">Awesome Topic</h1>
                        </div>
                    </div>

                    <div class="container-fluid list-items-topic">
                        <div class="item" v-for="(topic, index) in topics" :key="topic.id">
                            <Img_Card :condition="topic.imageUrl" :imageUrl='topic.imageUrl' :name_picture="topic.name"
                                @click="navigateToTopic(topic.path)" :name="topic.name" />
                        </div>
                    </div>
                </div>
                <!-- Recomment -->
                <div v-if="user" class="container-fluid frame topic">
                    <div class="container">
                        <div class="mx-auto text-center mb-5 title">
                            <h5 class="section-title px-3 ">How About This?</h5>
                            <h1 class="mb-0">Highly Recommended Places</h1>
                        </div>
                    </div>

                    <div class="container-fluid">
                        <Recomment_Destination :destinations="recommendations" :generateStars="generateStars"
                            :cities="cities" />
                    </div>
                </div>
                <!-- Tour -->
                <div class="container-fluid frame tour">
                    <div class="container" style="z-index: 10;">
                        <div class="mx-auto text-center mb-5 title">
                            <h5 class="section-title px-3 ">Tour proposal</h5>
                            <h1 class="mb-0">Awesome Tour</h1>
                        </div>
                    </div>

                    <div class="container-fluid list-tour">
                        <Swiper_Tour />
                    </div>
                </div>
            </div>
        </div>
    </div>

</template>

<script setup>
import { useRouter } from 'vue-router';
import { ref, onMounted, onUnmounted } from 'vue';
import dashboardViewModel from '../../viewModels/dashboardViewModel.js';
const isTopButtonVisible = ref(false);
// Sử dụng useRouter để lấy đối tượng router trong component
const router = useRouter();

const {
    activeButton, setActive,
    cities, visibleCities, prevSlide, nextSlide,
    topics, visibleTopics, prevTopic, nextTopic,
    tours, visibleToblurs, prevTour, nextTour,
    isMenuVisible, toggleMenu,
    generateStars, goToDestination, // vẫn import để lấy id
    recommendations, user
} = dashboardViewModel;

const navigateToDestination = (id) => {
    window.location.assign(`/Destination/${id}`);
};

const navigateToTopic = (topic) => {
    window.location.assign(`/Topic/${topic}`);
};

const handleScroll = () => {
    isTopButtonVisible.value = window.scrollY > 300;
};

onMounted(() => {
    window.addEventListener('scroll', handleScroll);
});

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
});
</script>

<script>
import Header from '../Header.vue';
import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
import Search_Btn_Big from '../Search_Btn_Big.vue';
import Tag_Button from './Tag_Button.vue';
import Control_Button from './Control_Button.vue';
import Carousel_For_Dashboard from './Carousel_For_Dashboard.vue';
import Img_Card from '../Img_Card.vue';
import Img_Card_2 from '../Img_Card_2.vue';
import Swiper_Tour from './Swiper_Tour.vue';
import Top_Button from '../Top_Button.vue';
import Recomment_Destination from '../Recomment_Destination.vue';
export default {
    name: "Dashboard",
    components: {
        Header, Scroll_Bar_Component, Search_Btn_Big, Tag_Button,
        Control_Button, Carousel_For_Dashboard, Img_Card,
        Img_Card_2, Swiper_Tour, Top_Button, Recomment_Destination
    }
}

</script>

<style scoped>
.frame-overall {
    display: grid;
    grid-template-columns: 5% 90% 5%;
}

.overall {
    grid-column: 2/3;
}

.search-btn {
    margin-top: -65px;
    width: 95%;
}

.section-title {
    position: relative;
    display: inline-block;
    color: #13357B;
    text-transform: uppercase;
    font-weight: 700;
}

.section-title::before {
    position: absolute;
    content: "";
    width: 100px;
    top: 50%;
    left: 0;
    border-radius: 5px;
    transform: translateY(-50%);
    margin-left: 350px;
    border: 2px solid #13357B;
}

.section-title::after {
    position: absolute;
    content: "";
    width: 100px;
    top: 50%;
    right: 0;
    border-radius: 5px;
    transform: translateY(-50%);
    margin-right: 350px;
    border: 2px solid #13357B;
}

.title {
    color: #13357B;
    display: flex;
    flex-direction: column;
    gap: 25px;
}

h4 {
    font-size: calc(1.275rem + 0.3vw);
    font-weight: bold;
    line-height: 2;
    text-transform: uppercase !important;
    font-weight: 700;
}

h1 {
    display: block;
    margin-block-start: 0.67em;
    margin-block-end: 0.67em;
    font-weight: bold;
    unicode-bidi: isolate;
}

.tag {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    color: #13357B;
}

.destination-list {
    display: grid;
    grid-template-columns: 5% 85% 5%;
    align-items: center;
    justify-content: center;
    justify-items: center;
    width: 100%;
    height: 100%;
}

.control-button {
    align-items: center;
    justify-content: center;
    width: 55px;
    height: 55px;
    border: 2px solid #13357B;
    border-radius: 50%;
    transition: .5s;
    background-color: #EDF6F9;
    fill: #EDF6F9
}

.control-button button {
    padding: 10px 20px;
}

.control-button:hover {
    background-color: #13357B;
}

.control-button svg {
    fill: #13357B;
}

.control-button:hover svg {
    fill: #EDF6F9;
}

.tag-button {
    position: relative;
    flex: 1;
    z-index: 10;
}

.frame {
    margin-top: 100px;
}

.list-items {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 50px;
    align-items: center;
    width: 100%;
    height: 100%;
}

.list-items-topic {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    align-items: center;
    width: 100%;
}
</style>