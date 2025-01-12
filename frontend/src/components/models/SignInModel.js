import axios from 'axios';


class SignInModel {
  constructor(username, password) {
    this.username = username;
    this.password = password;
  }

  async authenticate() {
    try {
      const data = new URLSearchParams();
      data.append('username', this.username);
      data.append('password', this.password);

      const response = await axios.post('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/login', data, {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      });
      console.log('phan hoi',response);
      if (response.data && response.data.access_token) {
        return { success: true, token: response.data.access_token };
      } else {
        return { success: false, message: 'Token not received' };
      }
    } catch (error) {
      if (error.response && error.response.status === 404) {
        const errorMessage = error.response.data.detail || 'Invalid username or password'; // Lấy thông báo từ API
        return { success: false, message: errorMessage };
      } else {
        return { success: false, message: 'An error occurred' };
      }
    }
  }
  async fetchCurrentUser(token) {
    try {
      const response = await axios.get('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/current-user', {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });
      
      // Check if the response has user data
      if (response.data) {
        return { success: true, user: response.data };
      } else {
        return { success: false, message: 'User data not received' };
      }
    } catch (error) {
      console.error('Failed to fetch user data:', error);
      return { success: false, message: 'Failed to fetch user data' };
    }
  }
}

export default SignInModel;
