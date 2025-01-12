<template>
    <div class="container-fluid top">
        <Header/>
        <Top_Button/>
    </div>  
    
    <div class="container-fluid">
        <div class="container-fluid frame-overall">
            <div class="container-fluid overall">
                <div class="container-fluid row select-topic">
                    <div class="container-fluid col frame-select-location">
                        <button 
                            class="dropdown-button" 
                            :class="{ 'active': dropdownVisibleRegion }" 
                            @click="toggleDropDownRegion">
                            {{ selectedCityName }}
                            <span class="arrow" :class="{ 'up': dropdownVisibleRegion }">
                                <svg width="30px" height="30px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M19 9L14 14.1599C13.7429 14.4323 13.4329 
                                        14.6493 13.089 14.7976C12.7451 14.9459 12.3745 15.0225 
                                        12 15.0225C11.6255 15.0225 11.2549 14.9459 10.9109 
                                        14.7976C10.567 14.6493 10.2571 14.4323 10 14.1599L5 9" 
                                        stroke="#currentColor" stroke-width="1.5" stroke-linecap="round" 
                                        stroke-linejoin="round" />
                                </svg>
                            </span>
                        </button>
                        <!-- Dropdown danh sách các lựa chọn -->
                        <div class="dropdown-list" v-if="dropdownVisibleRegion">
                            <!-- Tùy chọn tất cả tours -->
                            <button class="dropdown-item" @click="selectCity(null)">
                                Việt Nam
                            </button>
                            <!-- Tùy chọn các thành phố -->
                            <button 
                                class="dropdown-item" 
                                v-for="city in cities" 
                                :key="city.id" 
                                @click="selectCity(city.id)">
                                {{ city.name }}
                            </button>
                        </div>
                    </div>

                    <div class="container-fluid col frame-select-topic">
                        <Swiper class="swiper"
                            :slides-per-view="3"
                            :spaceBetween="70"
                            :pagination="{ clickable: true }"
                            :navigation="true"
                            :draggable="false"
                            :modules="modules">
                            <SwiperSlide class="swiper-slide" v-for="tag in tags" 
                                        :key="tag.id">
                                <button class="button-item" 
                                        :class="{ selected: selectedIndex === tag.id }" 
                                        @click="selectButton(tag.id)">
                                    {{ tag.name }}
                                </button>
                            </SwiperSlide>
                        </Swiper>
                    </div> 
                
                </div>
        

                <div v-if="loading">
                    <div class="skeleton-loader" v-for="n in 10" :key="n"></div>
                </div>

                <div v-else class="container-fluid content"
                    v-for="(item, index) in destinations" :key="index">
                    <div class="container">
                        <Topic_Item_2 :imageUrl="item.images[0]?.url || '/blue-image.jpg'"
                            :index="index+1"
                            :destID="item.id"
                            :name="item.name"
                            :location="getCity(item.address.city_id).name"
                            :stars="generateStars(item.rating)"
                            :reviewNumber="item?.review_count || 0"
                            :description="truncatedDescription(item.description)"
                            :tags="item.tags"
                            :price="item.price_bottom"
                            @click="navigate(item)"/>
                    </div>
                </div>
            </div>
        </div>
    </div>

</template>

<script setup>
import destinationViewModel from '../../viewModels/Topic_ListViewModel';
import generateViewModel from '../../viewModels/generate_ratingViewModel';
import { useRoute } from 'vue-router';
import { ref, onMounted, computed } from 'vue';
import { Swiper, SwiperSlide } from 'swiper/vue';
import { Navigation, Pagination, Scrollbar, A11y } from 'swiper/modules';
import 'swiper/css';
import 'swiper/css/navigation';
import 'swiper/css/scrollbar';
const modules = [Navigation, Pagination, Scrollbar, A11y];
const route = useRoute();
const topicName = route.params.topic;
const {
    destinations,
    tags,
    cities,
    selectedCityId,
    selectedIndex,
    dropdownVisibleRegion,
    loading,
    truncatedDescription,
    selectButton,
    selectCity,
    selectedCityName,
    toggleDropDownRegion,
    fetchFilteredDestinations,
} = destinationViewModel(topicName);
const selectTag = async (tag_id) => {
    selectButton(tag_id)
    await fetchFilteredDestinations();
};
const {
    generateStars,
  } = generateViewModel();
