import SignInModel from '../models/SignInModel';
import { onMounted, ref, computed, watch  } from 'vue';
import { getTourByUserId, getTourById, updateTour, addTour, deleteTour} from '../models/TourModel';
import { fetchCities } from '../models/CityModel';
import { useToast } from "vue-toastification";
import { getDestination } from '../models/homeBusinessModel';
 
export default function() {
    const toast = useToast();
    // Load User
    const user = ref(null);
    
    // Load Info TourbyID
    const tour = ref(null);

    const cities = ref([]); // Thay thế citiesCache thành cities
    const selectedCityId = ref(null); 
    const dropdownVisibleRegion = ref(false);
    const tourName = ref("");

    const destListID = ref([]);
    const destList = ref([]);
    const tourId = ref(null);
    const cityID = ref(null);
    const description = ref(null);
    const isLoading = ref(false);

    const destinations = ref([]);
    const destinations_2 = ref([]);

    watch(tourName, (newVal, oldVal) => {
        console.log('[ViewModel] tourName changed:', oldVal, '=>', newVal);
    });
  
    watch(description, (newVal, oldVal) => {
        console.log('[ViewModel] description changed:', oldVal, '=>', newVal);
    });

    // Load User 
    const loadUser = async () => {
        const signInModel = new SignInModel("", "");
        const token = sessionStorage.getItem('access_token');
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

    // Load All Desinations by UserID
    const loadDestinations = async () => {
        console.log("User ID:", user.value);
        isLoading.value = true;
        try {
            let place;
            // Nếu có dữ liệu, chỉ lọc lại; nếu chưa, gọi API
            if (destinations.value.length) {
                place = [...destinations.value];
            } else {
                place = await getDestination(user.value.id);    
            }
            // Sắp xếp rating giảm dần dùng để view 5 địa điểm có rating cao nhất
            // của 1 người dùg
            place.value = place.sort((a, b) => b.rating - a.rating);
     
            destinations.value = place || null;
            destinations_2.value = destinations.value;
            console.log("Destinations:", destinations.value);
            console.log("Destinations_2:", destinations_2.value);
            console.log("Place Update Name: ",destinations.value);
        } catch (error) {
            console.error("Error fetching destinations:", error);
        } finally {
            isLoading.value = false;
        }
    }

    // Load Tour by ID
    const loadTourbyID = async (tourID) => {
        try {
            const tourResult = await getTourById(tourID);
            tour.value = tourResult;
            console.log("Tour result:", tourResult);
            
            tourId.value = tourResult?.id;
            description.value = tourResult?.description;
            // Gán thành phố của tour trước khi cập nhật
            selectedCityId.value = tourResult.city_id;
            tourName.value = tourResult.name; // Gán giá trị tên tour

            destListID.value = tourResult.destinations.map(dest => dest.id);
            destList.value = tourResult.destinations;
            console.log("Dest List:", destList.value);
            return tourResult;
        } catch (error) {
            console.error('Error getting tour:', error);
            return [];
        }
    }

    const removeDestination = (destinationId) => {
        // Bước 1: Loại ID khỏi destListID
        destListID.value = destListID.value.filter(id => id !== destinationId);        
        // Bước 2: Loại object khỏi destList
        destList.value = destList.value.filter(dest => dest.id !== destinationId);
        console.log("Dest List:", destList.value);
        console.log("Dest List ID:", destListID.value);
    };

    const handleAddDestination = (destination) => {
        // Thêm vào destListID để dùng cho việc gửi lên server
        if(!destListID.value.includes(destination.id)){
            destListID.value.push(destination.id);
        }
        const isExists = destList.value.some(item => item.id === destination.id);
        // Thêm vào destList nếu chưa có
        if (!isExists) {
            destList.value.push(destination);
        }
        destinations_2.value = destinations_2.value.filter(el => el.id !== destination.id);
        console.log("destList after add:", destList.value);
        console.log("destListID after add:", destListID.value);
    };

    // Load City
    const loadCities = async () => {
        try {
            const cityResult = await fetchCities();
            cities.value = cityResult;
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

    const SendUpdateTour = async () => {
        try {
            console.log("Tour ID:", tourId.value);
            console.log("Tour Name:", tourName.value);
            console.log("Description:", description.value);
            console.log("Selected City ID:", selectedCityId.value);
            console.log("User ID:", user.value?.id);
            console.log("Destinations:", destListID.value);
            const tourObject = {
                id: tourId.value,
                name: tourName.value,
                description: description.value,
                user_id: user.value?.id,
                city_id: selectedCityId.value,
                destination_ids: destListID.value
            };
            const tourResult = await updateTour(tourObject);
            console.log("Tour result:", tourResult);
            // Kiểm tra response trả về để hiển thị thông báo
            if (tourResult.success) {
                // Hiển thị toast thành công
                toast.success("Update tour successfully!", {
                    timeout: 3000,    // thời gian hiển thị
                    position: "top-right", // vị trí
                });
            } else {
                // Hoặc hiển thị toast lỗi
                toast.error("Faild to update tour!");
            }
            return tourResult;
        } catch (error) {
            console.error('Error getting tour:', error);
            return [];
        }
    }

    const SendAddTour = async () => {
        // Kiểm tra các trường bắt buộc
        if (!tourName.value || tourName.value.trim() === "") {
            toast.error("Please enter the tour name.");
            return;
        }
        if (!description.value || description.value.trim() === "") {
            toast.error("Please enter the description.");
            return;
        }
        if (!selectedCityId.value) {
            toast.error("Please select a city.");
            return;
        }
        if (!destListID.value || destListID.value.length === 0) {
            toast.error("Please add at least one destination.");
            return;
        }
        try {
            console.log("Tour Name:", tourName.value);
            console.log("Description:", description.value);
            console.log("Selected City ID:", selectedCityId.value);
            console.log("User ID:", user.value?.id);
            console.log("Destinations:", destListID.value);
            const tourObject = {
                name: tourName.value,
                description: description.value,
                user_id: user.value?.id,
                city_id: selectedCityId.value,
                destination_ids: destListID.value
            };
            const tourResult = await addTour(tourObject);
            if (tourResult && tourResult.success) {
                toast.success("Tour added successfully!");
            }
            console.log("Tour result:", tourResult);
            return tourResult;
        } catch (error) {
            console.error('Error getting tour:', error);
            return [];
        }
    }

    const deleteTourByTourID = async () =>{
        try{
            console.log("User ID:", user.value?.id);
            const response = await deleteTour(tourId.value);
            if(response.success){
                toast.success("Delete a tour complete");
            }else{
                toast.error("Delete a tour faild");
            }
        }catch(error){
            console.error('Error getting tour:', error);
            return [];
        }
    }

    return {
        user,
        tour, tourId, tourName, description, destListID, destList,
        cities, selectedCityId, dropdownVisibleRegion, loadCities,
        toggleDropDownRegion, selectCity, selectedCityName, cityID, 
        isLoading, loadUser, loadTourbyID, loadCities, destinations_2,
        loadDestinations, destinations, removeDestination, handleAddDestination, 
        SendUpdateTour, SendAddTour     
    }
}
