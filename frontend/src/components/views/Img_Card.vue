<template>
    <div class="container-fluid">
        <div class="info-img">
            <img :src="imageUrl" :alt="name_picture" class="img-fluid rounded w-100"/>
            <div class="info-overlay p-4">
                <h4 class="text-white mb-2 mt-3">{{name}}</h4>
            </div>
            <div class="search-icon"></div>
        </div>
    </div>
</template>

<script>
export default {
    name: "Img_Card",
    props: {
        imageUrl: String,
        name_picture: String,
        name: String
    },
}
</script>

<style scoped>
.info-img {
    position: relative;
    overflow: hidden;
    border-radius: 10px;
    display: flex;
    align-items: end;
    justify-content: center;
    z-index: 1;
    cursor: pointer;
}
.info-img .info-overlay {
    position: absolute;
    bottom: 100%;
    text-align: center;
    z-index: 3;
    transition: 0.5s;
}
.info-img .search-icon {
    position: absolute;
    width: 100%;
    height: 100%;
    top: 0;
    right: 0;
    display: flex;
    padding: 20px 20px 0 0;
    background: rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    transition: 0.5s;
}
.info-img .info-overlay {
    bottom: 30%;
}
.info-img .search-icon {
    background: rgba(19, 53, 123, 0.3);
}
.info-img:hover .search-icon {
    background: rgba(19, 53, 123, 0.55);
}
.info-img:hover img {
    transition: 0.5s;
}
.info-img:hover img{
    transform: scale(1.2);
}
.info-img:hover .search-icon a i {
    opacity: 1;
    transition: 0.5s;
}
.img-fluid {
    width: 100%;
    height: 250px;
    object-fit: cover;
}
img, svg{
    vertical-align: middle;
}
img {
    overflow-clip-margin: content-box;
    overflow: clip ;
}
button {
    border: none;
    background: none;
}
</style>