// viewModels/TopButtonViewModel.js
import { computed, ref } from 'vue';
import { fetchCityDetails } from '../models/CityModel';

export default function (cityID) {
    const cityDetail = ref(null); // Dữ liệu chi tiết của thành phố

    // Hàm gọi API để lấy chi tiết thành phố
    const fetchCityDetailsData = async () => {
        try {
            if (!cityID) {
                console.warn('cityID is null or undefined');
                cityDetail.value = null; // Đảm bảo giá trị null khi cityID không hợp lệ
                return;
            }
            const data = await fetchCityDetails(cityID);
            cityDetail.value = data || null;
        } catch (error) {
            console.error('Error fetching city details:', error);
            cityDetail.value = null; // Xử lý lỗi và đặt cityDetails về null
        }
    };

    // Computed property để kiểm tra điều kiện hiển thị button
    const showNameButton = computed(() => {
        return cityDetail.value !== null && cityID !== null;
    });

    // Array of buttons with conditional display based on `name`
    const buttons = computed(() => {
        const buttonList = [
        showNameButton.value && { label: cityDetail.value.name, key: 'name' },
        { label: 'Things to do', key: 'things-to-do' },
        { label: 'Restaurants', key: 'restaurants' },
        { label: 'Resorts & Hotels', key: 'resorts-hotels' },
        ];
        return buttonList.filter(Boolean); // Filter out any `false` entries
    });

    fetchCityDetailsData();

    return {
        buttons,
        showNameButton,
    };
}
