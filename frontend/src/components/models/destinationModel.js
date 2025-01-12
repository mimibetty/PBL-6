import axios from 'axios';

export async function fetchDestinationsByCity(cityId) {
  try {
    const response = await axios.get(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/?city_id=${cityId}&limit=200`);
    const filteredDestinations = response.data.filter(destination => destination.hotel_id === null && destination.restaurant_id === null);

    // Chỉ map qua các destination đã lọc
    return response.data.map(destination => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: destination.address,
      hotel_id: destination.hotel_id,
      hotel: destination.hotel,
      restaurant_id: destination.restaurant_id,
      restaurant: destination.restaurant,
      tags: destination.tags,
      images: destination.images,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : null,
      review_count: destination.review_count,
      popularity_score: destination.popularity_score,
    }));
  } catch (error) {
    console.error('Error fetching destinations:', error);
    return [];
  }
};

export async function fetchAttractions() {
  try {
    const response = await axios.get(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/?limit=200`);
    const filteredDestinations = response.data.filter(destination => destination.hotel_id === null && destination.restaurant_id === null);

    // Chỉ map qua các destination đã lọc
    return filteredDestinations.map(destination => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: destination.address,
      images: destination.images,
      hotel_id: destination.hotel_id,
      hotel: destination.hotel,
      restaurant_id: destination.restaurant_id,
      restaurant: destination.restaurant,
      tags: destination.tags,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : null,
      review_count: destination.review_count,
      popularity_score: destination.popularity_score,
    }));
  } catch (error) {
    console.error('Error fetching destinations:', error);
    return [];
  }
};

// Hàm để lấy thông tin khách sạn từ API
export async function fetchHotelsByCity(cityId) {
  try {
    // Gọi API để lấy dữ liệu khách sạn
    const response = await axios.get(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/hotel/?city_id=${cityId}`);

    // In ra dữ liệu khách sạn để kiểm tra

    return response.data.map((destination) => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: {
        city_id: destination.address.city_id,
        district: destination.address.district,
        ward: destination.address.ward,
        street: destination.address.street,
      },
      images: destination.images,
      hotel_id: destination.hotel_id,
      hotel: destination.hotel,
      restaurant_id: destination.restaurant_id,
      restaurant: destination.restaurant,
      tags: destination.tags,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : null,
      review_count: destination.review_count,
      popularity_score: destination.popularity_score,
    }));
  } catch (error) {
    // In ra lỗi nếu có
    console.error("Có lỗi xảy ra khi lấy dữ liệu chi tiết khách sạn:", error);
    return null; // Trả về null hoặc xử lý theo cách khác nếu cần
  }
};

// Hàm để lấy thông tin khách sạn từ API
export async function fetchHotels() {
  try {
    // Gọi API để lấy dữ liệu khách sạn
    const response = await axios.get(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/hotel/?is_popular=true`);

    // In ra dữ liệu khách sạn để kiểm tra
    return response.data.map((destination) => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: {
        city_id: destination.address.city_id,
        district: destination.address.district,
        ward: destination.address.ward,
        street: destination.address.street,
      },
      images: destination.images,
      hotel_id: destination.hotel_id,
      hotel: destination.hotel,
      restaurant_id: destination.restaurant_id,
      restaurant: destination.restaurant,
      tags: destination.tags,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : null,
      review_count: destination.review_count,
      popularity_score: destination.popularity_score,
    }));
  } catch (error) {
    // In ra lỗi nếu có
    console.error("Có lỗi xảy ra khi lấy dữ liệu chi tiết khách sạn:", error);
    return null; // Trả về null hoặc xử lý theo cách khác nếu cần
  }
};

