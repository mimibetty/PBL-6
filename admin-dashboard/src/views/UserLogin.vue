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
import AuthController from "@/controllers/AuthController";
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

    const { login } = AuthController();

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
  height: 100vh;
  background: linear-gradient(to right, #beb3ac, #0a44e4);
  color: #fff;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.login-title {
  font-size: 2.5rem;
  margin-bottom: 20px;
  font-weight: bold;
  color: #ffffff;
}

.login-input {
  width: 100%;
  max-width: 400px;
  padding: 15px;
  margin: 10px 0;
  border: none;
  border-radius: 5px;
  outline: none;
  font-size: 1rem;
  transition: background-color 0.3s, box-shadow 0.3s;
  background-color: rgba(255, 255, 255, 0.1);
  color: #ffffff;
}

.login-input::placeholder {
  color: #c8e6c9;
}

.login-input:focus {
  background-color: rgba(255, 255, 255, 0.2);
  border: 2px solid #66bb6a;
  box-shadow: 0 0 10px rgba(102, 187, 106, 0.5);
}

.login-button {
  padding: 15px 30px;
  background-color: #388e3c;
  color: #fff;
  border: none;
  border-radius: 5px;
  font-size: 1.2rem;
  cursor: pointer;
  transition: background-color 0.3s, transform 0.2s;
  margin-top: 20px;
}

.login-button:hover {
  background-color: #2e7d32;
  transform: scale(1.05);
}

.error-message {
  color: #ff4d4d;
  margin-top: 10px;
  font-size: 1rem;
}
</style>