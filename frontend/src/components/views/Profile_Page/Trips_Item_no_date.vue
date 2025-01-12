<template>
    <div class="trip-item">
        <img src="@/assets/images/tms-hotel-da-nang-beach.jpg" alt="Avatar"/>
        <div class="info-trip d-flex flex-column gap-5 justify-content-center">
            <div class="name-of-trip">
                <span>Trip to Danang</span>
            </div>
            <div class="info-of-trip d-flex align-items-center gap-5">
                <div class="have-date-of-trip d-flex gap-2 align-items-center">
                    <span>Have date yet?<button>Add dates</button></span>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: "Trip_Item_no_date",
}
</script>

<style scoped>
.trip-item {
    display: grid;
    grid-template-columns: 40% 60%;
    margin: 20px 0;
    background-color: #CAF0F8;
    width: 100%;
    color: #13357B;
    border-radius: 10px;
    outline: 2px solid #13357B;
}
img{
    display: flex;
    width: 250px;
    height: 250px;
    object-fit: cover;
    border-radius: 10px;
}
.name-of-trip span{
    font-size: 30px;
    font-weight: 800;
}
.have-date-of-trip button{
    font-size: 18px;
    font-weight: 800;
    color: #13357B;
    background-color: transparent;
    border: none;
    border-radius: 10px;
    padding: 10px 10px;
    text-decoration: underline;
    margin: 0 0 0 10px;
}

.have-date-of-trip button:hover{
    color: #CAF0F8;
    background-color: #13357B;
} 
</style>