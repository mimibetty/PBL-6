import axios from "axios";

export async function fetchTours() {
  try {

    // Gửi yêu cầu để lấy danh sách tour
    const response = await axios.get(
      "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tour/?is_popular=true"
    );

    return response.data.map((tour) => ({
      id: tour.id,
      name: tour.name,
      description: tour.description,
      duration: tour.duration,
      user_id: tour.user_id,
      city_id: tour.city_id,
      destinations: tour.destinations,
      rating: tour.rating,
      numOfReviews: tour.numOfReviews,
    }));
  } catch (error) {
    console.error("Error fetching hotel:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}

export async function getTourByCityId(city_id) {
  try {

    // Gửi yêu cầu để lấy danh sách tour
    const response = await axios.get(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tour/?city_id=${city_id}&is_popular=true`
    );

    return response.data.map((tour) => ({
      id: tour.id,
      name: tour.name,
      description: tour.description,
      duration: tour.duration,
      user_id: tour.user_id,
      city_id: tour.city_id,
      destinations: tour.destinations,
      rating: tour.rating,
      numOfReviews: tour.numOfReviews,
    }));
  } catch (error) {
    console.error("Error fetching hotel:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}

export async function getTourById(tourID) {
  try {

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
      rating: tour.rating,
      numOfReviews: tour.numOfReviews,
    };
  } catch (error) {
    console.error("Error fetching tour:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}

export async function getTourByUserId(userID) {
  try {

    // Gửi yêu cầu để lấy danh sách người dùng
    const response = await axios.get(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tour/?user_id=${userID}&is_popular=true`
    );

    return response.data.map((tour) => ({
      id: tour.id,
      name: tour.name,
      description: tour.description,
      duration: tour.duration,
      user_id: tour.user_id,
      city_id: tour.city_id,
      cityName: tour.cityName,
      destinations: tour.destinations,
      rating: tour.rating,
      numOfReviews: tour.numOfReviews,
    }));
  } catch (error) {
    console.error("Error fetching tour:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}

export async function updateTour(tour) {
  try {

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
    const token = sessionStorage.getItem("access_token");
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

export async function getTourRatingStatic(tourID) {
  try {
    const response = await axios.get(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tour/rating-distribution/${tourID}`
    );

    const distribution = response.data;

    return {
      Excellent: distribution["5"] || 0,
      VeryGood: distribution["4"] || 0,
      Medium: distribution["3"] || 0,
      Bad: distribution["2"] || 0,
      Terrible: distribution["1"] || 0,
    };
  } catch (error) {
    console.error("Error fetching rating distribution:", error);
    return {
      Excellent: 0,
      VeryGood: 0,
      Medium: 0,
      Bad: 0,
      Terrible: 0,
    }; // Giá trị mặc định nếu có lỗi
  }
}