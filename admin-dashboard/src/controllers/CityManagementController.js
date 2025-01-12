// src/controllers/CityManagementController.js

import { ref } from "vue";
import { useToast } from "vue-toastification";
import {
  getCities as fetchCitiesAPI,
  getCityById,
  addCity,
  updateCity as updateCityAPI,
  deleteCity as deleteCityAPI,
} from "@/models/CityManagementModel";

export default function () {
  const toast = useToast();

  const fetchCities = async () => {
    try {
      const cities = await fetchCitiesAPI();
      return cities;
    } catch (error) {
      toast.error("Error fetching cities:", error);
    }
  };

  const getCity = async (cityID) => {
    try {
      const city = await getCityById(cityID);
      return city;
    } catch (error) {
      toast.error("Error fetching cities:", error);
    }
  };

  const updateCity = async (cityID) => {
    try {
      const city = getCity(cityID);
      return city;
    } catch (error) {
      toast.error("Error fetching cities:", error);
    }
  };

  const confirmCreate = async (city, images) => {
    try {
      await addCity(city, images);
      toast.success("Add City successfull");
      window.location.assign("/cities");
    } catch (error) {
      toast.error("Error add city:", error);
    }
  };
  const confirmUpdate = async (city, new_images, image_ids_to_remove) => {
    try {
      await updateCityAPI(city, new_images, image_ids_to_remove);
      toast.success("Update City successfull");
      window.location.assign("/cities");
    } catch (error) {
      toast.error("Error update city:", error);
    }
  };

  const deleteCity = async (cityID) => {
    const confirmDelete = window.confirm(
      "Are you sure you want to delete this city?"
    );
    if (confirmDelete) {
      try {
        const response = await deleteCityAPI(cityID);
        if (response.success) {
          toast.success(response.message);
          window.location.reload();
        } else {
          toast.error("Failed to delete city:", response.message);
        }
      } catch (error) {
        toast.error("Error deleting city:", error);
      }
    }
  };

  return {
    confirmCreate,
    fetchCities,
    deleteCity,
    updateCity,
    confirmUpdate,
  };
}
