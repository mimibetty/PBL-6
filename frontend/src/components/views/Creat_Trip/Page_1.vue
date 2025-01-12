<template>
    <div class="container-fluid-1">
        <div class="frame-search">
            <div class="container-fluid search">
                <h1 class="title">Where do you want to go?</h1>
                <div class="container-fluid position-relative">
                    <!-- Input search -->
                    <input class="form-control" type="text" placeholder="Choose a city or town" v-model="searchQuery">

                    <!-- Danh sách kết quả -->
                    <div v-if="result_citys.length" class="search-results" :class="{'show': result_citys.length > 0}">
                        <ul>
                            <li 
                                v-for="result in result_citys" 
                                :key="result.id" 
                                @click="selectResult(result)"
                            >
                                {{ result.name }}
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="frame-button">
            <button @click="goNext" class="next">Next</button>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import useLiveSearch from '../../viewModels/LiveSearchViewModel.js';
import CreateTrip from '../../viewModels/CreateTripViewModel';
import { useTripStore } from '@/store/useTripStore';
import { useRouter } from 'vue-router';

const router = useRouter();

const tripStore = useTripStore();
const searchQuery = ref('');

const{
    data,
    updateCity,
} = CreateTrip();

const { result_citys } = useLiveSearch(searchQuery);

const performSearch = (query = null) => {
    updateCity(query);
};

const selectResult = (result) => {
    performSearch(result);
    searchQuery.value = result.name;
};

const goNext = () => {
    router.push({ name: 'Page_2_1' });
};
</script>

<style scoped>
.container-fluid-1 {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 100vw;
    height: 100vh;
    margin: 0;
    padding: 0;
    overflow: hidden;
}
.frame-search {
    display: flex;
    align-items: center;
    justify-content: center;
    flex: 1;
    width: 80%;
}
.custom-search .form-control {
    background-color: #EDF6F9;
    font-size: 20px;
    border-radius: 40px;
    padding: 15px 20px;
    border: none;
    width: 60%;
    max-width: 600px;
}
.custom-search .form-control::placeholder {
    color: #13357B;
    font-size: 18px;
}
.frame-button {
    display: flex;
    justify-content: right;
    width: 100%;
    padding: 20px;
    margin-bottom: 200px;
    margin-right: 100px;
}
button {
    padding: 10px 50px;
    border: none;
    border-radius: 30px;
    background-color: #EDF6F9;
    color: #00B4D8;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.2);
}
button:hover {
    background-color: #13357B;
    color: #EDF6F9;
}
.search{
    display: flex;
    flex-direction: column;
    gap: 50px;
}
.search .title {
  color: #034141;
  font-size: 2.5rem;
  font-weight: 700;
  text-align: center;
}
.form-control {
    display: block;
    width: 100%;
    padding: 1.5rem 1.5rem 1.5rem 3rem ;
    border: 0;
    font-size: 1rem;
    font-weight: 400;
    line-height: 1.5;
    color: #13357B;
    background-color: #caf0f8;
    border-radius: 40px;
}
.form-control::placeholder,
.form-control:focus{
    color: #04173b;
}
input:focus, input:hover {
  outline: none;
  background-color: #caf0f8;
  color: #13357B;
  padding-left: 3rem;
}
.btn-primary {
    top : 50%;
    right: 25px;
    transform: translateY(-50%);
    box-shadow: inset 0 0 0 0 #13357B;  
    border-radius: 50rem;
    font-weight: 600;
    transition: all 0.5s;
    position: absolute;
    color: #EDF6F9;
    background-color: #13357B;
    border: 0;
    border-color: #13357B;
    padding: .5rem 1.5rem;
    margin-right: .5rem;
    display: inline-block;
    line-height: 1.5;
}

.search-results {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background-color: white;
    border: 1px solid #ddd;
    border-radius: 5px;
    z-index: 1000;
    max-height: 200px;
    overflow-y: auto;
    margin-top: 10px;
    padding: 10px;
    
    /* Hiệu ứng đổ xuống */
    opacity: 0;
    transform: translateY(-10px);
    animation: slideDown 0.3s ease-out forwards;
}

.search-results.show {
    opacity: 1;
    transform: translateY(0);
}

/* Animation: Đổ xuống */
@keyframes slideDown {
    0% {
        opacity: 0;
        transform: translateY(-10px);
    }
    100% {
        opacity: 1;
        transform: translateY(0);
    }
}

.search-results ul {
    list-style-type: none;
    padding: 0;
    margin: 0;
}

.search-results li {
    padding: 8px;
    cursor: pointer;
}

.search-results li:hover {
    background-color: #f0f0f0;
}
</style>

