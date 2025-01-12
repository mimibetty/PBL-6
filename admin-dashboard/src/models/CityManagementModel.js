import axios from "axios";

export async function getCities() {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    // Gửi yêu cầu để lấy danh sách người dùng
    const response = await axios.get(
      "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/city/"
    );

    return response.data.map((city) => ({
      id: city.id,
      name: city.name,
      description: city.description,
    }));
  } catch (error) {
    console.error("Error fetching city:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}

export async function getCityById(cityID) {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    // Gửi yêu cầu để lấy danh sách người dùng
    const response = await axios.get(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/city/${cityID}`
    );

    const city = response.data;
    return {
      id: city.id,
      name: city.name,
      description: city.description,
      images: city.images,
    };
  } catch (error) {
    console.error("Error fetching city:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}

export async function updateCity(city, new_images, image_ids_to_remove) {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    const url = new URL(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/city/${city.id}`
    );
    url.searchParams.append("name", city.name);
    url.searchParams.append("description", city.description);

    let formData = null;
    if (
      (new_images && new_images.length > 0) ||
      (image_ids_to_remove && image_ids_to_remove.length > 0)
    ) {
      formData = new FormData();

      // Thêm new_images nếu có dữ liệu
      if (new_images && new_images.length > 0) {
        new_images.forEach((file) => {
          formData.append("new_images", file);
        });
      }

      // Thêm image_ids_to_remove nếu có dữ liệu
      if (image_ids_to_remove && image_ids_to_remove.length > 0) {
        image_ids_to_remove.forEach((id) => {
          formData.append("image_ids_to_remove", id);
        });
      }
    }

    // Gửi PUT request với dữ liệu từ FormData
    const response = await axios.put(url.toString(), formData || undefined, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });

    if (response.status === 200) {
      console.log("City updated successfully");
      return { success: true, message: "City updated successfully" };
    }
  } catch (error) {
    console.error("Error updating city:", error);
    return { success: false, message: "Failed to update city" };
  }
}

export async function addCity(city, images) {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    const url = new URL(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/city/`
    );
    url.searchParams.append("name", city.name);
    url.searchParams.append("description", city.description);

    let formData = null;
    if (images && images.length > 0) {
      formData = new FormData();
      images.forEach((file) => {
        formData.append("images", file);
      });
    }

    // Gửi PUT request với dữ liệu từ FormData
    const response = await axios.post(url.toString(), formData || undefined, {
      headers: {
        "Content-Type": "multipart/form-data", // Đảm bảo gửi đúng content type
      },
    });

    if (response.status === 200) {
      console.log("City add successfully");
      return { success: true, message: "City added successfully" };
    }
  } catch (error) {
    console.error("Error add city:", error);
    return { success: false, message: "Failed to added city" };
  }
}

export async function deleteCity(cityID) {
  try {
    const token = sessionStorage.getItem("token");
    if (!token) throw new Error("No token found");

    const response = await axios.delete(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/city/${cityID}`
    );

    if (response.status === 200) {
      console.log("City delete successfully");
      return { success: true, message: "City delete successfully" };
    }
  } catch (error) {
    console.error("Error deleting city:", error);
    return { success: false, message: "Failed to deleting city" };
  }
}
