import { ref, computed, onMounted } from 'vue';
import DestinationModel from '../models/destinationModel';

export default function () {
  const model = DestinationModel();
  const images = ref([]);

  const isMenuVisible = ref(false);
  const isReadMore = ref(false);

  const toggleMenu = () => {
    isMenuVisible.value = !isMenuVisible.value;
  };
  const currentIndex = ref(0);

  const currentImage = computed(() => {
    // Kiểm tra xem images có rỗng hay currentIndex nằm ngoài giới hạn không
    if (!images.value.length || currentIndex.value < 0 || currentIndex.value >= images.value.length) {
      return null; // Hoặc một giá trị mặc định, ví dụ: '/cities/default.jpg'
    }
    return images.value[currentIndex.value].imageUrl;
  });

  const nextImage = () => {
    if (images.value.length) {  // Kiểm tra images không rỗng
      currentIndex.value = (currentIndex.value + 1) % images.value.length;
    }
  };
  
  const prevImage = () => {
    if (images.value.length) { // Kiểm tra images không rỗng
      currentIndex.value = (currentIndex.value - 1 + images.value.length) % images.value.length;
    }
  };

  const isHeartFilled = ref(false);

  const toggleHeart = () => {
    isHeartFilled.value = !isHeartFilled.value;
  };

  const truncatedDescription = ref(model.getTruncatedDescription());

  const toggleReadMore = () => {
    isReadMore.value = !isReadMore.value;
    truncatedDescription.value = model.getDescription(isReadMore);
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

  onMounted(async () => {
    images.value = await model.fetchImages();
  });

  const generateStars = (rating) => {
    return model.generateStars(rating);
  };

  const getImageUrl = (imageUrl) => {
    return new URL(imageUrl, import.meta.url).href;
  };

  const toggleLikeStatus = (id) => {
    liked.value[id] = !liked.value[id];
  };

  return {
    isMenuVisible,
    toggleMenu,
    currentImage,
    nextImage,
    prevImage,
    isHeartFilled,
    toggleHeart,
    truncatedDescription,
    toggleReadMore,
    buttons,
    selectedIndices,
    selectButton,
    images,
    entertainments,
    generateStars,
    getImageUrl,
    liked,
    toggleLikeStatus,
    heartFull: model.heartFull,
    heartEmpty: model.heartEmpty,
  };
}