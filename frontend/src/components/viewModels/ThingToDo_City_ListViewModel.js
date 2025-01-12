import { ref, computed, onMounted } from 'vue';
import { fetchDestinationsByCity, getTagById, fetchRecommendationsByCity} from '../models/destinationModel';
import { fetchCityDetails, fetchCities } from '../models/CityModel';
import { getTags as fetchTagsAPI } from '../models/TagModel';
import SignInModel from '../models/SignInModel';
export default function (cityId) {
  

  const isMenuVisible = ref(false);
  

  const toggleMenu = () => {
    isMenuVisible.value = !isMenuVisible.value;
  };
  


  const buttons = ref([]);
  const selectedIndices = ref([]);
  const filteredDestinations = ref([]);
  const destinations = ref([]);
  const city = ref(null);
  
  const liked = ref({});

  const fetchCityDetailsData = async () => {
    try {
      const data = await fetchCityDetails(cityId);
      city.value = data || null;
    } catch (error) {
      console.error('Error fetching city details:', error);
    }
  };

  const fetchTags = async () => {
    try {
      buttons.value = await fetchTagsAPI();
    } catch (error) {
      console.error("Error fetching tags:", error);
    }
  };

  const fetchDestinationsData = async () => {
    try {
        let place;

        // Nếu đã có dữ liệu, chỉ lọc lại; nếu chưa, gọi API
        if (destinations.value.length) {
            place = [...destinations.value];
        } else {
            place = await fetchDestinationsByCity(cityId);
            for (let destination of place) {
              try {
                  const tags = await getTagById(destination.id); // Giả sử hàm getTagById đã tồn tại
                  destination.tags = tags; // Gán tags vào destination
              } catch (error) {
                  console.error(`Error fetching tags for destination ${destination.id}:`, error);
                  destination.tags = []; // Gán mảng rỗng nếu gọi API thất bại
              }
          }
        }

        // Gọi API để lấy tags cho từng destination
        

        // Lọc dữ liệu theo tags
        const filteredPlace = filterItems(place);

        // Phân loại dữ liệu
        destinations.value = place.filter(destination => destination.hotel_id === null && destination.restaurant_id === null);

        filteredDestinations.value = filteredPlace.filter(destination => destination.hotel_id === null && destination.restaurant_id === null);

    } catch (error) {
        console.error('Error fetching destinations:', error);
    }
};

  const filterItems = (items) => {
    // Nếu items không tồn tại hoặc không phải là mảng, trả về mảng rỗng
    if (!Array.isArray(items)) return [];
    
    // Nếu không có tag nào được chọn, trả về toàn bộ danh sách
    if (!selectedIndices.value.length) return [...items];
  
    // Lọc các mục có ít nhất một tag trùng với tag đã chọn
    return items.filter(item => 
      Array.isArray(item.tags) && item.tags.some(tag => selectedIndices.value.includes(tag.id))
    );
  };

  const selectButton = async (index) => {
    const currentIndex = selectedIndices.value.indexOf(index);
    if (currentIndex === -1) {
      selectedIndices.value.push(index);
    } else {
      selectedIndices.value.splice(currentIndex, 1);
    }

    await fetchDestinationsData();
  };

  const toggleLikeStatus = (id) => {
    liked.value[id] = !liked.value[id];
    console.log(`Item ID: ${id}, Liked: ${liked.value[id]}`);
  };
  const truncatedDescription = (description) => {
    if (description.length > 200) {
      return description.slice(0, 200) + '...';
    }
    return description;
  };

  const heartFull = new URL('@/assets/svg/heart-full.svg', import.meta.url).href;
  const heartEmpty = new URL('@/assets/svg/heart-none.svg', import.meta.url).href;


  const recommendations = ref([]);
  const cities = ref([]);
  const user = ref(null);
  const token = sessionStorage.getItem('access_token');
  const loadUser = async () => {
    const signInModel = new SignInModel("", "");
    try{
      if(token){
        const userResult = await signInModel.fetchCurrentUser(token);
        console.log("User",userResult);
        if(userResult.success){
          user.value = userResult.user;
          console.log("User",user.value);
          console.log("User ID",user.value.id);
          await getRecommendationsByCity(user.value.id, cityId);
          console.log("Dữ liệu khóa học", recommendations.value);
        } else {
        console.error('Cannot get user:', error);
        }
      }
      
    } catch (error) {
      console.error('An error occurred during authentication:', error);
      return { success: false, message: error.message || 'An error occurred' };
    }
    
  }

  const loadCities = async () => {
    try {
      const data = await fetchCities();
      console.log("Dữ liệu thành phố:", data); // Kiểm tra dữ liệu
      cities.value = data;
    } catch (error) {
      console.error("Có lỗi xảy ra khi lấy dữ liệu thành phố:", error);
    }
  };

  const getRecommendationsByCity = async () => {
    console.log("User ID",user.value); 
    try {
      const data = await fetchRecommendationsByCity(user.value.id, cityId);
      recommendations.value = data;
    } catch (error) {
      console.error("Có lỗi xảy ra khi lấy dữ liệu khóa học:", error);
    }
  };
  return {
    isMenuVisible,
    toggleMenu,
    fetchCityDetailsData,
    fetchTags,
    fetchDestinationsData,
    buttons,
    selectedIndices,
    selectButton,
    
    destinations,
    filteredDestinations,
    city,
    liked,
    toggleLikeStatus,
    heartFull,
    heartEmpty,
    truncatedDescription,
    user, token, loadUser, recommendations, cities, loadCities, getRecommendationsByCity,
  };
}