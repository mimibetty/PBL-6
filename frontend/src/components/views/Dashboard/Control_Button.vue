<template>
    <div class="container-fluid control-button">
        <button class="owl-prev" @click="prevSlide">
            <svg class="bi bi-arrow-left" width="30" height="30" viewBox="0 0 24 24" fill="currentColor">
                <path d="M7.68473 7.33186C8.07526 6.94134 8.07526 6.30817 7.68473 5.91765C7.29421 5.52712 6.66105 5.52712 6.27052 5.91765L1.60492 10.5832C0.823873 11.3643 0.823872 12.6306 1.60492 13.4117L6.27336 18.0801C6.66388 18.4706 7.29705 18.4706 7.68757 18.0801C8.0781 17.6896 8.0781 17.0564 7.68757 16.6659L4.02154 12.9998L22 12.9998C22.5523 12.9998 23 12.5521 23 11.9998C23 11.4476 22.5523 10.9998 22 10.9998L4.01675 10.9998L7.68473 7.33186Z"/>
            </svg>
        </button>
        <button class="owl-next" @click="nextSlide">
            <svg class="bi bi-arrow-right" width="30px" height="30px" viewBox="0 0 24 24" fill="currentColor">
                <path d="M16.3153 16.6681C15.9247 17.0587 15.9247 17.6918 16.3153 18.0824C16.7058 18.4729 17.339 18.4729 17.7295 18.0824L22.3951 13.4168C23.1761 12.6357 23.1761 11.3694 22.3951 10.5883L17.7266 5.9199C17.3361 5.52938 16.703 5.52938 16.3124 5.91991C15.9219 6.31043 15.9219 6.9436 16.3124 7.33412L19.9785 11.0002L2 11.0002C1.44772 11.0002 1 11.4479 1 12.0002C1 12.5524 1.44772 13.0002 2 13.0002L19.9832 13.0002L16.3153 16.6681Z"/>
            </svg>
        </button>
    </div>
</template>

<script setup>
    import dashboardViewModel from '../../viewModels/dashboardViewModel';

    const {
        nextSlide,
        prevSlide
    } = dashboardViewModel;

</script>
<script>
export default {
    name: "Control_Button",
}
</script>

<style>
.control-button {
    display: flex;
    justify-content: space-between;
    width: 100%;
    gap: 1000px;
    justify-items: center;
    align-items: center;
    text-align: center;
}
.control-button button{
    padding: 5px 30px;
    border: 2px solid #13357B;
    border-radius: 30px;
    transition: .5s;
    background-color: #EDF6F9;
    fill: #EDF6F9
}
.control-button button:hover {
    background-color: #13357B;
}
.control-button button svg {
    fill: #13357B;
}
.control-button button:hover svg {
    fill: #EDF6F9;
}
</style>