import axios from 'axios';

class SignInModel {
  constructor(username, password) {
    this.username = username;
    this.password = password;
  }

  async authenticate() {
    try {
      const response = await axios.post('http://127.0.0.1:8000/token', {
        username: this.username,
        password: this.password,
      });
      return { success: true, token: response.data.access_token };
    } catch (error) {
      if (error.response && error.response.status === 401) {
        return { success: false, message: 'Invalid username or password' };
      } else {
        return { success: false, message: 'An error occurred' };
      }
    }
  }
}

export default SignInModel;
