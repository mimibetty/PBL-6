import { ref, computed, onMounted } from 'vue';
import ThingtodoModel from '../models/city_ThingToDo_ListModel';

export default function () {
  const model = ThingtodoModel();
  

  const isMenuVisible = ref(false);
  

  const toggleMenu = () => {
    isMenuVisible.value = !isMenuVisible.value;
  };
  


  const buttons = ref(model.buttons);
  const selectedIndices = ref([]);

  const selectButton = (index) => {
    const currentIndex = selectedIndices.value.indexOf(index);

    if (currentIndex === -1) {
      selectedIndices.value.push(index);
    } else {
      selectedIndices.value.splice(currentIndex, 1);
    }
  };

  const entertainments = ref([]);
  
  const liked = ref({});

  onMounted(async () => {
    entertainments.value = await model.fetchEntertainments();
  });


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
    
    buttons,
    selectedIndices,
    selectButton,
    
    entertainments,
    generateStars,
    getImageUrl,
    liked,
    toggleLikeStatus,
    heartFull: model.heartFull,
    heartEmpty: model.heartEmpty,
  };
}