export async function fetchRestaurantsByCity(cityId) {
  try {
    // Gọi API để lấy dữ liệu khách sạn
    const response = await axios.get(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/restaurant/?city_id=${cityId}&is_popular=true`);


    // In ra dữ liệu khách sạn để kiểm tra

    return response.data.map((destination) => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: {
        city_id: destination.address.city_id,
        district: destination.address.district,
        ward: destination.address.ward,
        street: destination.address.street,
      },
      images: destination.images,
      hotel_id: destination.hotel_id,
      hotel: destination.hotel,
      restaurant_id: destination.restaurant_id,
      restaurant: destination.restaurant,
      tags: destination.tags,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : null,
      review_count: destination.review_count,
      popularity_score: destination.popularity_score,
    }));
  } catch (error) {
    // In ra lỗi nếu có
    console.error("Có lỗi xảy ra khi lấy dữ liệu chi tiết nhà hàng:", error);
    return null; // Trả về null hoặc xử lý theo cách khác nếu cần
  }
};

export async function fetchRestaurants() {
  try {
    // Gọi API để lấy dữ liệu khách sạn
    const response = await axios.get(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/restaurant/?is_popular=true`);


    // In ra dữ liệu khách sạn để kiểm tra

    return response.data.map((destination) => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: {
        city_id: destination.address.city_id,
        district: destination.address.district,
        ward: destination.address.ward,
        street: destination.address.street,
      },
      images: destination.images,
      hotel_id: destination.hotel_id,
      hotel: destination.hotel,
      restaurant_id: destination.restaurant_id,
      restaurant: destination.restaurant,
      tags: destination.tags,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : null,
      review_count: destination.review_count,
      popularity_score: destination.popularity_score,
    }));
  } catch (error) {
    // In ra lỗi nếu có
    console.error("Có lỗi xảy ra khi lấy dữ liệu chi tiết nhà hàng:", error);
    return null; // Trả về null hoặc xử lý theo cách khác nếu cần
  }
};

