<template>
    <header_For_company />
    <div class="container-fluid p-5 frame-overall">
        <div class="container-fluid overall">
            <div class="container-fluid p-5">
                <!-- <Search_Btn_Big placeholderText="" /> -->
                <div class="container-fluid d-flex justify-content-center align-items-center gap-3 p-5">
                    <div class="container-fluid frame-1 d-flex justify-content-between align-items-center gap-5">
                        <div class="container-fluid info d-flex flex-column gap-3">
                            <h6>Total Places</h6>
                            <p>{{ totalDestination }}</p>
                        </div>
                        <div class="d-flex justify-content-center align-items-center svg">
                            <svg width="40px" height="40px" viewBox="0 0 24 24" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd" clip-rule="evenodd" d="M12.2848 18.9935C12.1567 19.0875 12.0373 19.1728 11.9282 
                                19.2493C11.8118 19.1721 11.6827 19.0833 11.5427 18.9832C10.8826 18.5109 10.0265 17.8176 9.18338 16.9529C7.45402 
                                15.1792 6 12.9151 6 10.5C6 7.18629 8.68629 4.5 12 4.5C15.3137 4.5 18 7.18629 18 10.5C18 12.8892 16.4819 15.1468 
                                14.6893 16.9393C13.8196 17.8091 12.9444 18.5099 12.2848 18.9935ZM19.5 10.5C19.5 16.5 12 21 12 21C11.625 21 4.5 16.5 
                                4.5 10.5C4.5 6.35786 7.85786 3 12 3C16.1421 3 19.5 6.35786 19.5 10.5ZM13.5 10.5C13.5 11.3284 12.8284 12 12 
                                12C11.1716 12 10.5 11.3284 10.5 10.5C10.5 9.67157 11.1716 9 12 9C12.8284 9 13.5 9.67157 13.5 10.5ZM15 10.5C15 
                                12.1569 13.6569 13.5 12 13.5C10.3431 13.5 9 12.1569 9 10.5C9 8.84315 10.3431 7.5 12 7.5C13.6569 7.5 15 8.84315 15 
                                10.5Z" fill="currentColor" />
                            </svg>
                        </div>
                    </div>
                    <div class="container-fluid frame-1 d-flex justify-content-between align-items-center gap-5">
                        <div class="container-fluid info d-flex flex-column gap-3">
                            <h6>Total Tour Packages</h6>
                            <p>{{ totalTour }}</p>
                        </div>
                        <div class="d-flex justify-content-center align-items-center svg">
                            <svg width="40px" height="40px" viewBox="0 0 24 24" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path d="M9 20L3 17V4L9 7M9 20L15 17M9 20V7M15 17L21 20V7L15 4M15 17V4M9 7L15 4"
                                    stroke="currentColor" stroke-width="1.5" stroke-linecap="round"
                                    stroke-linejoin="round" />
                            </svg>
                        </div>
                    </div>
                    <div class="container-fluid frame-1 d-flex justify-content-between align-items-center gap-5">
                        <div class="container-fluid info d-flex flex-column gap-3">
                            <h6>Total Reviews</h6>
                            <p>{{ totalReview }}</p>
                        </div>
                        <div class="d-flex justify-content-center align-items-center svg">
                            <svg xmlns="http://www.w3.org/2000/svg" width="40px" height="40px" viewBox="0 0 24 24"
                                fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                stroke-linejoin="round">
                                <path d="M21 11.5a8.38 8.38 0 01-.9 3.8 8.5 8.5 0 01-7.6 4.7 8.38 8.38 0 01-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 
                                01-.9-3.8 8.5 8.5 0 014.7-7.6 8.38 8.38 0 013.8-.9h.5a8.48 8.48 0 018 8v.5z" />
                            </svg>
                        </div>
                    </div>
                    <div class="container-fluid frame-1 d-flex justify-content-between align-items-center gap-5">
                        <div class="container-fluid info d-flex flex-column gap-3">
                            <h6>Average Rating</h6>
                            <p>{{ averageRating }}</p>
                        </div>
                        <div class="d-flex justify-content-center align-items-center svg">
                            <svg width="40px" height="40px" viewBox="0 0 24 24" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd" clip-rule="evenodd" d="M12.2848 18.9935C12.1567 19.0875 12.0373 19.1728 11.9282 
                                19.2493C11.8118 19.1721 11.6827 19.0833 11.5427 18.9832C10.8826 18.5109 10.0265 17.8176 9.18338 16.9529C7.45402 
                                15.1792 6 12.9151 6 10.5C6 7.18629 8.68629 4.5 12 4.5C15.3137 4.5 18 7.18629 18 10.5C18 12.8892 16.4819 15.1468 
                                14.6893 16.9393C13.8196 17.8091 12.9444 18.5099 12.2848 18.9935ZM19.5 10.5C19.5 16.5 12 21 12 21C11.625 21 4.5 
                                16.5 4.5 10.5C4.5 6.35786 7.85786 3 12 3C16.1421 3 19.5 6.35786 19.5 10.5ZM13.5 10.5C13.5 11.3284 12.8284 12 12 
                                12C11.1716 12 10.5 11.3284 10.5 10.5C10.5 9.67157 11.1716 9 12 9C12.8284 9 13.5 9.67157 13.5 10.5ZM15 10.5C15 
                                12.1569 13.6569 13.5 12 13.5C10.3431 13.5 9 12.1569 9 10.5C9 8.84315 10.3431 7.5 12 7.5C13.6569 7.5 15 8.84315 15 
                                10.5Z" fill="currentColor" />
                            </svg>
                        </div>
                    </div>
                </div>

                <div class="container-fluid d-flex p-2 gap-0">
                    <div class="container-fluid">
                        <Chart class="chart" :rating1="rating_1" :rating2="rating_2" :rating3="rating_3"
                            :rating4="rating_4" :rating5="rating_5" :nameOfLocation="nameDestination" />
                    </div>
                    <div class="container-fluid">
                        <!-- sẽ hiển thị ra top 5 destination của doanh nghiệp dựa trên số rating, nếu cùng rating sẽ sắp xếp theo tổng reviews -->
                        <Table class="table" :destinations="destinations" :selected-destination-id="selectDestinationID"
                            @update:selected-destination-id="getSelectDestinationID" />
                    </div>
                </div>

                <div class="container-fluid p-4 my-tour d-flex flex-column gap-5 ">
                    <h4>Tour</h4>
                    <Tour class="tour" :tours="tourList" :generateStars="generateStars" />
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import header_For_company from './header_For_company.vue';
import Carousel_For_Dashboard from '../Carousel_For_Dashboard.vue';
import Search_Btn_Big from '../Search_Btn_Big.vue';
import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
import Chart from '../Chart/Chart.vue';
import Table from './Table.vue';
import Tour from './Tour.vue';
export default {
    name: "Dashboard_For_Company",
    components: {
        header_For_company, Carousel_For_Dashboard,
        Search_Btn_Big, Chart, Table, Tour
    }
}
</script>

