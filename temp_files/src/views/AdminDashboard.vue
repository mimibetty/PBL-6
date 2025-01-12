<!-- src/views/AdminDashboard.vue -->
<template>
  <div class="dashboard-intro">
    <h1 class="welcome-title">Welcome to Admin Dashboard</h1>
    <p class="description">
      Manage your users, monitor activity, and access important reports easily
      and efficiently.
    </p>
    <button class="get-started">Get Started</button>
  </div>
</template>

<script>
export default {
  name: "DashboardIntro",
};
</script>

<style scoped>
.dashboard-intro {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  text-align: center;
  background: linear-gradient(to right, #2e3b4e, #42b983);
  color: #fff;
  border-radius: 8px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease, background-color 0.3s ease;
}

.welcome-title {
  font-size: 2.5rem;
  margin-bottom: 20px;
  animation: fadeIn 1s ease forwards;
}

.description {
  font-size: 1.2rem;
  margin-bottom: 30px;
  opacity: 0;
  animation: fadeIn 1s ease forwards 0.5s; /* Delayed animation */
}

.get-started {
  padding: 10px 20px;
  background-color: #007bff;
  color: #fff;
  border: none;
  border-radius: 5px;
  font-size: 1rem;
  cursor: pointer;
  transition: background-color 0.3s, transform 0.2s;
}

.get-started:hover {
  background-color: #0056b3;
  transform: scale(1.05);
}

/* Keyframes for fadeIn animation */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
