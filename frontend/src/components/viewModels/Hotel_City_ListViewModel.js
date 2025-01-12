import { ref, onMounted, watch, nextTick } from 'vue';
import { fetchHotelsByCity, fetchHotelsByFilter_City } from '../models/destinationModel.js';

import 'nouislider/dist/nouislider.css';

export default function (city_id) {

  const isMenuVisible = ref(false);
  const toggleMenu = () => {
    isMenuVisible.value = !isMenuVisible.value;
  };
  const searchQuery = ref('');

  const hotels = ref([]);
  const liked = ref({});

  

  const activeOptions = ref({
    amenities: false,
    hotel_star: false,
    price_range: false,
  });

  

  const toggleOptions = (optionKey) => {
    activeOptions.value[optionKey] = !activeOptions.value[optionKey];
  };

  const amenities_options = [
    'Free Wifi',
    'Breakfast included',
    'Parking',
    'Pool',
    'Restaurant',
    'Fitness center',
    'Bar/Lounge',
    'Spa',
  ];

  const hotel_star_options = [
    1,
    2,
    3,
    4,
    5,
  ];

  const price_range_options = [
    'low',
    'middle',
    'high',
  ];

  const save_option_price_range = ref([]);
  const save_option_amenities = ref([]);
  const save_option_hotel_star = ref([]);

  const filterHotels = async () => {
    const filteredHotels = await fetchHotelsByFilter_City(
      city_id,
      save_option_price_range.value, 
      save_option_amenities.value, 
      save_option_hotel_star.value, 
    );
    
    console.log('Filtered Hotels');  // Kiểm tra dữ liệu
  
    // Cập nhật restaurants sau khi có dữ liệu
    hotels.value = filteredHotels;
    
    // Gọi nextTick để đảm bảo Vue cập nhật giao diện sau khi thay đổi
    nextTick(() => {
      console.log('Hotels updated:');
    });
  };

  

  // Tạo đối tượng chứa tất cả các mảng
  const saveOptionsMap = {
    save_option_price_range,
    save_option_amenities,
    save_option_hotel_star,
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

    await filterHotels();
  };

  return {
    filterHotels,
    isMenuVisible,
    toggleMenu,
    hotels,
    liked,
    searchQuery,
    activeOptions,
    toggleOptions,
    amenities_options,
    hotel_star_options,
    price_range_options,
    save_option_price_range,
    save_option_amenities,
    save_option_hotel_star,
    handleCheckboxChange,
  };
}
