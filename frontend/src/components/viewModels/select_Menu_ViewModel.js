// viewModels/FilterPanelViewModel.js
import SelectMenuModel from '../models/select_Menu_Model';

export default function select_Menu_ViewModel() {
    const options = ref([
        new SelectMenuModel('restaurant', 'Restaurant'),
        new SelectMenuModel('coffee-tea', 'Coffee & Tea'),
        new SelectMenuModel('bar-pubs', 'Bar & Pubs'),
        new SelectMenuModel('dessert', 'Dessert'),
        new SelectMenuModel('bakeries', 'Bakeries'),
        new SelectMenuModel('delivery-only', 'Delivery Only')
    ]);

    // Toggle the isChecked status of a specific option
    const toggleOption = (id) => {
        options.value.forEach(option => {
            option.isChecked = option.id === id ? !option.isChecked : false;
        });
    };

    return { options, toggleOption };
}
