<template>
    <div class="container-fluid">
        <div class="container">
            <div class="container-fluid">
                <div class="container-fluid header">
                    <Header />
                    <Top_Button />
                </div>

                <div :class="['container-fluid', 'frame', { expanded: !hasMap }]">
                    <div class="container-fluid frame-image">
                        <div class="container-flud image">
                            <div class="container-flud img-container">
                                <img class="img" src="@/assets/images/carousal_1.jpg" alt="">
                                <div class="overlay"></div>
                                <div class="container info-trip">
                                    <h1 class="text" style="font-weight: 900;">{{ trip?.name }}</h1>
                                    <div class="container date-location">
                                        <div class="container length">
                                            <svg fill="#EDF6F9" width="35px" height="35px" viewBox="0 0 32 32"
                                                xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid">
                                                <path
                                                    d="M30.000,32.000 L2.000,32.000 C0.897,32.000 -0.000,31.103 -0.000,30.000 L-0.000,5.000 C-0.000,3.897 0.897,3.000 2.000,3.000 L10.000,3.000 L10.000,1.000 C10.000,0.448 10.448,-0.000 11.000,-0.000 C11.552,-0.000 12.000,0.448 12.000,1.000 L12.000,3.000 L20.000,3.000 L20.000,1.000 C20.000,0.448 20.448,-0.000 21.000,-0.000 C21.552,-0.000 22.000,0.448 22.000,1.000 L22.000,3.000 L30.000,3.000 C31.103,3.000 32.000,3.897 32.000,5.000 L32.000,30.000 C32.000,31.103 31.103,32.000 30.000,32.000 ZM22.000,5.000 L22.000,6.000 C22.000,6.552 21.552,7.000 21.000,7.000 C20.448,7.000 20.000,6.552 20.000,6.000 L20.000,5.000 L12.000,5.000 L12.000,6.000 C12.000,6.552 11.552,7.000 11.000,7.000 C10.448,7.000 10.000,6.552 10.000,6.000 L10.000,5.000 L2.000,5.000 L2.000,30.000 L29.997,30.000 L30.000,5.000 L22.000,5.000 ZM25.000,24.000 L23.000,24.000 C22.448,24.000 22.000,23.552 22.000,23.000 L22.000,21.000 C22.000,20.448 22.448,20.000 23.000,20.000 L25.000,20.000 C25.552,20.000 26.000,20.448 26.000,21.000 L26.000,23.000 C26.000,23.552 25.552,24.000 25.000,24.000 ZM25.000,16.000 L23.000,16.000 C22.448,16.000 22.000,15.552 22.000,15.000 L22.000,13.000 C22.000,12.448 22.448,12.000 23.000,12.000 L25.000,12.000 C25.552,12.000 26.000,12.448 26.000,13.000 L26.000,15.000 C26.000,15.552 25.552,16.000 25.000,16.000 ZM17.000,24.000 L15.000,24.000 C14.448,24.000 14.000,23.552 14.000,23.000 L14.000,21.000 C14.000,20.448 14.448,20.000 15.000,20.000 L17.000,20.000 C17.552,20.000 18.000,20.448 18.000,21.000 L18.000,23.000 C18.000,23.552 17.552,24.000 17.000,24.000 ZM17.000,16.000 L15.000,16.000 C14.448,16.000 14.000,15.552 14.000,15.000 L14.000,13.000 C14.000,12.448 14.448,12.000 15.000,12.000 L17.000,12.000 C17.552,12.000 18.000,12.448 18.000,13.000 L18.000,15.000 C18.000,15.552 17.552,16.000 17.000,16.000 ZM9.000,24.000 L7.000,24.000 C6.448,24.000 6.000,23.552 6.000,23.000 L6.000,21.000 C6.000,20.448 6.448,20.000 7.000,20.000 L9.000,20.000 C9.552,20.000 10.000,20.448 10.000,21.000 L10.000,23.000 C10.000,23.552 9.552,24.000 9.000,24.000 ZM9.000,16.000 L7.000,16.000 C6.448,16.000 6.000,15.552 6.000,15.000 L6.000,13.000 C6.000,12.448 6.448,12.000 7.000,12.000 L9.000,12.000 C9.552,12.000 10.000,12.448 10.000,13.000 L10.000,15.000 C10.000,15.552 9.552,16.000 9.000,16.000 Z" />
                                            </svg>
                                            <h3 style="font-weight: 900;">{{ trip?.duration }} {{ trip?.duration > 1 ?
                                                'days' : 'day' }}</h3>
                                        </div>
                                        <div class="container location">
                                            <svg fill="#EDF6F9" width="35px" height="35px" viewBox="0 0 32 32"
                                                xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid">
                                                <path
                                                    d="M30.000,32.000 L2.000,32.000 C0.897,32.000 -0.000,31.103 -0.000,30.000 L-0.000,5.000 C-0.000,3.897 0.897,3.000 2.000,3.000 L10.000,3.000 L10.000,1.000 C10.000,0.448 10.448,-0.000 11.000,-0.000 C11.552,-0.000 12.000,0.448 12.000,1.000 L12.000,3.000 L20.000,3.000 L20.000,1.000 C20.000,0.448 20.448,-0.000 21.000,-0.000 C21.552,-0.000 22.000,0.448 22.000,1.000 L22.000,3.000 L30.000,3.000 C31.103,3.000 32.000,3.897 32.000,5.000 L32.000,30.000 C32.000,31.103 31.103,32.000 30.000,32.000 ZM22.000,5.000 L22.000,6.000 C22.000,6.552 21.552,7.000 21.000,7.000 C20.448,7.000 20.000,6.552 20.000,6.000 L20.000,5.000 L12.000,5.000 L12.000,6.000 C12.000,6.552 11.552,7.000 11.000,7.000 C10.448,7.000 10.000,6.552 10.000,6.000 L10.000,5.000 L2.000,5.000 L2.000,30.000 L29.997,30.000 L30.000,5.000 L22.000,5.000 ZM25.000,24.000 L23.000,24.000 C22.448,24.000 22.000,23.552 22.000,23.000 L22.000,21.000 C22.000,20.448 22.448,20.000 23.000,20.000 L25.000,20.000 C25.552,20.000 26.000,20.448 26.000,21.000 L26.000,23.000 C26.000,23.552 25.552,24.000 25.000,24.000 ZM25.000,16.000 L23.000,16.000 C22.448,16.000 22.000,15.552 22.000,15.000 L22.000,13.000 C22.000,12.448 22.448,12.000 23.000,12.000 L25.000,12.000 C25.552,12.000 26.000,12.448 26.000,13.000 L26.000,15.000 C26.000,15.552 25.552,16.000 25.000,16.000 ZM17.000,24.000 L15.000,24.000 C14.448,24.000 14.000,23.552 14.000,23.000 L14.000,21.000 C14.000,20.448 14.448,20.000 15.000,20.000 L17.000,20.000 C17.552,20.000 18.000,20.448 18.000,21.000 L18.000,23.000 C18.000,23.552 17.552,24.000 17.000,24.000 ZM17.000,16.000 L15.000,16.000 C14.448,16.000 14.000,15.552 14.000,15.000 L14.000,13.000 C14.000,12.448 14.448,12.000 15.000,12.000 L17.000,12.000 C17.552,12.000 18.000,12.448 18.000,13.000 L18.000,15.000 C18.000,15.552 17.552,16.000 17.000,16.000 ZM9.000,24.000 L7.000,24.000 C6.448,24.000 6.000,23.552 6.000,23.000 L6.000,21.000 C6.000,20.448 6.448,20.000 7.000,20.000 L9.000,20.000 C9.552,20.000 10.000,20.448 10.000,21.000 L10.000,23.000 C10.000,23.552 9.552,24.000 9.000,24.000 ZM9.000,16.000 L7.000,16.000 C6.448,16.000 6.000,15.552 6.000,15.000 L6.000,13.000 C6.000,12.448 6.448,12.000 7.000,12.000 L9.000,12.000 C9.552,12.000 10.000,12.448 10.000,13.000 L10.000,15.000 C10.000,15.552 9.552,16.000 9.000,16.000 Z" />
                                            </svg>
                                            <h3 style="font-weight: 900;">{{ trip?.month_time }}</h3>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div>
                            <Tag_Trip @change-tab="handleTabChange" />
                            <component :is="currentComponent" :trip="trip" ref="itineraryList"
                                @update-dest-list-id="handleDestListIDUpdate"></component>
                        </div>
                    </div>
                    <div :class="['container-fluid', 'frame-map', { hidden: !hasMap }]">
                        <!-- Hiển thị Map ứng với tab Itinerary_List -->
                        <div v-if="currentComponent === 'Itinerary_List' && destListID.length > 0">
                            <p class="p-1">Map For {{ numDay !== 0 ? `Day ${numDay}` : 'Places to stay' }}</p>
                            <Map :destinationID="destListID" :select="select" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script setup>
