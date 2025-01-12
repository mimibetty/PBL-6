import {
    getDestination,
    fetchStatistics,
    getAllCities,
    fetchRatingByDestinationID
} from "../models/homeBusinessModel";
import {
    ref,
    onMounted
} from "vue";
import SignInModel from "../models/SignInModel";
import {
    getTourByUserId,
    deleteTour
} from '../models/TourModel'
import {
    useToast
} from "vue-toastification";

export default function () {
    const toast = useToast();

    const totalDestination = ref(0);
    const totalTour = ref(0);
    const totalReview = ref(0);
    const averageRating = ref(0);

    const selectDestinationID = ref(0);
    const nameDestination = ref("");
    const destID = ref({});
    const destinations = ref([]);
    const isLoading = ref(false);
    const user = ref(null);
    const cityCache = ref({}); //Cache để lưu tên thành phố theo city_id

    const tourList = ref([]);

    const rating_1 = ref({});
    const rating_2 = ref({});
    const rating_3 = ref({});
    const rating_4 = ref({});
    const rating_5 = ref({});

    onMounted(async () => {
        await loadUser(); // Đợi loadUser hoàn thành
        await loadAllcities();
        if (user.value) {
            await getStatistics();
            await loadTours();
            await loadDestinations(); // Gọi loadDestinations sau khi user đã được gán
            if (destinations.value.length > 0) {
                // Nếu có địa điểm, tự động load rating của địa điểm đầu tiên
                const firstDestination = destinations.value[0];
                await loadRatings(firstDestination.id);
            }
        }
    });

    // Load destinations
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

            //Thêm cityName từ cityCache vào mỗi destination
            place = place.map(destination => {
                destID.value[destination.id] = destination.id;
                totalReview.value += destination.review_count;
                const cityName = cityCache.value[destination.address.city_id] || "Unknown";
                return {
                    ...destination,
                    cityName
                };
            })
            console.log("Dest ID:", destID.value);
            console.log("Total Review:", totalReview.value);
            destinations.value = place || null;
            console.log("Place Update Name: ", destinations.value);
        } catch (error) {
            console.error("Error fetching destinations:", error);
        } finally {
            isLoading.value = false;
        }
    }

    // Láy tour của user DN
    const loadTours = async () => {
        try {
            let tours = await getTourByUserId(user.value.id);
            //Thêm cityName từ cityCache vào mỗi destination
            tours = tours.map(tour => {
                const cityName = cityCache.value[tour.city_id] || "Unknown";
                return {
                    ...tour,
                    cityName
                };
            });
            tours.reverse();
            tourList.value = tours || null;
            console.log("Tours:", tourList.value);
        } catch (error) {
            console.error("Error fetching tours:", error);
            return null;
        }
    };
    //Lấy tên tp theo ID
    const loadAllcities = async () => {
        try {
            const cities = await getAllCities();
            console.log("Fetched cities:", cities);
            cities.forEach(city => {
                cityCache.value[city.id] = city.name;
            });
            console.log("City ID:", destID.value);
            console.log("City cache:", cityCache.value);
        } catch (error) {
            console.error("Error fetching city details:", error);
            return null;
        }
    };
    // Lấy người dùng
    const loadUser = async () => {
        const signInModel = new SignInModel("", "");
        const token = sessionStorage.getItem('access_token');
        try {
            if (token) {
                const userResult = await signInModel.fetchCurrentUser(token);
                if (userResult.success) {
                    user.value = userResult.user;
                } else {
                    console.error('Cannot get user:', error);
                }
            }

        } catch (error) {
            console.error('An error occurred during authentication:', error);
            return {
                success: false,
                message: error.message || 'An error occurred'
            };
        }
        console.log("User:", user.value);
    }



    const getStatistics = async () => {
        console.log("UserIDD:", user.value.id);
        try {
            const statistics = await fetchStatistics(user.value.id);
            console.log("Statistics:", statistics);
            totalDestination.value = statistics.total_destinations;
            totalTour.value = statistics.total_tours;
            averageRating.value = statistics.average_rating;
            console.log("Total Destinations:", totalDestination.value);
            console.log("Total Tour:", totalTour.value);
            console.log("Average Rating:", averageRating.value);
            return statistics;
        } catch (error) {
            console.error("Error fetching statistics:", error);
            return null;
        }
    }
    // Hàm lấy rating 1 địa điểm
    const loadRatings = async (destinationID) => {
        try {
            const ratings = await fetchRatingByDestinationID(destinationID);
            // lấy tên thành phố load data
            nameDestination.value = destinations.value.find(destination => destination.id === destinationID)?.name || "Unknown";
            ratings.forEach(rating => {
                switch (rating.rating) {
                    case 1:
                        rating_1.value = rating.count;
                        console.log("Rating Data 1", rating_1.value);
                        break;
                    case 2:
                        rating_2.value = rating.count;
                        console.log("Rating Data 2", rating_2.value);
                        break;
                    case 3:
                        rating_3.value = rating.count;
                        console.log("Rating Data 3", rating_3.value);
                        break;
                    case 4:
                        rating_4.value = rating.count;
                        console.log("Rating Data 4", rating_4.value);
                        break;
                    case 5:
                        rating_5.value = rating.count;
                        console.log("Rating Data 5", rating_5.value);
                        break;
                    default:
                        console.warn(`Unexpected rating: ${rating.rating}`);
                }
            })
        } catch (error) {
            console.error("Error fetching ratings:", error);
            return null;
        }
    }
    // Hàm để lấy ID đ.điểm đã chọn
    const getSelectDestinationID = async (destinationID) => {
        try {
            selectDestinationID.value = destinationID;
            console.log("Selected Destination ID (1):", destinationID);
            console.log("Select Destination ID:", selectDestinationID.value);
            loadRatings(destinationID); // Gọi hàm để load ratings cho địa điểm được chọn
        } catch (error) {
            console.error("Error fetching select destination ID:", error);
            return null;
        }
    };
    const generateStars = (rating) => {
        const fullStar = new URL('@/assets/svg/star_full.svg',
            import.meta.url).href;
        const halfStar = new URL('@/assets/svg/star_half.svg',
            import.meta.url).href;
        const emptyStar = new URL('@/assets/svg/star_none.svg',
            import.meta.url).href;

        let stars = [];
        for (let i = 1; i <= 5; i++) {
            if (rating >= i) {
                stars.push(fullStar);
            } else if ((rating > i - 1 && rating - i + 1 >= 0.5) && rating < i) {
                stars.push(halfStar);
            } else {
                stars.push(emptyStar);
            }
        }
        return stars;
    };

    const deleteTourByTourID = async (tourID) => {
        try {
            console.log("User ID:", user.value?.id);
            const token = sessionStorage.getItem('access_token');
            console.log("Token:", token);
            const response = await deleteTour(tourID);
            if (response.success) {
                toast.success("Delete a tour complete");
                tourList.value = tourList.value.filter(tour => tour.id !== tourID);
            } else {
                toast.error("Delete a tour faild");
            }
        } catch (error) {
            console.error('Error getting tour:', error);
            return [];
        }
    }


    return {
        destinations,
        isLoading,
        loadDestinations, //trả về dùng cho table
        totalDestination,
        totalTour,
        averageRating,
        totalReview, //Dùng cho các biến khái quát ban đầu
        rating_1,
        rating_2,
        rating_3,
        rating_4,
        rating_5,
        loadRatings,
        nameDestination, //dùng cho chart
        selectDestinationID,
        getSelectDestinationID, //dùng để load dl cho chart khi chọn từ table
        tourList,
        generateStars,
        deleteTourByTourID,
    };
}