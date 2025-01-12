// src/controllers/UserManagementController.js
import {
  getUsers as fetchUsersAPI,
  getUserById,
  createUserInfo,
  updateUserInfo,
  deleteUserInfo,
  addNewUser,
} from "@/models/UserManagementModel";
import { ref } from "vue";

export default function () {
  const actionStep = ref("read");
  const fetchUsers = async () => {
    const users = await fetchUsersAPI();
    return users;
  };

  const getUser = async (userID) => {
    const user = await getUserById(userID);
    return user;
  };

  const createInfo = async (userID) => {
    const user = getUser(userID);
    actionStep.value = "create";
    return user;
  };

  const updateInfo = async (userID) => {
    const user = getUser(userID);
    actionStep.value = "update";
    return user;
  };

  const confirmCreateInfo = async (user) => {
    await createUserInfo(user);
    actionStep.value = "read";
    window.location.reload();
  };
  const confirmUpdateInfo = async (user) => {
    await updateUserInfo(user);
    actionStep.value = "read";
    window.location.reload();
  };

  const deleteInfo = async (userID) => {
    const confirmDelete = window.confirm(
      "Are you sure you want to delete this user information?"
    );
    if (confirmDelete) {
      await deleteUserInfo(userID);
      window.location.reload();
    }
  };

  const addUser = () => {
    actionStep.value = "addUser";
  };

  const confirmAddUser = async (user) => {
    if (user.confirmPassword === user.password) {
      await addNewUser(user);
      actionStep.value = "read";
      window.location.reload();
    } else {
      alert("Password and confirm password do not match. Please check again.");
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
  };
}
