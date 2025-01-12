<template>
    <div class="container-fluid search">
      <div class="container-fluid position-relative">
        <input
          class="form-control"
          type="text"
          :placeholder="name"
          v-model="searchQuery"
        />
        <button
          type="button"
          class="btn btn-primary"
          @click="performSearch"
        >
          Search
        </button>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  
  const searchQuery = ref(""); // Để lưu trữ từ khóa tìm kiếm
  
  // Hàm xử lý sự kiện khi bấm nút Search
  const performSearch = () => {
    if (searchQuery.value) {
      window.location.assign(`/search?q=${searchQuery.value}`); // Sử dụng window.location.assign để chuyển hướng
    } else {
      alert("Please enter a search query.");
    }
  };
  </script>
  
  <script>
  export default {
    name: "FormSearch",
    props: {
      name: String, // Placeholder của ô input
    },
  };
  </script>
  
  <style scoped>
  
  .search {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 100vh; /* Tối ưu để ô tìm kiếm chiếm toàn bộ chiều cao */
  }
  
  .container-fluid.position-relative {
    position: relative;
    width: 80%; /* Giới hạn độ rộng để trông hợp lý hơn */
    max-width: 600px; /* Đảm bảo kích thước không quá lớn */
  }
  
  .form-control {
    width: 100%;
    padding: 0.75rem 1.5rem;
    border: 1px solid #ccc;
    border-radius: 40px;
    font-size: 1rem;
    color: #13357b;
    background-color: #edf6f9;
  }
  
  .form-control::placeholder {
    color: #13357b;
  }
  
  .form-control:focus,
  .form-control:hover {
    outline: none;
    background-color: #caf0f8;
    color: #13357b;
  }
  
  .btn-primary {
    position: absolute;
    top: 50%;
    right: 10px;
    transform: translateY(-50%);
    background-color: #13357b;
    color: #fff;
    border: none;
    border-radius: 50px;
    padding: 0.5rem 1.5rem;
    cursor: pointer;
    font-weight: 600;
    transition: all 0.3s ease;
  }
  
  .btn-primary:hover {
    background-color: #edf6f9;
    color: #13357b;
    border: 2px solid #13357b;
  }
  
  button {
    border: none;
    font-size: 1rem;
    background-color: transparent;
    cursor: pointer;
  }
  
  button:focus {
    outline: none;
  }
  </style>
  