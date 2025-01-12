<template>
    <div class="container-fluid">
        <!-- Tab Button Start  -->
        <ul class="nav nav-pills d-inline-flex justify-content-center mb-5">
            <li class = "nav-item">
                <button class = "d-flex mx-3 py-2 bg-light rounded-pill" 
                :class="{ active: activeButton === 'all' }" 
                @click="setActive('all')">
                    All
                </button>
            </li>
            <li class = "nav-item">
                <button class = "d-flex mx-3 py-2 bg-light rounded-pill" 
                :class="{ active: activeButton === 'northern-vietnam' }" 
                @click="setActive('northern-vietnam')">
                    Northern Vietnam
                </button>
            </li>
            <li class = "nav-item">
                <button class = "d-flex mx-3 py-2 bg-light rounded-pill" 
                :class="{ active: activeButton === 'central-vietnam' }" 
                @click="setActive('central-vietnam')">
                    Central Vietnam
                </button>
            </li>
            <li class = "nav-item">
                <button class = "d-flex mx-3 py-2 bg-light rounded-pill"
                :class="{ active: activeButton === 'southern-vietnam' }" 
                @click="setActive('southern-vietnam')">
                    Southern Vietnam
                </button>
            </li>
        </ul>
        <!-- Tab Button End  -->
    </div>
</template>
    
<script setup>
    import dashboardViewModel from '../../viewModels/dashboardViewModel.js';

    const {
        activeButton, setActive
    } = dashboardViewModel;
</script>

<script>
export default {
    name: "Tag_Button",
}
</script>

<style scoped>
.nav {
    display: flex;
    flex-wrap: wrap;
    width: 100%;
}
.nav-item button {
    color: #13357B;
    justify-content: center;
    background-color: #EDF6F9 !important;
    width: 200px;
    border: 2px solid #13357B;
    font-family: 'Roboto';
}
.nav-item button:hover {
    color: #13357B;
    background-color: #caf0f8 !important;
    text-decoration: none;
}

.nav-item button.active {
    color: #caf0f8;
    background-color: #13357B !important;
    text-decoration: none;
}

</style>