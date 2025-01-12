<template>
  <div class="user-management">
    <h2>User Management</h2>
    <div v-if="actionStep === 'read'" class="table-container">
      <button class="add-user-button" @click="showAddUserForm">Add User</button>
      <table class="user-table">
        <thead>
          <tr>
            <th>Id</th>
            <th>Username</th>
            <th>Email</th>
            <th>Business Description</th>
            <th>Phone Number</th>
            <th>Role</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in users" :key="user.id">
            <td>{{ user.id }}</td>
            <td>{{ user.username }}</td>
            <td>{{ user.email }}</td>
            <td>{{ user.business_description }}</td>
            <td>{{ user.phone_number }}</td>
            <td>{{ user.role }}</td>
            <td>
              <button
                v-if="user.isCreate"
                class="action-button edit-button"
                @click="showUpdateForm(user.id)"
              >
                Edit user info
              </button>
              <button
                v-else
                class="action-button add-button"
                @click="showCreateForm(user.id)"
              >
                Create user info
              </button>
              <button
                class="action-button delete-button"
                @click="deleteInfo(user.id)"
              >
                Delete user info
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="actionStep === 'addUser'" class="form-container">
      <h3>Create User</h3>
      <form @submit.prevent="submitAddUser" class="form-style">
        <div class="form-group">
          <label>Username:</label>
          <input type="text" v-model="newUser.username" />
        </div>
        <div class="form-group">
          <label>Email:</label>
          <input type="email" v-model="newUser.email" />
        </div>
        <div class="form-group">
          <label>Password:</label>
          <input type="password" v-model="newUser.password" />
        </div>
        <div class="form-group">
          <label>Confirm Password:</label>
          <input type="password" v-model="newUser.confirmPassword" />
        </div>
        <div class="button-group">
          <button type="submit" class="create-button">Create</button>
          <button type="button" @click="cancelAction" class="cancel-button">
            Cancel
          </button>
        </div>
      </form>
    </div>
    <!-- Create User info Form -->
    <div v-if="actionStep === 'create'" class="form-container">
      <h3>Create User Info</h3>
      <form @submit.prevent="submitCreateUser" class="form-style">
        <div class="form-group">
          <label>Username:</label>
          <input type="text" v-model="currentUser.username" disabled />
        </div>
        <div class="form-group">
          <label>Email:</label>
          <input type="email" v-model="currentUser.email" disabled />
        </div>
        <div class="form-group">
          <label>Role:</label>
          <input type="text" v-model="currentUser.role" disabled />
        </div>
        <div class="form-group">
          <label>Business Description:</label>
          <textarea v-model="currentUser.business_description"></textarea>
        </div>
        <div class="form-group">
          <label>Phone Number:</label>
          <input type="text" v-model="currentUser.phone_number" />
        </div>
        <div class="button-group">
          <button type="submit" class="create-button">Create</button>
          <button type="button" @click="cancelAction" class="cancel-button">
            Cancel
          </button>
        </div>
      </form>
    </div>

    <!-- Update User info Form -->
    <div v-if="actionStep === 'update'" class="form-container">
      <h3>Update User Info</h3>
      <form @submit.prevent="submitUpdateUser" class="form-style">
        <div class="form-group">
          <label>Username:</label>
          <input type="text" v-model="currentUser.username" disabled />
        </div>
        <div class="form-group">
          <label>Email:</label>
          <input type="email" v-model="currentUser.email" disabled />
        </div>
        <div class="form-group">
          <label>Role:</label>
          <input type="text" v-model="currentUser.role" disabled />
        </div>
        <div class="form-group">
          <label>Business Description:</label>
          <textarea v-model="currentUser.business_description"></textarea>
        </div>
        <div class="form-group">
          <label>Phone Number:</label>
          <input type="text" v-model="currentUser.phone_number" />
        </div>
        <div class="button-group">
          <button type="submit" class="update-button">Update</button>
          <button type="button" @click="cancelAction" class="cancel-button">
            Cancel
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import UserManagementController from "@/controllers/UserManagementController";
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";

