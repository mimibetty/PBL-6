<template>
    <div class="create-trip-container" >
        <div v-if="currentStep === 1">
            <h2 class="title">Where do you want to go?</h2>
            <form class="search-container" @submit.prevent="searchDestinations">
                <input
                    type="text"
                    v-model="searchQuery"
                    placeholder="Attraction, activities or destination"
                    class="search-input"
                />
                <button type="submit" class="search-button">Search</button>
            </form>
            <div class="suggestions-grid">
                <div
                    v-for="(destination, index) in suggestedDestinations.slice(0, 4)"
                    :key="index"
                    class="suggestion-card"
                    @click="selectDestination(destination)"
                >
                    <img :src="destination.imageUrl" alt="Destination Image" class="destination-image" />
                    <p class="destination-name">{{ destination.name }}</p>
                </div>
            </div>
            <button @click="goToCalendar" class="next-button">Next</button>
        </div>

        <div v-else-if="currentStep === 2">
            <h2 class="title">Select Your Travel Dates</h2>
            <VueDatePicker
                v-model="rawSelectedDates"
                range
                color="primary"
                :multiCalendars="2"
                :active-picker.sync="activePicker"
                @change="onDateChange"
                :enableTime="false" 
                :format="'dd/MM/yyyy'"
                class="calendar"
                show-current="false"
            />
            <button @click="goToDestinationSelection" class="back-button">Back</button>
            <button @click="gotoTopic" class="next-button">Next</button>
        </div>
        <div v-else-if="currentStep === 3">
            <h2 class="title">Tell us what you’re interested in</h2>
            <h3 class="title-detail">Select all that apply</h3>
            <div class="topics">
                <button
                    v-for="(topic, index) in topics"
                    :key="index"
                    :class="['topic-button', { selected: selectedTopics.includes(topic) }]"
                    @click="toggleTopic(topic)"
                >
                    {{ topic }}
                </button>
            </div>
            <button @click="goToCalendar" class="back-button">Back</button>
            <button @click="gotoPickPlace" class="next-button">Next</button>
        </div>
        <div v-else-if="currentStep === 4">
            <h2 class="cities">Danang</h2>
            <h3 class="cities-title">Exploring the Cultural Heritage and Natural Beauty in Viet Nam</h3>
            <div class="places-grid">
                <div v-for="(place, index) in places" :key="index" class="place-card">
                    <img :src="place.imageUrl" alt="Place Image" class="place-image" />
                    <div class="pick-button" @click="togglePickStatus(place.id)">
                        <img :src="picked[place.id] ? pickFull : pickEmpty" alt="pick icon" class="pick-icon" />
                    </div>   
                    <div class="place-detail">
                        <p class="place-name">{{ place.name }}</p>
                        <div class="rating">
                            <img v-for="star in generateStars(place.rating)" :src="star" class="star" />
                        </div>
                        <div class="pick-button" @click="togglePickStatus(place.id)">
                            <img :src="picked[place.id] ? pickFull : pickEmpty" alt="pick icon" class="pick-icon" />
                        </div>
                    </div>     
                </div>
            </div>
            <h3 class="cities-title">Local Restaurant Picks</h3>
            <div class="places-grid">
                <div v-for="(restaurant, index) in restaurants" :key="index" class="place-card">
                    <img :src="restaurant.imageUrl" alt="Restaurant Image" class="place-image" />
                    <div class="pick-button" @click="togglePickStatus(restaurant.id)">
                        <img :src="picked[restaurant.id] ? pickFull : pickEmpty" alt="pick icon" class="pick-icon" />
                    </div>
                    <div class="place-detail">
                        <p class="place-name">{{ restaurant.name }}</p>
                        <div class="rating">
                            <img v-for="star in generateStars(restaurant.rating)" :src="star" class="star" />
                        </div>
                    </div>
                    
                </div>
            </div>
            <h3 class="cities-title">Place to stay</h3>
            <div class="places-grid">
                <div v-for="(hotel, index) in hotels" :key="index" class="place-card">
                    <img :src="hotel.imageUrl" alt="Hotel Image" class="place-image" />
                    <div class="pick-button" @click="togglePickStatus(hotel.id)">
                        <img :src="picked[hotel.id] ? pickFull : pickEmpty" alt="pick icon" class="pick-icon" />
                    </div>
                    <div class="place-detail">
                        <p class="place-name">{{ hotel.name }}</p>
                        <div class="rating">
                            <img v-for="star in generateStars(hotel.rating)" :src="star" class="star" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="selection-bar">
                <label class="toggle-switch">
                    <input type="checkbox" v-model="isAllSelected" @change="selectAll" /> <!-- Checkbox làm toggle -->
                        <span class="slider"></span> <!-- Phần slider của toggle -->
                </label>
                <label class="select-all-label">{{ isAllSelected ? 'Deselect All' : 'Select All' }}</label>
                <label class="count-label">{{ selectedCount }}/{{ totalItems }}</label>
            </div>
            
            <button @click="gotoTopic" class="back-button">Back</button>
            <button @click="gotoChoosePlanning" class="next-button">Next</button>
        </div>
        <div v-else-if="currentStep === 5">
            <h2 class="title">Continue planning your trip</h2>
            <h3 class="title-detail">Save your selections and get inspired with more more guidance</h3>
            <div class="button-container">
                <button @click="createItinerary" class="option-button">
                    <!-- <img src="@/assets/svg/travel.svg" alt="Icon 1" class="button-icon" /> -->
                    <div>
                        <h3 class="button-title">Create an itinerary</h3>
                        <p class="button-info">We'll smartly organize your picks into a daily itinerary you can edit and add to.</p>
                    </div>
                </button>

                <button @click="saveForLater" class="option-button">
                    <img src="@/assets/svg/heart-none.svg" alt="Icon 2" class="button-icon" />
                    <div>
                        <h3 class="button-title">Just save for now</h3>
                        <p class="button-info">We’ll keep all your selections together in a trip you can review, organize, and create an itinerary later.</p>
                    </div>
                </button>
            </div>
            <button @click="gotoPickPlace" class="back-button">Back</button>
            
        </div>
        <div v-else-if="currentStep === 6">
            <h2 class="title">Name your trip</h2>
            <h3 class="title-detail">Organize your saves and create a custom itinerary</h3>
            <form class="search-container" @submit.prevent="finishItinerary">
                <input
                    type="text"
                    v-model="itineraryName"
                    placeholder="Your ItineraryName"
                    class="itinerary-input"
                />
                <button type="submit" class="next-button">Create Itinerary</button>
            </form>
            <button @click="gotoChoosePlanning" class="back-button">Back</button>
            
        </div>
    </div>
