<template>
    <div class="header-container">
        <Header />
        <Top_Button />
    </div>

    <div class="container-fluid frame-overall">
        <div class="container-fluid overall">
            <div class="info-user">
                <div class="cover-photo">
                    <img src="@/assets/images/bg.webp" alt="Cover Photo" class="" />
                </div>
                <div class="avatar">
                    <img :src="userInfo?.user_info?.image ? userInfo.user_info.image.url : '/blue-image.jpg'"
                        alt="Avatar" class="ava" />
                </div>
                <div class="cover-button-photo">
                    <!-- nhầm tăng kích cỡ hình -->
                    <Cover_photo_btn></Cover_photo_btn>
                </div>
                <div class="change-ava">
                    <Icon></Icon>
                </div>
                <div class="infor-user">
                    <Info_User :username="userInfo.username" :gmail="userInfo.gmail" />
                </div>
            </div>
            <div class="main-content">
                <div class="group-tag">
                    <Group_tag @change-tab="handleTabChange"></Group_tag>
                </div>

                <div class="container content-1">
                    <component :is="currentComponent"></component>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import ProfileViewModel from '@/components/viewModels/Profile_Page_ViewModel/profilePage_ViewModel';

import Header from '../Header.vue';
import Scroll_Bar_Component from '../Scroll_Bar_Component.vue';
import Top_Button from '../Top_Button.vue';
import Cover_photo_btn from './Cover_photo_btn.vue';
import Icon from './Icon.vue';
import Info_User from './Info_User.vue';
import Group_tag from './Group_tag.vue';
import Trips_Profile from './Trips_Profile.vue';
import Favourite_Profile from './Favourite_Profile.vue';
import Setting_Profile from './Setting_Profile.vue';
import Reviews_Profile from './Reviews_Profile.vue';


export default {
    name: "Profile_Page",
    components: {
        Header, Scroll_Bar_Component, Top_Button, Cover_photo_btn, Icon,
        Info_User, Group_tag, Reviews_Profile,
        Trips_Profile, Favourite_Profile, Setting_Profile
    },
    data() {
        return {
            viewModel: new ProfileViewModel(), // Quản lý danh sách tab
            currentComponent: 'Trips_Profile', // Component mặc định
            userInfo: {
                username: '',
                gmail: '',
                dateJoined: '',
                location: '',
                user_info: {},
            },
        };
    },
    async created() {
        await this.viewModel.loadUserInfo();
        this.userInfo = this.viewModel.getUserInfo();
    },
    methods: {
        handleTabChange(tabName) {
            console.log('Tab Name:', tabName);
            this.viewModel.changeTab(tabName); // Thay đổi tab mà không duyệt danh sách
            this.currentComponent = this.viewModel.getCurrentComponent(); // Cập nhật component hiển thị
            console.log('Current Component:', this.currentComponent);
        },
    },
}
</script>
<style sc>
.frame-overall {
    display: grid;
    grid-template-columns: 2% 96% 2%;
}

.overall {
    grid-column: 2/3;
}

.info-user .cover-photo img {
    margin-top: 150px;
    border-radius: 20px;
    width: 100%;
    height: 300px;
    object-fit: cover;
    z-index: 1;
}

.content-1 {
    transition: all 0.3s ease-in-out;
}

.avatar {
    position: relative;
    margin-top: -120px;
    margin-left: 50px;
    height: 180px;
    width: 180px;
    border-radius: 50%;
    background-color: #EDF6F9;
    z-index: 15;
}

.ava {
    height: 170px;
    width: 170px;
    border-radius: 50%;
    object-fit: cover;
    transform: translate(5px, 5px);
    z-index: 15;
}

.cover-button-photo {
    position: relative;
    margin-top: -140px;
    margin-left: 800px;
    z-index: 2;
    opacity: 0;
}

.button-photo {
    position: relative;
    top: -50px;
    left: 770px;
    z-index: 2;
}

.change-ava {
    position: relative;
    margin-top: -18px;
    margin-left: 165px;
    z-index: 15;
}

.infor-user {
    margin: 20px 0 -50px 250px;
}
</style>