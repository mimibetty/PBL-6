<template>
  <div class="user-management container">
    <h2 class="my-3 text-center title-effect">Create User</h2>

    <div class="form-container">
      <form @submit.prevent="submitAddUser" class="form-style">
        <!-- Username -->
        <div class="form-floating mb-3">
          <input type="text" v-model="newUser.username" id="username" class="form-control" required placeholder=" " />
          <label for="username">Username</label>
        </div>

        <!-- Email -->
        <div class="form-floating mb-3">
          <input type="email" v-model="newUser.email" id="email" class="form-control" required placeholder=" " />
          <label for="email">Email</label>
        </div>

        <!-- Password -->
        <div class="form-floating mb-3">
          <input type="password" v-model="newUser.password" id="password" class="form-control" required placeholder=" " />
          <label for="password">Password</label>
        </div>

        <!-- Confirm Password -->
        <div class="form-floating mb-3">
          <input type="password" v-model="newUser.confirmPassword" id="confirmPassword" class="form-control" required placeholder=" " />
          <label for="confirmPassword">Confirm Password</label>
        </div>

        <!-- Action Buttons -->
        <div class="button-group">
          <button type="submit" class="btn btn-success">Create</button>
          <button type="button" @click="cancelAction" class="btn btn-danger">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</template>



  
  <script>
  import UserManagementController from "@/controllers/UserManagementController";
  import { ref, computed, onMounted } from "vue";
  
  export default {
    setup() {
      const {
        confirmAddUser,
      } = UserManagementController();

  
      const newUser = ref({
        username: "",
        email: "",
        password: "",
        confirmPassword: "",
      });
      const submitAddUser = async () => {
        await confirmAddUser(newUser.value);
      };
  
  
  
  
      const cancelAction = () => {
        window.history.back();
      };
  
      return {
        newUser,
        cancelAction,
        submitAddUser,
      };
    },
  };
  </script>
  
  <style scoped>
.user-management {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  background: #ffffff;
  border-radius: 10px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.form-container {
  padding: 20px;
}

h2 {
  text-align: center;
  color: #333;
}

.form-floating label {
  transition: all 0.3s ease;
}

.form-floating input:focus + label,
.form-floating input:not(:placeholder-shown) + label {
  transform: translateY(-1.5rem);
  font-size: 0.8rem;
  color: #0b31f0;
}

.button-group {
  display: flex;
  justify-content: space-between;
}
.title-effect {
  font-size: 2.5rem; /* Cỡ chữ lớn và dễ đọc */
  font-weight: 500; /* Độ đậm vừa phải */
  color: #343a40; /* Màu chữ xám đậm, dễ nhìn */
  text-transform: capitalize; /* Viết hoa chữ cái đầu tiên */
  letter-spacing: 1px; /* Khoảng cách giữa các chữ cái */
  text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.1); /* Bóng đổ nhẹ nhàng */
  transition: transform 0.3s ease, color 0.3s ease; /* Hiệu ứng khi hover */
}

.title-effect:hover {
  transform: scale(1.05); /* Phóng to nhẹ khi hover */
  color: #0b31f0; /* Đổi màu chữ khi hover */
}
</style>
  