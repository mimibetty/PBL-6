import SignInModel from '../models/SignInModel';

class SignInViewModel {
  constructor({ username, password, rememberMe }) {
    this.username = username;
    this.password = password;
    this.rememberMe = rememberMe;
  }

  validate() {
    const signInModel = new SignInModel(this.username, this.password);

    if (!signInModel.isValid()) {
      return { success: false, message: 'Invalid username or password' };
    }

    // Nếu cần thêm các logic khác, có thể thực hiện tại đây
    return { success: true };
  }
}

export default SignInViewModel;