</template>

<script setup>
import CreateTripViewModel from '../viewModels/Create_Trip_ViewModel/CreateTripViewModel';
import VueDatePicker from '@vuepic/vue-datepicker';
import '@vuepic/vue-datepicker/dist/main.css';

const {
    searchQuery,
        suggestedDestinations,
        searchDestinations,
        goToCalendar,
        goToDestinationSelection,
        gotoTopic,
        gotoPickPlace,
        currentStep,
        selectedDates,
        activePicker,
        onDateChange,
        rawSelectedDates,
        startDay,
        endDay,
        topics,
        selectedTopics,
        toggleTopic,
        destinations,
        places,
        attractions,
        hotels,
        restaurants,
        generateStars,
        picked,
        togglePickStatus,
        pickFull,
        pickEmpty,
        
        selectedCount,
        totalItems,
        selectAll,
        gotoChoosePlanning,
        createItinerary,
        saveForLater,
        itineraryName,
        finishItinerary
        
} = CreateTripViewModel();
</script>



  
  <style scoped>
  .create-trip-container {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    min-height: 100%;
    margin: 0 auto;
    background: #edf6f9;
    overflow: hidden;
    border-radius: 20px;
}


  
  .title {
      font-size: 4vw; /* Scale font-size with viewport width */
      color: #00bcd4;
      margin-bottom: 2vh; /* Scale margin with viewport height */
      text-align: center;
      margin-top: 20px;
  }
  
  .search-container {
    display: flex;
    align-items: center;
    
    margin-top: 100px;
    margin-left: 20vw;
    margin-right: 20vw;
    justify-content: center;
    width: 60vw;
    
    margin-bottom: 2vh;
    padding: 1vh;
    border: 1px solid #006494;
    border-radius: 30px;
    background-color: #f0f8ff;
}

