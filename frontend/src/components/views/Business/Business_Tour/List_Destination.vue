<template>
    <div class="modal fade" id="listDestination">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">List Destination</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-responsive table-striped">
                        <thead>
                            <tr>
                                <th class="number">Number</th>
                                <th>Photo</th>
                                <th>Destination Name</th>
                                <th class="type">Type</th>
                                <th class="rating">Rating</th>
                                <th class="add">Add</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(destination, index) in paginatedList" :key="index">
                                <td class="number"> {{ index + 1 + (currentPage - 1) * itemsPerPage }} </td>
                                <td>
                                    <img class="img1" :src="destination.images[0]?.url || '/blue-image.jpg'" alt="">
                                </td>
                                <td class="text-break">{{ destination.name }}</td>
                                <td class="type">{{ destination.hotel_id !== null && destination.restaurant_id === null 
                                        ? "Hotel" 
                                        : destination.hotel_id === null && destination.restaurant_id !== null
                                        ? "Restaurant" : "Place" }}</td>
                                <td class="rating">{{ destination.rating }}</td>
                                <td class="add">
                                    <button class="btn-add"  @click="emit('add-destination', destination)">
                                        <svg fill="currentColor" width="22px" height="22px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512">
                                            <path d="M416 208H272V64c0-17.7-14.3-32-32-32h-32c-17.7 0-32 14.3-32 32v144H32c-17.7 0-32 14.3-32 32v32c0 17.7 14.3 32 32 32h144v144c0 17.7 14.3 32 32 32h32c17.7 0 32-14.3 32-32V304h144c17.7 0 32-14.3 32-32v-32c0-17.7-14.3-32-32-32z"/>
                                        </svg>
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- Pagination -->
                    <div class="pagination-container d-flex justify-content-center align-items-center mt-3">
                        <button class="btn-pagination prev" :disabled="currentPage === 1" @click="currentPage--">Previous</button>
                        <!-- Trang đầu -->
                        <button class="btn-pagination" 
                                :class="{ active: currentPage === 1 }"
                                @click="currentPage = 1">
                            1
                        </button>
                        <!-- Dấu ... trước trang hiện tại -->
                        <span class="dot" v-if="currentPage > 3">...</span>

                        <button v-for="page in pagesToShow" 
                                :key="page" 
                                class="btn-pagination"
                                :class="{ active: page === currentPage }"
                                @click="currentPage = page">
                            {{ page }}
                        </button>

                        <!-- Dấu ... sau trang hiện tại -->
                        <span class="dot" v-if="currentPage < totalPages - 2">...</span>

                        <!-- Trang cuối -->
                        <button class="btn-pagination" 
                                :class="{ active: currentPage === totalPages }"
                                @click="currentPage = totalPages">
                            {{ totalPages }}
                        </button>
                        <button class="btn-pagination next" :disabled="currentPage === totalPages" @click="currentPage++">Next</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue';

const props = defineProps({
  destList: {
    type: Array,
    required: true
  }
})

const emit = defineEmits(['add-destination']);
// Sao chép destList sang local
//Xóa item khỏi bảng trong modal sau khi "Add" để khi xóa kh bị mất ở db

const currentPage = ref(1);
const itemsPerPage = 5;

// Computed property to calculate paginated list
const paginatedList = computed(() => {
    const start = (currentPage.value - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    return props.destList.slice(start, end);
});

// Tính tổng số trang
const totalPages = computed(() => {
    return Math.ceil(props.destList.length / itemsPerPage);
});

// Tính danh sách các trang cần hiển thị
const pagesToShow = computed(() => {
    const pages = [];
    // Hiển thị các trang từ currentPage - 2 đến currentPage + 2
    for (let i = Math.max(2, currentPage.value - 1); i <= Math.min(totalPages.value - 1, currentPage.value + 1); i++) {
        pages.push(i);
    }
    return pages;
});
</script>

<style scoped>
:deep(.table-striped>tbody>tr:nth-of-type(odd)>* ) {
    --bs-table-bg-type: rgba(202, 240, 248, 0.4);
}
:deep(.table) {
    table-layout: fixed;
    /* width: 100%; */
}
tbody {
    max-height: 200px ;
    width: 100%;
    box-shadow: 0 2px 6px -1px rgba(19, 53, 123, .1), 0 6px 18px -1px rgba(19, 53, 123, .08) !important;
}
th {
    border-color: #13357B !important;
    color: #EDF6F9 !important;
    background-color: #4AA4D9 !important;
    text-align: center; 
    /* padding: .5rem 1.5rem; */
    font-weight: 900 !important;
}
tr {
    vertical-align: middle !important;
    text-align: center !important;
    border-color: rgba(19, 53, 123, 0.4) !important;
    font-size: 14px;
}
th.add, td.add, th.number, td.number, th.rating, td.rating, th.type, td.type {
    width: 10%;
    text-align: center !important;
}
td {
    color: #13357B !important;
    background-color: #EDF6F9 !important;
}
.img1 {
    aspect-ratio: 16/9;
    object-fit: cover;
    height: 120px;
    border-radius: 10px;
}
.btn-add {
    border: none;
    background-color: transparent;
    cursor: pointer;
    color: #4AA4D9;
}
.btn-add:hover{
    opacity: 0.7;
}
tbody tr:hover td{
    background-color: #CAF0F8 !important ; /* Màu khi hover */
}
/* Pagination */
.pagination-container {
    gap: 10px;
}
.btn-pagination {
    padding: 8px 16px;
    border: 1px solid #4AA4D9;
    background-color: #EDF6F9;
    color: #13357B;
    cursor: pointer;
    border-radius: 5px;
    transition: all 0.3s;
}
.btn-pagination:hover {
    background-color: #4AA4D9;
    color: #EDF6F9;
}
.btn-pagination:disabled {
    background-color: #CAF0F8;
    cursor: not-allowed;
}
.btn-pagination.active {
    background-color: #4AA4D9;
    color: #EDF6F9;
    font-weight: bold;
}
.prev, .next {
    min-width: 85px;
}
.modal-title {
    color: #13357B;
    font-weight: 900;
}
.dot {
    color: #13357B;
}
</style>