import { ref, computed, onMounted, watch } from 'vue';
import { useToast } from "vue-toastification";
import { fetchCities } from "../models/CityModel";
import SignInModel from '../models/SignInModel';

import { 
    fetchDestinations as fetchDestinationsAPI,
    getDestinationById as getDestinationByIdAPI,
    addDestination as addDestinationAPI,
    updateDestination as updateDestinationAPI,
    deleteDestination as deleteDestinationAPI,
    addRestaurant as addRestaurantAPI,
    updateRestaurant as updateRestaurantAPI,
    addHotel as addHotelAPI,
    updateHotel as updateHotelAPI,
} from '../models/destinationModel';

export default function () {

    const toast = useToast();
    const user = ref(null);
    const token = sessionStorage.getItem('access_token');

    // Load Info Destination
    const destinations = ref([]);
    const hotels = ref([]);
    const restaurants = ref([]);
    
    // Dropdown Button City
    const cities = ref([]);
    const isDropdownVisible = ref(false);
    const isMenuVisible = ref(false);    
    const selectedCityId = ref(null);

    const isLoading = ref(false);
    
    const isReadMore = ref(false);
    const currentIndex = ref(0);
    
    const dropdownVisibleRegion = ref(false);
    const destination = ref(null);
    const descriptionModel = ref(null);
    const description = ref(null);
    const truncatedDescription = ref('');
    const images = ref([]);
    const new_images = ref([]);
    const image_ids_to_remove = ref([]);
    const previewImages = ref([]);
    const previewNewImages = ref([]);
    const commentList = ref([]);    
    const canReview = ref(true);

    onMounted (async () => {
        await loadUser();
        await loadCities();
    });

    // Load User 
    const loadUser = async () => {
        const signInModel = new SignInModel("", "");
        console.log("Token:", token);
        try {
            if(token){
                const userResult = await signInModel.fetchCurrentUser(token);
                if (userResult.success) {
                    user.value = userResult.user;
                } else {
                    console.error('Cannot get user:', error);
                    return null;
                }
            }
        } catch (error) {
            console.error('An error occurred during authentication:', error);
            return { success: false, message: error.message || 'An error occurred' };
        }
    }

    // Load City
    const loadCities = async () => {
        try {
            const cityResult = await fetchCities();
            cities.value = cityResult;
            console.log("Cities:", cities.value);
        } catch (error) {
            console.error('An error occurred during authentication:', error);
            return { success: false, message: error.message || 'An error occurred' };
        }
    }

    // Đóng mở dropdown
    const toggleDropDownRegion = () => {
        dropdownVisibleRegion.value = !dropdownVisibleRegion.value;
    };
    const selectCity = (cityId) => {
        selectedCityId.value = cityId; // Cập nhật ID thành phố được chọn
        console.log('Selected City ID:', selectedCityId.value);
        dropdownVisibleRegion.value = false; // Đóng dropdown
    };
    const selectedCityName = computed(() => {
        const city = cities.value.find(c => c.id === selectedCityId.value);
        return city ? city.name : 'Select City';
    });

    return{
        user, token,
        cities, selectedCityName, selectedCityId, dropdownVisibleRegion, loadCities, toggleDropDownRegion, selectCity,
    }
}