.search-input {
    flex: 1;
    padding: 1.5vh;
    border: none;
    outline: none;
    font-size: 2vw;
    color: #0099cc;
    background-color: transparent;
}

.search-button {
    background-color: #006494;
    color: #fff;
    padding: 1vh 2vw;
    border: none;
    border-radius: 20px;
    cursor: pointer;
    font-size: 2vw;
}

.suggestions-grid {
    display: flex;
    gap: 2vw;
    margin-top: 2vh;
    flex-wrap: wrap;
    justify-content: center;
    width: 100%;
}

.suggestion-card {
    text-align: center;
    width: 15vw;
}

.destination-image {
    width: 10vw;
    height: 10vw;
    border-radius: 1vh;
    object-fit: cover;
}

.destination-name {
    margin-top: 0.5vh;
    font-size: 1.5vw;
    color: #333;
}


  
.calendar {
    background-color: #e3f2fd; /* Soft blue background */
    color: #1a237e; /* Dark blue text for readability */
    border-radius: 12px;
    margin-left: 20%;
    margin-right: 20%;
    margin-top: 10%;
    width: 60%;
    padding: 16px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Soft shadow for elevation */
}

/* Header styling for the month and navigation arrows */
.calendar .vc-nav-header {
    color: #1a237e;
    font-weight: bold;
    font-size: 1.4em;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 10px;
}

/* Styling for days in the calendar */
.calendar .vc-day {
    color: #1a237e; /* Regular day color */
    font-weight: 500;
    padding: 10px;
    margin: 2px;
    border-radius: 50%; /* Make days circular */
    transition: background-color 0.3s, color 0.3s;
    cursor: pointer;
}

/* Styling for hovered day */
.calendar .vc-day:hover {
    background-color: #bbdefb; /* Light blue hover */
    color: #1a237e;
}

/* Styling for selected day */
.calendar .vc-day.selected {
    background-color: #0d47a1; /* Dark blue for selected day */
    color: white;
    font-weight: bold;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
}

/* Disabled days style */
.calendar .vc-day.disabled {
    color: #90a4ae;
    background-color: transparent;
    cursor: not-allowed;
}

/* Style for the 'Select' and 'Cancel' buttons */
.calendar .vc-actions button {
    background-color: #1a237e;
    color: white;
    border-radius: 20px;
    padding: 8px 16px;
    font-size: 0.9em;
    cursor: pointer;
    margin: 0 6px;
    transition: background-color 0.3s ease;
}

.calendar .vc-actions button:hover {
    background-color: #3949ab; /* Darker on hover */
}

/* Separate style for the 'Cancel' button */
.calendar .vc-actions .vc-btn-cancel {
    background-color: #e0e0e0;
    color: #455a64;
}

.calendar .vc-actions .vc-btn-cancel:hover {
    background-color: #cfd8dc;
    color: #263238;
}

/* Navigation arrows */
.calendar .vc-nav-btn {
    color: #1a237e;
    font-size: 1.2em;
    padding: 6px;
    transition: color 0.2s ease;
}

.calendar .vc-nav-btn:hover {
    color: #0d47a1;
}






.back-button, .next-button {
    position: absolute; /* Không cố định, nằm dưới phần tử cuối */
    margin-top: 20px;
    bottom: 100px;
    padding: 12px 24px;
    font-size: 1.2em;
    font-weight: bold;
    border: none;
    border-radius: 30px;
    color: #fff;
    cursor: pointer;
    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
    display: inline-block; /* Để căn chỉnh các nút ở cuối */
}

.back-button {
    left: 100px;
    background-color: #888;
}

.back-button:hover {
    background-color: #666;
}

.next-button {
    right: 100px;
    background-color: #00bcd4;
}

.next-button:hover {
    background-color: #0088a9;
}
.title-detail{
    font-size: 2vw; /* Scale font-size with viewport width */
    color: #1a237e;
    margin-bottom: 1.5vh; /* Scale margin with viewport height */
    text-align: center;
    margin-top: 20px;
}

.topics {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    grid-auto-rows: auto;
    width: 45%;
    margin: 0 auto; /* Center horizontally */
    gap: 10px;
    justify-content: center;
}

.topic-button {
    padding: 10px 20px;
    border: 5px solid #2a4f8d;
    border-radius: 40px;
    background-color: #f5faff;
    color: #2a4f8d;
    font-weight: 700;
    font-size: 1.2vw;
    cursor: pointer;
    text-align: center;
}