import DetailTrip from '@/components/viewModels/Trip/DetailTripViewModel';
import { useRoute } from 'vue-router';
const route = useRoute();
const tripId = route.params.id;
const { trip } = DetailTrip(tripId);
</script>

<script>
import Header from '../Header.vue';
import Top_Button from '../Top_Button.vue';
import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
import Tag_Trip from './Tag_Trip.vue';
import DetailTripViewModel from '@/components/viewModels/Trip/detailTrip_Viewmodel';
import Saved_List from './Saved/Saved_List.vue';
import Itinerary_List from './Itinerary/Itinerary_List.vue';
import Map from '../Map/Map.vue';
export default {

    name: "Detail_Trip",
    components: {
        Header, Top_Button, Tag_Trip, Saved_List,
        Itinerary_List, Map
    },
    data() {
        return {
            viewModel: new DetailTripViewModel(), //quản lý tag_trip
            currentComponent: 'Saved_List',
            destListID: [],
            hasMap: false,
        }
    },
    methods: {
        handleTabChange(tabName) {
            console.log('Tab Name:', tabName);
            this.viewModel.changeTab(tabName); // Thay đổi tab mà không duyệt danh sách
            this.currentComponent = this.viewModel.getCurrentComponent(); // Cập nhật component hiển thị
            console.log('Current Component:', this.currentComponent);
            this.hasMap = tabName === 'Itinerary' && this.destListID.length > 0;
        },
        handleDestListIDUpdate(destListID, select, numDay) {
            this.destListID = destListID;
            this.select = select;
            this.numDay = numDay;
            console.log('Select:', this.select);
            console.log('numDay:', this.numDay);
            console.log('Received destListID from child:', this.destListID);
            this.hasMap = this.currentComponent === 'Itinerary' && this.destListID.length > 0;
        },
    },
    watch: {
        destListID(newVal) {
            this.hasMap = newVal.length > 0; // Cập nhật trạng thái map
        }
    },
    mounted() {
        // Gửi yêu cầu tới tất cả các component con để đảm bảo nhận dữ liệu
        this.$nextTick(() => {
            const itineraryComponent = this.$refs.itineraryList;
            if (itineraryComponent && itineraryComponent.sendDestListID) {
                itineraryComponent.sendDestListID();
            }
        });
    },
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

.frame {
    margin-top: 13vw;
    display: grid;
    grid-template-columns: 1fr 38.6%;
    /*Điều chỉnh độ rộng tự động */
    gap: .5%;
    transition: grid-template-columns 0.3s ease;
    /* Thêm hiệu ứng */
}

.frame-image {
    width: fit-content;
}

.image {
    height: 500px;
}

.img-container {
    position: relative;
    width: 100%;
    height: 100%;
}

.img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-radius: 20px;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
}

.overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(180deg, rgba(237, 246, 249, 0.20) 45%, rgba(33, 37, 41, 0.55) 63%);
    border-radius: 20px;
    pointer-events: none;
}

.info-trip {
    color: #EDF6F9;
    opacity: 0.99;
    margin-top: -170px;
    margin-left: 50px;
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.date-location {
    display: flex;
}

.length,
.location {
    display: flex;
    justify-content: flex-start;
    gap: 10px;
    color: #EDF6F9;
    margin-left: -20px;
}

.thinking {
    border: none;
    padding: 25px;
    border-radius: 20px;
    background-color: #EDF6F9;
    color: #13357B;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
}

.thinking::placeholder {
    color: #13357B;
    opacity: 0.8;
}

.thinking:focus {
    outline: none;
    border: 1px solid #13357B;
    background-color: #CAF0F8;
}

.frame-map {
    border-radius: 15px;
    color: #13357B;
    border-radius: 20px;
    padding: 10px;
    height: fit-content;
    font-size: 40px;
    position: sticky;
    top: 150px;
    transition: opacity 0.3s ease, visibility 0.3s ease;
}

.frame-map.hidden {
    display: none;
    /* Hoặc visibility: hidden để giữ kích thước */
}

.frame.expanded {
    grid-template-columns: 1fr;
    /* Khi map ẩn, phần còn lại chiếm toàn bộ */
}

.p-1 {
    font-weight: 900;
}
</style>
