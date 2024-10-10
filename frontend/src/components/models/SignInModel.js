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

      if (response.data && response.data.access_token) {
        return { success: true, token: response.data.access_token };
      } else {
        return { success: false, message: 'Token not received' };
      }
    } catch (error) {
      if (error.response && error.response.status === 404) {
        return { success: false, message: 'Invalid username or password' };
      } else {
        return { success: false, message: 'An error occurred' };
      }
    }
  }
}

export default SignInModel;

