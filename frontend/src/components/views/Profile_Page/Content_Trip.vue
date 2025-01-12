<template>
    <div class="container-fluid">
        <!-- Info User Post like username activity, date post, avatar -->
        <div class="user-info">
            <div class="avatar">
                <img src="@/assets/images/ava.png" alt="Avatar" class="ava"/>
            </div>
            <div class="activity">
                <p>Tran Minh Nhat</p>
                <span>create a new trip</span>
            </div>
            <div class="date-post">
                Sep 2024
            </div>
        </div>

        <!-- Content Create a new trip Post -->
        <!-- Picture about Location of Review -->
        <div class="picture">
            <img src="@/assets/cities/daklak.jpg" alt="Picture" class="image-location"/>
        </div>

        <!-- Length Trip -->
        <div class="length-trip">
            <p>Ha Noi for 3 days</p>
        </div>

    </div>
</template>

<script>
import tag_location_review from './tag_location_review.vue';
export default {
    name: "Content_Trip",
    components: {
        tag_location_review
    }

}
</script>

<style scoped>
.container-fluid{
    display: grid;
    gap: 10px;
    width: 90%;
    height: 100%;
    border-radius: 15px;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.3);
    z-index: 2;
}

.user-info{
    width: 100%;
    height: 100%;
    display: grid;
    gap: 10px;
    align-items: center;
    color: #13357B;
    z-index: 5;
}

.user-info .avatar{
    width: 60px;
    height: 60px;
    margin-left: 10px;
    margin-top:10px;
    z-index: 5;
}

.user-info .avatar img{
    width: 60px;
    height: 60px;
    z-index: 5;
}
.activity{
    display: flex;
    align-items: center;
    width: 100%;   
    gap:10px;
    margin-top: -70px;
}
.user-info .activity p{
    font-weight: 700;
    margin: -40px 0 0 100px;
}
.user-info .activity span{
    margin: -40px 0 0 10px;
}

.user-info .date-post{
    margin: -60px 0 0 100px;
}
.picture {
    display: flex;
    justify-content: center; /* Căn giữa theo chiều ngang */
    align-items: center;
}

.picture .image-location {
    width: 100%;
    height: 350px;
    margin-bottom: 10px;
    object-fit: cover;
    border-radius: 6px;
}
.length-trip{
    display: flex;
    justify-content: center;
    font-size: 40px;
    color: #13357B;
    font-weight: 900;
}
</style>