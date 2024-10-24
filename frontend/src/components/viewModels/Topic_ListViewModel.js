import { ref, computed, onMounted } from 'vue';
import ThingtodoModel from '../models/Topic_ListModel';

export default function () {
  const model = ThingtodoModel();

  const isMenuVisible = ref(false);
  const toggleMenu = () => {
    isMenuVisible.value = !isMenuVisible.value;
  };

  // Các button và lựa chọn từ Model
  const buttons = ref(model.buttons);
  const selectedIndex = ref(null); // Biến lưu chỉ mục duy nhất của nút đang được chọn

  const selectButton = (index) => {
    const actualIndex = currentIndexButton.value + index; // Tính chỉ số thực tế trong mảng buttons
    if (selectedIndex.value === actualIndex) {
      selectedIndex.value = null; // Nếu nhấn lại nút đã được chọn, bỏ chọn nó
    } else {
      selectedIndex.value = actualIndex; // Cập nhật nút mới được chọn
    }
  };

  const currentIndexButton = ref(0);
  const visibleButtons = computed(() => {
    return buttons.value.slice(currentIndexButton.value, currentIndexButton.value + 3);
  });

  const prevButton = () => {
    if (currentIndexButton.value > 0) {
      currentIndexButton.value--;
    }
  };

  const nextButton = () => {
    if (currentIndexButton.value < buttons.value.length - 4) {
      currentIndexButton.value++;
    }
  };

  const entertainments = ref([]);
  const liked = ref({});

  // Khi component được mount, tải dữ liệu
  onMounted(async () => {
    entertainments.value = await model.fetchEntertainments();
  });

  // Hàm tạo các sao cho phần đánh giá
  const generateStars = (rating) => {
    return model.generateStars(rating);
  };

  // Lấy URL cho ảnh
  const getImageUrl = (imageUrl) => {
    return new URL(imageUrl, import.meta.url).href;
  };

  // Thích hoặc bỏ thích
  const toggleLikeStatus = (id) => {
    liked.value[id] = !liked.value[id];
    console.log(`Item ID: ${id}, Liked: ${liked.value[id]}`);
  };

  // Cập nhật cho chức năng chọn tỉnh thành
  const regions = ref(model.regions); // Danh sách tỉnh thành từ model
  const selectedRegion = ref(model.selectedRegion); // Tỉnh thành hiện tại
  const dropdownVisible = ref(false); // Hiển thị/ẩn dropdown

  const toggleDropdown = () => {
    dropdownVisible.value = !dropdownVisible.value;
  };

  const selectRegion = (region) => {
    selectedRegion.value = region;
    dropdownVisible.value = false; // Ẩn dropdown sau khi chọn
  };

  return {
    isMenuVisible,
    toggleMenu,

    buttons,
    visibleButtons,
    prevButton,
    nextButton,
    selectedIndex,
    selectButton,
    currentIndexButton,
    entertainments,
    generateStars,
    getImageUrl,
    liked,
    toggleLikeStatus,
    heartFull: model.heartFull,
    heartEmpty: model.heartEmpty,

    // Các biến và hàm cho chức năng chọn tỉnh thành
    regions, // Danh sách tỉnh thành
    selectedRegion, // Tỉnh thành hiện tại
    dropdownVisible, // Trạng thái dropdown
    toggleDropdown, // Hàm bật/tắt dropdown
    selectRegion, // Hàm chọn tỉnh thành
  };
}
