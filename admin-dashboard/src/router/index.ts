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
    redirect: "/login", // Chuyển hướng về Dashboard khi vào trang gốc
  },
  {
    path: "/dashboard",
    name: "Dashboard",
    component: () => import("@/views/AdminDashboard.vue"),
  },
  {
    path: "/users",
    name: "UserManagement",
    component: () => import("@/views/users/UserManagement.vue"),
  },
  {
    path: "/users/create",
    name: "UserManagement-Create",
    component: () => import("@/views/users/CreateUser.vue"),
  },
  {
    path: "/users/createInfo/:id",
    name: "UserManagement-CreateUserInfo",
    component: () => import("@/views/users/CreateUserInfo.vue"),
  },
  {
    path: "/users/updateInfo/:id",
    name: "UserManagement-UpdateUserInfo",
    component: () => import("@/views/users/UpdateUserInfo.vue"),
  },
  {
    path: "/cities",
    name: "CityManagement",
    component: () => import("@/views/cities/CityManagement.vue"),
  },
  {
    path: "/cities/create",
    name: "CityManagement-Create",
    component: () => import("@/views/cities/AddCity.vue"),
  },
  {
    path: "/cities/update/:id",
    name: "CityManagement-Update",
    component: () => import("@/views/cities/UpdateCity.vue"),
  },
  {
    path: "/destinations",
    name: "DestinationManagement",
    component: () => import("@/views/destinations/DestinationManagement.vue"),
  },
  {
    path: "/destinations/:id",
    name: "DestinationManagement-Detail",
    component: () => import("@/views/destinations/DestinationDetail.vue"),
  },
  {
    path: "/destinations/create",
    name: "DestinationManagement-Add",
    component: () => import("@/views/destinations/AddDestination.vue"),
  },
  {
    path: "/destinations/update/:id",
    name: "DestinationManagement-Update",
    component: () => import("@/views/destinations/UpdateDestination.vue"),
  },
  {
    path: "/destinations/hotel/create/:id",
    name: "DestinationManagement-AddHotel",
    component: () => import("@/views/destinations/AddHotel.vue"),
  },
  {
    path: "/destinations/hotel/update/:id",
    name: "DestinationManagement-UpdateHotel",
    component: () => import("@/views/destinations/UpdateHotel.vue"),
  },
  {
    path: "/destinations/restaurant/create/:id",
    name: "DestinationManagement-AddRestaurant",
    component: () => import("@/views/destinations/AddRestaurant.vue"),
  },
  {
    path: "/destinations/restaurant/update/:id",
    name: "DestinationManagement-UpdateRestaurant",
    component: () => import("@/views/destinations/UpdateRestaurant.vue"),
  },
  {
    path: "/tours",
    name: "TourManagement",
    component: () => import("@/views/tours/TourManagement.vue"),
  },
  {
    path: "/tours/:id",
    name: "TourManagement-Detail",
    component: () => import("@/views/tours/TourDetail.vue"),
  },
  {
    path: "/tours/create",
    name: "TourManagement-Add",
    component: () => import("@/views/tours/AddTour.vue"),
  },
  {
    path: "/tours/update/:id",
    name: "TourManagement-Update",
    component: () => import("@/views/tours/UpdateTour.vue"),
  },
  {
    path: "/reviews",
    name: "ReviewManagement",
    component: () => import("@/views/reviews/ReviewManagement.vue"),
  },
  {
    path: "/reviews/:id",
    name: "Review-Detail",
    component: () => import("@/views/reviews/ReviewDetail.vue"),
  },
  {
    path: "/reviews/create/:id",
    name: "Review-Create",
    component: () => import("@/views/reviews/AddReview.vue"),
  },
  {
    path: "/reviews/update/:id",
    name: "Review-Update",
    component: () => import("@/views/reviews/UpdateReview.vue"),
  },
  {
    path: "/tags",
    name: "TagManagement",
    component: () => import("@/views/tags/TagManagement.vue"),
  },
  {
    path: "/tags/:id",
    name: "TagManagement-TagDetail",
    component: () => import("@/views/tags/TagDetail.vue"),
  },
  {
    path: "/tags/:id/add-destination",
    name: "TagManagement-AddTagToDestination",
    component: () => import("@/views/tags/AddTagToDestination.vue"),
  },
  {
    path: "/tags/create",
    name: "TagManagement-Create",
    component: () => import("@/views/tags/AddTag.vue"),
  },
  {
    path: "/tags/update/:id",
    name: "TagManagement-Update",
    component: () => import("@/views/tags/UpdateTag.vue"),
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
