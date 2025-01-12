import { ref, computed } from 'vue';
import { fetchTopics } from '../models/dashboardModel';
import { fetchCities } from '../models/CityModel'
import { fetchTours } from '../models/TourModel'
import { fetchRecommendtions } from '../models/destinationModel';
import SignInModel from '../models/SignInModel';

const activeButton = ref('all');
const cities = ref([]);
const topics = ref([]);
const tours = ref([]);
const currentIndex = ref(0);
const recommendations = ref([]);
const user = ref(null);
const token = sessionStorage.getItem('access_token');

const setActive = (button) => {
  console.log(button);
  activeButton.value = button;
  currentIndex.value = 0;
};

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
        await getRecommendations(user.value.id);
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

const getRecommendations = async () => {
  console.log("User ID",user.value); 
  try {
    const data = await fetchRecommendtions(user.value.id);
    recommendations.value = data;
  } catch (error) {
    console.error("Có lỗi xảy ra khi lấy dữ liệu khóa học:", error);
  }
};

const filteredCities = computed(() => {
  if (activeButton.value === 'all') {
    return cities.value;
  }
  return cities.value.filter(city => city.region.toLowerCase().includes(activeButton.value.replace("-", " ")));
});

const getCityName = (cityId) => {
  const city = cities.value.find(city => city.id === cityId); // Tìm thành phố theo `city_id`
  return city ? city.name : null; // Trả về tên thành phố hoặc `null` nếu không tìm thấy
};

const visibleCities = computed(() => {
  return filteredCities.value.slice(currentIndex.value, currentIndex.value + 6);
});

const prevSlide = () => {
  if (currentIndex.value > 0) currentIndex.value--;
};

const nextSlide = () => {
  if (currentIndex.value < filteredCities.value.length - 8) currentIndex.value++;
};

// Trả về id thành phố mà không thực hiện điều hướng
const goToDestination = (id) => id;

const loadTopics = async () => {
  try {
    const data = await fetchTopics();
    console.log("Dữ liệu chủ đề:", data); // Kiểm tra dữ liệu
    topics.value = data;
  } catch (error) {
    console.error("Có lỗi xảy ra khi lấy dữ liệu topics:", error);
  }
};

const currentIndex_topic = ref(0);

const visibleTopics = computed(() => {
  return topics.value.slice(currentIndex_topic.value, currentIndex_topic.value + 4);
});

const prevTopic = () => {
  if (currentIndex_topic.value > 0) currentIndex_topic.value--;
};

const nextTopic = () => {
  if (currentIndex_topic.value < topics.value.length - 4) currentIndex_topic.value++;
};

const loadTours = async () => {
  try {
    const data = await fetchTours();
    console.log("Dữ liệu tour:", data); // Kiểm tra dữ liệu
    tours.value = data;
  } catch (error) {
    console.error("Có lỗi xảy ra khi lấy dữ liệu tours:", error);
  }
};

const currentIndex_tour = ref(0);

const visibleTours = computed(() => {
  return tours.value.slice(currentIndex_tour.value, currentIndex_tour.value + 12);
});

const prevTour = () => {
  if (currentIndex_tour.value > 0) currentIndex_tour.value--;
  console.log(currentIndex_tour);
};

const nextTour = () => {
  if (currentIndex_tour.value < tours.value.length - 3) currentIndex_tour.value++;
  console.log(currentIndex_tour);
};

// Hàm tạo sao dựa trên rating
const generateStars = (rating) => {
  const fullStar = new URL('@/assets/svg/star_full.svg', import.meta.url).href;
  const halfStar = new URL('@/assets/svg/star_half.svg', import.meta.url).href;
  const emptyStar = new URL('@/assets/svg/star_none.svg', import.meta.url).href;

  let stars = [];
  for (let i = 1; i <= 5; i++) {
    if (rating >= i) {
      stars.push(fullStar);
    } else if ((rating > i - 1 && rating - i + 1 >=0.5 )&& rating < i) {
      stars.push(halfStar);
    } else {
      stars.push(emptyStar);
    }
  }
  return stars;
};


const isMenuVisible = ref(false);

const toggleMenu = () => {
  isMenuVisible.value = !isMenuVisible.value;
};



loadCities();
loadTopics();
loadTours();
loadUser();

export default {
  activeButton,
  setActive,
  cities,
  visibleCities,
  prevSlide,
  nextSlide,
  topics,
  visibleTopics,
  prevTopic,
  nextTopic,
  tours,
  visibleTours,
  prevTour,
  nextTour,
  isMenuVisible,
  toggleMenu,
  generateStars,
  goToDestination,
  getCityName,
  recommendations,
  user, 
  
};