export async function getDestinationById(destinationID) {
  try {
    const response = await axios.get(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/${destinationID}`
    );

    const destination = response.data;
    return {
      id: destination.id,
      user_id: destination.user_id,
      name: destination.name,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: {
        city_id: destination.address.city_id,
        district: destination.address.district,
        ward: destination.address.ward,
        street: destination.address.street,
      },
      images: destination.images,
      hotel_id: destination.hotel_id,
      hotel: destination.hotel,
      restaurant_id: destination.restaurant_id,
      restaurant: destination.restaurant,
      tags: destination.tags,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : null,
      review_count: destination.review_count,
      popularity_score: destination.popularity_score,
    };
  } catch (error) {
    console.error("Error fetching destination:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}

export async function getHotelById(hotelID) {
  try {
    const response = await axios.get(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/hotel/${hotelID}`
    );

    const hotel = response.data;
    return {
      id: hotel.id,
      name: hotel.name,
      user_id: hotel.user_id,
      price_bottom: hotel.price_bottom,
      price_top: hotel.price_top,
      age: hotel.age,
      opentime: hotel.opentime,
      duration: hotel.duration,
      description: hotel.description,
      date_create: hotel.date_create,
      address: hotel.address,
      images: hotel.images,
      hotel_id: hotel.hotel_id,
      hotel: hotel.hotel,
      restaurant_id: hotel.restaurant_id,
      restaurant: hotel.restaurant,
      tags: hotel.tags,
      rating: hotel.average_rating ? parseFloat(hotel.average_rating.toFixed(1)) : null,
      review_count: hotel.review_count,
      popularity_score: hotel.popularity_score,
    };
  } catch (error) {
    console.error("Error fetching hotel:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}

export async function getRestaurantById(restaurantID) {
  try {
    const response = await axios.get(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/restaurant/${restaurantID}`
    );

    const restaurant = response.data;
    return {
      id: restaurant.id,
      name: restaurant.name,
      user_id: restaurant.user_id,
      price_bottom: restaurant.price_bottom,
      price_top: restaurant.price_top,
      age: restaurant.age,
      opentime: restaurant.opentime,
      duration: restaurant.duration,
      description: restaurant.description,
      date_create: restaurant.date_create,
      address: restaurant.address,
      images: restaurant.images,
      restaurant_id: restaurant.restaurant_id,
      restaurant: restaurant.restaurant,
      tags: restaurant.tags,
      rating: restaurant.average_rating ? parseFloat(restaurant.average_rating.toFixed(1)) : null,
      review_count: restaurant.review_count,
      popularity_score: restaurant.popularity_score,
    };
  } catch (error) {
    console.error("Error fetching restaurant:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}

export async function fetchDestinations() {
  try {
    const response = await axios.get(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/?limit=40`);

    return response.data.map(destination => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: {
        city_id: destination.address.city_id,
        district: destination.address.district,
        ward: destination.address.ward,
        street: destination.address.street,
      },
      hotel_id: destination.hotel_id,
      hotel: destination.hotel,
      restaurant_id: destination.restaurant_id,
      restaurant: destination.restaurant,
      tags: destination.tags,
      images: destination.images,
      average_rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : null,
      review_count: destination.review_count,
      popularity_score: destination.popularity_score,
    }));
  } catch (error) {
    console.error('Error fetching destinations:', error);
    return [];
  }
};

export async function updateDestination(
  destination,
  new_images,
  image_ids_to_remove
) {
  try {

    // Tạo URL với các query parameters
    const url = new URL(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/${destination.id}`
    );
    url.searchParams.append("name", destination.name);
    url.searchParams.append("user_id", destination.user_id);
    url.searchParams.append("price_bottom", destination.price_bottom);
    url.searchParams.append("price_top", destination.price_top);
    url.searchParams.append("age", destination.age);
    url.searchParams.append("opentime", destination.opentime);
    url.searchParams.append("duration", destination.duration);
    url.searchParams.append("description", destination.description);
    url.searchParams.append("date_create", destination.date_create);
    url.searchParams.append("city_id", destination.address.city_id);
    url.searchParams.append("district", destination.address.district);
    url.searchParams.append("ward", destination.address.ward);
    url.searchParams.append("street", destination.address.street);

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
      console.log("Destination updated successfully");
      return {
        success: true,
        message: "Destination updated successfully"
      };
    }
  } catch (error) {
    console.error(
      "Error details:",
      error.response ? error.response.data : error.message
    );
    return {
      success: false,
      message: "Failed to update destination"
    };
  }
}

export async function addDestination(destination, images) {
  try {

    const url = new URL(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/`
    );
    url.searchParams.append("name", destination.name);
    url.searchParams.append("user_id", destination.user_id);
    url.searchParams.append("price_bottom", destination.price_bottom);
    url.searchParams.append("price_top", destination.price_top);
    url.searchParams.append("age", destination.age);
    url.searchParams.append("opentime", destination.opentime);
    url.searchParams.append("duration", destination.duration);
    url.searchParams.append("description", destination.description);
    url.searchParams.append("date_create", destination.date_create);
    url.searchParams.append("city_id", destination.address.city_id);
    url.searchParams.append("district", destination.address.district);
    url.searchParams.append("ward", destination.address.ward);
    url.searchParams.append("street", destination.address.street);

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
      const {
        id,
        name
      } = response.data;
      console.log("Destination created successfully", {
        id,
        name
      });
      return {
        id,
        name,
        success: true
      };
    }
  } catch (error) {
    console.error(
      "Error details:",
      error.response ? error.response.data : error.message
    );
    return {
      success: false,
      message: "Failed to update destination"
    };
  }
}

