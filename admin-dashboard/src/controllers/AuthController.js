import { authenticateUser, fetchCurrentUser } from "@/models/UserModel";
import { useToast } from "vue-toastification";
import { ref } from "vue";
import { useRouter } from "vue-router";

export default function () {
  const loggedInUser = ref(null);
  const router = useRouter();
  const login = async (username, password) => {
    const authResponse = await authenticateUser(username, password);
    const toast = useToast();
    if (authResponse.success) {
      const userResponse = await fetchCurrentUser(); // Fetch user info
      if (userResponse.success) {
        if (userResponse.user.role === "admin") {
          sessionStorage.setItem("user", JSON.stringify(userResponse.user));
          loggedInUser.value = userResponse.user; // Lưu thông tin người dùng vào loggedInUser
          startInactivityTimer();
          toast.success("Login successful! Redirecting to dashboard...");
          return {
            success: true,
            token: authResponse.token,
            user: userResponse.user,
          };
        } else {
          toast.error("You do not have permission to access this system.");
          logout();
          return {
            success: false,
            message: "Do not have permission to access this system",
          };
        }
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
  let inactivityTimer;
  function startInactivityTimer() {
    // Clear any existing timer
    clearInactivityTimer();
    // Set a new timer for 10 minutes (600000 ms)
    inactivityTimer = setTimeout(() => {
      sessionStorage.removeItem("token");
      logout(); // Custom function to log the user out if necessary
    }, 600000); // 10 minutes in milliseconds
  }
  function clearInactivityTimer() {
    if (inactivityTimer) clearTimeout(inactivityTimer);
  }
  window.addEventListener("mousemove", startInactivityTimer);
  window.addEventListener("keydown", startInactivityTimer);

  const logout = () => {
    sessionStorage.removeItem("token"); // Clear the token from sessionStorage
    sessionStorage.removeItem("user"); // Clear the user data from sessionStorage
    loggedInUser.value = null; // Xóa thông tin người dùng khi logout
    router.push("/login");
  };

  return {
    login,
    logout,
    loggedInUser, // Trả về loggedInUser để sử dụng ở các thành phần khác
  };
}
