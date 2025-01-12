<template>
    <div class="group-tag">
        <div class="btn-group" 
            v-for="tab in detailTripViewModel.tabsMap.values()" 
            :key="tab.name">
            <button :class="{ active: tab.active }"
                @click="selectTab(tab.tagName)">
                {{ tab.tagName }}
            </button>
        </div>
    </div>
</template>

<script>
import detailTripViewModel from '@/components/viewModels/Trip/detailTrip_Viewmodel';
export default {
    name: "Info_User",
    data() {
        return {
            detailTripViewModel: new detailTripViewModel()
        }
    }, 
    methods: {
        selectTab(tabName) {
            console.log('Selected TabName:', tabName);
            this.detailTripViewModel.changeTab(tabName);
            this.$emit('change-tab', tabName);
        }
    }
}
</script>

<style scoped>
.group-tag {
    display: flex;
    justify-content: flex-start;
    margin-top: 10px;
    border-bottom: 1.5px solid #13357B;
}

.btn-group button {
    width: 120px;
    padding: 10px 20px;
    background-color: #EDF6F9;
    color: #13357B;
    border: none;
    cursor: pointer;
}

.btn-group button:hover {
    color: #00B4D8;
}

.btn-group button.active {
    border-bottom: 3px solid #13357B;
    font-weight: bold;
}
</style>