export async function deleteDestination(destinationID) {
  try {

    const response = await axios.delete(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/${destinationID}`
    );

    if (response.status === 200) {
      console.log("City delete successfully");
      return {
        success: true,
        message: "Destination delete successfully"
      };
    }
  } catch (error) {
    console.error("Error deleting destination:", error);
    return {
      success: false,
      message: "Failed to deleting destination"
    };
  }
}

export async function updateHotel(hotel) {
  try {

    const response = await axios.put(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/hotel/${hotel.hotel_id}`, // sử dụng user.id làm userId
      {
        property_amenities: hotel.hotel.property_amenities,
        room_features: hotel.hotel.room_features,
        room_types: hotel.hotel.room_types,
        hotel_class: hotel.hotel.hotel_class,
        hotel_styles: hotel.hotel.hotel_styles,
        Languages: hotel.hotel.Languages,
        phone: hotel.hotel.phone,
        email: hotel.hotel.email,
        website: hotel.hotel.website,
      }
    );

    if (response.status === 200) {
      console.log("Hotel updated successfully");
      return {
        success: true,
        message: "Hotel updated successfully"
      };
    }
  } catch (error) {
    console.error("Error updating hotel:", error);
    return {
      success: false,
      message: "Failed to update hotel"
    };
  }
}

export async function addHotel(hotel) {
  try {

    const response = await axios.post(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/hotel/${hotel.id}`, // sử dụng user.id làm userId
      {
        property_amenities: hotel.hotel.property_amenities,
        room_features: hotel.hotel.room_features,
        room_types: hotel.hotel.room_types,
        hotel_class: hotel.hotel.hotel_class,
        hotel_styles: hotel.hotel.hotel_styles,
        Languages: hotel.hotel.Languages,
        phone: hotel.hotel.phone,
        email: hotel.hotel.email,
        website: hotel.hotel.website,
      }
    );

    if (response.status === 200) {
      console.log("Hotel add successfully");
      return {
        success: true,
        message: "Hotel added successfully"
      };
    }
  } catch (error) {
    console.error("Error add hotel:", error);
    return {
      success: false,
      message: "Failed to added hotel"
    };
  }
}

export async function deleteHotel(hotelID) {
  try {

    const response = await axios.delete(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/hotel/${hotelID}`
    );

    if (response.status === 200) {
      console.log("Hotel delete successfully");
      return {
        success: true,
        message: "Hotel delete successfully"
      };
    }
  } catch (error) {
    console.error("Error deleting hotel:", error);
    return {
      success: false,
      message: "Failed to deleting hotel"
    };
  }
}

export async function updateRestaurant(restaurant) {
  try {

    const response = await axios.put(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/restaurant/${restaurant.restaurant_id}`, // sử dụng user.id làm userId
      {
        cuisine: restaurant.restaurant.cuisine,
        special_diet: restaurant.restaurant.special_diet,
        feature: restaurant.restaurant.feature,
        meal: restaurant.restaurant.meal,
      }
    );

    if (response.status === 200) {
      console.log("Restaurant updated successfully");
      return {
        success: true,
        message: "Restaurant updated successfully"
      };
    }
  } catch (error) {
    console.error("Error updating restaurant:", error);
    return {
      success: false,
      message: "Failed to update restaurant"
    };
  }
}

export async function addRestaurant(restaurant) {
  try {

    const response = await axios.post(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/restaurant/${restaurant.id}`, // sử dụng user.id làm userId
      {
        cuisine: restaurant.restaurant.cuisine,
        special_diet: restaurant.restaurant.special_diet,
        feature: restaurant.restaurant.feature,
        meal: restaurant.restaurant.meal,
      }
    );

    if (response.status === 200) {
      console.log("Restaurant add successfully");
      return {
        success: true,
        message: "Restaurant added successfully"
      };
    }
  } catch (error) {
    console.error("Error add restaurant:", error);
    return {
      success: false,
      message: "Failed to added restaurant"
    };
  }
}

