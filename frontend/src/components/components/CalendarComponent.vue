<template>
    <div>
      <h3>Select your dates</h3>
      <div class="calendar">
        <div
          v-for="(day, index) in daysInMonth"
          :key="index"
          :class="['day', { selected: isSelected(day) }]"
          @click="toggleDateSelection(day)"
        >
          {{ day.getDate() }}
        </div>
      </div>
      <p v-if="selectedDates.length > 0">Selected Dates: {{ formattedDateRange }}</p>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        selectedDates: [],
        currentMonth: new Date().getMonth(),
        currentYear: new Date().getFullYear(),
      };
    },
    computed: {
      daysInMonth() {
        const days = [];
        const date = new Date(this.currentYear, this.currentMonth, 1);
        while (date.getMonth() === this.currentMonth) {
          days.push(new Date(date));
          date.setDate(date.getDate() + 1);
        }
        return days;
      },
      formattedDateRange() {
        if (this.selectedDates.length < 2) return 'Select at least two dates';
        const [start, end] = this.selectedDates;
        return `${start.toDateString()} - ${end.toDateString()}`;
      },
    },
    methods: {
      toggleDateSelection(day) {
        const selectedDateIndex = this.selectedDates.findIndex(
          (d) => d.getTime() === day.getTime()
        );
  
        if (selectedDateIndex >= 0) {
          this.selectedDates.splice(selectedDateIndex, 1);
        } else if (this.selectedDates.length < 2) {
          this.selectedDates.push(day);
          this.selectedDates.sort((a, b) => a - b);
        } else {
          this.selectedDates = [day];
        }
        
        this.$emit('selectDateRange', this.selectedDates);
      },
      isSelected(day) {
        return this.selectedDates.some((d) => d.getTime() === day.getTime());
      },
    },
  };
  </script>
  
  <style scoped>
  .calendar {
    display: flex;
    flex-wrap: wrap;
    width: 200px;
  }
  .day {
    width: 25px;
    height: 25px;
    line-height: 25px;
    text-align: center;
    margin: 2px;
    cursor: pointer;
    border-radius: 50%;
  }
  .day.selected {
    background-color: #007bff;
    color: #fff;
  }
  </style>
  