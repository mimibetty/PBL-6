import SignInModel from '../models/SignInModel';

class SignInViewModel {
  constructor({ username, password, rememberMe }) {
    this.username = username;
    this.password = password;
    this.rememberMe = rememberMe;
  }

  async validate() {
    const signInModel = new SignInModel(this.username, this.password);

    try {
      // Send API request for authentication
      const result = await signInModel.authenticate();

      // Log the result for debugging purposes
      console.log('Authentication result:', result);

      // Handle failed authentication
      if (!result.success) {
        console.error('Login failed: ', result.message);
        alert('Login failed: ' + result.message);  // Display error
        return { success: false, message: result.message };
      }

      // Handle successful authentication with a token
      if (result.token) {
        console.log('Token received:', result.token); // Log token for debugging
        if (this.rememberMe) {
          localStorage.setItem('access_token', result.token);
        } else {
          sessionStorage.setItem('access_token', result.token);
        }

        // Display success message
        alert('Login successful! Token: ' + result.token);
        return { success: true, token: result.token };
      } else {
        // Handle case where the token is missing
        console.error('Authentication succeeded but token is missing.');
        alert('Authentication succeeded but token is missing.');
        return { success: false, message: 'Token not received' };
      }

    } catch (error) {
      // Handle any unexpected errors (e.g., network issues, server errors)
      console.error('An error occurred during authentication:', error);
      alert('An error occurred: ' + error.message);
      return { success: false, message: 'An error occurred' };
    }
  }
}

export default SignInViewModel;
