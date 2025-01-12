<template>
  <div class="card d-flex flex-row align-items-center p-3 shadow-sm rounded">
    <!-- Frame Image -->
    <div class="frame-image flex-shrink-0 me-3">
      <img :src="imageUrl" alt="pic" class="img-location rounded" />
    </div>

    <!-- Content: Name, Description, and Rating -->
    <div class="content flex-grow-1 d-flex flex-column justify-content-between">
      <!-- Name -->
      <div class="name mb-2">
        <h3 class="fw-bold mb-0">{{ name }}</h3>
      </div>

      <!-- Rating -->
      <div class="rating d-flex align-items-center mb-2">
        <div class="stars me-2">
          <img v-for="(star, index) in stars" :key="index" :src="star" alt="Star" class="star" />
        </div>
        <span class="rating-value fw-bold text-warning me-1">⭐ {{ rating }}</span>
        <span class="rating-count text-muted">({{ ratingCount }} reviews)</span>
      </div>

      <!-- Description -->
      <div class="description">
        <p class="mb-0">{{ description }}</p>
      </div>
    </div>

    <!-- Heart Button -->
    <div class="heart ms-3">
      <btn_heart class="custom" :destID="destID" />
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
    destID: Number,
    imageUrl: String,
    name: String,
    description: String,
    rating: Number,
    ratingCount: Number,
    stars: Array
  },
}
</script>

<style scoped>
.card {
  background-color: #EDF6F9;
  transition: 0.75s ease-in-out;
  cursor: pointer;
  font-size: 18px;
  box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .1), 0 6px 18px -1px rgba(19, 53, 123, .08) !important;
  border-radius: 30px;
  gap:5%;
}
.card:hover {
  background-color: #8ecae6;
}
.frame-image {
  width: 30%;
}
.img-location {
  width: 100%;
  height: 200px;
  object-fit: cover;
  border-radius: 15px;
}
.content {
  width: 60%;
}
.heart {
  width: 10%;
}
.custom {
  width: 80px;
  height: 80px;
}
.rating {
  font-size: 14px;
}
.star {
  width: 18px;
  height: 18px;
}
.rating-value {
  font-size: 16px;
}
.rating-count {
  font-size: 14px;
}
</style>
