// src/router/index.js
import { createRouter, createWebHistory } from "vue-router";

const routes = [
  {
    path: "/login",
    name: "UserLogin",
    component: () => import("@/views/UserLogin.vue"), // Lazy-load component
  },
  {
    path: "/",
    redirect: "/dashboard", // Chuyển hướng về Dashboard khi vào trang gốc
  },
  {
    path: "/dashboard",
    name: "Dashboard",
    component: () => import("@/views/AdminDashboard.vue"),
  },
  {
    path: "/users",
    name: "UserManagement",
    component: () => import("@/views/UserManagement.vue"),
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// Navigation guard to protect routes that require authentication
router.beforeEach((to, from, next) => {
  const isAuthenticated = Boolean(localStorage.getItem("authToken")); // Kiểm tra token hoặc trạng thái đăng nhập

  if (to.meta.requiresAuth && !isAuthenticated) {
    next({ path: "/login" }); // Chuyển hướng về trang đăng nhập nếu chưa đăng nhập
  } else {
    next();
  }
});

export default router;
