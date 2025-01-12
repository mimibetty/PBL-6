<template>
    <div class="favourite-item" @click="navigate(destination)">
        <div class="image d-flex flex-column align-items-flex-start">
            <img :src="destination?.images && destination.images[0] ? destination.images[0].url : '/blue-image.jpg'"
                alt="pic" class="img-location" />
            <div>
                <btn_heart class="btn-heart" :destID="destID" />
            </div>
        </div>
        <div class="info-location">
            <div class="name-of-location px-3 py-1">
                {{ destination?.name }}
            </div>
            <div class="icon-rating d-flex align-items-center gap-3 px-3">
                <svg width="40px" height="40px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path
                        d="M11.245 4.174C11.4765 3.50808 11.5922 3.17513 11.7634 3.08285C11.9115 3.00298 12.0898 3.00298 12.238 3.08285C12.4091 3.17513 12.5248 3.50808 12.7563 4.174L14.2866 8.57639C14.3525 8.76592 14.3854 8.86068 14.4448 8.93125C14.4972 8.99359 14.5641 9.04218 14.6396 9.07278C14.725 9.10743 14.8253 9.10947 15.0259 9.11356L19.6857 9.20852C20.3906 9.22288 20.743 9.23007 20.8837 9.36432C21.0054 9.48051 21.0605 9.65014 21.0303 9.81569C20.9955 10.007 20.7146 10.2199 20.1528 
                    10.6459L16.4387 13.4616C16.2788 13.5829 16.1989 13.6435 16.1501 13.7217C16.107 13.7909 16.0815 13.8695 16.0757 13.9507C16.0692 14.0427 16.0982 14.1387 16.1563 14.3308L17.506 18.7919C17.7101 19.4667 17.8122 19.8041 17.728 19.9793C17.6551 20.131 17.5108 20.2358 17.344 20.2583C17.1513 20.2842 16.862 20.0829 16.2833 19.6802L12.4576 17.0181C12.2929 16.9035 12.2106 16.8462 12.1211 16.8239C12.042 16.8043 11.9593 16.8043 11.8803 16.8239C11.7908 16.8462 11.7084 16.9035 11.5437 
                    17.0181L7.71805 19.6802C7.13937 20.0829 6.85003 20.2842 6.65733 20.2583C6.49056 20.2358 6.34626 20.131 6.27337 19.9793C6.18915 19.8041 6.29123 19.4667 6.49538 18.7919L7.84503 14.3308C7.90313 14.1387 7.93218 14.0427 7.92564 13.9507C7.91986 13.8695 7.89432 13.7909 7.85123 13.7217C7.80246 13.6435 7.72251 13.5829 7.56262 13.4616L3.84858 10.6459C3.28678 10.2199 3.00588 10.007 2.97101 9.81569C2.94082 9.65014 2.99594 9.48051 3.11767 9.36432C3.25831 9.23007 3.61074 9.22289 
                    4.31559 9.20852L8.9754 9.11356C9.176 9.10947 9.27631 9.10743 9.36177 9.07278C9.43726 9.04218 9.50414 8.99359 9.55657 8.93125C9.61593 8.86068 9.64887 8.76592 9.71475 8.57639L11.245 4.174Z"
                        stroke="#13357B" stroke-width="1" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                <div class="number-rating">
                    <span>{{ destination?.rating || 0 }}</span>
                </div>
            </div>
        </div>
        <div class="price px-3 my-3">
            <p>Price: {{ destination?.price_bottom || 0 }} - {{ destination?.price_top || 0 }}</p>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import DestinationLike from '../../viewModels/DestinationLikeViewModel';

// Khai báo props
const props = defineProps({
    destID: {
        type: Number,
        required: true,
    },
});

const { loadDestination } = DestinationLike();
const destination = ref(null);

// Tải dữ liệu khi component được mount
onMounted(async () => {
    // Sử dụng props.destID thay vì destID
    destination.value = await loadDestination(props.destID);
});
const navigate = (destination) => {
    if (destination.hotel_id != null) {
        navigateToDetailHotel(destination.hotel_id);
    }
    else if (destination.restaurant_id != null) {
        navigateToDetailRestaurant(destination.restaurant_id);
    }
    else {
        navigateToDetailPlace(destination.id);
    }
}
const navigateToDetailPlace = (id) => window.location.assign(`/Detail/Place/${id}`);
const navigateToDetailRestaurant = (restaurant_id) => window.location.assign(`/Detail/Restaurant/${restaurant_id}`);
const navigateToDetailHotel = (hotel_id) => window.location.assign(`/Detail/Hotel/${hotel_id}`);
</script>

<script>
import btn_heart from '../btn_heart.vue';
export default {
    name: "Favourite_Item",
    components: {
        btn_heart,
    },
};
</script>

<style scoped>
.favourite-item {
    width: 100%;
    color: #13357B;
    margin-bottom: 50px;
    font-size: 22px;
    border-radius: 20px;
    background-color: rgba(202, 240, 248, 0.2);
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .07), 0 6px 18px -1px rgba(19, 53, 123, .04) !important;
}

.favourite-item:hover {
    cursor: pointer;
    transition: 0.7ms ease-in-out;
    transform: translateY(-5px);
    background-color: #CAF0F8;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
}

.image {
    padding: 20px;
}

img {
    aspect-ratio: 16/9;
    height: 250px;
    object-fit: cover;
    border-radius: 10px;
}

.btn-heart {
    display: flex;
    margin-top: -235px;
    margin-left: 385px;
}

.name-of-location {
    font-size: 25px;
    font-weight: 600;
}
</style>