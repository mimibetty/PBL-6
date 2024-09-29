class SignUpModel {
    constructor(password, password_confirm) {
      this.password = password;
      this.password_confirm = password_confirm;
    }
  
    isPasswordValid() {
      return this.password === this.password_confirm;
    }
  }
  
  export default SignUpModel;
  