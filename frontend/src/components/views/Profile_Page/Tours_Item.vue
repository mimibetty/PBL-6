<template>
    <div class="trip-item">
        <div class="row">
            <div class="col-sm-1 p-2">
                <img src="@/assets/images/tms-hotel-da-nang-beach.jpg" alt="Avatar" class="ava"/>
            </div>
            <div class="col-sm-11 p-2">
                <div class="name-of-trip">
                    <span>{{ tour?.name }}</span>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: "Trip_Item_no_date",
    props: {
        tour: Object,
    }
}
</script>

<style scoped>

.trip-item {
    display: flex;
    margin: 20px 0;
    background-color: #CAF0F8;
    width: 99%;
    color: #13357B;
    border-radius: 10px;
    outline: 2px solid #13357B;
}
.trip-item:hover {
    cursor: pointer;
    transition: 0.7ms ease-in-out;
    transform: translateY(-5px);
    background-color: #CAF0F8;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
}
img{
    display: flex;
    width: 300px;
    height: 300px;
    object-fit: cover;
    border-radius: 10px;
}

.ava {
    display: flex;
    margin-top: -13px;
    margin-left: -0.8px;
    margin-bottom: -3px;    
}
.col-sm-11{
    display: grid;
    width: 100%;
    align-items: center;
    margin-left: 350px;
    margin-top: -300px;
}

.name-of-trip span{
    font-size: 30px;
    font-weight: 800;
}

.have-date-of-trip{
    display: inline-flex;
    align-items: center;
    margin: 0px 0 0 0px;
}

.have-date-of-trip span{
    font-size: 18px;
    gap: 10px
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