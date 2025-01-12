import axios from 'axios';
export async function fetchDestinationsByTag(tagId) {
  try {
    const response = await axios.get(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/by_tags?tag_ids=${tagId}`);

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
      popularity_score: destination.popularity_score,
    }));
  } catch (error) {
    console.error('Error fetching destinations:', error);
    return [];
  }
};