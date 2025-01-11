// src/controllers/DestinationManagementController.js

import { ref } from "vue";
import { useToast } from "vue-toastification";
import {
  getDestinations as fetchDestinationsAPI,
  getDestinationById,
  addDestination,
  updateDestination as updateDestinationAPI,
  deleteDestination as deleteDestinationAPI,
  addRestaurant,
  updateRestaurant as updateRestaurantAPI,
  deleteRestaurant as deleteRestaurantAPI,
  addHotel,
  updateHotel as updateHotelAPI,
  deleteHotel as deleteHotelAPI,
} from "@/models/DestinationManagementModel";
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


  const showDetailDestination = (destinationID) => {
    try {
      const destination = getDestination(destinationID);
      return destination;
    } catch (error) {
      toast.error("Error fetching destination");
    }
  };

  const updateDestination = async (destinationID) => {
    try {
      const destination = getDestination(destinationID);
      return destination;
    } catch (error) {
      toast.error("Error fetching destination");
    }
  };

  const confirmCreate = async (destination, images) => {
    try {
      const result = await addDestination(destination, images);
      if (result.success){
        toast.success(`Add Destination successful: ${result.name}`);
        setTimeout(() => {
          window.location.assign(`/destinations`);
        }, 3000);
      } else {
        toast.error("Error add destination");
      }
    } catch (error) {
      toast.error("Error add destination");
    }
  };
  const confirmUpdate = async (
    destination,
    new_images,
    image_ids_to_remove
  ) => {
    try {
      const result =  await updateDestinationAPI(destination, new_images, image_ids_to_remove);
      if (result.success) {
        toast.success("Update Destination successfull");
        setTimeout(() => {
          window.location.assign(`/destinations/${destination.id}`);
        }, 3000);
      } else {
        toast.error("Error update destination");
      }
    } catch (error) {
      toast.error("Error update destination");
    }
  };

  const deleteDestination = async (destinationID) => {
    const confirmDelete = window.confirm(
      "Are you sure you want to delete this destination?"
    );
    if (confirmDelete) {
      try {
        const response = await deleteDestinationAPI(destinationID);
        if (response.success) {
          toast.success(response.message);
          window.location.reload();
          // Trigger a data refresh instead of a page reload if possible
        } else {
          toast.error("Failed to delete destination:", response.message);
        }
      } catch (error) {
        toast.error("Error deleting destination:", error);
      }
    }
  };


  const updateHotel = async (destinationID) => {
    try {
      const hotel = getDestination(destinationID);
      return hotel;
    } catch (error) {
      toast.error("Error fetching Hotel");
    }
  };

  const confirmCreateHotel = async (hotel) => {
    try {
      const result =  await addHotel(hotel);
      if(result.success){
        toast.success("Create a hotel success");
        setTimeout(() => {
          window.location.assign(`/destinations/${hotel.id}`);
        }, 3000);
      } else {
        toast.error("Error add hotel");
      }
    } catch (error) {
      toast.error("Error add Hotel");
    }
  };
  const confirmUpdateHotel = async (hotel) => {
    try {
      const result =  await updateHotelAPI(hotel);
      if (result.success) {
        toast.success("Update Hotel successfull");
        setTimeout(() => {
          window.location.assign(`/destinations/${hotel.id}`);
        }, 3000);
      } else {
        toast.error("Error update Hotel");
      }
    } catch (error) {
      toast.error("Error update Hotel");
    }
  };
  const deleteHotel = async (hotelID) => {
    const confirmDelete = window.confirm(
      "Are you sure you want to delete this hotel?"
    );
    if (confirmDelete) {
      try {
        const response = await deleteHotelAPI(hotelID);
        if (response.success) {
          toast.success(response.message);
          window.location.reload();
        } else {
          toast.error("Failed to delete hotel:", response.message);
        }
      } catch (error) {
        toast.error("Error deleting hotel:", error);
      }
    }
  };


  const updateRestaurant = async (DestinationID) => {
    try {
      const restaurant = getDestination(DestinationID);
      return restaurant;
    } catch (error) {
      console.error("Error to get Restaurant");
    }
  };

  const confirmCreateRestaurant = async (Restaurant) => {
    try {
      const result =  await addRestaurant(Restaurant);
      if (result.success){
        toast.success(`Add Restaurant successful: ${result.name}`);
        setTimeout(() => {
          window.location.assign(`/destinations/${Restaurant.id}`);
        }, 3000);
        
      } else {
        toast.error("Error to add Restaurant");
      }
    } catch (error) {
      toast.error("Error to add Restaurant");
    }
  };
  const confirmUpdateRestaurant = async (Restaurant) => {
    try {
      const result =  await updateRestaurantAPI(Restaurant);
      if (result.success) {
        toast.success("Update Restaurant successfull");
        setTimeout(() => {
          window.location.assign(`/destinations/${Restaurant.id}`);
        }, 3000);
      } else {
        toast.error("Error to update Restaurant");
      }
    } catch (error) {
      toast.error("Error to update Restaurant");
    }
  };

  const deleteRestaurant = async (RestaurantID) => {
    const confirmDelete = window.confirm(
      "Are you sure you want to delete this Restaurant?"
    );
    if (confirmDelete) {
      try {
        const response = await deleteRestaurantAPI(RestaurantID);
        if (response.success) {
          toast.success(response.message);
          window.location.reload();
          // Trigger a data refresh instead of a page reload if possible
        } else {
          toast.error("Failed to delete Restaurant:", response.message);
        }
      } catch (error) {
        toast.error("Error deleting Restaurant:", error);
      }
    }
  };

  return {
    fetchDestinations,
    deleteDestination,
    fetchCities,
    fetchUsers,
    confirmCreate,
    confirmCreateHotel,
    getDestination,
    confirmCreateRestaurant,
    showDetailDestination,
    deleteHotel,
    deleteRestaurant,
    updateDestination,
    confirmUpdate,
    updateHotel,
    confirmUpdateHotel,
    updateRestaurant,
    confirmUpdateRestaurant,
  };
}