export default {
  setup() {
    const users = ref([]);
    const router = useRouter();

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
    } = UserManagementController();

    const currentUser = ref({
      id: "",
      username: "",
      email: "",
      role: "",
      business_description: "",
      phone_number: "",
    });

    const newUser = ref({
      username: "",
      email: "",
      password: "",
      confirmPassword: "",
    });

    const loadUsers = async () => {
      users.value = await fetchUsers();
      if (users.value.length === 0) {
        alert("No users found, redirecting to login...");
        router.push("/login");
      }
    };

    onMounted(loadUsers);

    const showAddUserForm = () => {
      addUser();
    };

    const submitAddUser = async () => {
      confirmAddUser(newUser.value);
    };

    const showCreateForm = async (userID) => {
      const user = await createInfo(userID);
      currentUser.value = user;
    };

    const showUpdateForm = async (userID) => {
      const user = await updateInfo(userID);
      currentUser.value = user;
    };

    const submitCreateUser = () => {
      // Logic to handle user creation
      confirmCreateInfo(currentUser.value);
    };

    const submitUpdateUser = () => {
      // Logic to handle user update
      confirmUpdateInfo(currentUser.value);
    };

    const cancelAction = () => {
      actionStep.value = "read"; // Cancel action and return to list view
    };

    return {
      users,
      actionStep,
      currentUser,
      newUser,
      showCreateForm,
      showUpdateForm,
      submitCreateUser,
      submitUpdateUser,
      cancelAction,
      deleteInfo,
      showAddUserForm,
      submitAddUser,
    };
  },
};
</script>

<style scoped>
* {
  font-family: Arial, sans-serif;
}

.user-management {
  padding: 20px;
  font-family: Arial, sans-serif;
  background-color: #f9f9f9; /* Light background for the entire section */
  border-radius: 8px; /* Rounded corners for the container */
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* Subtle shadow for depth */
}

h2 {
  margin-bottom: 20px;
  color: #333; /* Darker color for better readability */
}

.table-container {
  max-height: 60vh; /* Đặt chiều cao tối đa cho vùng chứa bảng */
  overflow-y: auto; /* Thêm thanh cuộn dọc */
  background-color: #f9f9f9; /* Màu nền cho vùng chứa bảng */
  border-radius: 5px; /* Bo góc cho vùng chứa */
  padding: 10px; /* Khoảng cách bên trong */
}

/* Tùy chỉnh thanh cuộn */
.table-container::-webkit-scrollbar {
  width: 12px; /* Chiều rộng của thanh cuộn */
}

.table-container::-webkit-scrollbar-track {
  background: #f1f1f1; /* Màu nền của thanh cuộn */
}

.table-container::-webkit-scrollbar-thumb {
  background-color: #003366; /* Màu của thanh cuộn */
  border-radius: 10px; /* Bo góc cho thanh cuộn */
}

.table-container::-webkit-scrollbar-thumb:hover {
  background-color: #005b8c; /* Màu khi hover lên thanh cuộn */
}

.user-table {
  width: 100%;
  margin-top: 30px;
  border-collapse: collapse;
  margin-bottom: 20px; /* Khoảng cách giữa bảng và nút */
  border: 1px solid #d1d1d1; /* Đường viền bảng */
  border-radius: 8px; /* Bo góc cho bảng */
  overflow: hidden; /* Ẩn các góc viền bên trong */
}

.user-table th,
.user-table td {
  padding: 12px 16px; /* Điều chỉnh khoảng cách bên trong */
  text-align: left;
  border-bottom: 1px solid #d1d1d1; /* Đường viền giữa các hàng */
}

.user-table th {
  background-color: #e8f0fe; /* Màu nền cho tiêu đề */
  font-weight: bold;
  color: #333; /* Màu chữ tối */
  font-size: 14px; /* Kích thước chữ tiêu đề */
}

.user-table tr {
  transition: background-color 0.3s; /* Hiệu ứng chuyển màu nền khi hover */
}

.user-table tr:hover {
  background-color: #d1e1f5; /* Màu nền sáng khi hover */
}

.user-table tr:nth-child(even) {
  background-color: #f9f9f9; /* Màu nền cho hàng chẵn */
}

.user-table tr:nth-child(odd) {
  background-color: #ffffff; /* Màu nền cho hàng lẻ */
}

.user-table td {
  color: #444; /* Màu chữ tối cho dữ liệu */
  font-size: 14px; /* Kích thước chữ dữ liệu */
}

.user-table td:last-child {
  border-bottom: none; /* Xóa đường viền cho ô cuối cùng */
}

.action-button {
  border: none;
  padding: 8px 12px;
  margin: 0 5px;
  cursor: pointer;
  border-radius: 5px;
  transition: background-color 0.3s, transform 0.2s; /* Smooth transition for hover effects */
}

