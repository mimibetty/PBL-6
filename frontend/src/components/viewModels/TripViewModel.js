import { ref, onMounted, watch, nextTick } from 'vue';
import { getTripByUserID, deleteTrip } from '../models/TripModel'
import SignInModel from '../models/SignInModel';
import { useToast } from 'vue-toastification';

export default function () {
    const user = ref(null);
    const toast = useToast();
    
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

      const fetchTripByUser = async () => {
        await loadUser();
        let trips = await getTripByUserID(user.value.id);
        trips = trips.sort((a, b) => b.id - a.id);
        return trips;
    }
    const deleteTripById = async (tripId) => {
      // Hiển thị cửa sổ xác nhận trước khi xóa
      const isConfirmed = window.confirm("Are you sure you want to delete this trip?");
      
      if (!isConfirmed) {
          return; // Nếu người dùng không xác nhận, không thực hiện hành động xóa
      }
  
      try {
          const result = await deleteTrip(tripId);
          if (!result.success) {
              console.error('An error occurred during deletion:', result.message);
              toast.error('An error occurred during deletion');
              return false;
          } else {
              toast.success('Trip deleted successfully');
          }
          window.location.reload();
      } catch (error) {
          console.error('An error occurred during deletion:', error);
          toast.error('An error occurred during deletion');
      }
  };

    return {
        fetchTripByUser,
        deleteTripById,
    }

}