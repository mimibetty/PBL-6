import axios from "axios";


const vietnamRegions = {
    "Hà Nội": "Northern Vietnam",
    "Hà Giang": "Northern Vietnam",
    "Cao Bằng": "Northern Vietnam",
    "Bắc Kạn": "Northern Vietnam",
    "Tuyên Quang": "Northern Vietnam",
    "Lào Cai": "Northern Vietnam",
    "Điện Biên": "Northern Vietnam",
    "Lai Châu": "Northern Vietnam",
    "Sơn La": "Northern Vietnam",
    "Yên Bái": "Northern Vietnam",
    "Hòa Bình": "Northern Vietnam",
    "Thái Nguyên": "Northern Vietnam",
    "Lạng Sơn": "Northern Vietnam",
    "Quảng Ninh": "Northern Vietnam",
    "Bắc Giang": "Northern Vietnam",
    "Phú Thọ": "Northern Vietnam",
    "Vĩnh Phúc": "Northern Vietnam",
    "Bắc Ninh": "Northern Vietnam",
    "Hải Dương": "Northern Vietnam",
    "Hải Phòng": "Northern Vietnam",
    "Hưng Yên": "Northern Vietnam",
    "Thái Bình": "Northern Vietnam",
    "Nam Định": "Northern Vietnam",
    "Ninh Bình": "Northern Vietnam",
    "Thanh Hóa": "North Central Vietnam",
    "Nghệ An": "North Central Vietnam",
    "Hà Tĩnh": "North Central Vietnam",
    "Quảng Bình": "Central Vietnam",
    "Quảng Trị": "Central Vietnam",
    "Thừa Thiên Huế": "Central Vietnam",
    "Đà Nẵng": "Central Vietnam",
    "Quảng Nam": "Central Vietnam",
    "Quảng Ngãi": "Central Vietnam",
    "Bình Định": "Central Vietnam",
    "Phú Yên": "Central Vietnam",
    "Khánh Hòa": "Central Vietnam",
    "Ninh Thuận": "Central Vietnam",
    "Bình Thuận": "Central Vietnam",
    "Kon Tum": "Central Vietnam",  
    "Gia Lai": "Central Vietnam",  
    "Đắk Lắk": "Central Vietnam",  
    "Đắk Nông": "Central Vietnam", 
    "Lâm Đồng": "Central Vietnam", 
    "TP Hồ Chí Minh": "Southern Vietnam",
    "Bà Rịa - Vũng Tàu": "Southern Vietnam",
    "Bình Dương": "Southern Vietnam",
    "Bình Phước": "Southern Vietnam",
    "Đồng Nai": "Southern Vietnam",
    "Tây Ninh": "Southern Vietnam",
    "An Giang": "Southern Vietnam",
    "Bạc Liêu": "Southern Vietnam",
    "Bến Tre": "Southern Vietnam",
    "Cà Mau": "Southern Vietnam",
    "Cần Thơ": "Southern Vietnam",
    "Đồng Tháp": "Southern Vietnam",
    "Hậu Giang": "Southern Vietnam",
    "Kiên Giang": "Southern Vietnam",
    "Long An": "Southern Vietnam",
    "Sóc Trăng": "Southern Vietnam",
    "Tiền Giang": "Southern Vietnam",
    "Trà Vinh": "Southern Vietnam",
    "Vĩnh Long": "Southern Vietnam"
  };

  export async function fetchCities() {
    try {
  
      // Gửi yêu cầu để lấy danh sách người dùng
      const response = await axios.get(
        "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/city/"
      );
  
      return response.data.map((city) => ({
        id: city.id,
        name: city.name,
        description: city.description,
        images: city.images.map(image => image.url),
        region: vietnamRegions[city.name] || "Unknown Region"
      }));
    } catch (error) {
      console.error("Error fetching city:", error);
      return []; // Hoặc bạn có thể xử lý khác tùy ý
    }
  }
  export async function fetchCityDetails(cityId){
    try {
      const response = await fetch(`https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/city/${cityId}`);
      const data = await response.json();
      // Chuyển đổi dữ liệu thành định dạng có thể sử dụng trong Vue
      return {
        id: data.id,
        name: data.name,
        description: data.description,
        images: data.images
      };
    } catch (error) {
      console.error("Có lỗi xảy ra khi lấy dữ liệu chi tiết thành phố:", error);
      return null; // Return null or handle as needed
    }
  };