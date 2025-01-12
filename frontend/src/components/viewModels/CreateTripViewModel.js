import { ref, onMounted, watch, nextTick } from 'vue';
import { getTags } from '../models/TagModel';
import { useTripStore } from '@/store/useTripStore';
import { fetchDestinationsByCity_Tag } from '../models/destinationModel';
import SignInModel from '../models/SignInModel';
import { addTour } from '../models/TourModel';
import { addTrip, addTripByAi } from '../models/TripModel';
import { useToast } from 'vue-toastification';
import { useRouter } from 'vue-router';

export default function () {
    const toast = useToast();
    const tripStore = useTripStore();
    const data = {
      city: '',
      month: '',
      dayLength: '',
      topics: [],
      destinations: [],
      tripOption: '',
      tourName: '',
    };

    const tags = ref([]);
    const selectTags = ref([]);
    const places = ref([]);
    const destinations = ref([]);
    const restaurants = ref([]);
    const hotels = ref([]);
    const selectedPlace = ref([]);
    const selectedHotel = ref([]);
    const selectedRestaurant = ref([]);
    const selectedDestination = ref([]);
    const isAllSelected = ref(false);

    const itineraryName = ref('');
    const descriptionName = ref('');
  
    const updateCity = (city) => {
      data.city = city.id;
      tripStore.setCity(city.id);
      tripStore.setSelectedDestination({ id: city.id, name: city.name });
      console.log('All Data:', tripStore.getAllInformation());
    }
  
    const updateDetails = ( month, dayLength ) => {
      data.month = month;
      data.dayLength = dayLength;
      tripStore.setSelectedMonth(month);
      tripStore.setSelectLength(dayLength);

      console.log('All Data:', tripStore.getAllInformation());
    }

    const toggleTopic = (topic) => {
      const index = selectTags.value.findIndex(t => t === topic);
      if (index === -1) {
        selectTags.value.push(topic); // Thêm topic nếu chưa có
      } else {
        selectTags.value.splice(index, 1); // Xóa topic nếu đã tồn tại
      }
  };

    const getTopics = async () => {
      return await getTags();
    }
  
    const updateTopics = () => {
      data.topics = selectTags.value;
      tripStore.setSelectTags(selectTags.value);
      console.log('All Data:', tripStore.getAllInformation());
    }

    const getPlaceData = async () => {
      try{
        places.value = await fetchDestinationsByCity_Tag(tripStore.cityId, tripStore.selectedTags);
        destinations.value = places.value.filter(destination => destination.hotel_id === null && destination.restaurant_id === null);
        hotels.value = places.value.filter(destination => destination.hotel_id !== null && destination.restaurant_id === null);
        restaurants.value = places.value.filter(destination => destination.restaurant_id !== null);
      } catch (error) {
        console.error('An error occurred while getting place data:', error);
      }
    }

    const picked = ref({});
    const pickFull = new URL('@/assets/svg/tick.svg', import.meta.url).href;
    const pickEmpty = new URL('@/assets/svg/plus-svgrepo-com.svg', import.meta.url).href;

const togglePickStatus = (place, type) => {
  const index = selectedPlace.value.findIndex(t => t === place);
  picked.value[place] = !picked.value[place];
  if (index === -1) {
    selectedPlace.value.push(place); // Thêm topic nếu chưa có
    if (type === 'hotel') {
      selectedHotel.value.push(place);
    }
    if (type === 'restaurant') {
      selectedRestaurant.value.push(place);
    }
    if (type === 'destination') {
      selectedDestination.value.push(place);
    }
  } else {
    selectedPlace.value.splice(index, 1); // Xóa topic nếu đã tồn tại
    if (type === 'hotel') {
      selectedHotel.value = selectedHotel.value.filter(id => id !== place);
    }
    if (type === 'restaurant') {
      selectedRestaurant.value = selectedRestaurant.value.filter(id => id !== place);
    }
    if (type === 'destination') {
      selectedDestination.value = selectedDestination.value.filter(id => id !== place);
    }
  }
};

const selectAll = (newvalue) => {
  // Chuyển đổi giá trị của isAllSelected
  
  // Kiểm tra xem isAllSelected có true hay không
  if (newvalue) {
      // Lấy toàn bộ place.id nếu isAllSelected là true
      selectedPlace.value = places.value.map(place => place.id);
      selectedHotel.value = places.value.filter(place => place.hotel_id !== null && place.restaurant_id == null).map(place => place.id);
      selectedDestination.value = places.value.filter(place => place.hotel_id == null && place.restaurant_id == null).map(place => place.id);
      selectedRestaurant.value = places.value.filter(place => place.restaurant_id !== null).map(place => place.id);
      picked.value = Object.fromEntries(places.value.map(place => [place.id, true])); // Đánh dấu tất cả là picked
  } else {
      // Xóa toàn bộ nếu isAllSelected là false
      selectedPlace.value = [];
      selectedHotel.value = [];
      selectedDestination.value = [];
      selectedRestaurant.value = [];
      picked.value = {}; // Đặt lại tất cả là không picked
  }
};

    
  
    const updateDestinations = () => {
      tripStore.setListPlace(selectedPlace.value);
      tripStore.setListHotel(selectedHotel.value);
      tripStore.setListRestaurant(selectedRestaurant.value);
      tripStore.setListDestination(selectedDestination.value);
      console.log('All Data:', tripStore.getAllInformation());
    }

    const user = ref(null);

    const loadUser = async () => {
      const signInModel = new SignInModel("", "");
      const token = sessionStorage.getItem('access_token');
      try{
        if(token){
          const userResult = await signInModel.fetchCurrentUser(token);
          if(userResult.success){
            user.value = userResult.user;
          } else {
          console.error('Cannot get user:', error);
          }
        }
        
      } catch (error) {
        console.error('An error occurred during authentication:', error);
        return { success: false, message: error.message || 'An error occurred' };
      }
      
    }
    const router = useRouter();
  
    const finishItinerary = async () => {
      try{
        const loadingIndicator = document.getElementById('loading-indicator');
        if (loadingIndicator) loadingIndicator.style.display = 'block';
        tripStore.setName(itineraryName.value);
        await loadUser();
        tripStore.setUserId(user.value.id);
        console.log('All Data:', tripStore.getAllInformation());

        const result =  await addTrip(tripStore.name, tripStore.selectedMonth, tripStore.selectedLength, tripStore.userId, tripStore.listPlace);
        if(result.success){
          toast.success('Your trip has been created successfully');
          const tripId = result.data.id;
          router.push({ 
            name: 'Page_7', 
            params: { id: tripId } // Chỉ cần truyền params
          });
        } else {
          toast.error('An error occurred while creating your trip');
        }
      } catch (error) {
        console.error('Error:', error);
        toast.error('An unexpected error occurred');
      } finally {
        // Tắt trạng thái loading sau khi xử lý xong
        const loadingIndicator = document.getElementById('loading-indicator');
        if (loadingIndicator) loadingIndicator.style.display = 'none';
      }
    }

    const finishItineraryAI = async () => {
      try {
        // Hiển thị trạng thái loading
        const loadingIndicator = document.getElementById('loading-indicator');
        if (loadingIndicator) loadingIndicator.style.display = 'block';
    
        // Bắt đầu xử lý logic
        tripStore.setName(itineraryName.value);
        await loadUser();
        tripStore.setUserId(user.value.id);
        console.log('All Data:', tripStore.getAllInformation());
    
        if (tripStore.listRestaurant.length >= tripStore.selectedLength) {
          const result = await addTripByAi(
            tripStore.name,
            tripStore.selectedMonth,
            tripStore.selectedLength,
            tripStore.userId,
            tripStore.listDestination,
            tripStore.listHotel,
            tripStore.listRestaurant
          );
    
          if (result.success) {
            toast.success('Your trip has been created successfully');
            const tripId = result.data;
            router.push({ 
              name: 'Page_7', 
              params: { id: tripId } // Chỉ cần truyền params
            });
          } else {
            toast.error('An error occurred while creating your trip');
          }
        } else {
          toast.error('Please select enough restaurants for your trip');
        }
      } catch (error) {
        console.error('Error:', error);
        toast.error('An unexpected error occurred');
      } finally {
        // Tắt trạng thái loading sau khi xử lý xong
        const loadingIndicator = document.getElementById('loading-indicator');
        if (loadingIndicator) loadingIndicator.style.display = 'none';
      }
    };


    
  
    return {
      data,
      toggleTopic,
      updateCity,
      updateDetails,
      getTopics,
      updateTopics,
      updateDestinations,
      selectTags,
      getPlaceData,
      destinations,
      hotels,
      restaurants,
      places,
      togglePickStatus,
      selectedPlace,
      isAllSelected,
      selectAll,
      itineraryName,
      descriptionName,
      finishItinerary,
      finishItineraryAI,
      picked,
      pickFull,
      pickEmpty,
    };
  }