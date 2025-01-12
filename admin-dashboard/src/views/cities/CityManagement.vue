<template>
    <div class="city-management">
      <h2>City Management</h2>
      <div v-if="isLoading" class="spinner-container">
        <div class="spinner"></div>
      </div>
      <div v-else class="table-container">
        <button class="action-button add-button" @click="showCreateForm">
          Add New City
        </button>
        <table class="city-table">
          <thead>
            <tr>
              <th>City Name</th>
              <th>Description</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="city in paginatedCities" :key="city.id">
              <td>{{ city.name }}</td>
              <td>{{ city.description }}</td>
              <td>
                <div class="dropdown">
                    <button 
                        class="action-button dropdown-toggle"
                        @click="toggleDropdown(city.id)"
                    >
                        <span class="icon">☰</span>
                    </button>
                    <div class="dropdown-menu" v-if="activeDropdown === city.id">
                        <button
                            class="dropdown-item"
                            @click="showUpdateForm(city.id)"
                        >
                            Update City
                        </button>
                        <button
                            class="dropdown-item"
                            @click="deleteCity(city.id)"
                        >
                            Delete City
                        </button>
                    </div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        <div class="pagination">
          <button :disabled="currentPage === 1" @click="prevPage" class="pagination-button">
            <span>&lt;</span>
          </button>
          <div class="pagination-numbers">
            <button 
              v-for="page in visiblePages" 
              :key="page" 
              @click="goToPage(page)" 
              :class="{ 'active': currentPage === page }"
            >
              {{ page }}
            </button>
            <span v-if="totalPages > maxVisiblePages && currentPage < totalPages - 2">...</span>
            <button 
              v-if="totalPages > maxVisiblePages" 
              @click="goToPage(totalPages)" 
              :class="{ 'active': currentPage === totalPages }"
            > 
              {{ totalPages }}
            </button>
          </div>
          <button :disabled="currentPage === totalPages" @click="nextPage" class="pagination-button">
            <span>&gt;</span>
          </button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import CityManagementController from "@/controllers/CityManagementController";
  import { ref, computed, onMounted } from "vue";
  
  const cities = ref([]);
  const itemsPerPage = 5;
  const currentPage = ref(1);
  const activeDropdown = ref(null);
  const isLoading = ref(true);

  const toggleDropdown = (cityId) => {
  activeDropdown.value = activeDropdown.value === cityId ? null : cityId;
};
  
  const {
    fetchCities,
    deleteCity,
  } = CityManagementController();
  
  // Load cities on component mount
  const loadCities = async () => {
    cities.value = await fetchCities();
  };
  
  onMounted(async () => {
    await loadCities();
    isLoading.value = false;
  });
  
  // Pagination
  const paginatedCities = computed(() => {
    const startIndex = (currentPage.value - 1) * itemsPerPage;
    return cities.value.slice(startIndex, startIndex + itemsPerPage);
  });
  
  const totalPages = computed(() => Math.ceil(cities.value.length / itemsPerPage));
  
  const prevPage = () => {
    if (currentPage.value > 1) currentPage.value--;
  };
  
  const nextPage = () => {
    if (currentPage.value < totalPages.value) currentPage.value++;
  };
  
  // CRUD operations
  const showCreateForm = () => {
    window.location.assign("/cities/create");
  };
  
  const showUpdateForm = async (cityID) => {
    window.location.assign(`/cities/update/${cityID}`);
  };

  const maxVisiblePages = 5; // Số trang hiển thị trước và sau trang hiện tại

const visiblePages = computed(() => {
  const pages = [];
  const startPage = Math.max(1, currentPage.value - 2);
  const endPage = Math.min(totalPages.value, currentPage.value + 2);

  for (let i = startPage; i <= endPage; i++) {
    pages.push(i);
  }

  if (pages[0] !== 1) {
    pages.unshift(1); // Thêm trang 1 nếu không nằm trong dải hiển thị
  }
  
  if (pages[pages.length - 1] !== totalPages.value) {
    pages.push(totalPages.value); // Thêm trang cuối nếu không nằm trong dải hiển thị
  }

  return pages;
});

