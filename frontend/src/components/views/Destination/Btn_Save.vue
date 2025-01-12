<template>
    <button :class="{ active: isActive, hover: isHovered }"
            @click="toggleActive"
            @mouseover="isHovered = true"
            @mouseleave="isHovered = false"
            class="btn-save">
            
        <svg width="55px" height="55px" viewBox="0 0 24 24" fill="#curentColor" xmlns="http://www.w3.org/2000/svg">
            <path d="M15.7 4C18.87 4 21 6.98 21 9.76C21 15.39 12.16 20 12 20C11.84 20 3 15.39 3 9.76C3 6.98 5.13 4 8.3 4C10.12 4 11.31 4.91 12 5.71C12.69 4.91 13.88 4 15.7 4Z" stroke="#currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        <p>Save</p>
    </button>
</template>

<script>
export default {
    name: "btn_heart",
    data() {
        return {
            isActive: false,
            isHovered: false
        };
    },
    methods: {
        toggleActive() {
            this.isActive = !this.isActive;
        }
    }
};
</script>

<style scoped>
button {
    display: flex;
    gap: 20px;
    background-color: #EDF6F9;
    fill: #EDF6F9;
    color: #13357B;
    stroke: #13357B;
    border: none;
    width: 250px;
    border-radius: 60px;
    font-weight: bold;
    z-index: 16;
    justify-content: center;
    align-items: center;
    border: 3px solid #13357B;
    transition: 0.5s;
}

button.hover:not(.active) {
    background-color: #CAF0F8;
    stroke: #E63946;
    fill: #CAF0F8;
    z-index: 16;
}

button.active {
    background-color: #CAF0F8;
    stroke: #E63946;
    fill: #E63946;
    z-index: 16;
}

.btn-save p {
    font-weight: bold;
    font-size: 35px;
    margin-top: 15px;
}
</style>