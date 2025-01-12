<template>
    <div class="cards">
      <div class="frame-image">
        <img :src="imageUrl" alt="pic" class="img-location" />
      </div>
      <div class="name">
        <h3>{{ name }}</h3>
      </div>
      <div class="description">
        <p>{{ description }}</p>
      </div>
    </div>
  </template>  
  <script>
  import btn_heart from '../btn_heart.vue';
  
  export default {
    name: "Cards",
    components: {
      btn_heart
    },
    props: {
      imageUrl: String,
      name: String,
      description: String,
    },
  }
  </script>
  
<style scoped>
.cards {
  display: grid;
  grid-template-columns: 30% 40% 10%;
  gap:5%;
  grid-template-rows: auto;
  grid-template-areas: "image name heart"
                       "image description heart-1";
  background-color: #EDF6F9;
  padding: 15px;
  box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .1), 0 6px 18px -1px rgba(19, 53, 123, .08) !important;
  border-radius: 30px;
  transition: 0.75s ease-in-out;
  cursor: pointer;
  font-size: 18px;
}
.cards:hover {
  background-color: #8ecae6;
}
.frame-image {
  grid-area: image;
}
.img-location {
  width: 100%;
  height: 200px;
  object-fit: cover;
  border-radius: 15px;
}
.name {
  grid-area: name;
  align-content: center;
}
h3 {
  font-weight: 900;
}
.description {
  grid-area: description;
  align-content: flex-start;
}
.heart {
  grid-area: heart;
}
.custom {
  width: 80px;
  height: 80px;
}
</style>

  <!-- <style scoped>
  .container-fluid {
    display: block;
    color: #13357B;
    height: 100%;
  }
  
  .img-location {
    width: 100%;
    height: 150px;
    object-fit: cover;
    border-radius: 15px;
  }
  
  .cards {
    display: flex;
    flex-direction: row;
    padding: 15px;
    background-color: #fff;
    border-radius: 15px;
    transition: 0.75s ease-in-out;
  }
  
  .cards:hover {
    cursor: pointer;
    box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.2);
    background-color: #f7f7f7;
  }
  
  .content-section {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
  }
  
  .btn-heart {
    text-align: right;
    margin-top: 10px;
  }
  
  .name-category h5 {
    font-weight: 600;
    font-size: 14px;
    color: #999;
  }
  
  .name-category h3 {
    font-weight: 900;
    font-size: 18px;
    margin: 5px 0;
  }
  
  .rating {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
  }
  
  .stars {
    display: flex;
    margin-right: 10px;
  }
  
  .rating img {
    width: 18px;
    height: 18px;
  }
  
  .rating span {
    font-size: 14px;
    color: #666;
  }
  
  .description p {
    font-weight: 400;
    font-size: 14px;
    color: #666;
  }
  
  .cards:hover .description p {
    color: #000;
  }
  
  .row {
    display: flex;
    width: 100%;
  }
  
  .col-sm-3 {
    width: 30%; /* Hình ảnh và nút trái tim chiếm 30% chiều rộng */
  }
  
  .col-sm-6 {
    width: 60%; /* Thông tin chiếm 60% chiều rộng */
  }
  
  .col-sm-3 p-2 {
    width: 10%; /* Phần trái tim chiếm 10% chiều rộng */
  }
  </style>
  
 -->
