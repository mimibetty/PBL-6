<template>
    <canvas id="myChart" height="550" width="600px"></canvas>
</template>

<script setup>
import { onMounted, watch } from 'vue';
import Chart from 'chart.js/auto';

const props = defineProps({
    rating1: {
        type: Array,
        required: true,
        default: () => []
    },
    rating2: {
        type: Array,
        required: true,
        default: () => []
    },
    rating3: {
        type: Array,
        required: true,
        default: () => []
    },
    rating4: {
        type: Array,
        required: true,
        default: () => []
    },
    rating5: {
        type: Array,
        required: true,
        default: () => []
    },
    nameOfLocation: {
        type: String,
        required: true,
        default: 'Destination'
    }
});

// Lưu instance của biểu đồ
let chartInstance = null;

const labels = [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'June',  
                 'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' ];

const createChart = () => {
    const ctx = document.getElementById('myChart');

    if (chartInstance) {
        chartInstance.destroy(); //Huỷ biểu đồ cũ
    }

    chartInstance = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: '1 star',
                backgroundColor: '#00b4d8',
                borderColor: '#00b4d8',
                data: props.rating1,
            },
            {
                label: '2 star',
                backgroundColor: '#0096c7',
                borderColor: '#0096c7',
                data: props.rating2,
            },
            {
                label: '3 star',
                backgroundColor: '#0077b6',
                borderColor: '#0077b6',
                data: props.rating3,
            },
            {
                label: '4 star',
                backgroundColor: '#023e8a',
                borderColor: '#023e8a',
                data: props.rating4,
            },
            {
                label: '5 star',
                backgroundColor: '#03045e',
                borderColor: '#03045e',
                data: props.rating5,
            }]
        },
        options: {
            responsive: true,
            plugins: {
                title: {
                    display: true,
                    text: `Rating of ${props.nameOfLocation}`,
                    color: '#13357B',
                    font: {
                        size: 20,
                        weight: 'bold'
                    } ,
                },
                legend: {
                    labels: {
                        color: '#13357B' // Màu chữ của chú thích (legend)
                    }
                }
            },
            scales: {
                x: {
                    stacked: true,
                    ticks: {
                        color: '#13357B', // Màu chữ trên trục X
                    },
                },
                y: {
                    stacked: true,
                    position: 'left',
                    title: {
                        display: true,
                        text: 'Number of R ating', // Tên cho trục Y bên trái
                        color: '#13357B',         // Màu chữ của tên trục
                        font: {
                            size: 12,             // Kích thước chữ
                            weight: 'bold'        // Đậm chữ
                        }
                    },
                    ticks: {
                        color: '#13357B', // Màu chữ trên trục Y (bên trái)
                    },
                },
            }
        }
    });
}

onMounted(createChart);

watch (
    () => [props.rating1, props.rating2, props.rating3, props.rating4, props.rating5, props.nameOfLocation],
    createChart,
    { deep: true }
)
</script>

<style scoped>
#myChart {
    margin: 0 auto;
    color: #13357B;
}
</style>