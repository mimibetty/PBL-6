import axios from 'axios';

export default class groupTag_Models {
    constructor(tagName, componentName) {
        this.tagName = tagName; // Tên tab
        this.componentName = componentName; // Tên component tương ứng
        this.active = false; // Trạng thái active
    }
}