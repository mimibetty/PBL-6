import tagTrip_Models from "@/components/models/Trip/tagTrip_Model";
import router from "@/router";
export default class DetailTripViewModel {
    constructor() {
        this.tabsMap = new Map([
            ['Saves', new tagTrip_Models('Saves', 'Saved_List')],
            ['Itinerary', new tagTrip_Models('Itinerary', 'Itinerary_List')],
        ]);

        //Current Tab
        this.currentTab = this.tabsMap.get('Saves');
        this.currentTab.active = true;//Set firstTab is active default
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
}