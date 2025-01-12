<template>
    <Swiper class="swiper"
            :slides-per-view="4"
            :spaceBetween="10"
            :scrollbar="{ draggable: true }"
            :modules="modules">
            <SwiperSlide class="swiper-slide" v-for="item in buttons" :key="item.id">
                <button class="button-item" 
                        :class="{ selected: selectedIndices.includes(item.id) }" 
                        @click="selectButton(item.id)">
                    {{ item.name }}
                </button>
            </SwiperSlide>
    </Swiper>
</template>

<script setup>
import { ref, watch } from 'vue';
import { Swiper, SwiperSlide } from 'swiper/vue';
import { Navigation, Pagination, Scrollbar, A11y } from 'swiper/modules';
import destinationViewModel from '../../viewModels/destinationViewModel.js';

// Import Swiper styles
import 'swiper/css';
import 'swiper/css/navigation';
import 'swiper/css/pagination';
import 'swiper/css/scrollbar';

const { buttons, selectedIndices, selectButton } = destinationViewModel();

const modules = [Navigation, Pagination, Scrollbar, A11y];

const onSwiper = (swiper) => {
    window.swiper = swiper;
};
</script>


<style scoped>

.swiper {
    width: 100%;
    max-width: 1450px; /* Set a max-width to ensure enough space for 3 slides */
}

.swiper-slide {
    color: #13357B;
    background-color: #EDF6F9;
    text-align: center;
    margin: 20px 0; 
}

button{
    color: #13357B;
    width: 80%;
    padding: 8px 16px;
    border: 1px solid #13357B;
    border-radius: 40px;
    cursor: pointer;
    background-color: #EDF6F9;
    transition: background-color 0.3s ease;
}

.button-item:hover {
    background-color: #0077b6;
    color: #EDF6F9 
}     
.button-item.selected {
    background-color: #13357B;
    color: #EDF6F9;
}
</style>

<style>
.swiper .swiper-scrollbar {
    background-color: #EDF6F9 !important;
    border: 1px solid #13357B !important;
    height: 6px !important;
}

.swiper .swiper-scrollbar-drag {
    background-color: #13357B !important;
}
</style>