const goToPage = (page) => {
  currentPage.value = page;
};
  
  // Return exposed values and methods
  </script>
  
  
  <style scoped>
  /* Reset CSS */
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, sans-serif;
  }
  
  body {
    background-color: #ffffff; /* White background */
    color: #333333; /* Black text */
    line-height: 1.6;
  }
  
  .city-management {
    padding: 20px;
  }
  
  h2 {
    margin-bottom: 20px;
    font-size: 24px;
    color: #333333;
    text-align: center;
  }
  
  /* Table Styling */
  .table-container {
    overflow-x: auto;
  }
  
  .city-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
    border: 1px solid #ddd; /* Light border */
  }
  
  .city-table th,
  .city-table td {
    padding: 12px;
    text-align: left;
    border-bottom: 1px solid #ddd; /* Light border between rows */
  }
  
  .city-table th {
    background-color: #f8f8f8; /* Light gray header */
    color: #333333;
    font-weight: bold;
  }
  
  .city-table tr:nth-child(even) {
    background-color: #f9f9f9; /* Alternate row colors */
  }
  
  .city-table tr:nth-child(odd) {
    background-color: #ffffff; /* Alternate row colors */
  }
  
  .city-table tr:hover {
    background-color: #f1f1f1; /* Row hover effect */
  }
  
  /* Button Styling */
  button {
    padding: 8px 12px;
    font-size: 14px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
  }
  
  button:hover {
    background-color: #333333;
    color: #ffffff;
  }
  
  .action-button {
    padding: 8px 12px;
    margin: 0 5px;
    border-radius: 5px;
    color: #ffffff;
    font-weight: bold;
    transition: background-color 0.3s, transform 0.2s;
    margin: 10px;
  }
  
  .edit-button {
    background-color: #1877f2;
    color: #ffffff;
    border: none;
    padding: 8px 12px;
    border-radius: 4px;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
  }
  
  .add-button {
    background-color: #28a745;
    color: #ffffff;
    border: none;
    padding: 8px 12px;
    border-radius: 4px;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
  }
  
  .delete-button {
    background-color: #dc3545;
    color: #ffffff;
    border: none;
    padding: 8px 12px;
    border-radius: 4px;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
  }
  
  .edit-button:hover,
  .add-button:hover,
  .delete-button:hover {
    transform: scale(1.1); /* Phóng to 1.1 lần */
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2); /* Tạo hiệu ứng nổi */
  }
  
  .button-group {
    display: flex;
    gap: 10px;
    justify-content: flex-end;
  }
  
  body {
    background-color: #f9f9f9; /* Light background for entire page */
    color: #333333; /* Dark text for contrast */
    line-height: 1.6;
  }
  
  .form-container {
    max-width: 500px; /* Restrict width for better responsiveness */
    margin: 40px auto; /* Center form */
    padding: 20px 30px; /* Comfortable padding */
    background-color: #ffffff; /* White background */
    border-radius: 8px; /* Smooth rounded corners */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); /* Subtle shadow for depth */
  }
  
  /* Form Group Styling */
  .form-group {
    margin-bottom: 20px;
  }
  
  .form-group label {
    display: block;
    font-size: 14px;
    color: #4a4a4a; /* Dark gray for labels */
    margin-bottom: 6px; /* Space between label and input */
    font-weight: 600;
  }
  
  /* Input and Textarea Styling */
  input,
  textarea {
    width: 100%; /* Full width */
    padding: 12px 14px; /* Comfortable padding */
    font-size: 14px; /* Readable font size */
    border: 1px solid #d1d5db; /* Light border */
    border-radius: 6px; /* Rounded corners */
    background-color: #f7f8fa; /* Slightly lighter background */
    color: #333333;
    outline: none;
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
  }
  
  input::placeholder,
  textarea::placeholder {
    color: #9ca3af; /* Light gray for placeholders */
  }
  
  input:focus,
  textarea:focus {
    border-color: #1877f2; /* Blue border on focus */
    box-shadow: 0 0 3px rgba(24, 119, 242, 0.5); /* Subtle glow */
  }
  
  .pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 1rem;
}

.pagination-button {
  background: blue;
  border: none;
  font-size: 1.2rem;
  cursor: pointer;
  padding: 0.5rem 1rem;
  margin: 0 0.5rem;
  border-radius: 50%;
  transition: background-color 0.3s;
}

.pagination-button:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

.pagination-numbers {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.pagination-numbers button {
  background: none;
  border: 1px solid #ccc;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
  color: #020729;
  transition: background-color 0.3s;
}

.pagination-numbers button.active {
  background-color: #000;
  color: #fff;
}

.pagination-numbers button:hover {
  background-color: #0f13e6;
  color: #fff;
}
  
  /* Hình ảnh */
  .image-list {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
  }
  
  .image-item {
    position: relative;
    width: 100px;
    height: 100px;
  }
  
  .image-item img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border: 1px solid #e5e7eb;
    border-radius: 6px;
  }
  
  .image-item button {
    position: absolute;
    top: 5px;
    right: 5px;
    background: #dc3545;
    color: #ffffff;
    border: none;
    border-radius: 50%;
    cursor: pointer;
    padding: 5px;
    font-size: 12px;
    transition: transform 0.2s;
  }
  
  .image-item button:hover {
    transform: scale(1.1);
  }
  .dropdown {
  position: relative;
  display: inline-block;
}

.dropdown-toggle {
  background: blue;
  border: none;
  cursor: pointer;
  font-size: 18px;
}

.dropdown-menu {
  position: absolute;
  top: 100%;
  left: 0;
  z-index: 1000;
  display: flex;
  flex-direction: column;
  background: rgb(0, 238, 255);
  border: 1px solid #ccc;
  border-radius: 4px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
  min-width: 150px;
}

.dropdown-item {
  padding: 8px 16px;
  cursor: pointer;
  text-align: left;
  background: none;
  color: #333;
  border: none;
  width: 100%;
}

.dropdown-item:hover {
  background: #0056b3;
  color: white;
}
.spinner-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
}

.spinner {
  width: 50px;
  height: 50px;
  border: 5px solid #f3f3f3;
  border-top: 5px solid #3498db;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
  </style>
  