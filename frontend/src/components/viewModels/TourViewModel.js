import { ref, onMounted, watch, nextTick } from 'vue';
import { fetchCities } from '../models/CityModel';
import { fetchTours, getTourById, getTourByCityId, getTourByUserId } from '../models/TourModel';
import { getUserById } from '../models/UserModel';
import { getReviewByTourId } from '../models/ReviewModel.js';
import generateViewModel from './generate_ratingViewModel'; 
import SignInModel from '../models/SignInModel';

export default function () {
    const { fetchRatingTour, ratings} = generateViewModel();
    const loadCities = async () => {
        try {
            const cities = await fetchCities();
            return cities;
        } catch (error) {
            console.error('Error getting city list:', error);
            return [];
        }
    }
    const loadTours = async () => {
        try {
            const tours = await fetchTours();
            return tours;
        } catch (error) {
            console.error('Error getting tour list:', error);
            return [];
        }
    }
    const loadTourById = async (tourID) => {
        try {
            const tour = await getTourById(tourID);
            return tour;
        } catch (error) {
            console.error('Error getting tour:', error);
            return [];
        }
    }
    const loadTourByCityId = async (city_id) => {
        try {
            const tours = await getTourByCityId(city_id);
            return tours;
        } catch (error) {
            console.error('Error getting tour list:', error);
            return [];
        }
    }
    const loadTourByUserId = async (user_id) => {
      try {
          const currentUser = await loadCurrentUser();
          const tours = await getTourByUserId(currentUser.id);
          return tours;
      } catch (error) {
          console.error('Error getting tour list:', error);
          return [];
      }
  }
    const loadUser = async (userId) => {    
        try {
            const user = await getUserById(userId);
            console.log("User: ",user);
            return user;
        } catch (error) {
            console.error('Error getting user:', error);
            return [];
        }
    }

    const loadCurrentUser = async () => {
        const signInModel = new SignInModel("", "");
        try{
            const token = sessionStorage.getItem('access_token');
          if(token){
            const userResult = await signInModel.fetchCurrentUser(token);
            console.log("User Logined: ",userResult);
            if(userResult.success){
              return userResult.user;
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

    const loadReviewByTourId = async (tourID) => {
        try {
            let reviews = await getReviewByTourId(tourID);
            reviews = await loadUsersForComments(reviews);
            return reviews;
        } catch (error) {
            console.error('Error getting review list:', error);
            return [];
        }
    }
    const loadUsersForComments = async (reviews) => {
        if (reviews.length === 0) {
          console.warn("Danh sách nhận xét trống, không thể tải thông tin người dùng.");
          return;
        }
      
        const userSet = new Set(); // Dùng Set để tránh gọi lại API cho các user_id trùng nhau
        try {
            reviews.forEach(comment => {
            if (comment.user_id) {
              userSet.add(comment.user_id);
            }
          });
      
          const userPromises = Array.from(userSet).map(userID => loadUser(userID));
          const userResults = await Promise.all(userPromises);
      
          const userMap = new Map();
          userResults.forEach(user => {
            if (user && user.id) {
              userMap.set(user.id, user);
            }
          });
      
          reviews.forEach(comment => {
            const user = userMap.get(comment.user_id);
            if (user) {
              comment.user = user; // Thêm thông tin user vào mỗi comment
            }
          });
      
          console.log("Danh sách nhận xét với thông tin người dùng:", reviews);
          return reviews;
        } catch (error) {
          console.error("Có lỗi xảy ra khi tải thông tin người dùng:", error);
        }
      };
    return {
        loadCities,
        loadTours,
        loadTourById,
        loadTourByCityId,
        loadUser,
        loadReviewByTourId,
        loadCurrentUser,
        loadTourByUserId,
        fetchRatingTour,
        ratings
    }
}