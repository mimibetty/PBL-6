<template>
  <div id="app">
    <!-- Sidebar on the left -->
    <aside class="sidebar">
      <ul>
        <li>
          <router-link
            to="/dashboard"
            :class="{ active: isActive('/dashboard') }"
            @click="handleNavigation"
          >
            <i class="icon-dashboard"></i> Dashboard
          </router-link>
        </li>
        <li>
          <router-link
            to="/users"
            :class="{ active: isActive('/users') }"
            @click="handleNavigation"
          >
            <i class="icon-user-management"></i> User Management
          </router-link>
        </li>
      </ul>
    </aside>

    <!-- Top Navigation -->
    <header class="top-nav">
      <div class="auth-section">
        <template v-if="!loggedInUser">
          <router-link to="/login" class="auth-button login-button"
            >Login</router-link
          >
        </template>
        <template v-else>
          <span class="welcome-message">
            Welcome, {{ loggedInUser.username }}
          </span>
          <button @click="handleLogout" class="auth-button logout-button">
            Logout
          </button>
        </template>
      </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
      <router-view :key="viewKey"></router-view>
    </main>
  </div>
</template>

<script>
import { logout } from "./controllers/AuthController";
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";

export default {
  name: "App",
  setup() {
    const router = useRouter();
    const loggedInUser = ref(null);
    const viewKey = ref(Date.now()); // Khóa duy nhất cho router-view

    const refreshView = () => {
      viewKey.value = Date.now(); // Thay đổi khóa để ép buộc làm mới router-view
    };

    const handleLogout = () => {
      logout();
      loggedInUser.value = null;
      sessionStorage.removeItem("user");
      sessionStorage.removeItem("token");
      router.push("/login");
      refreshView(); // Gọi hàm refreshView để làm mới giao diện sau khi đăng xuất
    };

    const handleNavigation = () => {
      refreshView(); // Gọi hàm refreshView khi điều hướng
    };

    const isActive = (route) => {
      return router.currentRoute.value.path === route;
    };

    onMounted(() => {
      const storedUser = JSON.parse(sessionStorage.getItem("user"));
      if (storedUser) {
        loggedInUser.value = storedUser;
        console.log("Log data:", loggedInUser.value);
      }
    });

    return { loggedInUser, handleLogout, handleNavigation, isActive, viewKey };
  },
};
</script>

<style lang="scss">
#app {
  display: flex;
  height: 100vh;
  font-family: Avenir, Helvetica, Arial, sans-serif;
}

/* Sidebar styling on the left */
.sidebar {
  position: fixed;
  left: 0;
  top: 100px; /* Below the top navigation */
  width: 15%;
  height: calc(100vh - 100px);
  background-color: #2e3b4e;
  color: #fff;
  display: flex;
  flex-direction: column;
  padding-top: 20px;
  box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1); /* Shadow effect */
}

.sidebar ul {
  list-style: none;
  padding: 0;
  width: 100%;
}

.sidebar li {
  margin-bottom: 20px;
}

.sidebar a {
  color: #cfd8dc; /* Default link color */
  text-decoration: none;
  font-size: 18px;
  display: flex;
  align-items: center;
  padding: 10px 15px; /* Added padding for better touch targets */
  transition: background-color 0.3s, color 0.3s;
}

.active {
  background-color: #ffffff; /* White background */
  color: #007bff !important; /* Blue text color with !important to ensure it overrides default */
}

.sidebar a:hover {
  background-color: rgba(255, 255, 255, 0.1); /* Light hover effect */
  color: #2215d4; /* Hover text color */
}

.icon-dashboard,
.icon-user-management {
  margin-right: 10px;
  font-size: 20px;
}

/* Top navigation bar styling */
.top-nav {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 100px;
  background-color: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  padding-right: 20px;
  box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
  z-index: 10;
}

.auth-section {
  display: flex;
  align-items: center;
  gap: 10px;
}

.welcome-message {
  color: #007bff; /* Blue color for the welcome message */
  font-weight: bold;
  margin-right: 10px;
}

.auth-button {
  padding: 8px 15px;
  border: none;
  border-radius: 5px;
  color: #fff;
  font-weight: bold;
  transition: background-color 0.3s, transform 0.2s; /* Added transform for scaling */
  cursor: pointer;
}

.login-button {
  background-color: #42b983;
}

.login-button:hover {
  background-color: #379970;
  transform: scale(1.05); /* Scale effect on hover */
}

.logout-button {
  background-color: #dc3545;
}

.logout-button:hover {
  background-color: #c82333;
  transform: scale(1.05); /* Scale effect on hover */
}

.main-content {
  position: fixed;
  top: 100px; /* Below the top navigation */
  left: 15%; /* Aligned to the right of the sidebar */
  width: 85%; /* Occupies the remaining 85% of the viewport width */
  height: calc(100vh - 100px); /* Full height minus the top navigation */
  padding: 20px;
  background-color: #f0f2f5;
  overflow-y: auto;
}
</style>
