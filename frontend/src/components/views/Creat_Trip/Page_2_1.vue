<template>
    <div class="container-fluid-1">
        <div class="container-fluid p-2">
            <div class="container-fluid frame-title" style="width: 100vw;">
                <h1>When are you going?</h1>
                <h5>Choose month and trip length</h5>
            </div>
            <div class="container frame-items">
                <button v-for="(month, index) in allMonths" :key="index" class="item" @click="selectMonth(index)"
                    :class="{ selected: index === selectedMonthIndex }">
                    {{ month }}
                </button>
            </div>
            <div class="container-fluid frame-choose-length">
                <div class="container-fluid title d-flex align-items-center">
                    <p>How many days?</p>
                </div>
                <div class="container-fluid length">
                    <div class="button-1">
                        <svg width="40px" height="40px" @click="decreaseLength" :class="{ disabled: numberLength <= 1 }"
                            viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg"
                            xmlns:xlink="http://www.w3.org/1999/xlink"
                            xmlns:sketch="http://www.bohemiancoding.com/sketch/ns">
                            <title>minus-circle</title>
                            <desc>Created with Sketch Beta.</desc>
                            <defs></defs>
                            <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"
                                sketch:type="MSPage">
                                <g id="Icon-Set" sketch:type="MSLayerGroup"
                                    transform="translate(-516.000000, -1087.000000)" fill="#currentColor">
                                    <path
                                        d="M532,1117 C524.268,1117 518,1110.73 518,1103 C518,1095.27 524.268,1089 532,1089 C539.732,1089 546,1095.27 546,1103 C546,1110.73 539.732,1117 532,1117 L532,1117 Z M532,1087 C523.163,1087 516,1094.16 516,1103 C516,1111.84 523.163,1119 532,1119 C540.837,1119 548,1111.84 548,1103 C548,1094.16 540.837,1087 532,1087 L532,1087 Z M538,1102 L526,1102 C525.447,1102 525,1102.45 525,1103 C525,1103.55 525.447,1104 526,1104 L538,1104 C538.553,1104 539,1103.55 539,1103 C539,1102.45 538.553,1102 538,1102 L538,1102 Z"
                                        id="minus-circle" sketch:type="MSShapeGroup">
                                    </path>
                                </g>
                            </g>
                        </svg>
                    </div>
                    <span class="length-input">{{ numberLength }}</span>
                    <div class="button-1">
                        <svg width="40px" height="40px" @click="increaseLength" :class="{ disabled: numberLength >= 7 }"
                            viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg"
                            xmlns:xlink="http://www.w3.org/1999/xlink"
                            xmlns:sketch="http://www.bohemiancoding.com/sketch/ns">
                            <title>plus-circle</title>
                            <desc>Created with Sketch Beta.</desc>
                            <defs></defs>
                            <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"
                                sketch:type="MSPage">
                                <g id="Icon-Set" sketch:type="MSLayerGroup"
                                    transform="translate(-464.000000, -1087.000000)" fill="#currentColor">
                                    <path
                                        d="M480,1117 C472.268,1117 466,1110.73 466,1103 C466,1095.27 472.268,1089 480,1089 C487.732,1089 494,1095.27 494,1103 C494,1110.73 487.732,1117 480,1117 L480,1117 Z M480,1087 C471.163,1087 464,1094.16 464,1103 C464,1111.84 471.163,1119 480,1119 C488.837,1119 496,1111.84 496,1103 C496,1094.16 488.837,1087 480,1087 L480,1087 Z M486,1102 L481,1102 L481,1097 C481,1096.45 480.553,1096 480,1096 C479.447,1096 479,1096.45 479,1097 L479,1102 L474,1102 C473.447,1102 473,1102.45 473,1103 C473,1103.55 473.447,1104 474,1104 L479,1104 L479,1109 C479,1109.55 479.447,1110 480,1110 C480.553,1110 481,1109.55 481,1109 L481,1104 L486,1104 C486.553,1104 487,1103.55 487,1103 C487,1102.45 486.553,1102 486,1102 L486,1102 Z"
                                        id="plus-circle" sketch:type="MSShapeGroup"></path>
                                </g>
                            </g>
                        </svg>
                    </div>
                </div>
            </div>
            <div class="container-fluid frame-button px-5 py-2">
                <button class="button back" @click="goBack">Back</button>
                <button class="button next" @click="goNext">Next</button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
import DateViewModel from '@/components/viewModels/Create_Trip_ViewModel/date_ViewModel';
import { useTripStore } from '@/store/useTripStore';
import CreateTrip from '@/components/viewModels/CreateTripViewModel';

const dateViewModel = new DateViewModel();
const tripStore = useTripStore();
const router = useRouter();

const selectedMonthIndex = ref(null);
const allMonths = computed(() => dateViewModel.getAllMonthNames());
const numberLength = ref(1);
const monthChoose = ref(0);

const selectMonth = (index) => {
    selectedMonthIndex.value = index;
    dateViewModel.setSelectedMonth(index);
    const monthName = allMonths.value[index];
    monthChoose.value = monthName;
};

const { data, updateDetails } = CreateTrip();

const goBack = () => {
    router.push({ name: 'Page_1' });
};

const goNext = () => {
    updateDetails(monthChoose.value, numberLength.value);
    router.push({ name: 'Page_3' });
};

const decreaseLength = () => {
    if (numberLength.value > 1) numberLength.value--;
};

const increaseLength = () => {
    if (numberLength.value < 7) numberLength.value++;
};
</script>

<style scoped>
.container-fluid-1 {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 100vw;
    height: 100vh;
    margin: 0;
    padding: 0;
    overflow: hidden;
}

.frame-title {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    margin-top: 30px;
    color: #00B4D8;
}

.frame-title h1 {
    font-weight: 900;
    font-size: 4vw;
}

.frame-title h5 {
    color: #13357B;
}

.frame-items {
    margin-top: 50px;
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    grid-template-rows: repeat(3, 50px);
    width: 80vw;
    gap: 30px;
}

.item {
    border-radius: 50px;
    background-color: #EDF6F9;
    color: #13357B;
    border: 2px solid #13357B;
}

.item.selected {
    background-color: #13357B;
    color: #EDF6F9;
}

.frame-button {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 20px;
    margin-bottom: 20px;
}

.button {
    padding: 10px 50px;
    border: none;
    border-radius: 30px;
    background-color: #00B4D8;
    color: #EDF6F9;
    cursor: pointer;
    transition: background-color 0.3s ease;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.2);
}

button:hover {
    background-color: #13357B;
    color: #EDF6F9
}

.frame-dates {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 50px;
    color: #13357B;
    font-size: 20px;
    text-decoration: underline;
    text-underline-offset: 7px;
    cursor: pointer;
}

.frame-dates:hover {
    color: #00B4D8
}

.frame-choose-length {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 35px;
    font-size: 20px;
}

.title {
    color: #13357B;
    text-decoration: underline;
    text-underline-offset: 7px;
    margin-left: 30%;
    font-size: 1.5vw;
}

.length-input {
    background-color: transparent;
    border: none;
    text-align: center;
    font-size: 1.5vw;
}

.length {
    display: flex;
    justify-content: flex-end;
    align-items: center;
    margin-right: 30%;
    gap: 10px;
    color: #13357B;
}

.length span {
    font-size: 20px;
    min-width: 50px;
    align-self: center
}

.length #Icon-Set {
    fill: #13357B;
    cursor: pointer;
}

.length .button-1:hover #Icon-Set {
    fill: #00B4D8;
}

.length .disabled #Icon-Set {
    cursor: not-allowed;
    opacity: 0.5;
}
</style>