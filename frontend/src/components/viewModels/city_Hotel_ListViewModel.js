import { ref, onMounted, watch, nextTick } from 'vue';
import ThingtodoModel from '../models/city_Hotel_ListModel';
import noUiSlider from 'nouislider';
import 'nouislider/dist/nouislider.css';

export default function () {
  const model = ThingtodoModel();

  const isMenuVisible = ref(false);
  const toggleMenu = () => {
    isMenuVisible.value = !isMenuVisible.value;
  };

  const buttons = ref(model.buttons);
  const selectedIndices = ref([]);
  const searchQuery = ref('');

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
    setupSlider(); // Khởi tạo noUiSlider
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

  const currency = ref('VND');
  const minPrice = ref(currency.value === 'USD' ? 1 : 1); 
const maxPrice = ref(currency.value === 'USD' ? 10000 : 10000000); 

  // Khởi tạo noUiSlider
  const setupSlider = () => {
    const slider = document.getElementById('price-slider');
  
    if (!slider) {
      console.error('Slider element not found');
      return;
    }
  
    noUiSlider.create(slider, {
      start: [minPrice.value, maxPrice.value],
      connect: true,
      step: currency.value === 'USD' ? 1 : 1,  // Đặt bước khởi tạo
      range: {
        min: currency.value === 'USD' ? 0 : 0,  // Giá trị tối thiểu
        max: currency.value === 'USD' ? 10000 : 10000000  // Giá trị tối đa
      },
      tooltips: {
        to: (value) => {
          // Định dạng số có dấu phẩy
          return currency.value === 'USD' 
            ? new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD', minimumFractionDigits: 0 }).format(value)
            : new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', minimumFractionDigits: 0 }).format(value);
        },
        from: (value) => parseFloat(value)  // Chuyển đổi lại thành số khi kéo
      },
      format: {
        to: (value) => Math.round(value),  // Làm tròn giá trị
        from: (value) => Number(value)
      }
    });
  
    slider.noUiSlider.on('update', (values) => {
      minPrice.value = parseFloat(values[0]);
      maxPrice.value = parseFloat(values[1]);
      updatePrice();
    });
  };
  
  // Hàm cập nhật step và range khi thay đổi đơn vị tiền tệ
  const updateSliderStep = () => {
    const slider = document.getElementById('price-slider');
    if (!slider || !slider.noUiSlider) return;
  
    const newStep = currency.value === 'USD' ? 1 : 1;
    const newMinPrice = currency.value === 'USD' ? 0 : 0;
    const newMaxPrice = currency.value === 'USD' ? 10000 : 10000000;
    slider.noUiSlider.updateOptions({
      step: newStep,
      range: {
        min: newMinPrice,
        max: newMaxPrice
      }
    });


    slider.noUiSlider.set([newMinPrice, newMaxPrice]);
    console.log('Updated step:', newStep);
  };
  
  
  
  
  

  // Cập nhật giá trị khi minPrice và maxPrice thay đổi
  watch([minPrice, maxPrice], () => {
    const slider = document.getElementById('price-slider');
    if (slider && slider.noUiSlider) {
      slider.noUiSlider.set([minPrice.value, maxPrice.value]);
    }
  });
  

  // Cập nhật giá trị hiển thị
  const updatePrice = () => {
    const format = new Intl.NumberFormat(currency.value === 'USD' ? 'en-US' : 'vi-VN', {
      style: 'currency',
      currency: currency.value,
      minimumFractionDigits: 0  // Không hiển thị số thập phân
    });
  
    console.log(`Price Range: ${format.format(minPrice.value)} - ${format.format(maxPrice.value)}`);
  };
  const updateSliderFromInput = (type) => {
    const slider = document.getElementById('price-slider');
    if (!slider || !slider.noUiSlider) return;
  
    const value = type === 'min' ? minPrice.value : maxPrice.value;
  
    if (value !== '' && !isNaN(value) && parseFloat(value) >= 0) {
      slider.noUiSlider.setHandle(type === 'min' ? 0 : 1, parseFloat(value));
    }
  };

  // Xử lý khi thay đổi đơn vị tiền tệ
  const handleCurrencyChange = (newCurrency) => {
    currency.value = newCurrency;
    updateSliderStep();
    
  };
  watch(currency, (newCurrency) => {
    minPrice.value = newCurrency === 'USD' ? 0 : 0;
    maxPrice.value = newCurrency === 'USD' ? 100000 : 100000000;
  });

  

  const activeOption = ref(null);
  const toggleOptions = (option) => {
    activeOption.value = activeOption.value === option ? null : option;
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
    currency,
    minPrice,
    maxPrice,
    setupSlider,
    updatePrice,
    handleCurrencyChange,
    activeOption,
    toggleOptions,
    searchQuery,
    updateSliderFromInput
  };
}
