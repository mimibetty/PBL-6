<template>
    <div class="frame-item-tour">
        <div class="frame-image">
            <img :src="images && images[0] ? images[0].url : '/blue-image.jpg'" alt="">
        </div>
        <div class="frame-infor">
            <div class="frame-title">
                <div class="location">
                    <div class="svg-location">
                        <svg width="30px" height="30px" viewBox="0 0 24 24" fill="none"
                            xmlns="http://www.w3.org/2000/svg">
                            <path fill-rule="evenodd" clip-rule="evenodd"
                                d="M12.2848 18.9935C12.1567 19.0875 12.0373 19.1728 11.9282 19.2493C11.8118 19.1721 11.6827 19.0833 11.5427 18.9832C10.8826 18.5109 10.0265 17.8176 9.18338 16.9529C7.45402 15.1792 6 12.9151 6 10.5C6 7.18629 8.68629 4.5 12 4.5C15.3137 4.5 18 7.18629 18 10.5C18 12.8892 16.4819 15.1468 14.6893 16.9393C13.8196 17.8091 12.9444 18.5099 12.2848 18.9935ZM19.5 10.5C19.5 16.5 12 21 12 21C11.625 21 4.5 16.5 4.5 10.5C4.5 6.35786 7.85786 3 12 3C16.1421 3 19.5 6.35786 19.5 10.5ZM13.5 10.5C13.5 11.3284 12.8284 12 12 12C11.1716 12 10.5 11.3284 10.5 10.5C10.5 9.67157 11.1716 9 12 9C12.8284 9 13.5 9.67157 13.5 10.5ZM15 10.5C15 12.1569 13.6569 13.5 12 13.5C10.3431 13.5 9 12.1569 9 10.5C9 8.84315 10.3431 7.5 12 7.5C13.6569 7.5 15 8.84315 15 10.5Z"
                                fill="#13357B" />
                        </svg>
                    </div>
                    <div class="name-location">
                        {{ city?.name }}
                    </div>
                </div>
                <div class="rating">
                    <div class="rating-number">{{ (tour?.rating).toFixed(1) }}</div>
                    <div class="svg-star">
                        <svg width="30px" height="30px" viewBox="0 0 24 24" fill="none"
                            xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M11.245 4.174C11.4765 3.50808 11.5922 3.17513 11.7634 3.08285C11.9115 3.00298 12.0898 3.00298 12.238 3.08285C12.4091 3.17513 12.5248 3.50808 12.7563 4.174L14.2866 8.57639C14.3525 8.76592 14.3854 8.86068 14.4448 8.93125C14.4972 8.99359 14.5641 9.04218 14.6396 9.07278C14.725 9.10743 14.8253 9.10947 15.0259 9.11356L19.6857 9.20852C20.3906 9.22288 20.743 9.23007 20.8837 9.36432C21.0054 9.48051 21.0605 9.65014 21.0303 9.81569C20.9955 10.007 20.7146 10.2199 20.1528 10.6459L16.4387 13.4616C16.2788 13.5829 16.1989 13.6435 16.1501 13.7217C16.107 13.7909 16.0815 13.8695 16.0757 13.9507C16.0692 14.0427 16.0982 14.1387 16.1563 14.3308L17.506 18.7919C17.7101 19.4667 17.8122 19.8041 17.728 19.9793C17.6551 20.131 17.5108 20.2358 17.344 20.2583C17.1513 20.2842 16.862 20.0829 16.2833 19.6802L12.4576 17.0181C12.2929 16.9035 12.2106 16.8462 12.1211 16.8239C12.042 16.8043 11.9593 16.8043 11.8803 16.8239C11.7908 16.8462 11.7084 16.9035 11.5437 17.0181L7.71805 19.6802C7.13937 20.0829 6.85003 20.2842 6.65733 20.2583C6.49056 20.2358 6.34626 20.131 6.27337 19.9793C6.18915 19.8041 6.29123 19.4667 6.49538 18.7919L7.84503 14.3308C7.90313 14.1387 7.93218 14.0427 7.92564 13.9507C7.91986 13.8695 7.89432 13.7909 7.85123 13.7217C7.80246 13.6435 7.72251 13.5829 7.56262 13.4616L3.84858 10.6459C3.28678 10.2199 3.00588 10.007 2.97101 9.81569C2.94082 9.65014 2.99594 9.48051 3.11767 9.36432C3.25831 9.23007 3.61074 9.22289 4.31559 9.20852L8.9754 9.11356C9.176 9.10947 9.27631 9.10743 9.36177 9.07278C9.43726 9.04218 9.50414 8.99359 9.55657 8.93125C9.61593 8.86068 9.64887 8.76592 9.71475 8.57639L11.245 4.174Z"
                                stroke="#13357B" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                        </svg>
                    </div>
                </div>
            </div>
            <div class="name-of-tour">
                <h5>{{ tour?.name }}</h5>
            </div>
            <div class="detail">
                <div class="frame-days">
                    <svg width="30px" height="30px" viewBox="0 0 19 19" xmlns="http://www.w3.org/2000/svg">
                        <path fill="#13357B" fill-rule="evenodd"
                            d="M161.960546,159.843246 L164.399107,161.251151 C164.637153,161.388586 164.71416,161.70086 164.580127,161.933013 C164.442056,162.172159 164.144067,162.258604 163.899107,162.117176 L161.419233,160.68542 C161.165323,160.8826 160.846372,161 160.5,161 C159.671573,161 159,160.328427 159,159.5 C159,158.846891 159.417404,158.291271 160,158.085353 L160,153.503423 C160,153.22539 160.231934,153 160.5,153 C160.776142,153 161,153.232903 161,153.503423 L161,158.085353 C161.582596,158.291271 162,158.846891 162,159.5 C162,159.6181 161.986351,159.733013 161.960546,159.843246 Z M160.5,169 C165.746705,169 170,164.746705 170,159.5 C170,154.253295 165.746705,150 160.5,150 C155.253295,150 151,154.253295 151,159.5 C151,164.746705 155.253295,169 160.5,169 Z M160.5,168 C165.19442,168 169,164.19442 169,159.5 C169,154.80558 165.19442,151 160.5,151 C155.80558,151 152,154.80558 152,159.5 C152,164.19442 155.80558,168 160.5,168 Z"
                            transform="translate(-151 -150)" />
                    </svg>
                    <p>{{ (tour.duration / 24).toFixed(1) }} {{ (tour.duration / 24).toFixed(1) == 1 ? 'day' : 'days' }}
                    </p>
                </div>
            </div>
            <div class="line"></div>
            <div class="name-of-tour ">
                <p class="text-truncated">{{ tour?.description }}</p>
            </div>
        </div>
    </div>
