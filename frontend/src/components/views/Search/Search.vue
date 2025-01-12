<template>
  <div class="header-container">
    <Header />
    <Top_Button />
  </div>
    <div class="container-fluid p-5">
      <div class="row content-1 d-flex 
            flex-column justify-content-center gap-5">
        <div class="container ">
          <Form_Search class="search-form" :name="'Attraction, activities or destination'" />
        </div>
      </div>
      <h2 class="title-result">Result for: {{ searchQuery }}</h2>
      <div class="row title-content">
        <div class="container-fluid context">
          <div class="row">
            <Cards_City
              v-for="(item, index) in cities"
              :key="index"
              :imageUrl="item.images[0]?.url || '/blue-image.jpg'"
              :name="item.name"
              :description="item.description"
              @click="navigateToDestination(item.id)"
            />
          </div>
        </div>
      </div>
      <!-- Things to do Section -->
      <div class="row title-content">
        <div class="container-fluid context">
          <div class="row">
            <Cards
              v-for="(item, index) in destinations"
              :key="index"
              :destID="item.id"
              :imageUrl="item.images[0]?.url || '/blue-image.jpg'"
              :name="item.name"
              :description="item.description"
              :rating="item.rating"
              :stars="generateStars(item.rating)"
              :ratingCount="item.review_count"
              :tags="item.tag"
              @click="navigateToDetailPlace(item.id)"
            />
          </div>
        </div>
      </div>

      <!-- Restaurants Section -->
      <div class="row title-content">
        <div class="container-fluid context">
          <div class="row">
            <Cards
              v-for="(item, index) in restaurants"
              :key="index"
              :destID="item.id"
              :imageUrl="item.images[0]?.url || '/blue-image.jpg'"
              :name="item.name"
              :description="item.description"
              :rating="item.rating"
              :stars="generateStars(item.rating)"
              :ratingCount="item.review_count"
              :tags="item.tag"
              @click="navigateToDetailRestaurant(item.restaurant_id)"
            />
          </div>
        </div>
      </div>

      <!-- Resort & Hotels Section -->
      <div class="row title-content">
        <div class="container-fluid context">
          <div class="row">
            <Cards
              v-for="(item, index) in hotels"
              :key="index"
              :destID="item.id"
              :imageUrl="item.images[0]?.url || '/blue-image.jpg'"
              :name="item.name"
              :description="item.description"
              :rating="item.rating"
              :stars="generateStars(item.rating)"
              :ratingCount="item.review_count"
              :tags="item.tag"
              @click="navigateToDetailHotel(item.hotel_id)"
            />
          </div>
        </div>
      </div>
    </div>
</template>

<script setup>
import SearchViewModel from "../../viewModels/SearchViewModel";
import generate_ratingViewModel from '@/components/viewModels/generate_ratingViewModel.js';
import { ref, computed, onMounted, watch } from 'vue';
import { useRoute } from 'vue-router';
const route = useRoute();
const searchQuery = route.query.q;

const {
  search,
  searchResult,
  isLoading,
  cities,
  destinations,
  hotels,
  restaurants,
} = SearchViewModel(searchQuery);

onMounted(() => {
  search();
});

const { generateStars } = generate_ratingViewModel();

// Navigation Functions
const navigateToDetailPlace = (id) => window.location.assign(`/Detail/Place/${id}`);
const navigateToDetailRestaurant = (restaurant_id) => window.location.assign(`/Detail/Restaurant/${restaurant_id}`);
const navigateToDetailHotel = (hotel_id) => window.location.assign(`/Detail/Hotel/${hotel_id}`);
const navigateToDestination = (id) => {
  window.location.assign(`/Destination/${id}`);
};
</script>

<script>
import Header from '../Header.vue';
import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
import Top_Button from '../Top_Button.vue';
import Img_Card from '../Img_Card.vue';
import Cards_City from './Cards_City.vue';
import Cards from './Cards.vue';
import Form_Search from '../Form_Search_Simple.vue';

export default {
  name: "ThingsToDo_List",
  components: {
    Header, Scroll_Bar_Component, Top_Button,
    Img_Card, Cards_City, Cards, Form_Search,
  }
}
</script>

<style scoped>
.search-form {
  margin-top: 120px;
  padding: 1rem .5rem;
  border-radius: 50px;
  background-color: #13357B;
  width: 100%;
  width: 75vw;
}
.results {
  color:#13357B;
}
.title {
  font-size: 30px;
  font-weight: 900;
}
.title-result {
  color: #13357B;
  font-size: 25px;
  font-weight: 900;
  margin-bottom: 10px; /* Giảm khoảng cách giữa tiêu đề và phần cards */
  margin-top: 50px;
}

.context {
  display: flex;
  flex-direction: column;
  gap: 20px;
}
</style>

