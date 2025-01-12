// src/models/UserManagementModel.js
import axios from "axios";

// Hàm lấy tất cả người dùng từ API
export async function getUsers() {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    // Lấy danh sách người dùng
    const response = await axios.get(
      "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/",
      {
        headers: {
          accept: "application/json",
          Authorization: `Bearer ${token}`,
        },
      }
    );

    // Duyệt qua từng user để lấy thông tin chi tiết
    const usersWithDetails = await Promise.all(
      response.data.map(async (user) => {
        // Mặc định thông tin business_description và phone_number là trống
        let businessDescription = "";
        let phoneNumber = "";
        let isCreate = false;

        try {
          // Lấy thông tin chi tiết của từng user dựa trên user_id
          const userInfoResponse = await axios.get(
            `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/userInfo/${user.id}`,
            {
              headers: {
                accept: "application/json",
                Authorization: `Bearer ${token}`,
              },
            }
          );

          // Nếu thành công, gán giá trị business_description và phone_number
          businessDescription = userInfoResponse.data.business_description;
          phoneNumber = userInfoResponse.data.phone_number;
          isCreate = true;
        } catch (error) {
          if (error.response && error.response.status === 500) {
            // console.warn(
            //   `User info not found for user ID ${user.id}, defaulting to empty values.`
            // );
          } else {
            console.error(
              `Error fetching user info for user ID ${user.id}:`,
              error
            );
          }
        }

        return {
          id: user.id,
          username: user.username,
          email: user.email,
          business_description: businessDescription,
          phone_number: phoneNumber,
          role: user.role,
          isCreate: isCreate,
        };
      })
    );

    return usersWithDetails;
  } catch (error) {
    console.error("Error fetching users:", error);
    return []; // Hoặc bạn có thể xử lý theo cách khác
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

    // Default empty values for business_description and phone_number
    let businessDescription = "";
    let phoneNumber = "";
    let isCreate = false;

    try {
      // Fetch additional user information if available
      const userInfoResponse = await axios.get(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/userInfo/${userId}`,
        {
          headers: {
            accept: "application/json",
            Authorization: `Bearer ${token}`,
          },
        }
      );

      // Assign values if user info is found
      businessDescription = userInfoResponse.data.business_description;
      phoneNumber = userInfoResponse.data.phone_number;
      isCreate = true;
    } catch (error) {
      if (error.response && error.response.status === 500) {
        // console.warn(
        //   `User info not found for user ID ${userId}, defaulting to empty values.`
        // );
      } else {
        console.error(`Error fetching user info for user ID ${userId}:`, error);
      }
    }

    // Return the user details with additional information
    return {
      id: user.id,
      username: user.username,
      email: user.email,
      business_description: businessDescription,
      phone_number: phoneNumber,
      role: user.role,
      isCreate: isCreate,
    };
  } catch (error) {
    console.error(`Error fetching user with ID ${userId}:`, error);
    return null; // Return null or handle as needed
  }
}

export async function createUserInfo(user) {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    const response = await axios.post(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/userInfo/${user.id}`,
      {
        business_description: user.business_description,
        phone_number: user.phone_number,
      },
      {
        headers: {
          accept: "application/json",
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
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    const response = await axios.put(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/userInfo/${user.id}`, // sử dụng user.id làm userId
      {
        business_description: user.business_description,
        phone_number: user.phone_number,
      },
      {
        headers: {
          accept: "application/json",
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