</template>
<script setup>
import { defineProps, ref, watchEffect } from 'vue';

// Định nghĩa props
const props = defineProps({
    tour: {
        type: Object,
        required: true,
    },
    city: {
        type: Object,
        required: false,
        default: () => ({}), // Truyền một đối tượng rỗng nếu không có giá trị
    },
});

// Mảng images
const images = ref([]);

// Sử dụng watchEffect để phản ứng với sự thay đổi của tour
watchEffect(() => {
    images.value = []; // Đặt lại mảng images mỗi khi tour thay đổi
    if (props.tour?.destinations?.length) {
        props.tour.destinations.forEach(destination => {
            if (destination.images?.length) {
                destination.images.forEach(image => {
                    images.value.push(image); // Thêm từng ảnh vào mảng images
                });
            }
        });
    }
});
</script>

<style scoped>
.frame-item-tour {
    color: #13357B;
    border-radius: 30px;
    height: 100%;
    width: 100%;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.2);
    transition: 0.7ms ease-in-out;
}

.frame-item-tour:hover {
    cursor: pointer;
    transition: 0.7ms ease-in-out;
    transform: translateY(-5px);
    background-color: #CAF0F8;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
}

.frame-image {
    display: flex;
}

.frame-image img {
    width: 100%;
    height: 200px;
    object-fit: cover;
    aspect-ratio: 16 / 9;
}

.btn-heart {
    margin: 10px 0px 0 -72px;
    z-index: 16;
}

.frame-infor {
    display: flex;
    flex-direction: column;
    gap: 10px;
    padding: 20px;
}

.frame-title {
    display: flex;
    justify-content: space-between;
    font-size: 18px;
}

.location {
    display: flex;
    gap: 3px;
    align-items: baseline;
}

.rating {
    display: flex;
    gap: 3px;
    align-items: center;
}

.name-of-tour h5 {
    font-weight: 900;
    font-size: 22px;
}

.detail {
    display: flex;
    gap: 10px;
    justify-content: space-between;
}

.frame-person,
.frame-days {
    display: flex;
    gap: 3px;
}

.line {
    background-color: #13357B;
    width: 100%;
    height: 1px;
    border-radius: 5px;
}

.frame-price span {
    font-size: 20px;
    font-weight: 900
}

.text-truncated {
    display: -webkit-box;
    /* Hiển thị như một hộp linh hoạt */
    -webkit-line-clamp: 2;
    /* Giới hạn số dòng hiển thị (ở đây là 2 dòng) */
    -webkit-box-orient: vertical;
    /* Hướng của hộp là dọc */
    overflow: hidden;
    /* Ẩn phần nội dung vượt quá */
    text-overflow: ellipsis;
    /* Thêm dấu "..." ở cuối khi bị cắt */
    white-space: normal;
    /* Cho phép ngắt dòng */
}
</style>