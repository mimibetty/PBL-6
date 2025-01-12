<template>
    <div class="container frame">
        <div class="float-button">
            <label class="toggle-switch">
                <input type="checkbox" v-model="isAllSelected" @change="selectAll">
                <span class="slider"></span>
            </label>
            <label class="select-all-label">{{ isAllSelected ? 'Deselect All' : 'Select All' }}</label>
            <label class="count-label">({{ selectedCount }}/{{ totalItems }})</label>
        </div>
    </div>
</template>

<script>
import CreateTripViewModel from '@/components/viewModels/Create_Trip_ViewModel/CreateTripViewModel';
export default {
    name: "Float_Button",
    props: {
        selectedCount: Number,
        totalItems: Number,
        isAllSelected: Boolean,
    },
    emits: ['update:isAllSelected'],
    setup() {
        const { isAllSelected } = CreateTripViewModel();
        return {
            isAllSelected
        }
    }
}
</script>

<style scoped>
.frame {
    display: flex;
    padding: 15px;
    background-color: #13357B;
    border-radius: 10px;
    box-shadow: 0px -5px 10px rgba(19, 53, 123, 0.25);
}
.float-button {
    display: flex;
    gap: 20px;
    align-items: center;
    justify-content: center;
}

.toggle-switch {
    position: relative;
    display: inline-block;
    width: 80px; /* Độ rộng của toggle */
    height: 34px; /* Chiều cao của toggle */
}

.toggle-switch input {
    opacity: 0; /* Ẩn checkbox thực */
    width: 0;
    height: 0;
}

.slider {
    position: absolute;
    cursor: pointer;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #EDF6F9; /* Màu nền khi không được chọn */
    transition: .4s; /* Hiệu ứng chuyển tiếp */
    border-radius: 34px; /* Bo tròn góc */
}

.slider:before {
    position: absolute;
    content: "";
    height: 26px; /* Chiều cao của "bánh xe" */
    width: 26px; /* Độ rộng của "bánh xe" */
    left: 4px; /* Vị trí "bánh xe" */
    bottom: 4px; /* Vị trí "bánh xe" */
    background-color: #0077b6; /* Màu nền của "bánh xe" */
    transition: .4s; /* Hiệu ứng chuyển tiếp */
    border-radius: 50%; /* Bo tròn "bánh xe" */
}


/* Hiệu ứng khi toggle được chọn */
input:checked + .slider {
    background-color: #a3bcf9; /* Màu nền khi được chọn */
}

input:checked + .slider:before {
    transform: translateX(45px); /* Di chuyển "bánh xe" sang bên phải khi được chọn */
}
label {
    color: #EDF6F9;
    font-size: 18px;
    font-weight: 900;
}
</style>