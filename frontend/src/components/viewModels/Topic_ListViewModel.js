import { ref, watch, onMounted, computed } from 'vue';
import { fetchDestinationsByTag, fetchDestinationsByCity_Tag, getTagById } from '../models/destinationModel';
import { fetchCities } from '../models/CityModel';
import { getTags } from '../models/TagModel';

export default function (topicName) {
  const topicId = ref(null);
  const destinations = ref([]);
  const tags = ref([]);
  const cities = ref([]);
  const selectedCityId = ref(null);
  const selectedIndex = ref(0);
  const dropdownVisibleRegion = ref(false);
  const loading = ref(false); // Trạng thái loading

  // Xác định topicId
  const setTopicId = () => {
    switch (topicName) {
      case 'culture': topicId.value = 2; break;
      case 'great-food': topicId.value = 13; break;
      case 'must-see-attraction': topicId.value = 5; break;
      case 'shopping': topicId.value = 9; break;
      default: topicId.value = 11; break;
    }
  };

  // Hàm tải dữ liệu điểm đến
  const fetchFilteredDestinations = async () => {
    loading.value = true;
    try {
      let data = [];
      console.log('selectedIndex:', selectedIndex.value);
      if (selectedCityId.value && selectedIndex.value != 0) {
        console.log('function 1');
        data = await fetchDestinationsByCity_Tag(selectedCityId.value, [topicId.value, selectedIndex.value]);
      } else if (selectedCityId.value) {
        console.log('function 2');
        data = await fetchDestinationsByCity_Tag(selectedCityId.value, [topicId.value]);
      } else if (selectedIndex.value != 0) {
        console.log('function 3');
        data = await fetchDestinationsByTag([topicId.value, selectedIndex.value]);
      } else {
        console.log('function 4');
        data = await fetchDestinationsByTag([topicId.value]);
      }

      // Thêm tags vào mỗi điểm đến
      for (const destination of data) {
        destination.tags = await getTagById(destination.id);
      }

      // Sắp xếp kết quả theo mức độ phổ biến
      destinations.value = data.sort((a, b) => b.popularity_score - a.popularity_score);

    } catch (error) {
      console.error('Lỗi tải dữ liệu:', error);
    } finally {
      loading.value = false;
    }
  };

  // Theo dõi sự thay đổi để gọi hàm tự động
  watch(selectedCityId, fetchFilteredDestinations);

  // Tải dữ liệu khi component được mount
  onMounted(async () => {
    setTopicId();
    await fetchFilteredDestinations(); // Gọi dữ liệu ban đầu
    tags.value = await getTags();
    cities.value = await fetchCities();
  });

  // Hàm chọn thành phố
  const selectCity = (cityId) => {
    selectedCityId.value = cityId;
    dropdownVisibleRegion.value = false;
  };

  // Hàm chọn tag
  const selectButton = (index) => {
    selectedIndex.value = selectedIndex.value === index ? 0 : index;
    
  };

  // Rút gọn mô tả
  const truncatedDescription = (description) => {
    const words = description.split(' ');
    return words.length > 25 ? words.slice(0, 25).join(' ') + '...' : description;
  };

  // Lấy tên thành phố

  const selectedCityName = computed(() => {
    if (!selectedCityId.value) return 'Việt Nam';
    const city = cities.value.find(c => c.id === selectedCityId.value);
    return city ? city.name : 'Việt Nam';
});

  const toggleDropDownRegion = () => {
    dropdownVisibleRegion.value = !dropdownVisibleRegion.value;
  };

  return {
    destinations,
    tags,
    cities,
    selectedCityId,
    selectedIndex,
    dropdownVisibleRegion,
    loading,
    truncatedDescription,
    selectButton,
    selectCity,
    selectedCityName,
    toggleDropDownRegion,
    fetchFilteredDestinations, // Cho phép gọi thủ công nếu cần
  };
}
