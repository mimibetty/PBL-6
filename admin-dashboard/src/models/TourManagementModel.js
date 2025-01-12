import axios from "axios";

export async function getTours() {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    // Gửi yêu cầu để lấy danh sách người dùng
    const response = await axios.get(
      "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tour/"
    );

    return response.data.map((tour) => ({
      id: tour.id,
      name: tour.name,
      description: tour.description,
      duration: tour.duration,
      user_id: tour.user_id,
      city_id: tour.city_id,
      destinations: tour.destinations,
    }));
  } catch (error) {
    console.error("Error fetching hotel:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}

export async function getTourById(tourID) {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    // Gửi yêu cầu để lấy danh sách người dùng
    const response = await axios.get(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tour/${tourID}`
    );

    const tour = response.data;
    return {
      id: tour.id,
      name: tour.name,
      description: tour.description,
      duration: tour.duration,
      user_id: tour.user_id,
      city_id: tour.city_id,
      destinations: tour.destinations,
    };
  } catch (error) {
    console.error("Error fetching tour:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}

export async function updateTour(tour) {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    const response = await axios.put(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tour/${tour.id}`, // sử dụng user.id làm userId
      {
        name: tour.name,
        description: tour.description,
        user_id: tour.user_id,
        city_id: tour.city_id,
        destination_ids: tour.destination_ids,
      }
    );

    if (response.status === 200) {
      console.log("Tour updated successfully");
      return { success: true, message: "Tour updated successfully" };
    }
  } catch (error) {
    console.error("Error updating tour:", error);
    return { success: false, message: "Failed to update tour" };
  }
}

export async function addTour(tour) {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    const response = await axios.post(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tour/`, // sử dụng user.id làm userId
      {
        name: tour.name,
        description: tour.description,
        user_id: tour.user_id,
        city_id: tour.city_id,
        destination_ids: tour.destination_ids,
      }
    );

    if (response.status === 200) {
      console.log("Tour add successfully");
      return { success: true, message: "Tour added successfully" };
    }
  } catch (error) {
    console.error("Error add tour:", error);
    return { success: false, message: "Failed to added tour" };
  }
}

export async function deleteTour(tourID) {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    const response = await axios.delete(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tour/${tourID}`
    );

    if (response.status === 200) {
      console.log("Tour delete successfully");
      return { success: true, message: "Tour delete successfully" };
    }
  } catch (error) {
    console.error("Error deleting tour:", error);
    return { success: false, message: "Failed to deleting tour" };
  }
}

export async function getDestination() {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    // Gửi yêu cầu để lấy danh sách người dùng
    const response = await axios.get(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/`
    );

    return response.data.map((destination) => ({
      id: destination.id,
      name: destination.name,
    }));
  } catch (error) {
    console.error("Error fetching destination:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}
