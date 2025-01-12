import { ref, onMounted, watch, nextTick, computed } from 'vue';
import { fetchCities } from '../models/CityModel'
import { fetchAttractions,  } from '../models/destinationModel';

export default function () {

  const isMenuVisible = ref(false);
  const toggleMenu = () => {
    isMenuVisible.value = !isMenuVisible.value;
  };
  const searchQuery = ref('');

  const attractions = ref([]);
  const cities = ref([]);
  const liked = ref({});
  const loading = ref(true);
  const loadingCities = ref(true);

  onMounted(async () => {
    cities.value = await fetchCities();
    loadingCities.value = false;
    attractions.value = await fetchAttractions();
    loading.value = false;
  });

  const currentIndexCity = ref(0);
  const visibleCities = computed(() => {
    return cities.value.slice(currentIndexCity.value, currentIndexCity.value + 4);
  });
  
  const prevCity = () => {
    if (currentIndexCity.value > 0) currentIndexCity.value--;
  };
  
  const nextCity = () => {
    if (currentIndexCity.value < cities.value.length - 4) currentIndexCity.value++;
  };

  const currentIndexAttraction = ref(0);
  const visibleAttraction = computed(() => {
    return attractions.value.slice(currentIndexAttraction.value, currentIndexAttraction.value + 4);
  });
  
  const prevAttraction = () => {
    if (currentIndexAttraction.value > 0) currentIndexAttraction.value--;
  };
  
  const nextAttraction = () => {
    if (currentIndexAttraction.value < attractions.value.length - 4) currentIndexAttraction.value++;
  };

  const getImageUrl = (imageUrl) => {
    return new URL(imageUrl, import.meta.url).href;
  };

  const toggleLikeStatus = (id) => {
    liked.value[id] = !liked.value[id];
    console.log(`Item ID: ${id}, Liked: ${liked.value[id]}`);
  };

  const heartFull = new URL('@/assets/svg/heart-full.svg', import.meta.url).href;
  const heartEmpty = new URL('@/assets/svg/heart-none.svg', import.meta.url).href;

  return {
    isMenuVisible,
    toggleMenu,
    getImageUrl,
    liked,
    toggleLikeStatus,
    searchQuery,
    cities,
    visibleCities,
    prevCity,
    nextCity,
    attractions,
    visibleAttraction,
    prevAttraction,
    nextAttraction,
    heartFull,
    heartEmpty,
    loading,
    loadingCities,
  };
}