const getCity = (city_id) => {
    return cities.value.find(city => city.id === city_id);
};
const navigate = (destination) => {
    if(destination.hotel_id!= null){
        navigateToDetailHotel(destination.hotel_id);
    }
    else if(destination.restaurant_id!= null){
        navigateToDetailRestaurant(destination.restaurant_id);
    }
    else{
        navigateToDetailPlace(destination.id);
    }
}
const navigateToDetailPlace = (id) => window.location.assign(`/Detail/Place/${id}`);
const navigateToDetailRestaurant = (restaurant_id) => window.location.assign(`/Detail/Restaurant/${restaurant_id}`);
const navigateToDetailHotel = (hotel_id) => window.location.assign(`/Detail/Hotel/${hotel_id}`);
</script>

<script>
import Header from '../../views/Header.vue';
import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
import Top_Button from '../Top_Button.vue';
import Topic_Item_1 from './Topic_Item_1.vue';
import Topic_Item_2 from './Topic_Item_2.vue';
import { Swiper, SwiperSlide } from 'swiper/vue';
import { Navigation, Pagination, Scrollbar, A11y } from 'swiper/modules';

// Import Swiper styles
import 'swiper/css';
import 'swiper/css/navigation';
import 'swiper/css/scrollbar';

const modules = [Navigation, Pagination, Scrollbar, A11y];

export default {
    name: "Topic_List",
    components: {
        Header, Scroll_Bar_Component, Top_Button,
        Topic_Item_1, Swiper,
        SwiperSlide,
    }, 
    setup() {
        return {
            modules,
        };
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
.select-topic{
    display: grid;
    grid-template-columns: 20% 80%;
    gap:5%;
    place-items: center;
    margin-top: 250px;
    align-items: center; /* Căn giữa theo chiều dọc */
}
.frame-select-location {
    display: flex;
    align-items: center; /* Căn giữa nội dung theo chiều dọc */
}

.frame-select-topic {
    width: 70vw;
    display: flex;
    align-items: center; /* Căn giữa nội dung theo chiều dọc */
}
.dropdown-button{
    min-width: 200px;
    min-width: 200px;
    padding: 10px;
    border-radius: 30px;
    border: none;
    margin: 20px 0;
    background-color: #CAF0F8;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
    color: #13357B;
    display: flex;
    justify-content: space-around;
    align-items: center;
    cursor: pointer;
    gap: 20px;
}
.dropdown-button svg {
    stroke: #13357B;
}
.dropdown-button.active {
    background-color: #13357B;
    color: #EDF6F9;
}
.dropdown-button.active svg {
    stroke: #EDF6F9;
    transform: rotate(180deg);
}
.dropdown-list {
    position: absolute;
    margin-top: 10px;
    min-width: 300px;
    height: 250px;
    overflow: hidden;
    border-radius: 10px;
    background-color: #EDF6F9;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
    z-index: 5;
    overflow-y: auto;
    padding: 15px 0px;
    display: flex;
    flex-direction: column;
    gap: 15px;
}
.dropdown-item {    
    padding: 15px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}
.dropdown-item:hover {
    background-color: #13357B;
    color: #EDF6F9;
}

.content{
    margin-bottom: 50px;
    width: 70%;
}
.swiper {
    width: 100%;
    padding: 0 60px;/* Set a max-width to ensure enough space for 3 slides */
}

.swiper-slide {
    color: #13357B;
    margin: 20px 0;

}
:deep(.swiper-button-next),
:deep(.swiper-button-prev) {
    color: #13357B !important;
    border: none;
    cursor: pointer;
    position: absolute;

}
.button-item{
    color: #13357B;
    width: 100%;
    padding: 15px 0px;
    border: none;
    border-radius: 40px;
    cursor: pointer;
    background-color: #CAF0F8;
    transition: background-color 0.3s ease;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
}

.button-item:hover {
    background-color: #0077b6;
    color: #EDF6F9 
}     
.button-item.selected {
    background-color: #13357B;
    color: #EDF6F9;
}
.skeleton-loader {
    height: 200px;
    margin: 10px;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: skeleton-loading 1.5s infinite;
}

@keyframes skeleton-loading {
    from {
        background-position: 200% 0;
    }
    to {
        background-position: -200% 0;
    }
}
</style>