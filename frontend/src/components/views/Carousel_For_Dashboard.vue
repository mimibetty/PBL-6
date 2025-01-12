<template>
    <!-- Carousel Image Dashboard Start-->
    <div class="container-fluid-carousel">
        <div class="carousel-header">
            <!-- Carousel -->
            <div id="carouselId" class="carousel slide" data-bs-ride="carousel">

            <!-- The slideshow/carousel -->
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="@/assets/images/carousal_1.jpg" alt="City 1" class="img-fluid">
                    <div class="carousel-caption">
                        <div class="captions p-5" >
                            <h4 class=" text-uppercase fw-bold" style="letter-spacing: 3px;">Explore Viet Nam</h4>
                            <h1 class="display-2 ">Vietnam: A Land of Endless Wonders</h1>
                        </div>
                    </div>
                </div>
                <div class="carousel-item">
                    <img src="@/assets/images/carousal_2.jpg" alt="City 1" class="img-fluid">
                    <div class="carousel-caption">
                        <div class="captions p-5" >
                            <h4 class=" text-uppercase fw-bold" style="letter-spacing: 3px;">Explore Viet Nam</h4>
                            <h1 class="display-2 ">You like to go ?</h1>
                        </div>
                    </div>
                </div>
                <div class="carousel-item">
                    <img src="@/assets/images/carousal_3.jpg" alt="City 1" class="img-fluid">
                    <div class="carousel-caption">
                        <div class="captions p-5" >
                            <h4 class=" text-uppercase fw-bold" style="letter-spacing: 3px;">Explore Viet Nam</h4>
                            <h1 class="display-2 ">Feel the Pulse of Vietnam</h1>
                        </div>
                    </div>
                </div>
                <div class="carousel-item">
                    <img src="@/assets/images/carousal_4.jpg" alt="City 1" class="img-fluid">
                    <div class="carousel-caption">
                        <div class="captions p-5" >
                            <h4 class=" text-uppercase fw-bold" style="letter-spacing: 3px;">Explore Viet Nam</h4>
                            <h1 class="display-2 ">Find Your Perfect Tour At Travel</h1>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Left and right controls/icons -->
            <button class="carousel-control-prev" type="button" data-bs-target="#carouselId" data-bs-slide="prev">
                <span class="carousel-control-prev-icon btn"></span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#carouselId" data-bs-slide="next">
                <span class="carousel-control-next-icon btn"></span>
            </button>
            </div>
        </div>
    </div>
    <!-- Carousel Image Dashboard End -->        
</template>

<script>
export default {
    name: 'Carousel_For_Dashboard'
}
</script>

<style scoped>
/*** Carousel Hero Header Start ***/
.container-fluid-carousel { 
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
}
.carousel-header .carousel-control-prev,
.carousel-header .carousel-control-next {
    background: transparent;
}
.carousel-header .carousel-control-prev .carousel-control-prev-icon {
    display: flex;
    margin-left: -10.9vw;
    padding: 25px 30px;
    border-top-left-radius: 0;
    border-top-right-radius: 50px;
    border-bottom-left-radius: 0;
    border-bottom-right-radius: 50px;
    background-color: #13357B;
    background-size: 60% 60%;
}
.carousel-header .carousel-control-next .carousel-control-next-icon {
    display: flex;
    margin-right: -10.9vw;
    padding: 25px 30px;
    border-top-left-radius: 50px;
    border-top-right-radius: 0;
    border-bottom-left-radius: 50px;
    border-bottom-right-radius: 0;
    background-color: #13357B;
    background-size: 50% 50%;
}
.carousel-header .carousel .carousel-indicators button {
    opacity: 0;
}
.carousel-header .carousel-inner .carousel-item img {
    width: 100vw; /* Chiều rộng 100% của container */
    height: calc(50vw); /* Chiều cao bằng 50% chiều rộng màn hình */
    max-height: 600px; /* Giới hạn chiều cao tối đa là 600px */
    object-fit: cover; /* Zoom ảnh nếu cần để khớp khung hình */
    object-position: center; /* Đặt tâm ảnh làm điểm neo khi zoom */
}
.carousel-header .carousel-item::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(39, 45, 45, 0.55);
    z-index: 0;
}
.captions {
    display: flex;
    flex-direction: column;
    gap: 25px;
    align-items: center;
    justify-content: center;
    margin-bottom: 100px;
    color: #CFE8EF;
}
/*** Carousel Hero Header End ***/
</style>