import SignUpModel from '../models/SignUpModel';

class SignUpViewModel {
  constructor({ username, email, password, password_confirm }) {
    this.username = username;
    this.email = email;
    this.password = password;
    this.password_confirm = password_confirm;
  }

  validate() {
    const signUpModel = new SignUpModel(this.password, this.password_confirm);

    if (!signUpModel.isPasswordValid()) {
      return { success: false, message: 'Confirm Password must equal Password' };
    }

    // Add more validations if needed
    return { success: true };
  }
}

export default SignUpViewModel;
