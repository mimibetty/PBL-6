import { ref, onMounted, computed, watch } from 'vue';
import CreateTripModel from '../../models/CreateTripModel';
import DateModel from '@/components/models/Create_Trip_Models/date_Model';
import { useTripStore } from '@/store/useTripStore';
import { fetchDestinationsByCity, addTour as addTourAPI} from '../../models/CreateTripModel';
import axios from 'axios';

export default function CreateTripViewModel() {
    const model = CreateTripModel();
    const dateModel = new DateModel();
    const currentStep = ref(1);
    const searchQuery = ref('');
    const selectedCity = ref('');
    const suggestedDestinations = ref([]);
    const activePicker = ref('');
    const location = ref('');
    const selectedLength = ref([]);
    const selectedMonth = ref([]);  
    const rawSelectedDates = ref([]);
    const topics = ref([]);
    const selectedTopics = ref([]);
    
    const places = ref([]);
    const attractions = ref([]);

    const filteredDestinations = ref([]);
    const filteredHotels = ref([]);
    const filteredRestaurants = ref([]);

    const destinations = ref([]);
    const restaurants = ref([]);
    const hotels = ref([]);
    
    const selectedDestination = ref({ id: null, name: '' });
    const tripStore = useTripStore();
    const isDestinationsLoading = ref(false);
    const tourid = ref();

    onMounted(async () => {
        suggestedDestinations.value = await model.fetchCities();
        topics.value = await model.fetchTags();
    });

    // // Watcher to fetch data whenever currentStep changes to 4
    // watch(currentStep, async (newStep) => {
    //     if (newStep === 4) {
    //         const allDestinations = await model.fetchEntertainments();
    //         destinations.value = allDestinations;
    //         places.value = allDestinations.filter(dest => dest.destinationType === 'Place' || dest.destinationType === 'Attraction');
    //         attractions.value = allDestinations.filter(dest => dest.destinationType === 'Attraction');
    //         restaurants.value = allDestinations.filter(dest => dest.destinationType === 'Restaurant');
    //         hotels.value = allDestinations.filter(dest => dest.destinationType === 'Hotel');
    //     }
    // });

    const selectDestination = (id, name) => {
        selectedDestination.value = { id, name }; // Lưu id và name vào destination
        tripStore.setSelectedDestination(selectedDestination.value);
        console.log('Selected Destination:', tripStore.selectedDestination);
        console.log('Selected destination:', selectedDestination.value);
    };

    const getSelectedLength = () => {
        selectedLength = dateModel.getSelectedLength();
        tripStore.setSelectLength(selectedLength.value);
        console.log('Selected length:', tripStore.selectedLength);
        return selectedLength.value;
    }

    const getSelectedMonth = () => {
        selectedMonth = dateModel.getSelectedMonth();
        tripStore.setSelectedMonth(selectedMonth.value);
        console.log('Selected length:', tripStore.selectedMonth);
        return selectedMonth.value;
    }

    const searchDestinations = () => {
        console.log('Search initiated with query:', searchQuery.value);
    };

    const goToCalendar = () => {
        currentStep.value = 2;
    };

    const goToDestinationSelection = () => {
        currentStep.value = 1;
    };

    const startDay = computed(() => {
        return rawSelectedDates.value && rawSelectedDates.value.length > 0 ? new Date(rawSelectedDates.value[0]) : null;
    });

    const endDay = computed(() => {
        return rawSelectedDates.value && rawSelectedDates.value.length > 1 ? new Date(rawSelectedDates.value[1]) : null;
    });
    
    const generateStars = (rating) => {
        return model.generateStars(rating);
    };

    const selectedDates = computed(() => {
        if (!rawSelectedDates.value || rawSelectedDates.value.length === 0) return null;
        return rawSelectedDates.value.map(date => {
            const newDate = new Date(date);
            newDate.setHours(0, 0, 0, 0); // Set time to 00:00:00
            return newDate;
        });
    });

    const onDateChange = (dates) => {
        rawSelectedDates.value = dates; // Keep raw dates
    };

    const gotoTopic = () => {
        console.log('Trip submitted with dates:', selectedDates.value);
        const startDateFormatted = startDay.value
            ? startDay.value.toLocaleDateString('en-GB') // 'en-GB' formats as dd/MM/yyyy
            : 'No start date';
        const endDateFormatted = endDay.value
            ? endDay.value.toLocaleDateString('en-GB')
            : 'No end date';
        console.log('Start Date:', startDateFormatted);
        console.log('End Date:', endDateFormatted);
        currentStep.value = 3;
    };

    const gotoPickPlace = () => {
        currentStep.value = 4;
    };

    const gotoChoosePlanning = () => {
        currentStep.value = 5;
    };

    const toggleTopic = (topic) => {
        if (selectedTopics.value.includes(topic)) {
            selectedTopics.value = selectedTopics.value.filter(t => t !== topic);
        } else {
            selectedTopics.value.push(topic);
        }
        tripStore.setSelectTags(selectedTopics.value);
        console.log('Selected Destination:', tripStore.selectedDestination);
        console.log('Selected Length:', tripStore.selectedLength);
        console.log('Selected Month:', tripStore.selectedMonth);
        console.log('Selected topics Storeq:', tripStore.selectedTags);
        console.log('Selected topics:', selectedTopics.value);
    };

    const picked = ref({});

    const togglePickStatus = (id) => {
        picked.value[id] = !picked.value[id];
        tripStore.setListDestination(Object.keys(picked.value).filter(key => picked.value[key]).map(Number)); 
        console.log('Picked:', tripStore.listDestination);
        console.log('Picked:', picked.value);
    };

    const pickFull = new URL('@/assets/svg/tick.svg', import.meta.url).href;
    const pickEmpty = new URL('@/assets/svg/plus-svgrepo-com.svg', import.meta.url).href;

    // Đếm tổng số items và số đã chọn
    const selectedCount = computed(() => 
        Object.values(picked.value).filter(isPicked => isPicked).length
    );
    
    const totalItems = computed(() => 
        destinations.value.length + restaurants.value.length + hotels.value.length
    );

    const isAllSelected = ref(false); // Thêm biến để theo dõi trạng thái chọn tất cả

    const selectAll = () => {
        const allItems = places.value.concat(restaurants.value, hotels.value);
    
        if (isAllSelected.value) {
            // Nếu đã chọn tất cả, bỏ chọn tất cả
            allItems.forEach((item) => {
                picked.value[item.id] = false;
            });
        } else {
            // Nếu chưa chọn tất cả, chọn tất cả
            allItems.forEach((item) => {
                picked.value[item.id] = true;
            });
        }

        // Đảo ngược trạng thái
        isAllSelected.value = !isAllSelected.value;
    };
    const createItinerary = () => {
        currentStep.value = 6;
    };

    const saveForLater = () => {
        console.log('Search initiated with query:', searchQuery.value);
        console.log('Trip submitted with dates:', selectedDates.value);
        console.log('Place pick', picked.value);
        console.log("Save for later");

        
    };

    const itineraryName = ref(tripStore.name);

    const finishItinerary = () => {
        tripStore.setName(itineraryName.value);  // Lưu tên chuyến đi vào store
        console.log("Selected Name:", tripStore.name);
        console.log('Selected Destination ver2:', tripStore.selectedDestination.id);
        console.log('Selected Length:', tripStore.selectedLength);
        console.log('Selected Month:', tripStore.selectedMonth);
        console.log('Selected topics Store:', tripStore.selectedTags);
        console.log('Selected place ver2:', tripStore.listDestination.slice().join(', '));
        
        
        console.log("Before setDestinationIds, listDestination:", tripStore.listDestination);
        tripStore.setDestinationIds(); // Set destination IDs
        console.log("Selected IDs:", tripStore.ids_destination);
    };

    const fetchDestinationsData = async () => {
        isDestinationsLoading.value = true;
        try {
          let place;
          // Nếu đã có dữ liệu, chỉ lọc lại; nếu chưa, gọi API
          if (destinations.value.length || hotels.value.length || restaurants.value.length) {
            place = [...destinations.value, ...hotels.value, ...restaurants.value];
          } else {
            place = await fetchDestinationsByCity(tripStore.selectedDestination.id);
          }
    
          // Lọc dữ liệu theo tags
          const filteredPlace = filterItems(place);
    
          // Phân loại dữ liệu
          destinations.value = place.filter(destination => destination.hotel_id === null && destination.restaurant_id === null);
          hotels.value = place.filter(destination => destination.hotel_id !== null);
          restaurants.value = place.filter(destination => destination.restaurant_id !== null);
          console.log('destinations: ', destinations.value);
          console.log('hotels: ', hotels.value);
          console.log('restaurants: ', restaurants.value);

          filteredDestinations.value = filteredPlace.filter(destination => destination.hotel_id === null && destination.restaurant_id === null);
          filteredHotels.value = filteredPlace.filter(destination => destination.hotel_id !== null);
          filteredRestaurants.value = filteredPlace.filter(destination => destination.restaurant_id !== null);
          console.log('filteredDestinations: ', filteredDestinations.value);
          console.log('filteredHotels: ', filteredHotels.value);
          console.log('filteredRestaurants: ', filteredRestaurants.value);
          
        } catch (error) {
          console.error('Error fetching destinations:', error);
        } finally {
          isDestinationsLoading.value = false;
        }
    };

    const filterItems = (items) => {
        // Nếu items không tồn tại hoặc không phải là mảng, trả về mảng rỗng
        if (!Array.isArray(items)) return [];
        
        // Nếu không có tag nào được chọn, trả về toàn bộ danh sách
        if (!tripStore.selectedTags.length) return [...items];
      
        // Lọc các mục có ít nhất một tag trùng với tag đã chọn
        return items.filter(item => 
          Array.isArray(item.tags) && item.tags.some(tag => tripStore.selectedTags.includes(tag.id))
        );
    };


    // Thêm tour
    const addTour = async () => {
        try {
            const result = await addTourAPI(tripStore);
            console.log("Add tour result:", result);
            if (result.success) {
                console.log("Add tour success");
                console.log("Tour id: ", result.id);
                tourid.value = result.id;
            } else {
                console.log("Add tour failed");
            }
        } catch (error) {
            console.log("Error adding tour:", error);
        }
    };

    return {
        selectedDestination,
        selectDestination,
        searchQuery,
        addTour,
        suggestedDestinations,
        searchDestinations,
        goToCalendar,
        goToDestinationSelection,
        gotoTopic,
        gotoPickPlace,
        currentStep,
        selectedDates,
        activePicker,
        onDateChange,
        rawSelectedDates,
        startDay,
        endDay,
        topics,
        selectedTopics,
        toggleTopic,
        destinations,
        places,
        attractions,
        hotels,
        restaurants,
        generateStars,
        picked,
        togglePickStatus,
        pickFull,
        pickEmpty,
        isAllSelected,
        selectedCount,
        totalItems,
        selectAll,
        gotoChoosePlanning,
        createItinerary,
        saveForLater,
        itineraryName,
        finishItinerary,
        fetchDestinationsData,
        tourid   
    };
}
