export default class SelectMenuModel {
    constructor(id, label) {
        this.id = id;
        this.label = label;
        this.isChecked = false; // Track if this option is selected
    }
}