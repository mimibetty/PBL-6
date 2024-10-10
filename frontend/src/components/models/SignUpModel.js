import axios from 'axios';

class SignUpModel {
  constructor(username, email, password, password_confirm) {
    this.username = username;
    this.email = email;
    this.password = password;
    this.password_confirm = password_confirm;
  }

  isPasswordValid() {
    return this.password === this.password_confirm;
  }

  async authenticate() {
    try {
      const data = {
        username: this.username,
        password: this.password,
        email: this.email
      };
      const response = await axios.post('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/', data, {
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (response.data && response.data.username) {
        return { success: true, name: response.data.username };  // Assuming name is returned
      } else {
        return { success: false, message: 'Failed to register account' };
      }
    } catch (error) {
      if (error.response && error.response.status === 422) {
        return { success: false, message: 'Invalid data' };
      } else {
        return { success: false, message: 'An error occurred' };
      }
    }
  }
}

export default SignUpModel;