export async function deleteRestaurant(restaurantID) {
  try {

    const response = await axios.delete(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/restaurant/${restaurantID}`
    );

    if (response.status === 200) {
      console.log("Restaurant delete successfully");
      return {
        success: true,
        message: "Restaurant delete successfully"
      };
    }
  } catch (error) {
    console.error("Error deleting Restaurant:", error);
    return {
      success: false,
      message: "Failed to deleting Restaurant"
    };
  }
}

export async function fetchRestaurantsByFilter(save_option_cuisine, save_option_meal, save_option_special_diet, save_option_feature) {
  try {
    const url = new URL(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/restaurant/?is_popular=true`
    );
    for (const cuisine of save_option_cuisine) {
      url.searchParams.append("cuisines", cuisine);
    }
    for (const meal of save_option_meal) {
      url.searchParams.append("meals", meal);
    }
    for (const special_diet of save_option_special_diet) {
      url.searchParams.append("special_diets", special_diet);
    }
    for (const feature of save_option_feature) {
      url.searchParams.append("features", feature);
    }

    const response = await axios.get(url.toString());



    // In ra dữ liệu khách sạn để kiểm tra

    return response.data.map((destination) => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: destination.address,
      images: destination.images,
      hotel_id: destination.hotel_id,
      hotel: destination.hotel,
      restaurant_id: destination.restaurant_id,
      restaurant: destination.restaurant,
      tags: destination.tags,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : null,
      numOfReviews: destination.review_count,
    }));
  } catch (error) {
    // In ra lỗi nếu có
    console.error("Có lỗi xảy ra khi lấy dữ liệu chi tiết nhà hàng:", error);
    return null; // Trả về null hoặc xử lý theo cách khác nếu cần
  }
};

export async function fetchRestaurantsByFilter_City(city_id, save_option_cuisine, save_option_meal, save_option_special_diet, save_option_feature) {
  try {
    const url = new URL(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/restaurant/?is_popular=true`
    );
    url.searchParams.append("city_id", city_id);
    for (const cuisine of save_option_cuisine) {
      url.searchParams.append("cuisines", cuisine);
    }
    for (const meal of save_option_meal) {
      url.searchParams.append("meals", meal);
    }
    for (const special_diet of save_option_special_diet) {
      url.searchParams.append("special_diets", special_diet);
    }
    for (const feature of save_option_feature) {
      url.searchParams.append("features", feature);
    }

    const response = await axios.get(url.toString());



    // In ra dữ liệu khách sạn để kiểm tra

    return response.data.map((destination) => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: destination.address,
      images: destination.images,
      hotel_id: destination.hotel_id,
      hotel: destination.hotel,
      restaurant_id: destination.restaurant_id,
      restaurant: destination.restaurant,
      tags: destination.tags,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : null,
      review_count: destination.review_count,
    }));
  } catch (error) {
    // In ra lỗi nếu có
    console.error("Có lỗi xảy ra khi lấy dữ liệu chi tiết nhà hàng:", error);
    return null; // Trả về null hoặc xử lý theo cách khác nếu cần
  }
};

export async function fetchHotelsByFilter(save_option_price_range, save_option_amenities, save_option_hotel_star) {
  try {
    const url = new URL(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/hotel/?is_popular=true`
    );
    for (const price_range of save_option_price_range) {
      url.searchParams.append("price_range", price_range);
    }
    for (const amenity of save_option_amenities) {
      url.searchParams.append("amenities", amenity);
    }
    for (const hotel_star of save_option_hotel_star) {
      url.searchParams.append("hotel_star", hotel_star);
    }

    const response = await axios.get(url.toString());



    // In ra dữ liệu khách sạn để kiểm tra

    return response.data.map((destination) => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: destination.address,
      images: destination.images,
      hotel_id: destination.hotel_id,
      hotel: destination.hotel,
      restaurant_id: destination.restaurant_id,
      restaurant: destination.restaurant,
      tags: destination.tags,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : null,
      review_count: destination.review_count,
    }));
  } catch (error) {
    // In ra lỗi nếu có
    console.error("Có lỗi xảy ra khi lấy dữ liệu chi tiết nhà hàng:", error);
    return null; // Trả về null hoặc xử lý theo cách khác nếu cần
  }
};

