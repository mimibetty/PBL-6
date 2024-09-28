class SignInModel {
    constructor(username, password) {
      this.username = username;
      this.password = password;
    }
  
    isValid() {
      // Logic kiểm tra tài khoản và mật khẩu (ở đây kiểm tra giả lập)
      return this.username === 'a111' && this.password === 'a111';
    }
  }
  
  export default SignInModel;
  