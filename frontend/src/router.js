import { createRouter, createWebHistory } from 'vue-router';

// Sử dụng dynamic import để lazy load các component
// Sign in & Sign up

// Sign in & Sign up
const SignInView = () => import('./components/views/SignInView.vue');
const SignUpView = () => import('./components/views/SignUpView.vue');

// Dashboard
const Dashboard_Final = () => import('./components/views/Dashboard/Dashboard.vue');

// List all thingstodo/restaurants/hotels
const ThingsToDo_List_All = () => import('./components/views/Things_To_Do/ThingsToDo_List_All.vue');
const Restaurants_List_All = () => import('./components/views/Restaurants/Restaurants_List_All.vue');
const Hotels_List_All = () => import('./components/views/Hotel/Hotel_List_All.vue');

// Profile
const Profile_Page = () => import('./components/views/Profile_Page/Profile_Page.vue');

// Destination
const Destination_Final = () => import('./components/views/Destination/destinationView_Test.vue');

// List thingstodo/restaurant/hotel in a city
const city_ThingsToDo_List = () => import('./components/views/Things_To_Do/ThingsToDo_1_City.vue');
const city_Restaurants_List = () => import('./components/views/Restaurants/Restaurants_1_City.vue');
const city_Hotels_List = () => import('./components/views/Hotel/Hotels_1_City.vue');

// Detail place/restaurant/hotel 
const Place = () => import('./components/views/Detail/Place.vue');
const Res = () => import('./components/views/Detail/Restaurant.vue');
const Hot = () => import('./components/views/Detail/Hotel.vue');

//Review
const writeReviewView = () => import('./components/views/Review/Review_WriteReview.vue');
const updateReviewView = () => import('./components/views/Review/Review_UpdateReview.vue');
const uploadPictureView = () => import('./components/views/Review/Review_UploadPicture.vue');
const writeTourReviewView = () => import('./components/views/Review/Review_Tour_Write.vue');
const updateTourReviewView = () => import('./components/views/Review/Review_Tour_Update.vue');

// Create a Trip
const Create_Trip = () => import('./components/views/Create_Trip.vue');
const Page_1 = () => import('./components/views/Creat_Trip/Page_1.vue');
const Page_2 = () => import('./components/views/Creat_Trip/Page_2.vue');
const Page_2_1 = () => import('./components/views/Creat_Trip/Page_2_1.vue');
const Page_3 = () => import('./components/views/Creat_Trip/Page_3.vue');
const Page_4 = () => import('./components/views/Creat_Trip/Page_4.vue');
const Page_5 = () => import('./components/views/Creat_Trip/Page_5.vue');
const Page_6_1 = () => import('./components/views/Creat_Trip/Page_6_1.vue');
const Page_6_2 = () => import('./components/views/Creat_Trip/Page_6_2.vue');
const Page_7 = () => import('./components/views/Creat_Trip/Page_7.vue');

// Detail Trip
const Detail_Trip = () => import('./components/views/Trip/Detail_Trip.vue');
const Trip_List = () => import('./components/views/Trip/Trip_List.vue');

//Dashboard_For_Company
const Dashboard_For_Company = () => import('./components/views/Dashboard_For_Company/dashboard_for_company.vue')

// Topic
const Topic_List = () => import('./components/views/Topic/Topic_List.vue');

//Tour
const Detail_Tour = () => import('./components/views/Tour/Detail/Detail_Tour.vue');
const List_Tour = () => import('./components/views/Tour/List/List_Tour.vue');

// Test UI
const test   = () => import('./components/views/Business/Business_Destination_List.vue'); 
const test1 = () => import('./components/views/Map/Map_Component.vue');
const test2 = () => import('./components/views/Chart/Chart.vue');
const test3 = () => import('./components/views/Tour/List/Tour_Item.vue');

// Review

//Business
const addDestination = () => import('./components/views/Business/Business_Destination_Add.vue');
const updateDestination = () => import('./components/views/Business/Business_Destination_Update.vue');
const addHotel = () => import('./components/views/Business/Business_Hotel_Add.vue');
const updateHotel = () => import('./components/views/Business/Business_Hotel_Update.vue');
const addRestaurant = () => import('./components/views/Business/Business_Restaurant_Add.vue');
const updateRestaurant = () => import('./components/views/Business/Business_Restaurant_Update.vue');
const destinationView = () => import('./components/views/Business/Business_Destination_List.vue');
const tourView = () => import('./components/views/Business/Business_Tour/Business_Tour_List.vue');
const tourEditView = () => import('./components/views/Business/Business_Tour/Business_Tour_Edit.vue');
const tourAddView = () => import('./components/views/Business/Business_Tour/Business_Tour_Add.vue');
const destUpdateView = () => import('./components/views/Business/Business_Destination/Edit_Destination.vue');
const destAddView = () => import('./components/views/Business/Business_Destination/Add_Destination.vue');

const restUpdateView = () => import('./components/views/Business/Business_Destination/Edit_Restaurant.vue');
const restAddView = () => import('./components/views/Business/Business_Destination/Add_Restaurant.vue');
const hotelUpdateView = () => import('./components/views/Business/Business_Destination/Edit_Hotel.vue');
const hotelAddView = () => import('./components/views/Business/Business_Destination/Add_Hotel.vue');
//Search
const search = () => import('./components/views/Search/Search.vue');

