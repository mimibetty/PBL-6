import axios from 'axios';

export async function getReviewByDestinationId(destinationID) {
    try {
      const response = await axios.get(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/?destination_id=${destinationID}`
      );

      return response.data.map((review) => ({ 
        id: review.id,
        title: review.title,
        content: review.content,
        rating: review.rating,
        language: review.language,
        date_create: review.date_create,
        user_id: review.user_id,
        destination_id: review.destination_id,
        images: review.images,
      }));
    } catch (error) {
      console.error("Error fetching reviews:", error);
      return []; // Hoặc bạn có thể xử lý khác tùy ý
    }
  }

  export async function getReviewById(reviewID) {
    try {
      const response = await axios.get(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/{id}?review_id=${reviewID}`
      );
      const review = response.data;
      return{ 
        id: review.id,
        title: review.title,
        content: review.content,
        rating: review.rating,
        language: review.language,
        date_create: review.date_create,
        user_id: review.user_id,
        destination_id: review.destination_id,
        companion: review.companion,
        images: review.images,
      };
    } catch (error) {
      console.error("Error fetching reviews:", error);
      return []; // Hoặc bạn có thể xử lý khác tùy ý
    }
  }

  export async function getReviewByUserID(user_id) {
    try {
      const response = await axios.get(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/?user_id=${user_id}`
      );
      return response.data.map((review) => ({ 
        id: review.id,
        title: review.title,
        content: review.content,
        rating: review.rating,
        language: review.language,
        date_create: review.date_create,
        user_id: review.user_id,
        destination_id: review.destination_id,
        tour_id: review.tour_id,
        companion: review.companion,
        images: review.images,
      }));
    } catch (error) {
      console.error("Error fetching reviews:", error);
      return []; // Hoặc bạn có thể xử lý khác tùy ý
    }
  }

  export async function addReview(title,content,rating,user_id,destination_id,language,companion,date_create, images) {
    try {
  
      const url = new URL(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/`
      );
      url.searchParams.append("title", title);
      url.searchParams.append("content", content);
      url.searchParams.append("rating", rating);
      url.searchParams.append("user_id", user_id);
      url.searchParams.append("destination_id", destination_id);
      url.searchParams.append("language", language);
      url.searchParams.append("companion", companion);
      url.searchParams.append("date_create", date_create);
  
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
        const result = response.data;
        console.log("Review created successfully", result);
        return { success: true, data: result };
      }
    } catch (error) {
      console.error(
        "Error details:",
        error.response ? error.response.data : error.message
      );
      return { success: false, message: "Failed to add review" };
    }
  }

  export async function updateReview(review, new_images, image_ids_to_remove) {
    try {
  
      const url = new URL(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/${review.id}`
      );
      url.searchParams.append("title", review.title);
      url.searchParams.append("content", review.content);
      url.searchParams.append("rating", review.rating);
      url.searchParams.append("user_id", review.user_id);
      url.searchParams.append("language", review.language);
      url.searchParams.append("companion", review.companion);
      url.searchParams.append("date_create", review.date_create);
  
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
          "Content-Type": "multipart/form-data", // Đảm bảo gửi đúng content type
        },
      });
  
      if (response.status === 200) {
        const result = response.data;
        console.log("Review update successfully", result);
        return { success: true, data: result };
      }
    } catch (error) {
      console.error(
        "Error details:",
        error ? error.detail : error.message
      );
      return { success: false, message: "Failed to add review" };
    }
  }
  export async function addImage(destination_id,image) {
    try {
  
      const url = new URL(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/image/`
      );
      url.searchParams.append('destination_id', destination_id);
  
      let formData = null;
      if (image) {
        formData = new FormData();
        formData.append('image_inp', image);
      }
  
      // Gửi PUT request với dữ liệu từ FormData
      const response = await axios.post(url.toString(), formData || undefined, {
        headers: {
          "Content-Type": "multipart/form-data", // Đảm bảo gửi đúng content type
        },
      });
  
      if (response.status === 200) {
        const result = response.data;
        console.log("Review add picture successfully", result);
        return { success: true, data: result };
      }
    } catch (error) {
      console.error(
        "Error details:",
        error.response ? error.response.data : error.message
      );
      return { success: false, message: "Failed to add review" };
    }
  }

  export async function deleteReview(reviewID) {
    try {
  
      const response = await axios.delete(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/${reviewID}`
      );
  
      if (response.status === 200) {
        console.log("Review delete successfully");
        return { success: true, message: "Review delete successfully" };
      }
    } catch (error) {
      console.error("Review deleting destination:", error);
      return { success: false, message: "Failed to deleting review" };
    }
  }

  export async function getReviewByTourId(tourID) {
    try {
      const response = await axios.get(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/?tour_id=${tourID}`
      );

      return response.data.map((review) => ({ 
        id: review.id,
        title: review.title,
        content: review.content,
        rating: review.rating,
        language: review.language,
        date_create: review.date_create,
        user_id: review.user_id,
        tour_id: review.tour_id,
        companion: review.companion,
        images: review.images,
      }));
    } catch (error) {
      console.error("Error fetching reviews:", error);
      return []; // Hoặc bạn có thể xử lý khác tùy ý
    }
  }

  export async function getReviewById_Tour(reviewID) {
    try {
      const response = await axios.get(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/{id}?review_id=${reviewID}`
      );
      const review = response.data;
      return{ 
        id: review.id,
        title: review.title,
        content: review.content,
        rating: review.rating,
        language: review.language,
        date_create: review.date_create,
        user_id: review.user_id,
        tour_id: review.tour_id,
        companion: review.companion,
        images: review.images,
      };
    } catch (error) {
      console.error("Error fetching reviews:", error);
      return []; // Hoặc bạn có thể xử lý khác tùy ý
    }
  }

  export async function addReviewForTour(title,content,rating,user_id,tour_id,language,companion,date_create, images) {
    try {
  
      const url = new URL(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/tour/`
      );
      url.searchParams.append("title", title);
      url.searchParams.append("content", content);
      url.searchParams.append("rating", rating);
      url.searchParams.append("user_id", user_id);
      url.searchParams.append("tour_id", tour_id);
      url.searchParams.append("language", language);
      url.searchParams.append("companion", companion);
      url.searchParams.append("date_create", date_create);
  
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
        const result = response.data;
        console.log("Review created successfully", result);
        return { success: true, data: result };
      }
    } catch (error) {
      console.error(
        "Error details:",
        error.response ? error.response.data : error.message
      );
      return { success: false, message: "Failed to add review" };
    }
  }