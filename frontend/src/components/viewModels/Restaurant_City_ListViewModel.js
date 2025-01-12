import { ref, onMounted, watch, nextTick } from 'vue';
import { fetchRestaurantsByCity, fetchRestaurantsByFilter_City } from '../models/destinationModel.js';


export default function (cityID) {
  const isMenuVisible = ref(false);
  const toggleMenu = () => {
    isMenuVisible.value = !isMenuVisible.value;
  };
  const searchQuery = ref('');

  const restaurants = ref([]);
  const liked = ref({});

  

  const activeOptions = ref({
    cuisine: false,
    meal: false,
    specialDiet: false,
    feature: false,
  });

  

  const toggleOptions = (optionKey) => {
    activeOptions.value[optionKey] = !activeOptions.value[optionKey];
  };

  const cuisine_options = [
    'American',
    'Asian',
    'Barbecue',
    'Chinese',
    'French',
    'Greek',
    'Indian',
    'Italian',
    'Japanese',
    'Korean',
    'Mediterranean',
    'Mexican',
    'Middle Eastern',
    'Spanish',
    'Thai',
    'Vietnamese',
  ];

  const meal_options = [
    'Breakfast',
    'Brunch',
    'Lunch',
    'Dinner',
    'Dessert',
    'Snack',
  ];

  const special_diet_options = [
    'Vegetarian',
    'Vegan',
    'Gluten Free',
    'Keto',
    'Paleo',
    'Low Carb',
    'Low Fat',
    'Low Sodium',
    'Low Sugar',
    'Organic',
  ];

  const feature_options = [
    'Outdoor Seating',
    'Takeout',
    'Delivery',
    'Reservations',
    'Wheelchair Accessible',
    'Pet Friendly',
    'Live Music',
    'Wifi',
    'Parking',
    'BYOB',
  ];

  const save_option_cuisine = ref([]);
  const save_option_meal = ref([]);
  const save_option_special_diet = ref([]);
  const save_option_feature = ref([]);

  const filterRestaurants = async () => {
    const filteredRestaurants = await fetchRestaurantsByFilter_City(
      cityID,
      save_option_cuisine.value, 
      save_option_meal.value, 
      save_option_special_diet.value, 
      save_option_feature.value
    );
    
    console.log('Filtered restaurants:', filteredRestaurants);  // Kiểm tra dữ liệu
  
    // Cập nhật restaurants sau khi có dữ liệu
    restaurants.value = filteredRestaurants;
    
    // Gọi nextTick để đảm bảo Vue cập nhật giao diện sau khi thay đổi
    nextTick(() => {
      console.log('Restaurants updated:', restaurants.value);
    });
  };

  

  // Tạo đối tượng chứa tất cả các mảng
  const saveOptionsMap = {
    save_option_cuisine,
    save_option_meal,
    save_option_special_diet,
    save_option_feature,
  };

  // Hàm xử lý checkbox
  const handleCheckboxChange = async (option, saveArrayName) => {
    // Lấy mảng dựa trên tên
    const saveArray = saveOptionsMap[saveArrayName];

    if (!saveArray) {
      console.error(`Invalid array name: ${saveArrayName}`);
      return;
    }

    if (saveArray.value.includes(option)) {
      // Xóa phần tử nếu đã tồn tại
      saveArray.value = saveArray.value.filter((item) => item !== option);
    } else {
      // Thêm phần tử nếu chưa tồn tại
      saveArray.value.push(option);
    }

    await filterRestaurants();
  };

  return {
    filterRestaurants,
    isMenuVisible,
    toggleMenu,
    restaurants,
    liked,
    searchQuery,
    activeOptions,
    toggleOptions,
    cuisine_options,
    meal_options,
    special_diet_options,
    feature_options,
    save_option_cuisine,
    save_option_meal,
    save_option_special_diet,
    save_option_feature,
    handleCheckboxChange,
  };
}