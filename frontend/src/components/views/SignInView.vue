<template>
    <div class="login-container">
      <h2 class="title">Sign in</h2>
      <p>Have an account?</p>
      <form @submit.prevent="handleSignIn">
        <input
          type="text"
          v-model="username"
          placeholder="Username"
          required
        />
        <input
          type="password"
          v-model="password"
          placeholder="Password"
          required
        />
        <button type="submit">Sign in</button>
      </form>
      <button class="google-signin">
        <img src="../pictures/GoogleLogo.jpg" alt="Google Logo" class="google-logo" />
        Or join with Google
      </button>
      <div class="options">
        <label>
          <input type="checkbox" v-model="rememberMe" />
          Remember me
        </label>
        <a href="#">Forgot password</a>
      </div>
      <p>
        Don’t have an account? <router-link to="/sign-up">Sign up here</router-link>
      </p>
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
        const result = signInVM.validate();
        if (result.success) {
          alert('Sign in successfully');
        } else {
          alert(result.message);
        }
      },
    },
  };
  </script>
  
  <style scoped>
  html, body {
    margin: 0;
    padding: 0;
    height: 100%;
  }
  
  .login-container {
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background-image: url('../pictures/background.jpg');
    background-size: cover;
    background-position: center;
    height: 100vh; /* Full viewport height */
    width: 100vw; /* Full viewport width */
}

.login-container::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.45); /* Màu đen với độ mờ 50% */
    z-index: 1; /* Đặt lớp phủ lên trên hình nền */
}

.login-container > * {
    position: relative; /* Để văn bản nổi lên trên lớp phủ */
    z-index: 2; /* Đặt văn bản lên trên lớp phủ */
    color: #ffffff; /* Màu chữ */
}
  
  .title {
    color: #6698f0; /* Blue color for the title */
  }
  
  form {
    display: flex;
    flex-direction: column;
    width: 300px;
}

input, 
textarea { /* Áp dụng cho tất cả các ô nhập và textarea */
    background-color: #f5f9e9; /* Màu nền vàng */
    color: blue; /* Màu chữ xanh dương */
    border: 1px solid #ccc; /* Thêm viền để ô nhập nổi bật hơn */
    padding: 10px; /* Thêm khoảng cách bên trong */
    margin-bottom: 10px; /* Khoảng cách giữa các ô nhập */
    font-size: 16px; /* Kích thước chữ */
    border-radius: 5px; /* Bo tròn góc ô nhập */
}

input::placeholder, 
textarea::placeholder { /* Để đặt màu chữ cho placeholder */
    color: blue; /* Màu chữ placeholder cũng là xanh dương */
    opacity: 0.7; /* Độ mờ cho placeholder */
}
  
  button {
    margin: 10px 0;
    padding: 10px;
    border-radius: 5px;
    border: none;
    background-color: #0044cc;
    color: #fff;
    cursor: pointer;
  }
  
  .google-signin {
    display: flex;
    align-items: center;
    background-color: #db4437;
    padding: 10px;
  }
  
  .google-logo {
    width: 20px;
    margin-right: 10px;
  }
  
  .options {
    display: flex;
    justify-content: space-between;
    width: 300px;
  }
  
  a {
    color: #fff;
    text-decoration: underline;
    cursor: pointer;
  }
  </style>
  