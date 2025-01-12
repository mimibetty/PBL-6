<template>
    <div class="frame-filter d-flex justify-content-between align-items-center">
        <span> {{ trip?.trip_destinations.length }} items</span>
        <div class="dropdown">
            <button class="filter-button" data-bs-toggle="dropdown">
                <svg width="30px" height="30px" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
                    <title>filter-horizontal</title>
                    <g id="Layer_2" data-name="Layer 2">
                        <g id="invisible_box" data-name="invisible box">
                            <rect width="48" height="48" fill="none" />
                        </g>
                        <g id="icons_Q2" fill="currentColor" data-name="icons Q2">
                            <path
                                d="M41.8,8H21.7A6.2,6.2,0,0,0,16,4a6,6,0,0,0-5.6,4H6.2A2.1,2.1,0,0,0,4,10a2.1,2.1,0,0,0,2.2,2h4.2A6,6,0,0,0,16,16a6.2,6.2,0,0,0,5.7-4H41.8A2.1,2.1,0,0,0,44,10,2.1,2.1,0,0,0,41.8,8ZM16,12a2,2,0,1,1,2-2A2,2,0,0,1,16,12Z" />
                            <path
                                d="M41.8,22H37.7A6.2,6.2,0,0,0,32,18a6,6,0,0,0-5.6,4H6.2a2,2,0,1,0,0,4H26.4A6,6,0,0,0,32,30a6.2,6.2,0,0,0,5.7-4h4.1a2,2,0,1,0,0-4ZM32,26a2,2,0,1,1,2-2A2,2,0,0,1,32,26Z" />
                            <path
                                d="M41.8,36H24.7A6.2,6.2,0,0,0,19,32a6,6,0,0,0-5.6,4H6.2a2,2,0,1,0,0,4h7.2A6,6,0,0,0,19,44a6.2,6.2,0,0,0,5.7-4H41.8a2,2,0,1,0,0-4ZM19,40a2,2,0,1,1,2-2A2,2,0,0,1,19,40Z" />
                        </g>
                    </g>
                </svg>
                Filter
            </button>
            <div class="nav-item dropdown-menu">
                <button class="dropdown-item" @click="filterCategory('thingstodo')">Things to do</button>
                <button class="dropdown-item" @click="filterCategory('restaurants')">Restaurants</button>
                <button class="dropdown-item" @click="filterCategory('hotels')">Resorts & Hotels</button>
            </div>
        </div>
    </div>

    <div v-for="section in sections" :key="section.id" :class="['frame', section.className]">
        <div class="title">
            <h2>{{ section.title }}</h2>
            <button class="button" @click="toggleSection(section.id)">
                <svg width="40px" height="40px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path :d="section.show ? 'M5 15L12 9L19 15' : 'M19 9L12 15L5 9'" stroke="#13357B" stroke-width="1.5"
                        stroke-linecap="round" stroke-linejoin="round" />
                </svg>
            </button>
        </div>
        <div v-show="section.show">
            <Saved_Item v-for="item in section.items" :key="item.id" :place="item" @click="section.navigate(item.id)" />
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import Saved_Item from './Saved_Item.vue'

const props = defineProps({
    trip: Object
})

const sections = ref([
    {
        id: 'thingstodo',
        title: 'Things to do',
        className: 'things-to-do',
        show: true,
        items: computed(() => props.trip?.destinations.filter(d => !d.restaurant_id && !d.hotel_id) || []),
        navigate: id => window.location.assign(`/Detail/Place/${id}`)
    },
    {
        id: 'restaurants',
        title: 'Restaurants',
        className: 'restaurants',
        show: true,
        items: computed(() => props.trip?.destinations.filter(d => d.restaurant_id) || []),
        navigate: id => window.location.assign(`/Detail/Restaurant/${id}`)
    },
    {
        id: 'hotels',
        title: 'Place to stay',
        className: 'hotels',
        show: true,
        items: computed(() => props.trip?.destinations.filter(d => !d.restaurant_id && d.hotel_id) || []),
        navigate: id => window.location.assign(`/Detail/Hotel/${id}`)
    }
]);

const toggleSection = (id) => {
    const section = sections.value.find(s => s.id === id);
    if (section) section.show = !section.show;
}

const filterCategory = (category) => {
    sections.value.forEach(section => section.show = section.id === category);
}
</script>



<style scoped>
.frame-filter {
    font-size: 18px;
    color: #13357B;
    margin-top: 20px;
}

.dropdown {
    display: flex;
    align-items: center;
}

.filter-button {
    display: flex;
    gap: 10px;
    padding: 8px 25px;
    border-radius: 30px;
    background-color: transparent;
    color: #13357B;
    border: 2px solid #13357B;
    cursor: pointer;
    font-weight: 900;
}

#icons_Q2 {
    fill: #13357B;
}

.dropdown-menu {
    background: #CAF0F8;
    z-index: 99999;
}

.nav-item .dropdown-menu {
    display: block;
    visibility: hidden;
    position: absolute;
    top: 100%;
    transform: rotateX(-75deg);
    transform-origin: 0% 0%;
    border: 0;
    transition: .5s;
    opacity: 0;
    z-index: 99999;
}

.nav-item:hover .dropdown-menu {
    transform: rotateX(0deg);
    position: absolute;
    visibility: visible;
    transition: .5s;
    opacity: 1;
    z-index: 99999;
}

.dropdown .dropdown-menu button:hover {
    background: #13357B;
    color: #EDF6F9;
}

.frame {
    margin-top: 65px;
    margin-bottom: 50px;
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.title {
    cursor: pointer;
    display: flex;
    color: #13357B;
    justify-content: space-between;
}

.title h2 {
    font-weight: 900;
}

.button {
    background: transparent;
    border: none;
    cursor: pointer;
    pointer-events: auto;
    z-index: 10000;
}

.filter-button:hover {
    background-color: #D7DAF9;
}
</style>