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
      <img src="@/assets/google_logo.svg" alt="Google Logo" class="google-logo" />
      JOIN WITH GOOGLE
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
  width: 100%;
  overflow: hidden;
  box-sizing: border-box;
}

*, *::before, *::after {
  box-sizing: inherit;
}

.login-container {
  position: absolute;
  top : 0;
  left : 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background-image: url('@/assets/images/background.jpg');
  background-size: cover;
  background-position: center;
  height: 100vh;
  width: 100vw;
  max-width: 100vw;
  padding: 20px;
  text-align: center;
}

.login-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.45);
  z-index: 1;
}

.login-container > * {
  position: relative;
  z-index: 2;
  color: #ffffff;
}

.title {
  color: #6698f0;
}

form {
  display: flex;
  flex-direction: column;
  width: 100%;
  max-width: 400px;
  margin: 0 auto;
}

input {
  background-color: #f5f9e9;
  color: blue;
  border: 1px solid #ccc;
  padding: 10px;
  margin-bottom: 10px;
  font-size: 1rem;
  border-radius: 5px;
  width: 100%;
}

input::placeholder {
  color: blue;
  opacity: 0.7;
}

button {
  margin: 10px 0;
  padding: 10px;
  border-radius: 5px;
  border: none;
  background-color: #0044cc;
  color: #fff;
  cursor: pointer;
  font-size: 1rem;
}

.google-signin {
  width: 100%;
  max-width: 250px;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #daa916;
  padding: 10px;
  border-radius: 5px;
  margin: 10px 0;
}

.google-logo {
  width: 20px;
  margin-right: 10px;
}

.options {
  display: flex;
  justify-content: space-between;
  width: 100%;
  max-width: 400px;
}

a {
  color: #fff;
  text-decoration: underline;
  cursor: pointer;
}

/* Media Queries for Responsiveness */
@media (max-width: 768px) {
  .login-container {
    padding: 10px;
  }

  .title {
    font-size: 1.5rem;
  }

  input, button {
    font-size: 0.9rem;
  }

  .google-signin {
    font-size: 0.9rem;
  }
}

@media (max-width: 480px) {
  .title {
    font-size: 1.2rem;
  }

  input, button {
    font-size: 0.8rem;
  }

  .google-signin {
    font-size: 0.8rem;
  }
}
</style>
