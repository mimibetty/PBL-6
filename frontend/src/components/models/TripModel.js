import axios from "axios";
export async function addTrip(name, month_time, duration, user_id, destination_ids) {
    try {
        // Gửi request để thêm chuyến đi mới
        const response = await axios.post(
            `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/`,
            {
                name: name,
                month_time: month_time,
                duration: duration,
                user_id: user_id,
                isAI: false,
            }
        );

        // Kiểm tra phản hồi từ server
        if (response.status === 200) {
            console.log("Tour added successfully");

            // Nhận dữ liệu từ response
            const tripData = response.data;
            const tripId = tripData.id; // Lấy ID của chuyến đi

            // Lặp qua từng destination_id để thêm vào chuyến đi
            for (const destination_id of destination_ids) {
                const addDestResponse = await addDestToTrip(tripId, destination_id);

                if (!addDestResponse.success) {
                    console.error(`Failed to add destination ${destination_id} to trip ${tripId}`);
                    return { success: false, message: `Failed to add destination ${destination_id}` };
                }
            }

            // Trả về kết quả thành công
            return { success: true, data: tripData };
        }
    } catch (error) {
        console.error("Error adding tour:", error);
        return { success: false, message: "Failed to add tour" };
    }
}

export async function addDestToTrip(trip_id, destination_id) {
    try {
        const response = await axios.post(
            `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/add_destination`,
            {
                destination_id: destination_id,
                trip_id: trip_id,
                order: 0,
                day: 0,
            }
        );

        if (response.status === 200) {
            console.log("Destination added successfully");
            return { success: true, message: "Destination added successfully" };
        }
    } catch (error) {
        console.error("Error adding destination:", error);
        return { success: false, message: "Failed to add destination" };
    }
}

