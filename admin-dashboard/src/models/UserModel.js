// src/models/UserModel.js
import axios from "axios";

export const authenticateUser = async (username, password) => {
  try {
    const data = new URLSearchParams();
    data.append("username", username);
    data.append("password", password);

    const response = await axios.post(
      "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/login",
      data,
      { headers: { "Content-Type": "application/x-www-form-urlencoded" } }
    );

    if (response.data && response.data.access_token) {
      const token = response.data.access_token;
      sessionStorage.setItem("token", token); // Save the token in sessionStorage
      return { success: true, token };
    } else {
      return { success: false, message: "Token not received" };
    }
  } catch (error) {
    const errorMessage = error.response?.data?.detail || "An error occurred";
    return { success: false, message: errorMessage };
  }
};

export const fetchCurrentUser = async () => {
  const token = sessionStorage.getItem("token"); // Retrieve token from sessionStorage
  if (!token) return { success: false, message: "No token found" };

  try {
    const response = await axios.get(
      "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/current-user",
      { headers: { Authorization: `Bearer ${token}` } }
    );

    if (response.data) {
      return { success: true, user: response.data };
    } else {
      return { success: false, message: "User data not received" };
    }
  } catch (error) {
    console.error("Failed to fetch user data:", error);
    return { success: false, message: "Failed to fetch user data" };
  }
};
