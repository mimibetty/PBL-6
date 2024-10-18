import { createRouter, createWebHistory } from 'vue-router';

// Sử dụng dynamic import để lazy load các component
const SignInView = () => import('./components/views/SignInView.vue');
const SignUpView = () => import('./components/views/SignUpView.vue');
const DashBoardView = () => import('./components/views/dashboard.vue');
const DashBoardView_Test = () => import('./components/views/Dashboard_Test.vue');
const destinationView = () => import('./components/views/destinationView.vue');
const detailLocation_Place = () => import('./components/views/detailLocation_Place.vue');

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
    path: '/test',
    name: 'Dashboard_Test',
    component: DashBoardView_Test,  // Lazy load DashBoardView
  },
  {
    path: '/destination',
    name: 'Destination',
    component: destinationView,  // Lazy load destinationView
  },
  {
    path: '/detailLocation/Place',
    name: 'DetailLocation_Place',
    component: detailLocation_Place,  // Lazy load detailLocation_Entertainment
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

