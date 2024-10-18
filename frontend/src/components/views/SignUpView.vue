<template>
    <div class="signup-container">
      <form @submit.prevent="handleSignUp">
        
        <!-- Sign up Title -->
        <h2 class="title">Sign up</h2>
        
        <!-- Sign up form -->
        <input type="text" v-model="username"
          placeholder="Username" required />
        <input type="email" v-model="email"
          placeholder="Email" required/>
          <input type="password" v-model="password"
          placeholder="Password" required/>
        <input type="password" v-model="password_confirm"
          placeholder="Confirm Password" required />

        <!-- Sign up button -->
        <button type="submit">Sign up</button>

        <!-- Options -->
        <p>
          Already have an account? <router-link to="/login">Sign in here</router-link>
        </p>
    
      </form>
    </div>
  </template>
  
  <script>
  import SignUpViewModel from '../viewModels/SignUpViewModel';
  
  export default {
    data() {
      return {
        username: '',
        email: '',
        password: '',
        password_confirm: '',
      };
    },
    methods: {
      handleSignUp() {
        const signUpVM = new SignUpViewModel({
          username: this.username,
          email: this.email,
          password: this.password,
          password_confirm: this.password_confirm
        });
        const result = signUpVM.validate();
        if (result.success) {
          alert('Sign up successfully');
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
  
.signup-container {
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
  height: 100vh;
  width: 100vw;
  max-width: 100vw;
  padding: 50px;
  text-align: center;
} 

.signup-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(39, 45, 45, 0.48);
  z-index: 1; /* Đặt lớp phủ lên trên hình nền */
}

.signup-container > * {
  position: relative; /* Để văn bản nổi lên trên lớp phủ */
  z-index: 2; /* Đặt văn bản lên trên lớp phủ */
  color: #EDF6F9; /* Màu chữ */
}

.title {
  color: #13357B; /* Blue color for the title */
  font-weight: bold;
  margin-bottom: 10px;
}

form {
  display: flex;
  flex-direction: column;
  width: 100%;
  max-width: 400px;
  margin: 0 auto;
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

a {
  color: #fff;
  text-decoration: underline;
  cursor: pointer;
}
</style>
  