<template>
    <div class="container-fluid search">
        <h1 class="title">{{ name_of_page }}</h1>
        <div class="container-fluid position-relative">
            <!-- Input search -->
            <input class="form-control" type="text" :placeholder="name" v-model="searchQuery">
            
            <!-- Danh sách kết quả -->
            <div v-if="results.length" class="search-results" :class="{'show': results.length > 0}">
                <ul>
                    <li 
                        v-for="(result, index) in results" 
                        :key="index" 
                        @click="selectResult(result)"
                    >
                        {{ result }}
                    </li>
                </ul>
            </div>
        </div>
    </div>
  </template>

<script setup>
import { ref } from 'vue';
import useLiveSearch from '../viewModels/LiveSearchViewModel.js';
import CreateTripViewModel from '../viewModels/Create_Trip_ViewModel/CreateTripViewModel.js';

const { searchQuery } = CreateTripViewModel();
const { search, isLoading, results } = useLiveSearch(searchQuery);

// Hàm thực hiện tìm kiếm
const performSearch = (query = null) => {
  const queryToSearch = query || searchQuery.value;
  if (queryToSearch) {
      window.location.assign(`/search?q=${queryToSearch}`);
  } else {
      alert('Please enter a search query.');
  }
};

// Hàm xử lý khi chọn một kết quả
const selectResult = (result) => {
  performSearch(result);
};
</script>

<script>
    export default {
        name: "Form_search",
        props: {
            modelValue: {
                type: String,
                default: ''
            },
            name_of_page: String,
            name: String
        },
        emits: ['update:modelValue', 'enter']
    }
</script>

<style scoped>
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
button {
    justify-content: center;
    margin: 0;
    border: none;
    font-size: 100%;
    border-radius: 10px;
    text-transform: none;
    background-color: transparent;
}
.btn-primary:hover {
    color: #13357B;
    background-color: #EDF6F9;  
    border: 2px solid #13357B;
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