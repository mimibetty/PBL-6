<template>
    <div class="container-fluid calendar">
        <div class="container-fluid">
            <div class="container-fluid frame-calendar">
                <div class="prev-month">
                    <button class="btn prev" @click="prevMonth">
                        <svg width="35px" height="35px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M19 9L14 14.1599C13.7429 14.4323 13.4329 14.6493 13.089 
                            14.7976C12.7451 14.9459 12.3745 15.0225 12 15.0225C11.6255 15.0225 
                            11.2549 14.9459 10.9109 14.7976C10.567 14.6493 10.2571 14.4323 10 
                            14.1599L5 9" stroke="#currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </button>
                    <div class="container-fluid frame month-year-1">
                        <div class="container-fluid month-year">
                            <span>{{ currentMonthName }}</span>
                            <span> - </span>
                            <span>{{ currentYear }}</span>
                        </div>
                        <div class="container-fluid day">
                            <p>Sun</p>
                            <p>Mon</p>
                            <p>Tue</p>
                            <p>Wed</p>
                            <p>Thu</p>
                            <p>Fri</p>
                            <p>Sat</p>
                        </div>
                        <div class="container-fluid frame-1">
                            <button v-for="(day, index) in monthDays" 
                                    :key="index">
                                {{ day }}
                            </button>
                        </div>
                    </div>
                </div>
                <div class="next-month">
                    <div class="container-fluid frame month-year-2">
                        <div class="container-fluid month-year">
                            <span>{{ nextMonthName }}</span>
                            <span> - </span>
                            <span>{{ nextYear }}</span>
                        </div>
                        <div class="container-fluid day">
                            <p>Sun</p>
                            <p>Mon</p>
                            <p>Tue</p>
                            <p>Wed</p>
                            <p>Thu</p>
                            <p>Fri</p>
                            <p>Sat</p>
                        </div>
                        <div class="container-fluid frame-1">
                            <button v-for="(day, index) in nextMonthDays" 
                                    :key="index">
                                {{ day }}
                            </button>
                        </div>
                    </div>
                    <button class="btn next" @click="nextMonth">
                        <svg width="35px" height="35px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M19 9L14 14.1599C13.7429 14.4323 13.4329 14.6493 13.089 
                            14.7976C12.7451 14.9459 12.3745 15.0225 12 15.0225C11.6255 15.0225 
                            11.2549 14.9459 10.9109 14.7976C10.567 14.6493 10.2571 14.4323 10 
                            14.1599L5 9" stroke="#currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import DateViewModel from '@/components/viewModels/Create_Trip_ViewModel/date_ViewModel';
export default {
    name: "Calendar",
    data () {
        return {
            dateViewModel: new DateViewModel()
        }
    },
    computed: {
        // Get days for the current month
        monthDays() {
            return this.dateViewModel.getMonthDays(this.dateViewModel.model.month, this.dateViewModel.model.year);
        },
        // Get name of the current month
        currentMonthName() {
            return this.dateViewModel.getCurrentMonthName();
        },
        // Get year of the current month
        currentYear() {
            return this.dateViewModel.getCurrentYear();
        },
        // Get days for the next month
        nextMonthDays() {
            const { nextMonth, nextYear } = this.dateViewModel.model.getNextMonth();
            return this.dateViewModel.getNextMonthDays(nextMonth, nextYear);
        },
        // Get name of the next month
        nextMonthName() {
            return this.dateViewModel.getNextMonthName();
        },
        // Get year of the next month
        nextYear() {
            return this.dateViewModel.getNextYear();
        },
        // Check if Prev button should be disabled
        isPrevDisabled() {
            return !this.dateViewModel.isNextMonthValid();
        }
    },
    methods: {
        // Chuyển tháng tới
        nextMonth() {
            this.dateViewModel.updateMonth('next');
        },
        // Chuyển tháng về
        prevMonth() {
            if (!this.isPrevDisabled) {
                this.dateViewModel.updateMonth('prev');
            }
        },
    },
}
</script>

<style scoped>
.frame-calendar {
    display: grid;
    grid-template-columns: 45% 45%;
    gap: 10%;
    color: #13357B;
}
.prev-month, .next-month {
    display: flex;
    gap: 25px;
}
.btn {
    border: 3px solid #13357B;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 110px;
    height: 65px;
    background-color: transparent;
}
.prev {
    transform: rotate(90deg);
    stroke: #13357B;
}
.next {
    transform: rotate(-90deg);
    stroke: #13357B;
}
.frame {
    display: flex;
    flex-direction: column;
    gap: 15px;
    padding: 10px;
}
.month-year {
    display: flex;  
    justify-content: space-around;
    font-size: 25px;
}
.day {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    grid-template-rows: repeat(1, 1fr);
    border-radius: 10px;
    width: 100%;
    gap: 20px;
}
.day p {
    font-size: 20px;
    display: flex;
    justify-content: center;
    min-width: 58.5px;
}
.frame-1{
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    grid-template-rows: repeat(6, 1fr);
    border-radius: 10px;
    width: 100%;
    gap: 25px;
}
.frame-1 button {
    color: #13357B;
    background-color: transparent;
    border: none;
    font-size: 20px;
    height: 55px;
    border-radius: 50%;
}
.frame-1 button:hover {
    background-color: #00B4D8;
    color: #EDF6F9;
}
.frame-1 button.highlighted {
    background-color: #CAF0F8; /* Màu nền cho các ngày nằm giữa */
    color: #13357B;
}
.frame-1 button.active {
    background-color: #8ecae6;
    color: #EDF6F9;
}
</style>
