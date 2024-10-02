import SignInModel from '../models/SignInModel';

class SignInViewModel {
  constructor({ username, password, rememberMe }) {
    this.username = username;
    this.password = password;
    this.rememberMe = rememberMe;
  }

  async validate() {
    const signInModel = new SignInModel(this.username, this.password);

    // Gửi yêu cầu xác thực qua API
    const result = await signInModel.authenticate();

    if (!result.success) {
      return { success: false, message: result.message };
    }

    // Lưu token nếu đăng nhập thành công (tuỳ thuộc vào yêu cầu của bạn)
    if (this.rememberMe) {
      localStorage.setItem('access_token', result.token);
    } else {
      sessionStorage.setItem('access_token', result.token);
    }

    // Hiển thị token trong thông báo (hoặc bất kỳ hành động nào khác)
    alert('Login successful! Token: ' + result.token);
    
    return { success: true, token: result.token };
  }
}

export default SignInViewModel;
