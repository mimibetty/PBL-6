import { ref, onMounted, watch, nextTick } from 'vue';
import SignInModel from '../models/SignInModel';
import { useToast } from "vue-toastification";
import { getReviewByUserID } from '../models/ReviewModel';
import { getDestinationById } from '../models/destinationModel';
import { fetchCityDetails } from '../models/CityModel';

export default function () {
    const toast = useToast();
    const user = ref(null);

    const reviewList = async () => {
        try {
          // Kiểm tra và load user nếu chưa có
          if (!user.value) {
            const signInModel = new SignInModel("", "");
            const token = sessionStorage.getItem("access_token");
      
            if (!token) {
              console.error("No access token found. Cannot authenticate user.");
              return false;
            }
      
            const userResult = await signInModel.fetchCurrentUser(token);
      
            if (userResult.success) {
              user.value = userResult.user;
            } else {
              console.error("User authentication failed");
              return false;
            }
          }
      
          // Gọi API để lấy danh sách reviews
          const result = await getReviewByUserID(user.value.id);
          console.log("result:", result);
      
          // Sắp xếp danh sách review theo `date_create` (giảm dần)
          if (Array.isArray(result) && result.length > 0) {
            result.sort((a, b) => new Date(b.date_create) - new Date(a.date_create));
          }
      
          return result;
        } catch (error) {
          console.error("Error getting review list:", error);
          return [];
        }
      };
      const loadDestination = async (destinationID) => {
        try {
            console.log('destinationID:', destinationID);
            const destination = await getDestinationById(destinationID);
            return destination;
        } catch (error) {
            console.error("Có lỗi xảy ra khi lấy dữ liệu destination:", error);
        }
        };
        const loadCity = async (cityID) => {
            try {
                const city = await fetchCityDetails(cityID);
                return city;
            } catch (error) {
                console.error("Có lỗi xảy ra khi lấy dữ liệu destination:", error);
            }
            };

      
    return {
        user,
        reviewList,
        loadDestination,
        loadCity,
    }

}