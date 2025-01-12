// src/controllers/DestinationManagementController.js

import { ref } from "vue";
import { useToast } from "vue-toastification";
import {
  getDestinations as fetchDestinationsAPI,
  getDestinationById,
} from "@/models/DestinationManagementModel";
import {
    getReviewByDestinationId,
    getReviewById,
    addReview,
    updateReview as updateReviewAPI,
    deleteReview as deleteReviewAPI,
    
} from "@/models/ReviewManagementModel";
import { getCities as fetchCitiesAPI } from "@/models/CityManagementModel";
import { getUsers as fetchUsersAPI } from "@/models/UserManagementModel";


export default function () {
  const actionStep = ref("read");
  const toast = useToast();

  const fetchCities = async () => {
    try {
      const cities = await fetchCitiesAPI();
      return cities;
    } catch (error) {
      toast.error("Error fetching cities:", error);
    }
  };

  const fetchUsers = async () => {
    try {
      const users = await fetchUsersAPI();
      return users;
    } catch (error) {
      toast.error("Error to get User");
    }
  };

  const fetchDestinations = async () => {
    try {
      const destinations = await fetchDestinationsAPI();
      return destinations;
    } catch (error) {
      toast.error("Error fetching destination:", error);
    }
  };

  const getDestination = async (destinationID) => {
    try {
      const destination = await getDestinationById(destinationID);
      return destination;
    } catch (error) {
      toast.error("Error fetching destination:", error);
    }
  };

  const fetchReviewByDestination = async (destinationID) => {
    try {
      const reviews = await getReviewByDestinationId(destinationID);
      return reviews;
    } catch (error) {
      toast.error("Error fetching review:", error);
    }
  };


  const updateReview = async (reviewID) => {
    try {
      const review = await getReviewById(reviewID);
      return review;
    } catch (error) {
      toast.error("Error fetching review");
    }
  };

  const confirmCreate = async (review, images) => {
    try {
      const result = await addReview(review, images);
      if (result.success) {
        toast.success(`Add Review successful: ${result.name}`);
        window.location.assign(`/reviews/:${review.destination_id}`);
      } else {
        toast.error("Error add review");
      }
    } catch (error) {
      toast.error("Error add destination");
    }
  };
  const confirmUpdate = async (
    review,
    new_images,
    image_ids_to_remove
  ) => {
    try {
      const result =  await updateReviewAPI(review, new_images, image_ids_to_remove);
      if (result.success) {
        toast.success("Update Review successfull");
        window.location.assign(`/reviews/:${review.destination_id}`);
      } else {
        toast.error("Error update review");
      }
    } catch (error) {
      toast.error("Error update review");
    }
  };

  const deleteReview = async (reviewID) => {
    const confirmDelete = window.confirm(
      "Are you sure you want to delete this review?"
    );
    if (confirmDelete) {
      try {
        const response = await deleteReviewAPI(reviewID);
        if (response.success) {
          toast.success(response.message);
          window.location.reload();
        } else {
          toast.error("Failed to delete review:", response.message);
        }
      } catch (error) {
        toast.error("Error deleting review:", error);
      }
    }
  };


  return {
    fetchCities,
    fetchUsers,
    confirmCreate,
    fetchDestinations,
    getDestination,
    fetchReviewByDestination,
    deleteReview,
    updateReview,
    confirmUpdate,
  };
}
