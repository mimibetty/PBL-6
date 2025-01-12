<template>
  <div class="user-management">
    <h2>User Management</h2>
    <div v-if="isLoading" class="spinner-container">
      <div class="spinner"></div>
    </div>
    <div class="table-container">
      <!-- Thanh tìm kiếm -->
       <div class="header-container">
        <button class="action-button add-button" @click="showAddUserForm">
          Add User
        </button>
        <div class="search-container">
          <input
            type="text"
            v-model="searchQuery"
            placeholder="Search by username, email, or phone number..."
            class="search-input"
          />
        </div>
        
       </div>

      

      <table class="user-table">
        <thead>
          <tr>
            <th>Username</th>
            <th>Email</th>
            <th>Description</th>
            <th>Phone Number</th>
            <th>Address</th>
            <th>Role</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in paginatedUsers" :key="user.id">
            <td>{{ user.username }}</td>
            <td>{{ user.email }}</td>
            <td v-if="user.userInfo && user.userInfo.description">
              {{ user.userInfo.description }}
            </td>
            <td v-else>N/A</td>
            <td v-if="user.userInfo && user.userInfo.phone_number">
              {{ user.userInfo.phone_number }}
            </td>
            <td v-else>N/A</td>
            <td v-if="user.userInfo && user.userInfo.address">
              {{ user.userInfo.address.street }},
              {{ user.userInfo.address.ward }},
              {{ user.userInfo.address.district }},
              {{ getCityName(user.userInfo.address.city_id) }}
            </td>
            <td v-else>N/A</td>
            <td>{{ user.role }}</td>
            <td>{{ user.status }}</td>
            <td>
              <div class="dropdown">
                <button
                  class="action-button dropdown-toggle"
                  @click="toggleDropdown(user.id)"
                >
                  <span class="icon">☰</span>
                </button>
                <div class="dropdown-menu" v-if="activeDropdown === user.id">
                  <button
                    class="dropdown-item"
                    v-if="user.userInfo"
                    @click="showUpdateForm(user.id)"
                  >
                    Edit user info
                  </button>
                  <button
                    class="dropdown-item"
                    v-else
                    @click="showCreateForm(user.id)"
                  >
                    Create user info
                  </button>
                  <button
                    class="dropdown-item"
                    @click="changeStatus(user.id)"
                  >
                    Change user status
                  </button>
                  <button
                    class="dropdown-item"
                    @click="deleteInfo(user.userInfo.id)"
                  >
                    Delete user info
                  </button>
                </div>
              </div>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Phân trang -->
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
import { ref, computed, onMounted } from 'vue';
import UserManagementController from "@/controllers/UserManagementController";
import { useRouter } from "vue-router";
import { useToast } from "vue-toastification";

const users = ref([]);
const cities = ref([]);
const searchQuery = ref(''); // Biến tìm kiếm
const currentPage = ref(1);
const itemsPerPage = 5;
const activeDropdown = ref(null);
const isLoading = ref(true);

const router = useRouter();
const toast = useToast();

const {
  fetchUsers,
  actionStep,
  createInfo,
  updateInfo,
  confirmCreateInfo,
  confirmUpdateInfo,
  deleteInfo,
  addUser,
  confirmAddUser,
  changeStatus,
  fetchCities,
} = UserManagementController();

const loadUsers = async () => {
  users.value = await fetchUsers();
  if (users.value.length === 0) {
    toast.error("No users found, redirecting to login...");
    router.push("/login");
  }
};

const loadCity = async () => {
  cities.value = await fetchCities();
};

onMounted(async () => {
  await loadCity();
  await loadUsers();
  isLoading.value = false;
});

// Live Search (Tìm kiếm)
const filteredUsers = computed(() => {
  if (!searchQuery.value) {
    return users.value;
  }
  return users.value.filter(user =>
    user.username.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    user.email.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
    (user.userInfo && user.userInfo.phone_number && user.userInfo.phone_number.includes(searchQuery.value))
  );
});

// Pagination (Phân trang)
const paginatedUsers = computed(() => {
  const startIndex = (currentPage.value - 1) * itemsPerPage;
  return filteredUsers.value.slice(startIndex, startIndex + itemsPerPage);
});

const totalPages = computed(() => Math.ceil(filteredUsers.value.length / itemsPerPage));

const prevPage = () => {
  if (currentPage.value > 1) currentPage.value--;
};

const nextPage = () => {
  if (currentPage.value < totalPages.value) currentPage.value++;
};

const showAddUserForm = () => {
  window.location.assign(`/users/create`);
};

const getCityName = (city_id) => {
  const city = cities.value.find((c) => c.id === city_id);
  return city ? city.name : "Unknown City";
};

const showCreateForm = async (userID) => {
  window.location.assign(`/users/createInfo/${userID}`);
};

const showUpdateForm = async (userID) => {
  window.location.assign(`/users/updateInfo/${userID}`);
};

const cancelAction = () => {
  actionStep.value = "read";
};