export async function fetchHotelsByFilter_City(city_id, save_option_price_range, save_option_amenities, save_option_hotel_star) {
  try {
    const url = new URL(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/hotel/?is_popular=true`
    );
    url.searchParams.append("city_id", city_id);
    for (const price_range of save_option_price_range) {
      url.searchParams.append("price_range", price_range);
    }
    for (const amenity of save_option_amenities) {
      url.searchParams.append("amenities", amenity);
    }
    for (const hotel_star of save_option_hotel_star) {
      url.searchParams.append("hotel_star", hotel_star);
    }

    const response = await axios.get(url.toString());



    // In ra dữ liệu khách sạn để kiểm tra

    return response.data.map((destination) => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: destination.address,
      images: destination.images,
      hotel_id: destination.hotel_id,
      hotel: destination.hotel,
      restaurant_id: destination.restaurant_id,
      restaurant: destination.restaurant,
      tags: destination.tags,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : null,
      review_count: destination.review_count,
    }));
  } catch (error) {
    // In ra lỗi nếu có
    console.error("Có lỗi xảy ra khi lấy dữ liệu chi tiết nhà hàng:", error);
    return null; // Trả về null hoặc xử lý theo cách khác nếu cần
  }
};

export async function getDestinationRatingStatic(destinationID) {
  try {
    const response = await axios.get(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/rating-distribution/${destinationID}`
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

export async function setLikeForDestination(user_id, destination_id) {
  try {
    const response = await axios.post(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/${user_id}/like/${destination_id}`)
    if (response.status === 200) {
      console.log("Destination liked successfully");
      return {
        success: true,
        message: "Destination liked successfully"
      };
    } else {
      console.log("Destination liked failed");
      return {
        success: false,
        message: "Destination liked failed"
      };
    }
  } catch (error) {
    console.error("Error liking destination:", error);
    return {
      success: false,
      message: "Failed to like destination"
    };
  }
}
export async function setUnLikeForDestination(user_id, destination_id) {
  try {
    const response = await axios.delete(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/${user_id}/unlike/${destination_id}`)
    if (response.status === 200) {
      console.log("Destination unliked successfully");
      return {
        success: true,
        message: "Destination unliked successfully"
      };
    } else {
      console.log("Destination unliked failed");
      return {
        success: false,
        message: "Destination unliked failed"
      };
    }
  } catch (error) {
    console.error("Error unliking destination:", error);
    return {
      success: false,
      message: "Failed to unlike destination"
    };
  }
}
export async function checkLikeForDestination(user_id, destination_id) {
  try {
    const response = await axios.get(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/${user_id}/has_liked/${destination_id}`
    );
    if (response.status === 200) {
      return response.data === true; // Đảm bảo response.data trả về boolean
    } else {
      console.error("Error checking like for destination:", response);
      return false; // Mặc định là false nếu API trả về trạng thái khác 200
    }
  } catch (error) {
    console.error("Error checking like for destination:", error);
    return false; // Mặc định là false nếu có lỗi
  }
}

export async function getDestinationListOfLike(user_id) {
  try {
    const response = await axios.get(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/${user_id}/likes`
    );
    if (response.status === 200) {
      return response.data;
    } else {
      console.error("Error checking like for destination:", response);
      return []; // Mặc định là false nếu API trả về trạng thái khác 200
    }
  } catch (error) {
    console.error("Error checking like for destination:", error);
    return []; // Mặc định là false nếu có lỗi
  }
}

export async function fetchDestinationsByUser(userId) {
  try {
    const response = await axios.get(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/?user_id=${userId}&is_popular=true&get_rating=true`);

    // Chỉ map qua các destination đã lọc
    return response.data.map(destination => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: destination.address,
      hotel_id: destination.hotel_id,
      hotel: destination.hotel,
      restaurant_id: destination.restaurant_id,
      restaurant: destination.restaurant,
      tags: destination.tags,
      images: destination.images,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : 0,
      review_count: destination.review_count,
    }));
  } catch (error) {
    console.error('Error fetching destinations:', error);
    return [];
  }
};
// Lấy recommend trong trang home
export async function fetchRecommendtions(userID) {
  try {
    const response = await axios.get(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/recommendations_bylikes/${userID}?limit=20`);
    return response.data.map(destination => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: destination.address,
      hotel_id: destination.hotel_id,
      hotel: destination.hotel,
      restaurant_id: destination.restaurant_id,
      restaurant: destination.restaurant,
      tags: destination.tags,
      images: destination.images,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : 0,
      review_count: destination.review_count,
    }));
  } catch (error) {
    console.error('Error fetching destinations:', error);
    return [];
  }
}
// Lấy recommend trong khu vực
export async function fetchRecommendationsByCity(userID, city_id) {
  try {
    const response = await axios.get(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/recommendations_bylikes/${userID}?city_id=${city_id}&limit=20`);
    return response.data.map(destination => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: destination.address,
      hotel_id: destination.hotel_id,
      hotel: destination.hotel,
      restaurant_id: destination.restaurant_id,
      restaurant: destination.restaurant,
      tags: destination.tags,
      images: destination.images,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : 0,
      review_count: destination.review_count,
    }));
  } catch (error) {
    console.error('Error fetching destinations:', error);
    return [];
  }
}

export async function fetchDestinationsByCity_Tag(city_id, tags) {
  try {
    const url = new URL(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/by_tags?limit=80`
    );
    url.searchParams.append("city_id", city_id);
    for (const tag of tags) {
      url.searchParams.append("tag_ids", tag);
    }

    const response = await axios.get(url.toString());



    // In ra dữ liệu khách sạn để kiểm tra

    return response.data.map((destination) => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: destination.address,
      images: destination.images,
      hotel_id: destination.hotel_id,
      restaurant_id: destination.restaurant_id,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : null,
      review_count: destination.review_count,
      popularity_score: destination.popularity_score,
    }));
  } catch (error) {
    // In ra lỗi nếu có
    console.error("Có lỗi xảy ra khi lấy dữ liệu chi tiết nhà hàng:", error);
    return null; // Trả về null hoặc xử lý theo cách khác nếu cần
  }
};

