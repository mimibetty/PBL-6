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
  width: 100%; /* Đảm bảo toàn bộ body chiếm hết chiều rộng */
  overflow: hidden; /* Ngăn cuộn ngang */
  box-sizing: border-box;
  }
  *, *::before, *::after {
  box-sizing: inherit; /* Đảm bảo các phần tử không vượt kích thước khung */
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
  background-attachment: fixed;
  height: 100vh; /* Đảm bảo container phủ toàn màn hình */
  width: 100vw; /* Đảm bảo chiều rộng container không tràn */
  max-width: 100vw;
  overflow: hidden; /* Ngăn cuộn bên trong container */
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
  width: 100%;
  max-width: 300px; /* Giới hạn độ rộng tối đa của form */
  padding: 0 20px; /* Thêm padding cho form trên màn hình nhỏ */
}

input, 
textarea {
  background-color: #f5f9e9;
  color: blue;
  border: 1px solid #ccc;
  padding: 10px;
  margin-bottom: 10px;
  font-size: 16px;
  border-radius: 5px;
  width: 100%; /* Đảm bảo các ô nhập chiếm toàn bộ chiều rộng */
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
  width: 100%; /* Đảm bảo các nút chiếm toàn bộ chiều rộng */
  max-width: 300px;
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
  