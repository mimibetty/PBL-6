// FilterOptionModel.js
export default class FilterOptionModel {
    constructor(id, label, selected = false) {
        this.id = id;
        this.label = label;
        this.selected = selected;
    }
}
