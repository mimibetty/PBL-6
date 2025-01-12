<template>
    <div class="container-fluid">
      <div class="container left-panel">
        <div class="filter-section">
  
          <!-- Cuisine Filter -->
          <div 
            class="filter-item" 
            @click="toggleOptions('cuisine')" 
            :class="{ active: activeOptions.cuisine }"
          >
            Cuisine
            <div class="icon"></div>
          </div>
          <div v-if="activeOptions.cuisine" class="options">
            <div 
              v-for="option in cuisine_options" 
              :key="option" 
              class="option"
            >
              <input 
                type="checkbox" 
                :id="`cuisine-${option}`" 
                :checked="save_option_cuisine.includes(option)" 
                @change="handleCheckboxChange(option, 'save_option_cuisine')"
              />
              <label class="label" :for="`cuisine-${option}`">{{ option }}</label>
            </div>
          </div>
  
          <!-- Meal Filter -->
          <div 
            class="filter-item" 
            @click="toggleOptions('meal')" 
            :class="{ active: activeOptions.meal }"
          >
            Meals
            <div class="icon"></div>
          </div>
          <div v-if="activeOptions.meal" class="options">
            <div 
              v-for="option in meal_options" 
              :key="option" 
              class="option"
            >
              <input 
                type="checkbox" 
                :id="`meal-${option}`" 
                :checked="save_option_meal.includes(option)" 
                @change="handleCheckboxChange(option, 'save_option_meal')"
              />
              <label class="label" :for="`meal-${option}`">{{ option }}</label>
            </div>
          </div>
  
          <!-- Special Diet Filter -->
          <div 
            class="filter-item" 
            @click="toggleOptions('specialDiet')" 
            :class="{ active: activeOptions.specialDiet }"
          >
            Special Diet
            <div class="icon"></div>
          </div>
          <div v-if="activeOptions.specialDiet" class="options">
            <div 
              v-for="option in special_diet_options" 
              :key="option" 
              class="option"
            >
              <input 
                type="checkbox" 
                :id="`specialDiet-${option}`" 
                :checked="save_option_special_diet.includes(option)" 
                @change="handleCheckboxChange(option, 'save_option_special_diet')"
              />
              <label class="label" :for="`specialDiet-${option}`">{{ option }}</label>
            </div>
          </div>
  
          <!-- Feature Filter -->
          <div 
            class="filter-item" 
            @click="toggleOptions('feature')" 
            :class="{ active: activeOptions.feature }"
          >
            Features
            <div class="icon"></div>
          </div>
          <div v-if="activeOptions.feature" class="options">
            <div 
              v-for="option in feature_options" 
              :key="option" 
              class="option"
            >
              <input 
                type="checkbox" 
                :id="`feature-${option}`" 
                :checked="save_option_feature.includes(option)" 
                @change="handleCheckboxChange(option, 'save_option_feature')"
              />
              <label class="label" :for="`feature-${option}`">{{ option }}</label>
            </div>
          </div>
  
        </div>
      </div>
    </div>
  </template>
  
  

<script setup>
import { ref, onMounted, watch, nextTick } from 'vue';
import destinationViewModel from '../viewModels/Restaurant_ListViewModel';

const {
    isMenuVisible,
    toggleMenu,
    restaurants,
    liked,
    searchQuery,
    activeOptions,
    toggleOptions,
    cuisine_options,
    meal_options,
    special_diet_options,
    feature_options,
    save_option_cuisine,
    save_option_meal,
    save_option_special_diet,
    save_option_feature,
    handleCheckboxChange,
} = destinationViewModel();

</script>