export async function fetchDestinationsByTag(tags) {
  try {
    const url = new URL(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/by_tags?limit=80`
    );
    for (const tag of tags) {
      url.searchParams.append("tag_ids", tag);
    }

    const response = await axios.get(url.toString());

    // Chỉ map qua các destination đã lọc
    return response.data.map(destination => ({
      id: destination.id,
      name: destination.name,
      user_id: destination.user_id,
      price_bottom: destination.price_bottom,
      price_top: destination.price_top,
      age: destination.age,
      opentime: destination.opentime,
      duration: destination.duration,
      description: destination.description,
      date_create: destination.date_create,
      address: {
        city_id: destination.address.city_id,
        district: destination.address.district,
        ward: destination.address.ward,
        street: destination.address.street,
      },
      hotel_id: destination.hotel_id,
      restaurant_id: destination.restaurant_id,
      tags: destination.tags,
      images: destination.images,
      rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : null,
      review_count: destination.review_count,
      popularity_score: destination.popularity_score,
    }));
  } catch (error) {
    console.error('Error fetching destinations:', error);
    return [];
  }
};

export async function getTagById(destinationID) {
  try {
    const response = await axios.get(
      `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/${destinationID}/get_tags_byid`
    );

    const final = response.data;
    return final.tags;
  } catch (error) {
    console.error("Error fetching restaurant:", error);
    return []; // Hoặc bạn có thể xử lý khác tùy ý
  }
}