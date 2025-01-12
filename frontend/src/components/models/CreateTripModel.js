import axios from 'axios';

export default function () {
  
  const heartFull = new URL('@/assets/svg/heart-full.svg', import.meta.url).href;
  const heartEmpty = new URL('@/assets/svg/heart-none.svg', import.meta.url).href;
  
  const fetchCities = async () => {
    try {
      const response = await axios.get(
        "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/city/"
      );
      return response.data.map(city => ({
        id: city.id,
        name: city.name,
        location: city.location,
        reviewNumber: city.reviewNumber,
        rating: city.rating,
        images: city.images.map(image => image.url),
      }));
    } catch (error) {
      console.error("Có lỗi xảy ra khi lấy dữ liệu thành phố:", error);
      return []; // Return an empty array or handle as needed
    }
  }
  const fetchTags = async () => {
    try {
      const response = await axios.get(
        "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tag/"
      );
      return response.data.map(tag => ({
        id: tag.id,
        name: tag.name,
      }));
    } catch (error) {
      console.error("Có lỗi xảy ra khi lấy dữ liệu thành phố:", error);
      return []; // Return an empty array or handle as needed
    }
  }
  // const fetchEntertainments = async () => {
  //   try {
  //     const response = await axios.get('http://localhost:3000/entertainments');
  //     return response.data.map(entertainment => ({
  //       id: entertainment.id,
  //       name: entertainment.name,
  //       reviewNumber: entertainment.reviewNumber,
  //       tag: entertainment.tag,
  //       rating: entertainment.rating,
  //       description: entertainment.description,
  //       imageUrl: entertainment.imageUrl,
  //       destinationType: entertainment.destinationType,
  //     }));
  //   } catch (error) {
  //     console.error('Error fetching entertainments:', error);
  //     return [];
  //   }
  // };
  const generateStars = (rating) => {
    const fullCircle = new URL('@/assets/svg/star_full.svg', import.meta.url).href;
    const halfCircle = new URL('@/assets/svg/star_half.svg', import.meta.url).href;
    const emptyCircle = new URL('@/assets/svg/star_none.svg', import.meta.url).href;

    let circles = [];
    for (let i = 1; i <= 5; i++) {
        if (rating >= i) {
        circles.push(fullCircle);
        } else if ((rating > i - 1 && rating - i + 1 >= 0.5) && rating < i) {
            circles.push(halfCircle);
        } else {
            circles.push(emptyCircle);
        }
    }
    return circles;
  };
  
  return {
    heartFull,
    heartEmpty,
    fetchCities,
    fetchTags,
    generateStars
  };
}

// Dùng để chọn thêm vào tạo tour = đã like
export async function setLikeForDestination(user_id, destination_id){
  try{
    const response = await axios.post(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/${user_id}/like/${destination_id}`)
    if(response.status === 200){
      console.log("Destination liked successfully");
      return { success: true, message: "Destination liked successfully" };
    }
    else {
      console.log("Destination liked failed");
      return { success: false, message: "Destination liked failed" };
    }
  } catch (error) {
    console.error("Error liking destination:", error);
    return { success: false, message: "Failed to like destination" };
  }
}
// Dùng để chọn bỏ khỏi tạo tour = unlike
export async function setUnLikeForDestination(user_id, destination_id){
  try{
    const response = await axios.delete(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/${user_id}/unlike/${destination_id}`)
    if(response.status === 200){
      console.log("Destination unliked successfully");
      return { success: true, message: "Destination unliked successfully" };
    }
    else {
      console.log("Destination unliked failed");
      return { success: false, message: "Destination unliked failed" };
    }
  } catch (error) {
    console.error("Error unliking destination:", error);
    return { success: false, message: "Failed to unlike destination" };
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

export async function fetchDestinationsByCity(cityId) {
  try {
    const response = await axios.get(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/?city_id=${cityId}&is_popular=true&get_rating=true`);
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
      rating: destination.rating ? parseFloat(destination.rating.toFixed(1)) : null,
      numOfReviews: destination.numOfReviews,
    }));
  } catch (error) {
    console.error('Error fetching destinations:', error);
    return [];
  }
};
// Thêm tour
export async function addTour(tripStore) {
  try {
    console.log("Name",tripStore.name);
    console.log("Description",tripStore.description);
    console.log("User ID",tripStore.userId);
    console.log("City ID",tripStore.selectedDestination.id);
    console.log("Destination IDS:",tripStore.ids_destination);

    const response = await axios.post(
      'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/tour/',
      {
        name: tripStore.name,
        description: tripStore.description,
        user_id: tripStore.userId,
        city_id: tripStore.selectedDestination.id,
        destination_ids: tripStore.ids_destination,
      }
    );
    console.log("Data",response.data);
    if (response.status === 200) {
      const { id } = response.data; // Lấy id từ response
      console.log("Tour added successfully");
      return { success: true, message: "Tour added successfully", id };
    }
  } catch (error) {
    console.error("Error add hotel:", error);
    return { success: false, message: "Failed to added tour" };
  }
}