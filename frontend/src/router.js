import { createRouter, createWebHistory } from 'vue-router';

// Sử dụng dynamic import để lazy load các component
const SignInView = () => import('./components/views/SignInView.vue');
const SignUpView = () => import('./components/views/SignUpView.vue');
const DashBoardView = () => import('./components/views/dashboard.vue');
const destinationView = () => import('./components/views/destinationView.vue');
const detailLocation_Entertainment = () => import('./components/views/detailLocation_Entertainment.vue');

const routes = [
  {
    path: '/login',
    name: 'Login to Account',
    component: SignInView,  // Lazy load SignInView
  },
  {
    path: '/sign-up',
    name: 'Create a new account',
    component: SignUpView,  // Lazy load SignUpView
  },
  {
    path: '/home',
    name: 'Dashboard',
    component: DashBoardView,  // Lazy load DashBoardView
  },
  {
    path: '/destination',
    name: 'Destination',
    component: destinationView,  // Lazy load destinationView
  },
  {
    path: '/detailLocation/Entertainment',
    name: 'DetailLocation_Entertainment',
    component: detailLocation_Entertainment,  // Lazy load detailLocation_Entertainment
  },
  // Đường dẫn mặc định nếu không có URL cụ thể
  {
    path: '/',
    redirect: '/login',
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;

