// src/controllers/UserManagementController.js
import {
  getUsers as fetchUsersAPI,
  getUserById,
  createUserInfo,
  updateUserInfo,
  deleteUserInfo,
  addNewUser,
  changeUserStatus,
} from "@/models/UserManagementModel";

import { getCities as fetchCitiesAPI } from "@/models/CityManagementModel";
import { useToast } from "vue-toastification";
import { ref } from "vue";

export default function () {
  const actionStep = ref("read");
  const toast = useToast();
  const fetchUsers = async () => {
    try {
      const users = await fetchUsersAPI();
      return users;
    } catch (error) {
      toast.error("Error to get User");
    }
  };

  const fetchCities = async () => {
    try {
      const cities = await fetchCitiesAPI();
      return cities;
    } catch (error) {
      toast.error("Error fetching cities:", error);
    }
  };

  const getUser = async (userID) => {
    try {
      const user = await getUserById(userID);
      return user;
    } catch (error) {
      toast.error("Error to get User");
    }
  };

  const createInfo = async (userID) => {
    try {
      const user = getUser(userID);
      return user;
    } catch (error) {
      toast.error("Error to get User");
    }
  };

  const updateInfo = async (userID) => {
    try {
      const user = getUser(userID);
      return user;
    } catch (error) {
      toast.error("Error to get User");
    }
  };

  const confirmCreateInfo = async (user, uploadedImageFile) => {
    try {
      await createUserInfo(user, uploadedImageFile);
      window.location.assign(`/users`);
      toast.success("Create user info sucessfully");
    } catch (error) {
      toast.error("Error to create user info");
    }
  };
  const confirmUpdateInfo = async (user, uploadedImageFile) => {
    try {
      await updateUserInfo(user, uploadedImageFile);
      window.location.assign(`/users`);
      toast.success("Update user info sucessfully");
    } catch (error) {
      toast.error("Error to update user info");
    }
  };

  const deleteInfo = async (userID) => {
    const confirmDelete = window.confirm(
      "Are you sure you want to delete this user information?"
    );
    if (confirmDelete) {
      try {
        await deleteUserInfo(userID);
        window.location.assign(`/users`);
        toast.success("Delete user info sucessfully");
      } catch (error) {
        toast.error("Error to delete user info");
      }
    }
  };

  const addUser = () => {
    actionStep.value = "addUser";
  };

  const confirmAddUser = async (user) => {
    if (user.confirmPassword === user.password) {
      try {
        await addNewUser(user);
        window.location.assign(`/users`);
        toast.success("Add user sucessfully");
      } catch (error) {
        toast.error("Error to add user");
      }
    } else {
      toast.error(
        "Password and confirm password do not match. Please check again."
      );
    }
  };

  const changeStatus = async (userID) => {
    const confirmChange = window.confirm(
      "Are you sure you want to change this user status?"
    );
    if (confirmChange) {
      try {
        await changeUserStatus(userID);
        toast.success("Change user status sucessfully");
        window.location.assign(`/users`);
        
      } catch (error) {
        toast.error("Error to Change user status");
      }
    }
  };
  return {
    fetchUsers,
    actionStep,
    createInfo,
    updateInfo,
    confirmCreateInfo,
    confirmUpdateInfo,
    deleteInfo,
    addUser,
    confirmAddUser,
    changeStatus,
    fetchCities,
  };
}