<style scoped>
.filter-section {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 20px;
    width: 100%;
    margin-top: 0px;
    padding: 30px;
    border-radius: 25px;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
}
.filter-item {
    position: sticky;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 20px;
    background-color: #CAF0F8;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
    color: #13357B;
    font-weight: bold;
    cursor: pointer;
    border-radius: 15px;
    transition: background-color 0.3s;
    gap: 50px;
    font-size: 25px;
    width: 100%;
}
.filter-item svg{
    stroke: #13357B;
}
.filter-item:hover {
    background-color: #13357B;
    color: #EDF6F9;
}
.filter-item:hover svg{
    stroke: #EDF6F9;
}
.filter-item.active {
    background-color: #13357B;
    color: #e7c6ff;
}
.filter-item.active svg{
    stroke: #e7c6ff;
    transform: rotate(180deg);
}
.options {
    display: flex;
    flex-direction: column;
    padding: 25px;
    background-color: #EDF6F9;
    border-radius: 8px;
    width: 100%;
    min-width: 400px;
    gap: 20px;
    max-height: 280px; /* Set a maximum height for the scroll area */
    overflow-y: auto;  /* Enable vertical scroll */
}
.option{
    display: flex;
    padding: 20px;
    gap: 10px;
    background-color: #EDF6F9;
    border-radius: 10px;
}
.option label{
    color: #13357B;
    font-size: 20px;
}
.option input[type="checkbox"]  {
    appearance: none;
    background-color: #EDF6F9;
    margin-right: 10px;
    border: 2px solid #13357B;
    width: 25px;
    height: 25px;
    border-radius: 25%;
    align-items: center; /* Căn giữa nội dung */
    position: relative; /* Để pseudo-element ::after hoạt động đúng */
}
.option input[type = "checkbox"]:checked { 
    background-color: #13357B;
}
.option input[type = "checkbox"]:checked +label { 
    font-weight: 900;
}
.option input[type = "checkbox"]:checked::after { 
    content: "\2714";
    color: #EDF6F9;
    font-size: 15px;
    font-weight: bold;
    position: absolute; /* Để kiểm soát vị trí của tick */
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%); /* Đưa dấu tick vào giữa checkbox */
}
.option:hover {
    background-color: #00b4d8;
}
.option:hover label{
    color: #EDF6F9;
    font-weight: 800;
}
.option.active {
    background-color: #13357B;
    font-weight: 800;
    color: #e7c6ff;
}
.option.active label{
    color: #e7c6ff;
    font-weight: 800;
}
.checked {
    /* Background color when checked */
    background-color: #CAF0F8;
}
.checked label{
    color: #13357B;
    font-weight: 900;
}

.icon {
    width: 30px;
    height: 30px;
    background-image: url("data:image/svg+xml;charset=UTF-8,<svg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%2313357B'><path d='M19 9L14 14.1599C13.7429 14.4323 13.4329 14.6493 13.089 14.7976C12.7451 14.9459 12.3745 15.0225 12 15.0225C11.6255 15.0225 11.2549 14.9459 10.9109 14.7976C10.567 14.6493 10.2571 14.4323 10 14.1599L5 9' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'/></svg>");
    background-repeat: no-repeat;
    background-size: contain;
    background-position: center;
}
.filter-item:hover .icon {
    background-image: url("data:image/svg+xml;charset=UTF-8,<svg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%23EDF6F9'><path d='M19 9L14 14.1599C13.7429 14.4323 13.4329 14.6493 13.089 14.7976C12.7451 14.9459 12.3745 15.0225 12 15.0225C11.6255 15.0225 11.2549 14.9459 10.9109 14.7976C10.567 14.6493 10.2571 14.4323 10 14.1599L5 9' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'/></svg>");
}
.filter-item.active .icon {
    background-image: url("data:image/svg+xml;charset=UTF-8,<svg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%23E7C6FF'><path d='M19 9L14 14.1599C13.7429 14.4323 13.4329 14.6493 13.089 14.7976C12.7451 14.9459 12.3745 15.0225 12 15.0225C11.6255 15.0225 11.2549 14.9459 10.9109 14.7976C10.567 14.6493 10.2571 14.4323 10 14.1599L5 9' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'/></svg>");
}
</style>