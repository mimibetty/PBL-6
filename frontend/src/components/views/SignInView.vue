<template>
  <div class="login-container">

  </div>
  <div class="container container-fluid row-cols-1" style="z-index: 1000;">
    <form @submit.prevent="handleSignIn">
      
      <!-- Sign in Title -->
      <h2 class="title">Sign in</h2>
      <p>Have an account?</p>
      
      <!-- Sign in form -->
      <input type="email" v-model="username"
        placeholder="Email" required />
      <input type="password" v-model="password"
        placeholder="Password" required />

      <!-- Sign in button -->
      <button type="submit">Sign in</button>

      <!-- Options -->
      <div class="options">
        <label class="custom-checkbox">
          <input type="checkbox" v-model="rememberMe" />
          <span class="checkbox"></span>
          Remember me
        </label>
        <button class="forgot-password">Forgot password</button>
      </div>
      <h5 style="color: #EDF6F9">
        Don’t have an account? <router-link class="sign-up-link" to="/sign-up">Sign up here</router-link>
      </h5>
    </form>
  </div>
</template>

<script>
import SignInViewModel from '../viewModels/SignInViewModel';

export default {
  data() {
    return {
      username: '',
      password: '',
      rememberMe: false,
    };
  },
  methods: {
    handleSignIn() {
      const signInVM = new SignInViewModel({
        username: this.username,
        password: this.password,
        rememberMe: this.rememberMe,
      });
      signInVM.validate();
    },
  },
};
</script>

<style scoped>
html, body {
  margin: 0;
  padding: 0;
  height: 100%;
  width: 100%;
  overflow: hidden;
  box-sizing: border-box;
}

*, *::before, *::after {
  box-sizing: inherit;
}

.login-container {
  font-family: 'Roboto';
  position: absolute;
  top : 0;
  left : 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background-image: url('@/assets/images/frame_bg.png');
  background-size: cover;
  background-position: center 0%;
  height: 100%;
  width: 100%;
  text-align: center;  
}

.login-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(39, 45, 45, 0.48);
}

.login-container > * {
  position: absolute;
  top: 0px;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 2;
  color: #EDF6F9;
}

.container {
  position: absolute;
  top: calc(10% + 10px); /* Đảm bảo khoảng cách tương đối với viewport */
  left: 20%; /* Cách phải 20% */
  max-width: 400px;
  width: 100%;
  text-align: center;
}
/* Responsive cho màn hình nhỏ */
@media (max-width: 768px) {
  .container {
    top: 50%; /* Đưa form vào giữa chiều dọc */
    left: 50%; /* Đưa form vào giữa chiều ngang */
    right: auto; /* Xóa định nghĩa right */
    transform: translate(-50%, -50%); /* Căn chính xác giữa màn hình */
    max-width: 90%; /* Đảm bảo form không vượt quá chiều ngang màn hình */
  }
}

/* Điều chỉnh cho màn hình rất lớn hoặc scale cao */
@media (min-height: 1400px) and (min-width: 2560px) {
  .container {
    top: calc(10% + 50px); /* Giảm khoảng cách top để phù hợp với scale */
    right: 15%; /* Cách phải 15% để giữ sự cân đối */
  }
}

.title {
  color: #EDF6F9;
  font-weight: bold;
}

form {
  display: flex;
  flex-direction: column;
  width: 100%;
  max-width: 400px;
  margin: 0 auto;
  z-index: 0;
}

input {
  background-color: #EDF6F9;
  color: #13357B;
  border: 1px solid #EDF6F9;
  padding: 10px 10px 10px 20px;
  margin-bottom: 10px;
  margin-top: 10px;
  font-size: 1rem;
  border-radius: 40px;
  width: 100%;
  outline: none;
}

input:hover {
  outline: none;
  background-color: #caf0f8;
  color: #13357B;
  border: 1px solid #caf0f8;
}

input:focus {
  outline: none;
  background-color: #caf0f8;
  color: #023e8a;
  border: 1px solid #caf0f8;
}

input::placeholder { /* Để đặt màu chữ cho placeholder */
    color: #13357B;
}

