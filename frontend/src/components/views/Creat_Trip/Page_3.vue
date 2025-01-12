<template>
    <div class="container-fluid-1">
        <div class="container-fluid p-2">
            <div class="container-fluid frame-title" style="width: 100vw;">
                <h1>Tell us what you’re interested in</h1>
                <h5>Select all that apply</h5>
            </div>
            <div class="container frame-items">
                <button v-for="topic in topics" :key="topic.id" 
                        class="item"
                        :class="{ 'selected': selectTags.includes(topic.id) }"
                        @click="toggleTopic(topic.id)">
                    {{ topic.name }}
                </button>
            </div>
            <div class="container-fluid frame-button px-5 py-2">
                <button class="button back" @click="goBack" >Back</button>
                <button class="button next" @click="goNext" >Next</button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import CreateTrip from '../../viewModels/CreateTripViewModel'
import { useRouter } from 'vue-router';
const router = useRouter();

const topics = ref([]);
const { getTopics, toggleTopic, selectTags, updateTopics } = CreateTrip();
onMounted(async () => {
    topics.value = await getTopics();
});

const goBack = () => {
    router.push({ name: 'Page_2_1' });
};

const goNext = () => {
    updateTopics();
    router.push({ name: 'Page_4' });
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
.frame-title{
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    margin-top: 30px;
    color: #00B4D8;
}
.frame-title h1{
    font-weight: 900;
    font-size: 4vw;
}
.frame-title h5{
    color: #13357B;
}
.frame-items {
    margin-top: 50px;
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    grid-template-rows: repeat(3, 50px);
    gap: 30px;
    width: 80vw;
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
    margin-top: 50px;
    margin-bottom: 40px;
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
}
</style>