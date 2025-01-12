import { ref, computed, onMounted, watch } from 'vue';
import SignInModel from '../models/SignInModel';
import { getDestinationById } from '../models/destinationModel.js';
import RatingViewModel from './generate_ratingViewModel.js';
import { updateReview, getReviewById } from '../models/ReviewModel';

export default function (reviewID) {
  // Menu visibility toggle
  const user = ref(null);
  const token = sessionStorage.getItem('access_token');
  const loadUser = async () => {
    const signInModel = new SignInModel("", "");
    try {
      const userResult = await signInModel.fetchCurrentUser(token);
      if (userResult.success) {
        user.value = userResult.user;
      } else {
        console.error('Cannot get user:', error);
      }
    } catch (error) {
      console.error('An error occurred during authentication:', error);
      return { success: false, message: error.message || 'An error occurred' };
    }
  };

  const review = ref(null);
  const destination = ref(null);
  const loadReview = async () => {
    try {
      review.value = await getReviewById(reviewID);
      destination.value = await getDestinationById(review.value.destination_id);
      console.log(review.value);
    } catch (error) {
      console.error("Có lỗi xảy ra khi lấy dữ liệu:", error);
    }
  };

  loadReview();
  loadUser();

  // Star rating assets
  const { fullStar, halfStar, emptyStar } = RatingViewModel();

  // Rating states
  const currentRating = ref(0); // Giá trị mặc định
  const hoveredRating = ref(0);

  // Status labels for ratings
  const statuses = ['Terrible', 'Bad', 'Medium', 'Very Good', 'Excellent'];

  // Computed property for rating status
  const ratingStatus = computed(() => {
    const rating = hoveredRating.value || currentRating.value; // Ưu tiên giá trị hover
    return rating > 0 && rating <= statuses.length ? statuses[rating - 1] : '';
  });

  // Hover and leave rating logic
  const hoverRating = (index) => {
    hoveredRating.value = index; // Đặt trạng thái hover
  };

  const leaveRating = () => {
    hoveredRating.value = 0; // Đặt lại trạng thái hover
  };

  // Set rating on click
  const setRating = (index) => {
    currentRating.value = index; // Cập nhật đánh giá
    if (review.value) {
      review.value.rating = index;
    }
  };

  // Companion selection
  const companions = [
    { value: 'Solo', label: 'Solo' },
    { value: 'Family', label: 'Family' },
    { value: 'Couple', label: 'Couple' },
    { value: 'Friends', label: 'Friends' },
    { value: 'Company', label: 'Company' },
    { value: 'Other', label: 'Other' },
  ];

  const selectedCompanion = ref(companions[0]); // Mặc định

  const selectCompanion = (value) => {
    selectedCompanion.value = companions.find(option => option.value === value) || companions[0];
    if (review.value) {
      review.value.companion = selectedCompanion.value.value;
    }
  };

  // Handle visit date
  const rawSelectedDate = ref(new Date());
  const visitDate = ref('');

  const formatDate = (date) => {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  };

  const onDateChange = (selectedDate) => {
    if (selectedDate) {
      const newDate = new Date(selectedDate);
      rawSelectedDate.value = newDate;
      visitDate.value = formatDate(newDate);
      if (review.value) {
        review.value.date_create = visitDate.value;
      }
    }
  };
  const new_images = ref([]);
  const image_ids_to_remove = ref([]);
  const previewNewImages = ref([]);

  const handleNewImageUpload = (event) => {
    const files = event.target.files;
    Array.from(files).forEach((file) => {
      new_images.value.push(file);
      previewNewImages.value.push(URL.createObjectURL(file)); // Thêm URL preview vào mảng
    });
  };

  const removeNewImage = (index) => {
    new_images.value.splice(index, 1); // Remove new image by index
    URL.revokeObjectURL(previewNewImages.value[index]); // Giải phóng bộ nhớ của URL preview
    previewNewImages.value.splice(index, 1); // Xoá URL preview khỏi mảng
  };

  const removeExistingImage = (id) => {
    image_ids_to_remove.value.push(id); // Add image id to removal list
    review.value.images = review.value.images.filter(
      (img) => img.id !== id
    );
  };

  const submitReview = async () => {
    try{
        const result = await updateReview(review.value, new_images.value, image_ids_to_remove.value);
        console.log(result.data);
        if (result.success) {
            window.history.back();
          }

    } catch(error){
        console.error("Update Failed");
    }
  }

  // Watch for changes in `review` data
  watch(review, (newReview) => {
    if (newReview) {
      currentRating.value = newReview.rating || 0;
      selectedCompanion.value = companions.find(option => option.value === newReview.companion) || companions[0];
      const initialDate = new Date(newReview.date_create);
      if (!isNaN(initialDate.getTime())) {
        rawSelectedDate.value = initialDate;
        visitDate.value = formatDate(initialDate);
      }
    }
  });

  return {
    destination,
    review,
    fullStar,
    halfStar,
    emptyStar,
    rawSelectedDate,
    onDateChange,
    currentRating,
    ratingStatus,
    hoverRating,
    leaveRating,
    setRating,
    hoveredRating,
    companions,
    selectedCompanion,
    selectCompanion,
    visitDate,
    previewNewImages,
    handleNewImageUpload,
    removeNewImage,
    removeExistingImage,
    submitReview,
  };
}