export async function getTrip() {
    try {
  
      // Gửi yêu cầu để lấy danh sách tour
      const response = await axios.get(
        "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/"
      );
  
      return response.data.map((trip) => ({
        id: trip.id,
        name: trip.name,
        month_time: trip.month_time,
        duration: trip.duration,
        user_id: trip.user_id,
      }));
    } catch (error) {
      console.error("Error fetching trip:", error);
      return []; // Hoặc bạn có thể xử lý khác tùy ý
    }
  }
  export async function getTripByUserID(user_id) {
    try {
  
      // Gửi yêu cầu để lấy danh sách tour
      const response = await axios.get(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/?user_id=${user_id}`
      );
  
      return response.data.map((trip) => ({
        id: trip.id,
        name: trip.name,
        month_time: trip.month_time,
        duration: trip.duration,
        user_id: trip.user_id,
      }));
    } catch (error) {
      console.error("Error fetching trip:", error);
      return []; // Hoặc bạn có thể xử lý khác tùy ý
    }
  }

  export async function getTripByID(tripId) {
    try {
  
      // Gửi yêu cầu để lấy danh sách tour
      const response = await axios.get(
        `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/${tripId}`
      );
      const trip = response.data;
  
      return {
        id: trip.id,
        name: trip.name,
        month_time: trip.month_time,
        duration: trip.duration,
        user_id: trip.user_id,
        isAI: trip.city_id,
        trip_destinations: trip.trip_destinations,
      };
    } catch (error) {
      console.error("Error fetching trip:", error);
      return []; // Hoặc bạn có thể xử lý khác tùy ý
    }
  }

  
//   export async function addTripByAi(name, month_time, duration, user_id, thing_to_do_ids, hotel_ids, restaurant_ids) {
//     try {
//         // 1. Call API to build trip by AI
//         const buildResponse = await fetch(
//             `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/build?trip_day=${duration}`,
//             {
//                 method: 'POST',
//                 headers: {
//                     'Content-Type': 'application/json'
//                 },
//                 body: JSON.stringify({
//                     hotel_ids: hotel_ids,
//                     thingtodo_ids: thing_to_do_ids,
//                     restaurant_ids: restaurant_ids
//                 })
//             }
//         );

//         if (!buildResponse.ok) {
//             throw new Error('Failed to build trip by AI');
//         }

//         const buildData = await buildResponse.json();

//         // 2. Create the trip
//         const tripResponse = await fetch(
//             'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/',
//             {
//                 method: 'POST',
//                 headers: {
//                     'Content-Type': 'application/json'
//                 },
//                 body: JSON.stringify({
//                     name: name,
//                     month_time: month_time,
//                     duration: duration,
//                     user_id: user_id,
//                     isAI: false
//                 })
//             }
//         );

//         if (!tripResponse.ok) {
//             throw new Error('Failed to create trip');
//         }

//         const tripData = await tripResponse.json();
//         const trip_id = tripData.id;

//         // 3. Prepare destinations array
//         const destinations = [];

//         Object.entries(buildData.daily_schedule).forEach(([dayKey, destinationsList], dayIndex) => {
//             destinationsList.forEach((destination_id, order) => {
//                 // Skip last destination of each day
//                 if (order === destinationsList.length - 1) return;

//                 destinations.push({
//                     destination_id,
//                     trip_id,
//                     order,
//                     day: dayIndex + 1
//                 });
//             });
//         });

//         buildData.hotels.forEach((hotel_id, order) => {
//             destinations.push({
//                 destination_id: hotel_id,
//                 trip_id,
//                 order,
//                 day: 0
//             });
//         });

//         // 4. Add destinations
//         for (const destination of destinations) {
//             const destinationResponse = await fetch(
//                 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/add_destination',
//                 {
//                     method: 'POST',
//                     headers: {
//                         'Content-Type': 'application/json'
//                     },
//                     body: JSON.stringify(destination)
//                 }
//             );

//             if (!destinationResponse.ok) {
//                 throw new Error('Failed to add destination');
//             }
//         }

//         return { success: true, message: 'Trip created successfully', data: trip_id };
//     } catch (error) {
//         console.error('Error adding tour:', error);
//         return { success: false, message: 'Failed to add tour' };
//     }
// }
export async function addTripByAi(name, month_time, duration, user_id, thing_to_do_ids, hotel_ids, restaurant_ids) {
    try {
        // 1. Call API to build trip by AI
        const buildResponse = await fetch(
            `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/build?trip_day=${duration}`,
            {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    hotel_ids: hotel_ids,
                    thingtodo_ids: thing_to_do_ids,
                    restaurant_ids: restaurant_ids
                })
            }
        );

        if (!buildResponse.ok) {
            throw new Error('Failed to build trip by AI');
        }

        const buildData = await buildResponse.json();

        // 2. Prepare daily_schedule (remove last destination of each day) and hotels
        const listDay = {};

        // Filter daily_schedule: Remove last destination of each day
        Object.entries(buildData.daily_schedule).forEach(([dayKey, destinationsList]) => {
            // Remove the last destination for each day (if it's a duplicate)
            const filteredDestinations = destinationsList.slice(0, -1);  // Remove the last element
            listDay[dayKey] = filteredDestinations;
        });

        // Prepare list of hotels (from buildData)
        const listHotel = buildData.hotels;

        // 3. Call create-complete-trip API to create the full trip
        const createCompleteTripResponse = await fetch(
            'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/create-complete-trip',
            {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    trip_name: name,
                    month_time: month_time,
                    user_id: user_id,
                    isAI: true,
                    trip_day: duration,
                    list_day: listDay, // The filtered daily schedule
                    list_hotel: listHotel // The list of hotels
                })
            }
        );

        if (!createCompleteTripResponse.ok) {
            throw new Error('Failed to create complete trip');
        }

        const completeTripData = await createCompleteTripResponse.json();

        // Return the trip ID
        return { success: true, message: 'Trip created successfully', data: completeTripData };

    } catch (error) {
        console.error('Error adding trip:', error);
        return { success: false, message: 'Failed to add trip' };
    }
}

export async function deleteTrip(tripId) {
    try {
        // Gửi request để xóa chuyến đi
        const response = await axios.delete(
            `https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/${tripId}`
        );

        // Kiểm tra phản hồi từ server
        if (response.status === 200 || response.data === 1) {
            console.log("Trip deleted successfully");
            return { success: true, message: "Trip deleted successfully" };
        } else {
            console.error("Failed to delete trip");
            return { success: false, message: "Failed to delete trip" };
        }
    } catch (error) {
        console.error("Error deleting trip:", error);
        return { success: false, message: "Failed to delete trip" };
    }
}

  

