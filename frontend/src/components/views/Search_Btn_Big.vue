<template>
  <div class="container-fluid search">
      <div class="container-fluid position-relative">
          <!-- Input search -->
          <input 
              class="form-control" 
              type="text" 
              v-model="searchQuery" 
              :placeholder="placeholderText"
              @keyup.enter="performSearch" 
          />
          
          <!-- Nút Search -->
          <button 
                type="button" 
                class="btn btn-primary" 
                @click="performSearch"
            >
                Search
            </button>
          
          <!-- Danh sách kết quả -->
          <div 
                v-if="results && results.length" 
                class="search-results" 
                :class="{'show': results.length > 0}"
            >
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
import { ref, watch } from 'vue';
import useLiveSearch from '../viewModels/LiveSearchViewModel.js';

// Trạng thái tìm kiếm
const searchQuery = ref('');
const { search, results } = useLiveSearch(searchQuery);

// Theo dõi sự thay đổi query để cập nhật kết quả
watch(searchQuery, (newQuery) => {
    if (newQuery.trim()) {
        search(newQuery);
    }
});

// Hàm thực hiện tìm kiếm
const performSearch = () => {
  const queryToSearch = searchQuery.value.trim(); // Lấy query từ v-model
  if (queryToSearch) {
    window.location.href = `/search?q=${encodeURIComponent(queryToSearch)}`;
  } else {
    alert('Please enter a search query.');
  }
};

// Hàm xử lý khi chọn một kết quả từ danh sách
const selectResult = (result) => {
    searchQuery.value = result; // Cập nhật query
    performSearch(); // Thực hiện tìm kiếm
};
</script>

<script>
    export default {
  props: {
    placeholderText: {
        type: String,
        default: 'Where do you want to go?'
    }
  },
        name: "Search_Btn_Big",
    }
</script>

<style scoped>
/* General container styling */
.position-relative {
    display: flex;
    position: relative;
    background: #014f86;
    border-radius: 50rem;
    padding: 2.5rem;
    width: 100%;
}

/* Placeholder and focus styling */
.form-control::placeholder,
.form-control:focus {
    color: #13357B;
}

.form-control {
    display: block;
    width: 100%;
    padding: 1rem 1.5rem;
    border: 0;
    font-size: 1rem;
    font-weight: 400;
    line-height: 1.5;
    color: #13357B;
    background-color: #EDF6F9;
    border-radius: 30px;
}

/* Input focus and hover effects */
input:focus, input:hover {
    outline: none;
    background-color: #caf0f8;
    color: #13357B;
}

/* Button primary styling */
.btn-primary {
    top: 50%;
    right: 46px;
    transform: translateY(-50%);
    box-shadow: inset 0 0 0 0 #13357B;
    border-radius: 50rem;
    font-weight: 600;
    transition: all 0.5s;
    position: absolute;
    color: #EDF6F9;
    background-color: #13357B;
    border: none;
    padding: .5rem 1.5rem;
    margin-right: .5rem;
    display: inline-block;
    line-height: 1.5;
}

/* Button hover effect */
.btn-primary:hover {
    color: #13357B;
    background-color: #EDF6F9;
    border: 2px solid #13357B;
}

/* General button styling */
button {
    justify-content: center;
    margin: 0;
    border: none;
    font-size: 100%;
    border-radius: 10px;
    text-transform: none;
    background-color: transparent;
}

/* Search result styling */
.search-results {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background-color: #EDF6F9;
    border: 1px solid #ddd;
    border-radius: 15px;
    z-index: 1000;
    max-height: 200px;
    overflow-y: auto;
    margin-top: 10px;
    padding: 10px;
    
    /* Slide down effect */
    opacity: 0;
    transform: translateY(100px);
    animation: slideDown 0.3s ease-out forwards;
}

.search-results.show {
    opacity: 1;
    transform: translateY(0);
}

/* Slide down animation */
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

/* Search result list styling */
.search-results ul {
    list-style-type: none;
    padding: 0;
    margin: 0;
}

.search-results li {
    padding: 10px 35px;
    cursor: pointer;
    border-radius: 10px;
}

.search-results li:hover {
    background-color: #CAF0F8;
}

/* Deep selector fix (seems to be incomplete in original code) */
:deep(.scrool) {
    /* Thêm style cho phần tử có class .scrool ở trong scoped component hoặc shadow DOM */
    overflow-y: auto;
    max-height: 300px;
    padding: 10px;
}
</style>
