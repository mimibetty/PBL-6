import { ref, computed, onMounted } from 'vue';
import { getRestaurantById } from '../models/destinationModel.js';

import { getReviewByDestinationId } from '../models/ReviewModel.js';
import { getUserById } from '../models/UserModel.js';
import { fetchCityDetails } from '../models/CityModel';
import generateViewModel from './generate_ratingViewModel'; 

import SignInModel from '../models/SignInModel'; 

export default function(restaurantID) {

  const isLoading = ref(false);
  const isDropdownVisible = ref(false);
  const isMenuVisible = ref(false);
  const restaurant = ref(null);
  const images = ref([]);
  const commentList = ref([]);
  const city = ref(null);
  const { fetchRatingDistribution, ratings} = generateViewModel();

  const user = ref(null);
  const token = sessionStorage.getItem('access_token');
  const canReview = ref(true);
  const loadUser = async () => {
    const signInModel = new SignInModel("", "");
    try{
      if(token){
        const userResult = await signInModel.fetchCurrentUser(token);
        if(userResult.success){
          user.value = userResult.user;
        } else {
        console.error('Cannot get user:', error);
        }
      }
      
    } catch (error) {
      console.error('An error occurred during authentication:', error);
      return { success: false, message: error.message || 'An error occurred' };
    }
    
  }


  const loadRestaurant = async () => {
    try {
      restaurant.value = await getRestaurantById(restaurantID);
      console.log("Restaurant: ",restaurant.value);
      console.log("City ID: ",restaurant.value.id);
      city.value = await fetchCityDetails(restaurant.value.address.city_id);
      images.value = restaurant.value.images;
    } catch (error) {
      console.error("Có lỗi xảy ra khi lấy dữ liệu nhà hàng:", error);
    }
  };
  
  const getAllcomments = async () => {
    if (!restaurant.value || !restaurant.value.id) {
      console.error("Không thể lấy nhận xét: destination chưa được tải.");
      return;
    }
  
    try {
      console.log(restaurant.value.id);
      commentList.value = await getReviewByDestinationId(restaurant.value.id);
    } catch (error) {
      console.error("Có lỗi xảy ra khi lấy nhận xét:", error);
    }
  };
  
  const loadUsersForComments = async () => {
    if (commentList.value.length === 0) {
      console.warn("Danh sách nhận xét trống, không thể tải thông tin người dùng.");
      return;
    }
  
    const userSet = new Set(); // Dùng Set để tránh gọi lại API cho các user_id trùng nhau
    try {
      commentList.value.forEach(comment => {
        if (comment.user_id) {
          userSet.add(comment.user_id);
          if(user.value && comment.user_id == user.value.id){
            canReview.value = false;
          }
        }
      });
  
      const userPromises = Array.from(userSet).map(userID => getUserById(userID));
      const userResults = await Promise.all(userPromises);
  
      const userMap = new Map();
      userResults.forEach(user => {
        if (user && user.id) {
          userMap.set(user.id, user);
        }
      });
  
      commentList.value.forEach(comment => {
        const user = userMap.get(comment.user_id);
        if (user) {
          comment.user = user; // Thêm thông tin user vào mỗi comment
        }
      });
  
      console.log("Danh sách nhận xét với thông tin người dùng:", commentList.value);
    } catch (error) {
      console.error("Có lỗi xảy ra khi tải thông tin người dùng:", error);
    }
  };
  
  const initializePage = async () => {
    try {
      await loadRestaurant();      // Đợi loadRestaurant hoàn tất
      await getAllcomments();      // Sau đó gọi getAllcomments
      await loadUsersForComments(); // Cuối cùng là loadUsersForComments
      await fetchRatingDistribution(restaurant.value.id);
  
      isLoading.value = true; // Chuyển trạng thái sang loaded khi hoàn thành
    } catch (error) {
      console.error("Có lỗi xảy ra khi tải trang:", error);
    }
  };
  loadUser();
  initializePage();
  
  
  


  const toggleDropdown = () => {
    isDropdownVisible.value = !isDropdownVisible.value;
    console.log(isDropdownVisible);
  };

  const toggleMenu = () => {
    isMenuVisible.value = !isMenuVisible.value;
    console.log(isMenuVisible);
  };

  

  // Chuyển đổi hình ảnh
  const currentIndex = ref(0);

  const currentImage = computed(() => {
    if (!images.value.length || currentIndex.value < 0 || currentIndex.value >= images.value.length) {
      return null;
    }
    console.log("Current image: ", images.value[currentIndex.value].url);
    return images.value[currentIndex.value].url;
  });

  const nextImage = () => {
    if (images.value.length) {
      currentIndex.value = (currentIndex.value + 1) % images.value.length;
    }
  };

  const prevImage = () => {
    if (images.value.length) {
      currentIndex.value = (currentIndex.value - 1 + images.value.length) % images.value.length;
    }
  };

  // Fetch dữ liệu ảnh và bình luận
  getAllcomments();

  return {
    isDropdownVisible,
    toggleDropdown,
    currentImage,
    nextImage,
    prevImage,
    commentList,
    images,
    isMenuVisible,
    toggleMenu,
    restaurant,
    city,
    isLoading,
    user,
    token,
    ratings,
    canReview,
  };
}

