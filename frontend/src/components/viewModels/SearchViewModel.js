import { ref, onMounted } from 'vue';
import { getSearchResult } from '../models/SearchModel.js';
import { fetchCityDetails } from '../models/CityModel.js';
import { getDestinationById } from '../models/destinationModel.js';

export default function (searchQuery) {
    const searchResult = ref(null);
    const cities = ref([]);
    const destinations = ref([]);
    const hotels = ref([]);
    const restaurants = ref([]);
    const places = ref([]);
    const isLoading = ref(false);

    // Hàm tìm kiếm
    const search = async () => {
        isLoading.value = true;
        try {
            // Lấy kết quả tìm kiếm
            searchResult.value = await getSearchResult(searchQuery);
            console.log("Search searchResult: ", searchResult.value);
    
            // Kiểm tra và xử lý mảng cities
            if (searchResult.value.cities && searchResult.value.cities.length > 0) {
                await Promise.all(
                    searchResult.value.cities.map(city => getDetailCity(city.id))
                );
            } else {
                console.log("No cities found in search results.");
            }
    
            // Kiểm tra và xử lý mảng destinations
            if (searchResult.value.destinations && searchResult.value.destinations.length > 0) {
                await Promise.all(
                    searchResult.value.destinations.map(destination => getPlaceData(destination.id))
                );
            } else {
                console.log("No destinations found in search results.");
            }
        } catch (error) {
            console.error('An error occurred while searching:', error);
        } finally {
            isLoading.value = false;
        }
    };
    

    // Hàm lấy chi tiết thành phố
    const getDetailCity = async (cityId) => {
        try {
            const city = await fetchCityDetails(cityId);
            if (!cities.value.some(existingCity => existingCity.id === city.id)) {
                cities.value.push(city); // Thêm thành phố vào mảng nếu chưa có
            }
        } catch (error) {
            console.error('An error occurred while getting city details:', error);
        }
    };

    // Hàm lấy dữ liệu địa điểm
    const getPlaceData = async (id) => {
        try {
            const place = await getDestinationById(id);
            if (!places.value.some(existingPlace => existingPlace.id === place.id)) {
                places.value.push(place); // Thêm địa điểm vào mảng nếu chưa có
            }

            // Phân loại các địa điểm vào đúng mảng (Destinations, Hotels, Restaurants)
            if (place.hotel_id == null && place.restaurant_id == null) {
                destinations.value.push(place);
            } else if (place.hotel_id != null) {
                hotels.value.push(place);
            } else if (place.restaurant_id != null) {
                restaurants.value.push(place);
            }
        } catch (error) {
            console.error('An error occurred while getting place details:', error);
        }
    };

    // Trả về các biến và hàm cần thiết
    return {
        search,
        searchResult,
        isLoading,
        cities,
        destinations,
        hotels,
        restaurants,
    };
}
