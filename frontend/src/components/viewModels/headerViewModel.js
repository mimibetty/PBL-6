import { reactive, onMounted, onUnmounted } from 'vue';
import { useRouter } from 'vue-router';
import HeaderModel from '../models/headerModel';  // Importing the model

export default function useHeaderViewModel() {
  const state = reactive({
    isScrolled: HeaderModel.data.isScrolled,
    activeButton: HeaderModel.data.activeButton,
  });

  const router = useRouter();

  // Handle scroll event to change header background
  const handleScroll = () => {
    if (window.scrollY > 0) {
      HeaderModel.setScrollState(true);  // Update the model state
    } else {
      HeaderModel.setScrollState(false);
    }
    state.isScrolled = HeaderModel.data.isScrolled;  // Update local state
  };

  // Change active button when clicked
  const setActiveButton = (buttonName) => {
    HeaderModel.setActiveButton(buttonName);  // Update the model state
    state.activeButton = HeaderModel.data.activeButton;  // Update local state
  };

  // Navigate to a new page when button is clicked
  const navigateToPage = (route) => {
    router.push(route);
  };

  onMounted(() => {
    window.addEventListener('scroll', handleScroll);
  });

  onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll);
  });

  return {
    state,
    setActiveButton,
    navigateToPage,
  };
}
