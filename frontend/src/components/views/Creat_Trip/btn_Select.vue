<template>
    <button @click="togglePickStatus(id)">
        <img :src="picked[id] ? pickFull : pickEmpty " alt="">
    </button>
</template>

<script setup>
import CreateTripViewModel from '@/components/viewModels/CreateTripViewModel';
const {
    togglePickStatus, picked, pickEmpty, pickFull 
} = CreateTripViewModel();
</script>

<script>
export default {
    name: "btn_select",
    props: {
        id: Number
    }
};
</script>

<style scoped>
button {
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #EDF6F9;
    fill: #EDF6F9;
    stroke: #13357B;
    border: none;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    font-weight: bold;
    z-index: 16;
    transition: 0.5s;
}

button:hover {
    background-color: #CAF0F8;
}

button.active {
    background-color: #CAF0F8;
    stroke: #E63946;
    fill: #E63946;
    z-index: 16;
}
</style>