button {
  margin: 10px 0;
  padding: 10px;
  border-radius: 40px;
  border: none;
  align-items: center;
  justify-content: center;
  background-color: #13357B;
  color: #EDF6F9;
  cursor: pointer;
  font-size: 1rem;
  width: 100%;
}  

button:hover {
  background-color: #caf0f8;
  color: #13357B;
}

button:pressed {
  background-color: #13357B;
  color: #caf0f8;
}

.google-signin-container {
  display: flex;
  align-items: center; /* Canh giữa theo chiều dọc */
  position: relative;
}

.google-signin {
  width: 100%;
  background-color: #F64135;
  padding-left: 50px;
}

.google-logo {
  background-color: #EDF6F9;
  border-radius: 50%;
  padding: 5px;
  position: absolute;
  width: 30px;
  height: 30px;
  margin-left: 6px;
}

.options {
  display: flex; /* Sử dụng Flexbox để đặt tất cả phần tử trên cùng một hàng */
  align-items: center; /* Căn giữa các phần tử theo chiều dọc */
  justify-content: space-between; /* Tạo khoảng cách giữa checkbox và link */
  width: 100%;
  max-width: 400px; /* Đảm bảo chiều rộng tối đa cho container */
  margin: 0 auto; /* Căn giữa trong bố cục */
  padding: 10px 0; /* Thêm khoảng đệm trên và dưới */
}

.custom-checkbox {
  display: flex; /* Sử dụng Flexbox để căn chỉnh checkbox và text */
  align-items: center; /* Căn giữa checkbox và văn bản theo chiều dọc */
  color: #EDF6F9
}

input[type="checkbox"] {
  display: none; /* Ẩn checkbox gốc */
}

.checkbox {
  width: 20px; /* Kích thước của checkbox */
  height: 20px; /* Kích thước của checkbox */
  border: 2px solid #EDF6F9; /* Màu viền */
  border-radius: 5px; /* Bo tròn góc checkbox */
  background-color: #EDF6F9; /* Màu nền */
  margin-right: 5px; /* Khoảng cách giữa checkbox và văn bản */
  cursor: pointer; /* Con trỏ tay khi di chuột lên checkbox */
  position: relative; /* Định vị cho pseudo-element */
}

input[type="checkbox"]:checked + .checkbox {
  border: 2px solid #13357B; /* Màu viền */
  background-color: #13357B; /* Màu nền khi được chọn */
}

.checkbox::after {
  content: ''; /* Pseudo-element cho dấu kiểm */
  position: absolute;
  left: 6px; /* Định vị dấu kiểm */
  top: 2px; /* Định vị dấu kiểm */
  width: 5px; /* Kích thước dấu kiểm */
  height: 10px; /* Kích thước dấu kiểm */
  border: solid #EDF6F9; /* Màu dấu kiểm */
  border-width: 0 2px 2px 0; /* Hình dáng dấu kiểm */
  transform: rotate(45deg); /* Xoay dấu kiểm */
  opacity: 0; /* Ẩn dấu kiểm khi không được chọn */
}

input[type="checkbox"]:checked + .checkbox::after {
  opacity: 1; /* Hiện dấu kiểm khi được chọn */
}

a {
  color: #EDF6F9;
  text-decoration: underline;
  cursor: pointer;
}
p {
  color: #EDF6F9;
}

.forgot-password {
  color: #EDF6F9;
  text-decoration: underline;
  cursor: pointer;
  background-color: transparent;
  border: none;
  margin: 10px 0;
  padding: 10px 0px;
  border-radius: 15px;
  width :150px;
}
.forgot-password:hover{
  border-radius: 15px;
}
.sign-up-link{
  font-size:20px;
  color: #EDF6F9;
  text-decoration: underline;
  cursor: pointer;
  background-color: transparent;
  border: none;
  margin: 10px 10px;
  padding: 10px 10px;
  border-radius: 10px;
}
.sign-up-link:hover{
  color: #13357B;
  text-decoration: underline;
  cursor: pointer;
  background-color: #caf0f8;
  border: none;
  margin: 10px 10;
  padding: 10px 10px;
  border-radius: 10px;
}
</style>