.topic-button.selected {
    background-color: #2a4f8d;
    color: #fff;
}



.cities{
    font-size: 2.25vw; /* Scale font-size with viewport width */
    color: #030842;
    margin-bottom: 1.5vh; /* Scale margin with viewport height */
    text-align: left;
    margin-top: 50px;
    font-weight: 700;
    margin-left: 15%;
}

.cities-title{
    font-size: 2vw; /* Scale font-size with viewport width */
    color: #030842;
    text-align: left;
    margin-top: 30px;
    font-weight: 600;
    margin-left: 15%;
}

.places-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    justify-content: center;
    margin: 0 auto;
    width: 70%;
    margin-top: 20px;
    margin-bottom: 300px;
}

.place-card {
    position: relative; /* Ensure pick button is positioned within card */
    text-align: center;
    border: 1px solid #ccc;
    border-radius: 10px;
    padding: 10px;
    background-color: none;
}

.place-image {
    width: 100%;
    height: 90%;
    border-radius: 5px;
    object-fit: cover;
}
.place-detail {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 5px; 
}

.place-name {
    font-size: 1vw;
    color: #333;
    font-weight: bold;
    margin-left: 5px;
    
}

.rating {
    display: flex;
    margin-right: 5px;
}
.star {
  width: 20px;
  height: 20px;
}

.pick-button {
    position: absolute;
    top: 8px; /* Position near the top */
    right: 8px; /* Position near the right */
    width: 40px;
    height: 40px;
    background-color: none;
    border-radius: 50%;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 10; /* Ensure button appears above other content */
}

.pick-icon {
    width: 40px;
    height: 40px;
}

.selection-bar {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    position: fixed;
    bottom: 20px;
    left: 50%;
    width: 40%;
    transform: translateX(-50%);
    padding: 10px 20px;
    background-color: #6398e7; /* Màu nền chính */
    border-radius: 10px; /* Bo tròn góc */
    color: #520ed1; /* Màu chữ */
    font-size: 1.5vw;
    font-weight: 800;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3); /* Đổ bóng cho thanh */
    transition: background-color 0.3s ease; /* Hiệu ứng chuyển tiếp cho màu nền */
}

.selection-bar:hover {
    background-color: #0097a7; /* Thay đổi màu khi hover */
}

.select-all-label {
    cursor: pointer; /* Chỉ thị rằng có thể nhấn vào */
    font-weight: 700;
    transition: color 0.3s; /* Hiệu ứng chuyển tiếp cho màu chữ */
}



.count-label {
    margin-left: 70px; /* Khoảng cách giữa các nhãn */
    font-weight: 600;
    font-size: 0.9em; /* Giảm kích thước chữ cho nhãn đếm */
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
    background-color: #ccc; /* Màu nền khi không được chọn */
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
    background-color: white; /* Màu nền của "bánh xe" */
    transition: .4s; /* Hiệu ứng chuyển tiếp */
    border-radius: 50%; /* Bo tròn "bánh xe" */
}

/* Hiệu ứng khi toggle được chọn */
input:checked + .slider {
    background-color: rgb(9, 3, 70); /* Màu nền khi được chọn */
}

input:checked + .slider:before {
    transform: translateX(45px); /* Di chuyển "bánh xe" sang bên phải khi được chọn */
}

.button-container {
    display: flex;
    flex-direction: column;
    gap: 20px;
    margin: 40px auto;
    width: 70%;
    
}

.option-button {
    display: flex;
    align-items: center;
    background-color: #d1e9fc;
    border: 2px solid #0f7cd4;
    border-radius: 10px;
    padding: 20px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    text-align: left;
    
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}
.button-title{
    font-size: 1.5vw;
    font-weight: 700;
}
.button-info{
    font-size: 1vw;
    margin-top:20px;
    font-weight: 500;
}

.option-button:hover {
    background-color: #e8f0fe;
}

.button-icon {
    width: 40px;
    height: 40px;
    margin-right: 20px;
}
.itinerary-input{
    flex: 1;
    padding: 1.5vh;
    border: none;
    outline: none;
    font-size: 2vw;
    color: #0099cc;
    background-color: transparent;
}
  </style>
  
  
  
  