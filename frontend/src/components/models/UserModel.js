import axios from 'axios';

export async function getUserById(userId) {
    try {
  
      // Fetch the basic user information based on userId
      const response = await axios.get(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/${userId}`,
        {
          headers: {
            accept: "application/json",
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
  export async function createUserInfo(user) {
    try {
      const token = sessionStorage.getItem("access_token");
      if (!token) throw new Error("No token found");
  
      // Construct query parameters from user data
      const params = new URLSearchParams();
      params.append("user_id", user.id);
      params.append("description", user.user_info.description);
      params.append("phone_number", user.user_info.phone_number);
      params.append("district", user.user_info.address.district);
      params.append("street", user.user_info.address.street);
      params.append("ward", user.user_info.address.ward);
      params.append("city_id", user.user_info.address.city_id);
  
      // Create FormData and add the image if provided
      let formData = null;
  
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
  export async function updateUserInfo(user) {
    try {
      const token = sessionStorage.getItem("access_token");
      if (!token) throw new Error("No token found");
  
      // Construct query parameters from user data
      const params = new URLSearchParams();
      params.append("description", user.user_info.description || "");
      params.append("phone_number", user.user_info.phone_number || "");
      params.append("district", user.user_info.address.district || "");
      params.append("street", user.user_info.address.street || "");
      params.append("ward", user.user_info.address.ward || "");
      params.append("city_id", user.user_info.address.city_id || "");
  
      // Only include the image in FormData if it is provided
      let formData = null;
  
      const response = await axios.put(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/userInfo/${
          user.user_info.id
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