import SignUpModel from '../models/SignUpModel';
import router from '../../router';

class SignUpViewModel {
  constructor({ username, email, password, password_confirm }) {
    this.username = username;
    this.email = email;
    this.password = password;
    this.password_confirm = password_confirm;
  }

  async validate() {
    const signUpModel = new SignUpModel(this.username, this.email, this.password, this.password_confirm);

    if (!signUpModel.isPasswordValid()) {
      return { success: false, message: 'Confirm Password must equal Password' };
    } else {
      try {
        const result = await signUpModel.authenticate();
        // Log the result for debugging purposes
        console.log('Authentication result:', result);

        // Handle failed authentication
        if (!result.success) {
          console.error('Register failed: ', result.message);
          alert('Register failed: ' + result.message);  // Display error
          return { success: false, message: result.message };
        }

        // Handle successful authentication with name
        if (result.name) {
          console.log('Register complete, congratulations to ', result.name);

          // Display success message
          alert('Register complete, congratulations to ' + result.name + '!');
          router.push('/login');
          return { success: true, name: result.name };
        } else {
          // Handle case where the name is missing
          console.error('Authentication succeeded but user information is missing.');
          alert('Authentication succeeded but user information is missing.');
          return { success: false, message: 'User information not received' };
        }
      } catch (error) {
        console.error('An error occurred during authentication:', error);
        alert('An error occurred: ' + error.message);
        return { success: false, message: 'An error occurred' };
      }
    }
  }
}

export default SignUpViewModel;