// Routes configuration
const routes = [
  // Đường dẫn mặc định nếu không có URL cụ thể
  { path: '/',
    redirect: '/login',
  },

  // Đăng nhập + Đăng ký
  { path: '/login', name: 'Login', component: SignInView },
  { path: '/sign-up', name: 'SignUp', component: SignUpView },

  // Home
  { path: '/home', name: 'Dashboard', component: Dashboard_Final },
  
  // Destination/id
  { path: '/Destination/:id', name: 'Destination', component: Destination_Final },
  
  // Things to do + Hotels + Restaurants all
  { path: '/ThingsToDo', name: 'ThingsToDoList', component: ThingsToDo_List_All },
  { path: '/Restaurants', name: 'RestaurantsList', component: Restaurants_List_All },
  { path: '/Hotels', name: 'HotelsList', component: Hotels_List_All },
  
  // Profile
  { path: '/Profile_Page', name: 'ProfilePage', component: Profile_Page },
  
  // City things to do + Restaurants + Hotels
  { path: '/ThingsToDo/:id', name: 'CityThingsToDo', component: city_ThingsToDo_List },
  { path: '/Restaurants/:id', name: 'CityRestaurants', component: city_Restaurants_List },
  { path: '/Hotels/:id', name: 'CityHotels', component: city_Hotels_List },
  
  // Detail Place + Restaurant + Hotel
  { path: '/Detail/Place/:id', name: 'PlaceDetail', component: Place },
  { path: '/Detail/Restaurant/:id', name: 'RestaurantDetail', component: Res },
  { path: '/Detail/Hotel/:id', name: 'HotelDetail', component: Hot },
  
  // Review
  { path: '/Review/Write/:id', name: 'WriteReview', component: writeReviewView },
  { path: '/Review/Update/:id', name: 'UpdateReview', component: updateReviewView },
  { path: '/Review/Upload/:id', name: 'UploadPicture', component: uploadPictureView },
  { path: '/Review/Tour/Write/:id', name: 'WriteReviewTour', component: writeTourReviewView },
  { path: '/Review/Tour/Update/:id', name: 'UpdateReviewTour', component: updateTourReviewView },
  
  // Create Trip
  { path: '/Create_Trip/', name: 'Page_1', component: Page_1 },
  { path: '/Create_Trip/Page_2', name: 'Page_2', component: Page_2 },
  { path: '/Create_Trip/Page_2_1', name: 'Page_2_1', component: Page_2_1 },
  { path: '/Create_Trip/Page_3', name: 'Page_3', component: Page_3 },
  { path: '/Create_Trip/Page_4', name: 'Page_4', component: Page_4 },
  { path: '/Create_Trip/Page_5', name: 'Page_5', component: Page_5 },
  { path: '/Create_Trip/Page_6_1', name: 'Page_6_1', component: Page_6_1 },
  { path: '/Create_Trip/Page_6_2', name: 'Page_6_2', component: Page_6_2 },
  {
    path: '/Create_Trip/Page_7/:id',
    name: 'Page_7',
    component: Page_7,
  },
  
  // Detail Trip
  { path: '/Trip/:id', name: 'DetailTrip', component: Detail_Trip },
  { path: '/Trip', name: 'Trip', component: Trip_List },
  
  // Topic_List
  { path: '/Topic/:topic', name: 'Topic_List', component: Topic_List },
  
  // Detail_Tour
  { path: '/Tour/:id', name: 'Detail_Tour', component: Detail_Tour },
  
  // List_Tour
  { path: '/Tour', name: 'List_Tour', component: List_Tour },
  
  // Business
  { path: '/Business', name: 'Dashboard_For_Company', component: Dashboard_For_Company },
  { path: '/Business/Destination/Add', name: 'destAddView', component: destAddView },
  { path: '/Business/Destination/Update/:id', name: 'destUpdateView', component: destUpdateView },
  
  { path: '/Business/Hotel/Add/:id', name: 'hotelAddView', component: hotelAddView },
  { path: '/Business/Hotel/Update/:id', name: 'hotelUpdateView', component: hotelUpdateView },

  { path: '/Business/Restaurant/Add/:id', name: 'restAddView', component: restAddView },
  { path: '/Business/Restaurant/Update/:id', name: 'restUpdateView', component: restUpdateView },

  { path: '/Business/Destination', name: 'DestinationView', component: destinationView },
  { path: '/Business/Tour', name: 'tourView', component: tourView },
  { path: '/Business/Tour/Update/:id', name: 'tourEditView', component: tourEditView },
  { path: '/Business/Tour/Add', name: 'tourAddView', component: tourAddView },
  
  // Search
  { 
    path: '/search', 
    name: 'Search', 
    component: search,
    props: route => ({ query: route.query.q }) // Truyền query vào props của component
  },

  // Test UI
  { path: '/test', name: 'Test', component: test },
  { path: '/test1', name: 'Test1', component: test1 },
  { path: '/test2', name: 'Test2', component: test2 },
  { path: '/test3', name: 'Test3', component: test3 },
  { path: '/', redirect: '/login' },
  
];

// Router instance
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL || '/'),
  routes,
});

export default router;
