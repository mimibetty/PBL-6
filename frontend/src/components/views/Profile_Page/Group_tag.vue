<template>
    <div class="group-tag d-flex justify-content-around gap-2">
        <div class="btn-group d-flex gap-2" 
            v-for="tab in profileViewModel.tabsMap.values()" 
            :key="tab.name">
            <button :class="{ active: tab.active }"
                @click="selectTab(tab.tagName)">
                {{ tab.tagName }}
            </button>
        </div>
    </div>
</template>

<script>
import ProfileViewModel from '@/components/viewModels/Profile_Page_ViewModel/profilePage_ViewModel';
export default {
    name: "Info_User",
    data() {
        return {
            profileViewModel: new ProfileViewModel()
        }
    }, 
    methods: {
        selectTab(tabName) {
            console.log('Selected TabName:', tabName);
            this.profileViewModel.changeTab(tabName);
            this.$emit('change-tab', tabName);
        }
    }
}
</script>

<style scoped>
.group-tag {
    background-color: #EDF6F9;
    align-items: center;/* Cách đều các nút */
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.3);
    padding: 15px 0px;
    margin-bottom: 20px;
    border-radius: 10px;
    z-index: 15;
    width: 100%;
}

.btn-group button {
    width: 200px;
    padding: 10px 0px;
    background-color: #EDF6F9;
    color: #13357B;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-weight: bold;
}

.btn-group button:hover {
    background-color: #13357B;
    color: #CAF0F8;
}

.btn-group button.active {
    background-color: #13357B;
    color: #CAF0F8;
}
</style>