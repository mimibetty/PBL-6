import { ref, watch } from 'vue';
import { getSearchResult } from '../models/SearchModel.js';

export default function (searchQuery) {
    const searchResult = ref(null);
    const isLoading = ref(false);
    const results = ref([]);
    const result_citys = ref([]);

    // Hàm debounce
    const debounce = (func, delay) => {
        let timer;
        return (...args) => {
            clearTimeout(timer);
            timer = setTimeout(() => func(...args), delay);
        };
    };

    // Hàm tìm kiếm
    const search = async () => {
        if (!searchQuery.value) {
            results.value = [];
            result_citys.value = [];
            return;
        }

        isLoading.value = true;
        try {
            searchResult.value = await getSearchResult(searchQuery.value);
            results.value = [
                ...searchResult.value.cities.map(city => city.name),
                ...searchResult.value.destinations.map(destination => destination.name),
            ];
            result_citys.value = searchResult.value.cities;
        } catch (error) {
            console.error('An error occurred while searching:', error);
        } finally {
            isLoading.value = false;
        }
    };

    const debouncedSearch = debounce(search, 300); // Gọi API sau 300ms không thay đổi

    // Tự động tìm kiếm khi searchQuery thay đổi
    watch(searchQuery, () => {
        debouncedSearch();
    });

    return {
        search,
        searchResult,
        isLoading,
        results,
        result_citys,
    };
}
