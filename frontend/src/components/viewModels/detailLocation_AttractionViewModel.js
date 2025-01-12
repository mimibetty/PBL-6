import { ref, computed, onMounted } from 'vue';
import { getDestinationById } from '../models/destinationModel.js';
import { getReviewByDestinationId } from '../models/ReviewModel.js';
import { getUserById } from '../models/UserModel.js';
import { fetchCityDetails } from '../models/CityModel'; 
import SignInModel from '../models/SignInModel';
import generateViewModel from './generate_ratingViewModel'; 

export default function(destinationID) {
  class DescriptionModel {
    constructor(fullDescription) {
        this.fullDescription = fullDescription;
    }

    getTruncatedDescription() {
        return this.fullDescription.split(' ').slice(0, 40).join(' ') + '...';
    }

    getDescription(isReadMore) {
        return isReadMore.value ? this.fullDescription : this.getTruncatedDescription();
    }
}

  // Khởi tạo dữ liệu đánh giá
  const isLoading = ref(false);
  const isDropdownVisible = ref(false);
  const isMenuVisible = ref(false);
  const isReadMore = ref(false);
  const destination = ref(null);
  const descriptionModel = ref(null);
  const truncatedDescription = ref('');
  const images = ref([]);
  const commentList = ref([]);
  const city = ref(null);
  const canReview = ref(true);
  const { fetchRatingDistribution, ratings} = generateViewModel();

  const user = ref(null);
  const token = sessionStorage.getItem('access_token');
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

  const loadDestination = async () => {
    try {
      destination.value = await getDestinationById(destinationID);
      if (destination.value && destination.value.description) {
        // Khởi tạo DescriptionModel với mô tả đầy đủ lấy từ API
        descriptionModel.value = new DescriptionModel(destination.value.description);
        truncatedDescription.value = descriptionModel.value.getTruncatedDescription();
      
      }
      images.value = destination.value.images;
      city.value = await fetchCityDetails(destination.value.address.city_id);
      isLoading.value = true;
    } catch (error) {
      console.error("Có lỗi xảy ra khi lấy dữ liệu destination:", error);
    }
  };
  const getAllcomments = async () => {
    if (!destination.value || !destination.value.id) {
      console.error("Không thể lấy nhận xét: destination chưa được tải.");
      return;
    }
  
    try {
      console.log(destination.value.id);
      commentList.value = await getReviewByDestinationId(destination.value.id);
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
      await loadDestination();      // Đợi loadRestaurant hoàn tất
      await getAllcomments();      // Sau đó gọi getAllcomments
      await loadUsersForComments(); // Cuối cùng là loadUsersForComments
      await fetchRatingDistribution(destination.value.id);
  
      isLoading.value = true; // Chuyển trạng thái sang loaded khi hoàn thành
    } catch (error) {
      console.error("Có lỗi xảy ra khi tải trang:", error);
    }
  };
  loadUser();
  initializePage();
  
  

  const toggleReadMore = () => {
    isReadMore.value = !isReadMore.value;
    truncatedDescription.value = descriptionModel.value.getDescription(isReadMore);
  };

  const toggleDropdown = () => {
    isDropdownVisible.value = !isDropdownVisible.value;
    console.log(isDropdownVisible);
  };

  const toggleMenu = () => {
    isMenuVisible.value = !isMenuVisible.value;
    console.log(isMenuVisible);
  };

  // Danh sách bình luận
  


  // Hàm lấy bình luận
  

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
    truncatedDescription,
    toggleReadMore,
    isReadMore,
    destination,
    city,
    isLoading,
    user,
    token,
    ratings,
    canReview,
  };
}

