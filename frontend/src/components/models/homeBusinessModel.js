import axios from "axios";

// Lấy địa điểm của DN
export async function getDestination(userID) {
    try {
        const response = await axios.get(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/?user_id=${userID}`);
        const destinations = response.data;
        console.log("Model: ", destinations);

        return destinations.map((destination) => ({
            id: destination.id,
            name: destination.name,
            address: {
                city_id: destination.address.city_id,
                district: destination.address.district,
                ward: destination.address.ward,
                street: destination.address.street,
            },
            cityName: "Unknown", // Xử lý khi city.name là undefined
            hotel_id: destination.hotel_id,
            hotel: destination.hotel,
            restaurant_id: destination.restaurant_id,
            restaurant: destination.restaurant,
            images: destination.images,
            rating: destination.average_rating ? parseFloat(destination.average_rating.toFixed(1)) : 0,
            review_count: destination.review_count,
        }));
    } catch (error) {
        console.error("Error fetching destination:", error);
        return [];
    }
}

// Lấy tên tp theo ID
export async function getAllCities() {
    try {
        const response = await fetch(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/city/`);
        const data = await response.json();
        // Chuyển đổi dữ liệu thành định dạng có thể sử dụng trong Vue
        return data.map(city => ({
            id: city.id,
            name: city.name
        }));
    } catch (error) {
        console.error("Có lỗi xảy ra khi lấy dữ liệu chi tiết thành phố:", error);
        return null; // Return null or handle as needed
    }
}

// Lấy tổng tour, tổng destination, tổng rating
export async function fetchStatistics(userID) {
    try {
        const response = await fetch(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/dashboard/business/metrics/${userID}`);
        const data = await response.json();
        // Chuyển đổi dữ liệu thành định dạng có thể sử dụng trong Vue
        return {
            total_tours: data.total_tours,
            total_destinations: data.total_destinations,
            average_rating: data.average_rating ? parseFloat(data.average_rating.toFixed(1)) : null
        };
    } catch (error) {
        console.error("Có lỗi xảy ra khi lấy dữ liệu chi tiết thành phố:", error);
        return null; // Return null or handle as needed
    }
}

// Lấy rating 1* -> 5* trong 12 tháng cua 1 địa điểm
export async function fetchRatingByDestinationID(destinationID) {
    try {
        const response = await fetch(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/dashboard/business/stacked_review?destination_id=${destinationID}&year=2024`);

        if (!response.ok) {
            throw new Error(`Failed to fetch data: ${response.statusText}`);
        }
        const data = await response.json();
        // Chuyển đổi dữ liệu thành định dạng cần thiết
        const transformedData = Object.keys(data).map(rating => ({
            rating: parseInt(rating), // Chuyển key (rating) thành số nguyên
            count: data[rating] // Giữ lại mảng giá trị tương ứng
        }));
        return transformedData;
    } catch (error) {
        console.error("Error fetching ratings by destination ID:", error);
        return [];
    }
}