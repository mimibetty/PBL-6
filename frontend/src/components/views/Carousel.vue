<template>
    <div class="container-fluid-carousel">
        <div class="carousel-header">
            <!-- Carousel -->
            <div id="carouselId" class="carousel slide" data-bs-ride="carousel">

            <!-- The slideshow/carousel -->
            <div class="carousel-inner">
                    <div v-for="(image, index) in images" :key="index" :class="['carousel-item', { active: index === currentIndex }]">
                        <!-- Ensure image is a URL, otherwise access image.url if it's an object -->
                        <img 
                            :src="image?.url  || '/blue-image.jpg'" 
                            :alt="`Image ${index + 1}`" 
                            class="img-fluid" 
                            loading="lazy"
                        >
                    </div>
            </div>

            <!-- Left and right controls/icons -->
            <button  @click="prevImage" class="carousel-control-prev" type="button" data-bs-target="#carouselId" data-bs-slide="prev">
                <span class="carousel-control-prev-icon btn"></span>
            </button>
            <button @click="nextImage" class="carousel-control-next" type="button" data-bs-target="#carouselId" data-bs-slide="next">
                <span class="carousel-control-next-icon btn"></span>
            </button>
            </div>
        </div>
    </div>

</template>

<script>
export default {
    name: "Carousel",
    props: {
        currentImage: String,
        images: {
            type: Array,
            default: () => []
        }
    },
    data() {
        return {
            currentIndex: 0
        };
    },
    watch: {
        currentImage(newImage) {
        // Update the current index based on the new current image
        const index = this.images.indexOf(newImage);
        if (index !== -1) this.currentIndex = index;
        }
    },
}
</script>

<style scoped>
/*** Carousel Hero Header Start ***/
.container-fluid-carousel { 
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 20px;
}
.carousel-header {
    display: flex;
    margin-top: 200px;
    flex-direction: column;
    align-items: center;
}
.carousel-header .carousel-control-prev,
.carousel-header .carousel-control-next {
    background: transparent;
}
.carousel-header .carousel-control-prev .carousel-control-prev-icon {
    display: flex;
    margin-left: -10.85vw;
    padding: 25px 30px;
    border-top-right-radius: 50px;
    border-bottom-right-radius: 50px;
    background-color: #13357B;
    background-size: 60% 60%;
}
.carousel-header .carousel-control-next .carousel-control-next-icon {
    display: flex;
    margin-right: -10.85vw;
    padding: 25px 30px;
    border-top-left-radius: 50px;
    border-bottom-left-radius: 50px;
    background-color: #13357B;
    background-size: 60% 60%;
}
.carousel-header .carousel .carousel-indicators button {
    opacity: 0;
}
.carousel-header .carousel-inner .carousel-item img {
    width: 100vw;
    height: calc(50vw);
    max-height: 550px;
    object-fit: cover;
    object-position: center;
    border-radius: 20px;
}
/*** Carousel Hero Header End ***/
</style>