.edit-button,
.delete-button,
.add-button {
  padding: 12px 24px; /* Tăng padding để nút dài hơn */
  color: white; /* Màu chữ */
  font-weight: bold; /* Chữ đậm */
  font-size: 16px; /* Kích thước chữ lớn hơn */
  border: none; /* Không có viền */
  border-radius: 5px; /* Bo góc */
  cursor: pointer; /* Con trỏ khi hover */
  transition: background-color 0.3s, transform 0.2s; /* Smooth transition for hover effects */
  width: 100%; /* Đặt chiều rộng nút 100% */
  margin-bottom: 10px; /* Khoảng cách giữa các nút */
}

.edit-button {
  background-color: #007bff; /* Màu nền cho nút chỉnh sửa */
}

.edit-button:hover {
  background-color: #0056b3; /* Màu nền khi hover */
  transform: scale(1.05); /* Tăng kích thước khi hover */
}

.add-button {
  background-color: #28a745; /* Màu nền cho nút chỉnh sửa */
}

.add-button:hover {
  background-color: #02270b; /* Màu nền khi hover */
  transform: scale(1.05); /* Tăng kích thước khi hover */
}

.delete-button {
  background-color: #dc3545; /* Màu nền cho nút xóa */
}

.delete-button:hover {
  background-color: #c82333; /* Màu nền khi hover */
  transform: scale(1.05); /* Tăng kích thước khi hover */
}

.add-user-button {
  padding: 10px 20px;
  background-color: #28a745; /* Màu nền */
  width: 30%;
  color: white; /* Màu chữ */
  border: none; /* Không có viền */
  border-radius: 5px; /* Bo góc */
  cursor: pointer; /* Con trỏ khi hover */
  transition: background-color 0.3s, transform 0.2s, box-shadow 0.2s; /* Smooth transition for hover effects */
  font-weight: bold; /* Chữ đậm */
  font-size: 16px; /* Kích thước chữ */
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Đổ bóng nhẹ */
}

.add-user-button:hover {
  background-color: #218838; /* Màu nền khi hover */
  transform: scale(1.05); /* Tăng kích thước khi hover */
  box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2); /* Đổ bóng rõ hơn khi hover */
}

/* Center form container */
.form-container {
  width: 80%;
  margin: 20px auto;
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 8px;
  box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
  font-family: Arial, sans-serif;
}

/* Form layout */
.form-style {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

/* Form groups for label and input alignment */
.form-group {
  display: flex;
  margin-right: 10px;
  flex-direction: column;
  margin-bottom: 10px;
}

/* Labels */
.form-group label {
  font-weight: 700;
  color: #333;
  margin-bottom: 5px;
}

/* Input fields and textarea styling */
input[type="text"],
input[type="email"],
input[type="password"],
textarea {
  width: 100%;
  padding: 12px;
  font-size: 14px;
  color: #333;
  border: 1px solid #d1d5db; /* Light border */
  border-radius: 6px; /* Rounded corners */
  background-color: #f3f4f6; /* Light background for inputs */
  outline: none;
  transition: border-color 0.2s ease;
}

/* Placeholder color for inputs */
input[type="text"]::placeholder,
input[type="email"]::placeholder,
input[type="password"]::placeholder,
textarea::placeholder {
  color: #9ca3af;
}

/* Focus effect for input fields */
input[type="text"]:focus,
input[type="email"]:focus,
input[type="password"]:focus,
textarea:focus {
  border-color: #0078d4; /* Microsoft blue color on focus */
  background-color: #ffffff; /* White background on focus */
}

/* Textarea resizing */
textarea {
  resize: vertical;
  height: 80px;
  padding: 12px;
  font-size: 14px;
}

/* Button styling */
button {
  padding: 10px 16px;
  font-size: 14px;
  font-weight: 600;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: transform 0.2s ease, filter 0.2s ease;
  width: 40%;
}

/* Button container */
.button-group {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
  margin-top: 1rem;
}

/* Button colors */
.create-button {
  background-color: #28a745; /* Green for create */
  color: white;
}

.update-button {
  background-color: #0078d4; /* Microsoft blue for update */
  color: white;
}

.cancel-button {
  background-color: #dc3545; /* Red for cancel */
  color: white;
}

/* Hover effect for buttons */
button:hover {
  transform: scale(1.05);
  filter: brightness(90%);
}
</style>
