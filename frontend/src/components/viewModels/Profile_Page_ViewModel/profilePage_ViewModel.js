import groupTag_Models from "../../models/Profile_Page_Models/groupTag_Models";
import userInfo_Models from "../../models/Profile_Page_Models/userInfo_Models";
import router from "@/router";

export default class ProfileViewModel {
    constructor () { 

        //Tabs Button
        this.tabsMap = new Map([
            ['Trips', new groupTag_Models('Trips', 'Trips_Profile')],
            ['Reviews', new groupTag_Models('Reviews', 'Reviews_Profile')],
            ['My Favourites', new groupTag_Models('My Favourites', 'Favourite_Profile')],
            ['Change Information', new groupTag_Models('Change Information', 'Setting_Profile')],
        ]);

        // Current Tab
        this.currentTab = this.tabsMap.get('Trips');
        this.currentTab.active = true; // Set firstTab is active default

        // Token
        this.token = this.getToken(); // Fetch token during initialization

        // User Information
        this.userInfo = new userInfo_Models();
    }

    // Thay đổi tab mà không duyệt danh sách
    changeTab(tabName) {
        console.log('TabName:', tabName);
        console.log('Available Tabs:', Array.from(this.tabsMap.keys()));
        if (this.tabsMap.has(tabName)) {
            console.log('Trước khi thay đổi:', this.currentTab);
            this.currentTab.active = false;
            this.currentTab = this.tabsMap.get(tabName);
            this.currentTab.active = true;
            console.log('Sau khi thay đổi:', this.currentTab);
        } else {
            console.error(`Tab với tên "${tabName}" không tồn tại.`);
        }
    }
    //lấy component tương ứng với tab đã chọnn
    getCurrentComponent() {
        return this.currentTab.componentName;
    }

    // Retrieve token from sessionStorage or localStorage
    getToken() {
        const token = sessionStorage.getItem('access_token') || localStorage.getItem('access_token');
        if (!token) {
            console.warn('No token found. Please log in.');
            router.push('/login');
        }
        console.log('Token:', token);
        return token;
    }

    // Validate token
    validateToken() {
        if (!this.token) {
            console.error('Invalid or missing token. Redirecting to login page...');
            router.push('/login');
            return false;
        }
        return true;
    }

    async loadUserInfo() {
        if (!this.validateToken()) {
            console.error('Token is invalid or missing. Cannot fetch user info.');
            return;
        }
        const userInfo = await this.userInfo.fetchUserInfo(this.token);
        if (userInfo) {
            console.log('User Info Loaded:', userInfo);
        }
    }

    getUserInfo() {
        return this.userInfo;
    }
}