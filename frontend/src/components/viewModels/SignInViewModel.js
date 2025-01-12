import SignInModel from '../models/SignInModel';
import router from '../../router';

class SignInViewModel {
  constructor({ username, password, rememberMe }) {
    this.username = username;
    this.password = password;
    this.rememberMe = rememberMe;
  }

  async validate() {
    const signInModel = new SignInModel(this.username, this.password);
    
    try {
      const result = await signInModel.authenticate();

      if (!result.success) {
        alert(`Login failed: ${result.message}`);
        return { success: false, message: result.message };
      }

      if (result.token) {
        if (this.rememberMe) {
          localStorage.setItem('access_token', result.token);
        } else {
          sessionStorage.setItem('access_token', result.token);
        }

        // Fetch user data with the token
        const userResult = await signInModel.fetchCurrentUser(result.token);

        if (userResult.success) {
          console.log('User role:', userResult.user);
          sessionStorage.setItem('role', userResult.user.role);
          if(userResult.user.role === 'business') {
            router.push('/Business');
          }
          else{
            router.push('/home');
          }
        } else {
          console.error('Failed to fetch user data:', userResult.message);
        }

        return { success: true };
      } else {
        console.error('Token not received.');
        return { success: false, message: 'Token not received' };
      }
    } catch (error) {
      console.error('An error occurred during authentication:', error);
      return { success: false, message: error.message || 'An error occurred' };
    }
  }
}

export default SignInViewModel;
