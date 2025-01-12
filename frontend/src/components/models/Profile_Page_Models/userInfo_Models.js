import axios from 'axios';

export default class userInfo_Models {
    constructor() {
        this.username = '';
        this.gmail = '';
        this.dateJoined = '';
        this.location = '';
        this.user_info = {};
    }

    async fetchUserInfo(token) {
        // const token = localStorage.getItem('access_token');
        console.log("Token gửi đi:", token);
        try {
            console.log("Token 1 gửi đi:", token);
            // Gửi yêu cầu GET đến endpoint với token trong header
            const response = await axios.get(
                'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/current-user',
                {
                    headers: {
                        'Accept': 'application/json', // Yêu cầu server trả về dữ liệu JSON
                        'Authorization': `Bearer ${token}` // Gửi token xác thực
                    }
                }
            );
            // Log phản hồi từ server
            console.log("Phản hồi từ server:", response);
    
            // Dữ liệu trả về từ server
            const data = response.data;
    
            // Gán dữ liệu vào đối tượng
            this.username = data.username;
            this.gmail = data.email; // Thay đổi theo format API nếu cần
            this.dateJoined = data.dateJoined;
            this.location = data.location;
            this.user_info = data.user_info;
    
            return {
                username: this.username,
                gmail: this.gmail,
                dateJoined: this.dateJoined,
                location: this.location,
                user_info: this.user_info
            };
        } catch (error) {
            console.error('Lỗi khi lấy thông tin user:', error);
    
            // Xử lý lỗi từ server hoặc mạng
            if (error.response) {
                // Lỗi từ server (ví dụ: 401 Unauthorized)
                console.error(`Lỗi từ server: ${error.response.status} - ${error.response.statusText}`);
                console.error("Chi tiết lỗi từ server:", error.response.data);
            } else {
                // Lỗi khác (ví dụ: kết nối mạng)
                console.error('Lỗi không kết nối được server:', error.message);
            }
    
            return null;
        }
    }
}