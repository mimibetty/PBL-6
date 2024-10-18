<template>
    <Suspense>
      <template #default>
        <div class="top_website">
            <div class="navbar">
                <!-- Phần 1: Logo và tên -->
                <div class="navbar-section logo-section">
                    <img src="@/assets/images/company_image.png" alt="Logo" class="logo" />
                    <span class="logo-text">Travel Tips</span>
                </div>

                <!-- Phần 2: Các nút điều hướng -->
                <div class="navbar-section navbar-buttons">
                    <button class="nav-button">Home</button>
                    <button class="nav-button">Your Proposal</button>
                    <button class="nav-button">Trips</button>
                    <button class="nav-button">Travel Itinerary</button>
                </div>

                <!-- Phần 3: Biểu tượng người dùng -->
                <div class="navbar-section user-icon">
                    <div class="user-image"></div>
                </div>
            </div>
            <div class="main">

            </div>
            <div class="footer_search">

            </div>
        </div>
      </template>

      <template #fallback>
        <div>Loading...</div>
      </template>
    </Suspense>
</template>
  
<script setup>
    import dashboardViewModel from '../viewModels/dashboardViewModel.js';
    const {
        activeButton,
        setActive,
        cities,
        visibleCities,
        prevSlide,
        nextSlide,
        topics,
        visibleTopics,
        prevTopic,
        nextTopic,
        tours,
        visibleTours,
        prevTour,
        nextTour,
        isMenuVisible,
        toggleMenu,
        generateStars,
    } = dashboardViewModel;
</script>
  
<style>
:root {
--default-font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
    Ubuntu, "Helvetica Neue", Helvetica, Arial, "PingFang SC",
    "Hiragino Sans GB", "Microsoft Yahei UI", "Microsoft Yahei",
    "Source Han Sans CN", sans-serif;
}

body{
    font-family: 'Roboto', sans-serif;
}
.top_website {
    position: absolute;
    background: url('@/assets/images/background_picture.png');
    background-size: cover;
    width :100%;
    display: flex;
    height: 640px;
    top : 0;
    left: 0;
}    
.navbar {
    position: fixed;
    top : 0;
    left: 0;
    width :100%;
    height: 20%;
    display: flex;
    justify-content: space-between; /* Chia đều không gian giữa các phần */
    align-items: center;
    border-bottom: 1px solid #13357B;
    padding: 10px 20px; /* Đệm bên trong thanh điều hướng */
}
.logo-section {
    display: flex;
    align-items: center;
}
.logo {
    height: 55px;
    margin-right: 10px;
    border-radius: 50%;
}

.logo-text {
    font-size: 20px;
    color: #13357B;
    font-weight: bold;
    font-family: 'Roboto', sans-serif;
}

/* Phần các nút điều hướng */
.nav-buttons {
    display: flex;
    gap: 15px; 
    height: 100%;
}

.nav-button {
    position: relative;
    background: none;
    border: none;
    color: #13357B;
    font-weight: bold;
    font-size: 16px;
    cursor: pointer;
    font-family: 'Roboto', sans-serif;
    padding: 53px 15px;
    height: 100%;
    transition: .5s;
}
.nav-button:hover {
    background-color: #13357B; /* Màu nền khi hover */
    color: white; /* Màu chữ khi hover */
    transition: background-color 0.3s ease-in-out; /* Hiệu ứng chuyển đổi */
}



/* Phần biểu tượng người dùng */
.user-icon {
    display: flex;
    align-items: center;
}

.user-image {
    background: url('@/assets/union-1.svg') no-repeat center;
    background-size: cover;
    width: 40px;
    height: 40px;
}
</style>