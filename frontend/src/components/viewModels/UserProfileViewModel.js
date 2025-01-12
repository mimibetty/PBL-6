import { getUserById , createUserInfo, updateUserInfo } from '../models/UserModel';
import { useToast } from 'vue-toastification';
import { ref, onMounted, watch, nextTick } from 'vue';
import { fetchCities } from '../models/CityModel';
import SignInModel from '../models/SignInModel';

export default function () {
    const toast = useToast();
    const user = ref(null);
    const token = sessionStorage.getItem('access_token');

    const loadUser = async () => {
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
              console.log('User:', user.value);
              return user.value;
            } else {
              console.error("User authentication failed");
              return false;
            }
          }
      
          return user.value;
        } catch (error) {
          console.error("Error getting review list:", error);
          return [];
        }
      };

    const createUser = async (user) => {
        try {
            const result = await createUserInfo(user);
            if (result.success) {
                console.log('Create user info success');
            } else {
                console.error('Cannot create user info:', error);
            }
        } catch (error) {
            console.error('An error occurred during authentication:', error);
            return { success: false, message: error.message || 'An error occurred' };
        }
    }

    const updateUser = async (user) => {
        try {
            const result = await updateUserInfo(user);
            if (result.success) {
                console.log('Update user info success');
            } else {
                console.error('Cannot update user info:', error);
            }
        } catch (error) {
            console.error('An error occurred during authentication:', error);
            return { success: false, message: error.message || 'An error occurred' };
        }
    }

    const loadCities = async () => {
        try {
            const cities = await fetchCities();
            return cities;
        } catch (error) {
            console.error("Error getting city list:", error);
            return [];
        }
    }

    return {
        user,
        loadUser,
        createUser,
        updateUser,
        loadCities,
    }

}