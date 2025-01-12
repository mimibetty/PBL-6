// src/controllers/AuthController.js
import { authenticateUser, fetchCurrentUser } from "@/models/UserModel";

export const login = async (username, password) => {
  const authResponse = await authenticateUser(username, password);

  if (authResponse.success) {
    const userResponse = await fetchCurrentUser(); // Fetch user info
    if (userResponse.success) {
      sessionStorage.setItem("user", JSON.stringify(userResponse.user));
      return {
        success: true,
        token: authResponse.token,
        user: userResponse.user,
      };
    } else {
      console.error(userResponse.message);
      return {
        success: false,
        message: "Failed to fetch user info after login",
      };
    }
  } else {
    return authResponse; // Return the original error message from authenticateUser
  }
};

export const logout = () => {
  sessionStorage.removeItem("token"); // Clear the token from sessionStorage
};
