// src/models/UserManagementModel.js
import axios from "axios";

export async function getUsers() {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    // Gửi yêu cầu để lấy danh sách người dùng
    const response = await axios.get(
      "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/",
      {
        headers: {
          accept: "application/json",
          Authorization: `Bearer ${token}`,
        },
      }
    );

    return response.data.map((user) => ({
      id: user.id,
      username: user.username,
      email: user.email,
      userInfo: user.user_info,
      role: user.role,
      status: user.status,
    }));
  } catch (error) {
    console.error("Error fetching users:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}

export async function getUserById(userId) {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    // Fetch the basic user information based on userId
    const response = await axios.get(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/${userId}`,
      {
        headers: {
          accept: "application/json",
          Authorization: `Bearer ${token}`,
        },
      }
    );

    const user = response.data;

    return {
      id: user.id,
      username: user.username,
      email: user.email,
      userInfo: user.user_info,
      role: user.role,
      status: user.status,
    };
  } catch (error) {
    console.error(`Error fetching user with ID ${userId}:`, error);
    return null; // Return null or handle as needed
  }
}

export async function createUserInfo(user, uploadedImageFile) {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    // Construct query parameters from user data
    const params = new URLSearchParams();
    params.append("user_id", user.id);
    params.append("description", user.userInfo.description);
    params.append("phone_number", user.userInfo.phone_number);
    params.append("district", user.userInfo.address.district);
    params.append("street", user.userInfo.address.street);
    params.append("ward", user.userInfo.address.ward);
    params.append("city_id", user.userInfo.address.city_id);

    // Create FormData and add the image if provided
    let formData = null;
    if (uploadedImageFile) {
      formData = new FormData();
      formData.append("image_inp", uploadedImageFile);
    }

    const response = await axios.post(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/userInfo/?${params.toString()}`,
      formData || undefined,
      {
        headers: {
          accept: "application/json",
          "Content-Type": "multipart/form-data",
          Authorization: `Bearer ${token}`,
        },
      }
    );

    if (response.status === 200) {
      console.log("User info created successfully");
      return { success: true, message: "User info created successfully" };
    }
  } catch (error) {
    console.error("Error creating user info:", error);
    return { success: false, message: "Failed to create user info" };
  }
}

// Cập nhật thông tin người dùng
export async function updateUserInfo(user, uploadedImageFile) {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    // Construct query parameters from user data
    const params = new URLSearchParams();
    params.append("description", user.userInfo.description || "");
    params.append("phone_number", user.userInfo.phone_number || "");
    params.append("district", user.userInfo.address.district || "");
    params.append("street", user.userInfo.address.street || "");
    params.append("ward", user.userInfo.address.ward || "");
    params.append("city_id", user.userInfo.address.city_id || "");

    // Only include the image in FormData if it is provided
    let formData = null;
    if (uploadedImageFile) {
      formData = new FormData();
      formData.append("image_inp", uploadedImageFile);
    }

    const response = await axios.put(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/userInfo/${
        user.userInfo.id
      }?${params.toString()}`,
      formData || undefined,
      {
        headers: {
          accept: "application/json",
          "Content-Type": "multipart/form-data",
          Authorization: `Bearer ${token}`,
        },
      }
    );

    if (response.status === 200) {
      console.log("User info updated successfully");
      return { success: true, message: "User info updated successfully" };
    }
  } catch (error) {
    console.error("Error updating user info:", error);
    return { success: false, message: "Failed to update user info" };
  }
}

export async function deleteUserInfo(userID) {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    const response = await axios.delete(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/userInfo/${userID}`, // sử dụng user.id làm userId
      {
        headers: {
          accept: "application/json",
          Authorization: `Bearer ${token}`,
        },
      }
    );

    if (response.status === 200) {
      console.log("User info delete successfully");
      return { success: true, message: "User info deleted successfully" };
    }
  } catch (error) {
    console.error("Error updating user info:", error);
    return { success: false, message: "Failed to delete info" };
  }
}

export async function addNewUser(user) {
  try {
    const data = {
      username: user.username,
      password: user.password,
      email: user.email,
    };
    const response = await axios.post(
      "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/",
      data,
      {
        headers: {
          "Content-Type": "application/json",
        },
      }
    );

    if (response.data && response.data.username) {
      return { success: true, name: response.data.username }; // Assuming name is returned
    } else {
      return { success: false, message: "Failed to register account" };
    }
  } catch (error) {
    if (error.response && error.response.status === 422) {
      return { success: false, message: "Invalid data" };
    } else {
      return { success: false, message: "An error occurred" };
    }
  }
}

export async function changeUserStatus(userID) {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    const response = await axios.post(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net//user/status_change/${userID}`, // sử dụng user.id làm userId
      {
        headers: {
          accept: "application/json",
          Authorization: `Bearer ${token}`,
        },
      }
    );

    if (response.status === 200) {
      console.log("User change status successfully");
      return { success: true, message: "User change status successfully" };
    }
  } catch (error) {
    console.error("Error User change status:", error);
    return { success: false, message: "Failed to User change status" };
  }
}
