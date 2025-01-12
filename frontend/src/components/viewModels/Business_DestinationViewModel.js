import {
  ref,
  computed,
  onMounted,
  watch
} from 'vue';
import {
  useToast
} from "vue-toastification";
import {
  fetchDestinations,
  getDestinationById as getDestinationByIdAPI,
  addDestination as addDestinationAPI,
  updateDestination as updateDestinationAPI,
  deleteDestination as deleteDestinationAPI,
  addRestaurant as addRestaurantAPI,
  updateRestaurant as updateRestaurantAPI,
  deleteRestaurant as deleteRestaurantAPI,
  addHotel as addHotelAPI,
  updateHotel as updateHotelAPI,
  deleteHotel as deleteHotelAPI,
} from '../models/destinationModel';

import {
  fetchCities as fetchCitiesAPI
} from "../models/CityModel";
import SignInModel from '../models/SignInModel';

export default function () {
  const toast = useToast();
  const destination = ref({
    name: "",
    user_id: 0,
    price_bottom: 0,
    price_top: 0,
    age: 0,
    opentime: "",
    duration: 0,
    description: "",
    date_create: "",
    address: {
      city_id: 0,
      district: "",
      ward: "",
      street: "",
    },
    images: [],
    hotel_id: 0,
    hotel: {
      property_amenities: "",
      room_features: "",
      room_types: "",
      hotel_class: 0,
      hotel_styles: "",
      Languages: "",
      phone: "",
      email: "",
      website: "",
      id: "",
    },
    restaurant_id: 0,
    restaurant: {
      cuisine: "",
      special_diet: "",
      feature: "",
      meal: "",
      id: "",
    },
  });
  const hotel = ref({
    id: 0,
    hotel: {
      property_amenities: "",
      room_features: "",
      room_types: "",
      hotel_class: 0,
      hotel_styles: "",
      Languages: "",
      phone: "",
      email: "",
      website: "",
      id: "",
    },
  });

  const restaurant = ref({
    id: 0,
    restaurant: {
      cuisine: "",
      special_diet: "",
      feature: "",
      meal: "",
      id: "",
    },
  });
  const cities = ref([]);
  const selectedCityId = ref(0);
  const fetchCities = async () => {
    try {
      cities.value = await fetchCitiesAPI();
    } catch (error) {
      toast.error("Error fetching cities:", error);
    }
  };
  const user = ref(null);
  const token = sessionStorage.getItem('access_token');
  const loadUser = async () => {
    const signInModel = new SignInModel("", "");
    try {
      const userResult = await signInModel.fetchCurrentUser(token);
      if (userResult.success) {
        user.value = userResult.user;
      } else {
        console.error('Cannot get user:', error);
      }
    } catch (error) {
      console.error('An error occurred during authentication:', error);
      return {
        success: false,
        message: error.message || 'An error occurred'
      };
    }

  }
  const getDestinationById = async (id) => {
    try {
      destination.value = await getDestinationByIdAPI(id);
      selectedCityId.value = destination.value.address.city_id;
      console.log('Selected city:', selectedCityId.value);
    } catch (error) {
      console.error('Error fetching destination:', error);
      toast.error("Error fetching destination:", error);
    }
  };
  const showAddDestination = async () => {
    await loadUser();
    const today = new Date();

    const formattedDate = today.toISOString().split('T')[0];

    destination.value.user_id = user.value.id;
    destination.value.date_create = formattedDate; // Gán ngày hôm nay làm mặc định
  };

  const images = ref([]);
  const new_images = ref([]);
  const image_ids_to_remove = ref([]);
  const previewImages = ref([]);
  const previewNewImages = ref([]);
  const addDestination = async () => {
    try {
      const result = await addDestinationAPI(destination.value, images.value);
      if (result.success) {
        toast.success("Add destination successfully");
      } else {
        toast.error("Add destination failed");
      }
    } catch (error) {
      toast.error("Error adding destination:", error);
    }
  };
  const updateDestination = async () => {
    try {
      const result = await updateDestinationAPI(destination.value, new_images.value, image_ids_to_remove.value);
      if (result.success) {
        toast.success("Update destination successfully");
      } else {
        toast.error("Update destination failed");
      }
    } catch (error) {
      toast.error("Error updating destination:", error);
    }
  };
  const deleteDestination = async () => {
    try {
      const result = await deleteDestinationAPI(destination.value.id);
      if (result.success) {
        toast.success("Delete destination successfully");
      } else {
        toast.error("Delete destination failed");
      }
    } catch (error) {
      toast.error("Error deleting destination:", error);
    }
  };
  const addHotel = async () => {
    try {
      console.log(hotel.value);
      const result = await addHotelAPI(hotel.value);
      if (result.success) {
        toast.success("Add hotel successfully");
      } else {
        toast.error("Add hotel failed");
      }
    } catch (error) {
      toast.error("Error adding hotel:", error);
    }
  };
  const updateHotel = async () => {
    try {
      const result = await updateHotelAPI(destination.value);
      if (result.success) {
        toast.success("Update hotel successfully");
      } else {
        toast.error("Update hotel failed");
      }
    } catch (error) {
      toast.error("Error updating hotel:", error);
    }
  };
  const deleteHotel = async () => {
    try {
      const result = await deleteHotelAPI(hotel.value.id);
      if (result.success) {
        toast.success("Delete hotel successfully");
      } else {
        toast.error("Delete hotel failed");
      }
    } catch (error) {
      toast.error("Error deleting hotel:", error);
    }
  };
  const addRestaurant = async () => {
    try {
      const result = await addRestaurantAPI(restaurant.value);
      if (result.success) {
        toast.success("Add restaurant successfully");
      } else {
        toast.error("Add restaurant failed");
      }
    } catch (error) {
      toast.error("Error adding restaurant:", error);
    }
  };
  const updateRestaurant = async () => {
    try {
      const result = await updateRestaurantAPI(destination.value);
      if (result.success) {
        toast.success("Update restaurant successfully");
      } else {
        toast.error("Update restaurant failed");
      }
    } catch (error) {
      toast.error("Error updating restaurant:", error);
    }
  };
  const deleteRestaurant = async () => {
    try {
      const result = await deleteRestaurantAPI(restaurant.value.id);
      if (result.success) {
        toast.success("Delete restaurant successfully");
      } else {
        toast.error("Delete restaurant failed");
      }
    } catch (error) {
      toast.error("Error deleting restaurant:", error);
    }
  };

  const handleImageUpload = (event) => {
    const files = Array.from(event.target.files);

    files.forEach((file) => {
      images.value.push(file);

      // Generate preview URL for the uploaded file
      const reader = new FileReader();
      reader.onload = (e) => {
        previewImages.value.push(e.target.result); // Add the image preview URL
      };
      reader.readAsDataURL(file);
    });
  };

  const removeImage = (index) => {
    images.value.splice(index, 1); // Xoá file ảnh khỏi mảng
    URL.revokeObjectURL(previewImages.value[index]); // Giải phóng bộ nhớ của URL preview
    previewImages.value.splice(index, 1); // Xoá URL preview khỏi mảng
  };

  const handleNewImageUpload = (event) => {
    const files = event.target.files;
    Array.from(files).forEach((file) => {
      new_images.value.push(file);
      previewNewImages.value.push(URL.createObjectURL(file)); // Thêm URL preview vào mảng
    });
  };

  const removeNewImage = (index) => {
    new_images.value.splice(index, 1); // Remove new image by index
    URL.revokeObjectURL(previewNewImages.value[index]); // Giải phóng bộ nhớ của URL preview
    previewNewImages.value.splice(index, 1); // Xoá URL preview khỏi mảng
    console.log("previewNewImages after remove:", previewNewImages.value);
  };

  const removeExistingImage = (id) => {
    image_ids_to_remove.value.push(id); // Add image id to removal list
    destination.value.images = destination.value.images.filter(
      (img) => img.id !== id
    );
    console.log(
      "destination.images after remove:",
      destination.value.images
    )
  };


  const dropdownVisibleRegion = ref(false);

  const languages = [
    'Korean',
    'Japanese',
    'English',
    'Vietnamese',
    'Thai',
    'Chinese',
    'French',
  ];
  const dropdownVisibleLanguage = ref(false);
  const selectedLanguage = ref('');
  // Đóng mở dropdown
  const toggleDropDownLanguage = () => {
    dropdownVisibleLanguage.value = !dropdownVisibleLanguage.value;
  }
  const selectLanguage = (language) => {
    selectedLanguage.value = language;
    destination.value.language = selectedLanguage.value;
    console.log('Selected Language:', destination.value.language);
    console.log('Selected Language 1:', selectedLanguage.value);
    dropdownVisibleLanguage.value = false; // Đóng dropdown
  }
  const selectedLanguageName = computed(() => {
    return selectedLanguage.value ? selectedLanguage.value : 'Select Language';
  });

  const toggleDropDownRegion = () => {
    dropdownVisibleRegion.value = !dropdownVisibleRegion.value;
  };
  const selectCity = (cityId) => {
    selectedCityId.value = cityId; // Cập nhật ID thành phố được chọn
    destination.value.address.city_id = selectedCityId.value;
    console.log('Selected City ID:', destination.value.address.city_id);
    console.log('Selected City ID:', selectedCityId.value);
    dropdownVisibleRegion.value = false; // Đóng dropdown
  };
  const selectedCityName = computed(() => {
    const city = cities.value.find(c => c.id === selectedCityId.value);
    return city ? city.name : 'Select City';
  });


  return {
    fetchCities,
    cities,
    loadUser,
    destination,
    hotel,
    restaurant,
    getDestinationById,
    showAddDestination,
    addDestination,
    updateDestination,
    deleteDestination,
    addHotel,
    updateHotel,
    deleteHotel,
    addRestaurant,
    updateRestaurant,
    deleteRestaurant,
    previewImages,
    previewNewImages,
    handleImageUpload,
    removeImage,
    handleNewImageUpload,
    removeNewImage,
    removeExistingImage,
    selectedCityId,
    dropdownVisibleRegion,
    toggleDropDownRegion,
    selectCity,
    selectedCityName,
    selectedLanguage,
    dropdownVisibleLanguage,
    toggleDropDownLanguage,
    selectLanguage,
    selectedLanguageName,
    languages,
  };
}