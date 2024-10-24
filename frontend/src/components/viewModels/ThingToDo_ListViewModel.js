import { ref, onMounted, watch, nextTick, computed } from 'vue';
import ThingtodoModel from '../models/ThingToDo_ListModel';

export default function () {
  const model = ThingtodoModel();

  const isMenuVisible = ref(false);
  const toggleMenu = () => {
    isMenuVisible.value = !isMenuVisible.value;
  };
  const searchQuery = ref('');

  const attractions = ref([]);
  const cities = ref([]);
  const liked = ref({});

  onMounted(async () => {
    attractions.value = await model.fetchEntertainments();
    cities.value = await model.fetchCities();
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

  const generateStars = (rating) => {
    return model.generateStars(rating);
  };

  const getImageUrl = (imageUrl) => {
    return new URL(imageUrl, import.meta.url).href;
  };

  const toggleLikeStatus = (id) => {
    liked.value[id] = !liked.value[id];
    console.log(`Item ID: ${id}, Liked: ${liked.value[id]}`);
  };



  

  

  

  return {
    isMenuVisible,
    toggleMenu,
    
    
    generateStars,
    getImageUrl,
    liked,
    toggleLikeStatus,
    heartFull: model.heartFull,
    heartEmpty: model.heartEmpty,
    searchQuery,
    cities,
    visibleCities,
    prevCity,
    nextCity,
    attractions,
    visibleAttraction,
    prevAttraction,
    nextAttraction,
  };
}