const toggleDropdown = (userId) => {
  activeDropdown.value = activeDropdown.value === userId ? null : userId;
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
</script>


  
  <style scoped>
  * {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }
  
  body {
    background-color: #ffffff; /* Nền trắng */
    color: #333333; /* Chữ đen */
    line-height: 1.6;
  }
  
  .user-management {
    padding: 20px;
    min-height: 80vh;
  }
  
  h2 {
    margin-bottom: 20px;
    font-size: 24px;
    color: #333333;
    text-align: center;
  }
  
  .table-container {
    max-height: 80vh;
    overflow-y: auto;
  }
  
  .table-container::-webkit-scrollbar {
    width: 8px;
  }
  
  .table-container::-webkit-scrollbar-track {
    background: #f0f0f0;
  }
  
  .table-container::-webkit-scrollbar-thumb {
    background-color: #888888;
    border-radius: 4px;
  }
  
  .user-table {
    width: 100%;
    margin: 20px 0;
    border-collapse: collapse;
    border: 1px solid #dddddd;
    font-size: 14px;
  }
  
  .user-table th,
  .user-table td {
    padding: 12px;
    text-align: left;
    border-bottom: 1px solid #dddddd;
  }
  
  .user-table th {
    background-color: #f8f9fa;
    color: #333333;
    font-weight: bold;
  }
  
  .user-table tr:nth-child(odd) {
    background-color: #f7f7f7;
  }
  
  .user-table tr:nth-child(even) {
    background-color: #ffffff;
  }
  
  .user-table tr:hover {
    background-color: #e9ecef;
  }
  
  button {
    padding: 8px 12px;
    border: none;
    border-radius: 4px;
    font-size: 14px;
    cursor: pointer;
    color: #ffffff;
    transition: background-color 0.2s;
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
    background-color: #007bff;
  }
  
  .edit-button:hover {
    background-color: #0056b3;
    transform: scale(1.05);
  }
  
  .add-button {
    background-color: #28a745;
  }
  
  .add-button:hover {
    background-color: #218838;
    transform: scale(1.05);
  }
  
  .delete-button {
    background-color: #dc3545;
  }
  
  .delete-button:hover {
    background-color: #c82333;
    transform: scale(1.05);
  }
  
  .change-button {
    background-color: #3114db;
  }
  
  .change-button:hover {
    background-color: #110670;
    transform: scale(1.05);
  }
  
  .form-container {
    width: 100%;
    max-width: 600px;
    margin: 20px auto;
    padding: 20px;
    border: 1px solid #dddddd;
    border-radius: 6px;
    background-color: #ffffff;
  }
  
  .form-group {
    margin-bottom: 15px;
  }
  
  .form-group label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
    color: #333333;
  }
  
  input[type="text"],
  input[type="email"],
  input[type="password"],
  textarea,
  select {
    width: 100%;
    padding: 10px;
    border: 1px solid #dddddd;
    border-radius: 4px;
    background-color: #f9f9f9;
    font-size: 14px;
    color: #333333;
  }
  
  input[type="text"]:focus,
  input[type="email"]:focus,
  input[type="password"]:focus,
  textarea:focus,
  select:focus {
    border-color: #007bff;
    outline: none;
  }
  
  .button-group {
    display: flex;
    gap: 10px;
    margin-top: 15px;
  }
  
  button:hover {
    background-color: #0056b3;
  }
  
  .create-button {
    background-color: #28a745;
  }
  
  .update-button {
    background-color: #007bff;
  }
  
  .cancel-button {
    background-color: #dc3545;
  }
  
  .cancel-button:hover {
    background-color: #c82333;
  }
  
  .button-group {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 20px;
  }
  
  .form-group {
    position: relative;
    width: 100%;
  }
  
  .form-group select {
    width: 100%;
    padding: 10px;
    padding-right: 35px; /* Thêm khoảng trống để chứa mũi tên */
    border: 1px solid #ced4da;
    border-radius: 4px;
    background-color: #f5f6f7; /* Màu nền nhẹ giống Facebook */
    font-size: 14px;
    color: #333;
    appearance: none;
    -webkit-appearance: none; /* Đồng nhất trên các trình duyệt */
    transition: border-color 0.3s, box-shadow 0.3s;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='6' viewBox='0 0 10 6'%3E%3Cpath fill='%239ca3af' d='M0 0l5 5 5-5H0z'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 12px center;
    background-size: 10px 6px;
  }
  
  .form-group select:focus {
    border-color: #1877f2; /* Màu xanh đậm Facebook khi focus */
    box-shadow: 0 0 0 2px rgba(24, 119, 242, 0.2);
    outline: none;
  }
  
  /* CSS cho thanh cuộn màu xanh đậm */
  .form-group select::-webkit-scrollbar {
    width: 10px;
  }
  
  .form-group select::-webkit-scrollbar-thumb {
    background-color: #1877f2; /* Màu xanh dương đậm */
    border-radius: 10px;
  }
  
  .form-group select::-webkit-scrollbar-track {
    background: #e0e0e0; /* Màu nền cho track thanh cuộn */
  }
  
  /* Style cho các options bên trong select */
  .form-group select option {
    padding: 10px;
    color: #333;
    background-color: #fff;
  }
  
  .form-group select option:hover {
    background-color: #e4e6eb; /* Màu nền khi hover */
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
.header-container {
  display: flex;
  justify-content: space-between; /* Chia đều không gian giữa 2 phần tử */
  align-items: center; /* Căn chỉnh theo chiều dọc */
  width: 100%;
}

.search-container {
  margin-bottom: 20px;
  text-align: right;
  width: 40%; /* Điều chỉnh chiều rộng của thanh tìm kiếm */
  margin-left: auto; /* Tự động căn trái để thanh tìm kiếm nằm bên phải */
  margin-right: 20px;
}



.search-input {
  padding: 8px 12px;
  border-radius: 4px;
  border: 1px solid #ddd;
  font-size: 14px;
  width: 300px;
  outline: none;
}

.search-input:focus {
  border-color: #1877f2;
  box-shadow: 0 0 0 2px rgba(24, 119, 242, 0.2);
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
  