<script setup>
import homeBusiness_ViewModel from '@/components/viewModels/homeBusiness_ViewModel';

const {
    totalDestination, totalTour, averageRating, totalReview,
    rating_1, rating_2, rating_3, rating_4, rating_5, loadRatings, nameDestination,
    selectDestinationID, getSelectDestinationID,
    destinations, isLoading, loadDestinations,
    tourList, generateStars
} = homeBusiness_ViewModel();

console.log("Rating1:", rating_1.value);
console.log("Rating2:", rating_2.value);
console.log("Rating3:", rating_3.value);
console.log("Rating4:", rating_4.value);
console.log("Rating5:", rating_5.value);
</script>

<style scoped>
.frame-overall {
    display: grid;
    grid-template-columns: 0% 100% 0%;
}

.overall {
    grid-column: 2/3;
}

.search-btn {
    margin-top: 200px;
    margin-bottom: 80px;
    width: 100%;
}

.frame-1 {
    background-color: #CAF0F8;
    border-radius: 20px;
    padding: 10px;
    color: #13357B;
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .1), 0 6px 18px -1px rgba(19, 53, 123, .08) !important;
}

.svg {
    padding: 10px;
    border-radius: 50%;
    background-color: #EDF6F9;
}

h6 {
    font-weight: bold;
    font-size: 15.5px;
}

p {
    font-size: 25px;
}

.chart,
.table {
    padding: 20px;
    border-radius: 20px;
    background-color: #EDF6F9;
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .07), 0 6px 18px -1px rgba(19, 53, 123, .04) !important;
}

.my-tour h4 {
    color: #13357B;
    font-weight: 900;
    font-size: 30px;
}
</style>