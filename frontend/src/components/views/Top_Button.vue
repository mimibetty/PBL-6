<template>
    <div class="container-fluid topper">
        <div class="row">
            <div class="text-center text-lg-start">
                <div class="d-inline-flex align-items-center row" style="height: 50px; padding: 0 10px;">
                    <button 
                        v-for="button in buttons" 
                        :key="button.key" 
                        class="col me-3"
                        @click="handleButtonClick(button.key)">
                        {{ button.label }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>


<script>
    import '@fortawesome/fontawesome-free/css/all.css';
    import 'bootstrap-icons/font/bootstrap-icons.css';
    import topButton_ViewModel from '../viewModels/topButton_ViewModel';
    import { useRouter } from 'vue-router';
    export default {
    name: "Top_Button",
    props: {
        cityID: Number,
    },
    setup(props) {
        const router = useRouter(); // Khởi tạo router để điều hướng

        const handleButtonClick = (key) => {
            switch (key) {
                case 'things-to-do':
                    if (props.cityID) {
                        router.push(`/ThingsToDo/${props.cityID}`);
                    } else {
                        router.push('/ThingsToDo');
                    }
                    break;
                case 'resorts-hotels':
                    if (props.cityID) {
                        router.push(`/Hotels/${props.cityID}`);
                    } else {
                        router.push('/Hotels');
                    }
                    break;
                case 'restaurants':
                    if (props.cityID) {
                        router.push(`/Restaurants/${props.cityID}`);
                    } else {
                        router.push('/Restaurants');
                    }
                    break;
                case 'name': // City label
                    if (props.cityID) {
                        router.push(`/Destination/${props.cityID}`);
                    }
                    break;
                default:
                    console.warn(`Unhandled button key: ${key}`);
                    break;
            }
        };

        const { buttons } = topButton_ViewModel(props.cityID);

        return {
            buttons,
            handleButtonClick,
        };
    },
};
</script>
<style scoped>
.container-fluid {
    width: 100%;
    position: fixed;
    top: -20px;
    left: 0;
    border-bottom: 1px solid #13357B;
    background-color: #EDF6F9;
    z-index: 99;
}
.topper {
    margin-top: 90px;
    left: 0;
    width: 100%;
    border-bottom: 1px solid #13357B;
    z-index: 99;
}

.topper{
    padding-top: 25px;
    padding-bottom: 15px;
}
.topper button {
    position: relative;
    color: #13357B;
    font-size: 21px;
    padding: 6px 20px;
    border: none;
    width: 200px;
    background-color: transparent;
}

.topper button:hover {
    color: #EDF6F9;
    background-color: #13357B;
    border-radius: 10px;
}


.topper button:focus {
    outline: none; /* Loại bỏ đường viền focus mặc định */
}

.topper button:focus::after {
    content: "";
    position: absolute;
    bottom: -13.75px; /* Điều chỉnh khoảng cách từ nút đến đường viền */
    left: 0;
    right: 0;
    height: 3px;
    background-color: #13357B;
    border-radius: 1px; /* Bo tròn hai đầu của đường viền dưới */
}

.topper button.active {
    content: "";
    position: absolute;
    bottom: -13.75px; /* Điều chỉnh khoảng cách từ nút đến đường viền */
    left: 0;
    right: 0;
    height: 3px;
    background-color: #13357B;
    border-radius: 1px; /* Bo tròn hai đầu của đường viền dưới */
}

</style>