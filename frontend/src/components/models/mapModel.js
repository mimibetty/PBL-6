import axios from "axios";

export async function getMap(destinationID) {
    try {
        const response = await axios.get(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/map/get-coordinates/${destinationID}`); // Thay đổi URL theo yêu cầu của bạn
        const dataMap = response.data;
        console.log("Dữ liệu map: ",dataMap);

        // Nếu dữ liệu là đối tượng, chuyển thành mảng
        if (dataMap && !Array.isArray(dataMap)) {
            return [
                {
                    location_name: dataMap.location_name,
                    latitude: dataMap.latitude,
                    longitude: dataMap.longitude,
                },
            ];
        }
        
        return dataMap.data.map((map) => ({
            location_name: map.location_name,
            latitude: map.latitude,
            longitude: map.longitude
        }));
    } catch (error) {    
        console.error("Error fetching map:", error);
        return []; // Hoặc bạn có thể xử lý lỗi khác theo nhu cầu của bạn
    }
}

