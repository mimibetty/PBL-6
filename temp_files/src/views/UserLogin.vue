<template>
  <div class="login-container">
    <h2 class="login-title">Login to the system</h2>
    <input
      v-model="username"
      type="email"
      placeholder="Email"
      class="login-input"
      required
    />
    <input
      v-model="password"
      type="password"
      placeholder="Password"
      class="login-input"
      required
    />
    <button @click="handleLogin" class="login-button">Login</button>
    <p v-if="errorMessage" class="error-message">{{ errorMessage }}</p>
  </div>
</template>

<script>
import { login } from "@/controllers/AuthController";
import { useRouter } from "vue-router";
import { ref } from "vue";
import { useToast } from "vue-toastification";

export default {
  name: "UserLogin",
  setup() {
    const router = useRouter();
    const toast = useToast(); // Sử dụng hook useToast
    const username = ref("");
    const password = ref("");
    const errorMessage = ref("");

    const handleLogin = async () => {
      // Validate input fields
      if (!username.value || !password.value) {
        errorMessage.value = "Please enter both email and password.";
        toast.error("Please enter both email and password."); // Thông báo lỗi nếu chưa điền đầy đủ thông tin
        return;
      }

      // Clear error message before API call
      errorMessage.value = "";

      // Call API
      const response = await login(username.value, password.value);

      if (response.success) {
        const userData = response.user;
        console.log("User data:", userData);

        if (userData.role !== "admin") {
          sessionStorage.removeItem("token");
          sessionStorage.removeItem("user");
          toast.error("You do not have permission to access this system."); // Thông báo lỗi nếu không có quyền truy cập
          return;
        }
        toast.success("Login successful! Redirecting to dashboard...");
        setTimeout(() => {
          location.reload();
        }, 2000);
        router.push("/dashboard");
      } else {
        errorMessage.value = response.message || "Invalid credentials";
        toast.error(errorMessage.value); // Thông báo lỗi khi đăng nhập thất bại
      }
    };

    return { username, password, handleLogin, errorMessage };
  },
};
</script>

<style scoped>
.login-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  background: linear-gradient(to right, #2e3b4e, #42b983);
  color: #fff;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.login-title {
  font-size: 2rem;
  margin-bottom: 20px;
}

.login-input {
  width: 100%;
  max-width: 400px;
  padding: 10px;
  margin: 10px 0;
  border: none;
  border-radius: 5px;
  outline: none;
  font-size: 1rem;
  transition: background-color 0.3s;
}

.login-input::placeholder {
  color: #cfd8dc;
}

.login-input:focus {
  background-color: rgba(255, 255, 255, 0.1);
}

.login-button {
  padding: 10px 20px;
  background-color: #007bff;
  color: #fff;
  border: none;
  border-radius: 5px;
  font-size: 1rem;
  cursor: pointer;
  transition: background-color 0.3s, transform 0.2s;
}

.login-button:hover {
  background-color: #0056b3;
  transform: scale(1.05);
}

.error-message {
  color: #ff4d4d;
  margin-top: 10px;
  font-size: 0.9rem;
}
</style>
