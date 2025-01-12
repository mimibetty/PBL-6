<template>
  <div class="dashboard-container">
    <div class="stats-container">
      <!-- Container chung cho City Destinations và Tag Distribution -->
      <div class="charts-container">
        <div class="chart-card">
          <h2 class="chart-title">City Destinations Overview</h2>
          <canvas id="destinationChart"></canvas>
        </div>
        <div class="chart-card">
          <h2 class="chart-title">Tag Distribution</h2>
          <canvas id="tagChart" class="pie-chart"></canvas>
        </div>
      </div>
    </div>
    
    <!-- City Ratings Chart (100% width) -->
    <div class="chart-card">
      <h2 class="chart-title">City Ratings Overview</h2>
      <canvas id="cityChart"></canvas>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import AdminController from '../controllers/AdminController';
import Chart from 'chart.js/auto';

const { getRatingsOfCities, rateNumberOfDestOfCities, getNumDestByTags } = AdminController();
const cityRatings = ref([]);
const cityDestinations = ref([]);
const tagData = ref([]);

const fetchCityRatings = async () => {
  try {
    const data = await getRatingsOfCities();
    cityRatings.value = data;  // Display all data, not limited to top 20
    drawRatingChart();
  } catch (error) {
    console.error('Error fetching city ratings:', error);
  }
};

const fetchCityDestinations = async () => {
  try {
    const data = await rateNumberOfDestOfCities();
    cityDestinations.value = data;  // Display all cities
    drawDestinationChart();
  } catch (error) {
    console.error('Error fetching city destinations:', error);
  }
};

const fetchTagData = async () => {
  try {
    const data = await getNumDestByTags();
    tagData.value = data;
    drawTagChart();
  } catch (error) {
    console.error('Error fetching tag data:', error);
  }
};

const drawRatingChart = () => {
  const ctx = document.getElementById('cityChart').getContext('2d');
  const labels = cityRatings.value.map(city => city.city_name);
  const averageRatings = cityRatings.value.map(city => city.average_rating);
  const reviewCounts = cityRatings.value.map(city => city.total_review_count);

  new Chart(ctx, {
    data: {
      labels,
      datasets: [
        {
          type: 'line',
          label: 'Average Rating',
          data: averageRatings,
          backgroundColor: 'rgba(31, 188, 26, 0.1)',
          borderColor: 'rgba(31, 188, 26, 1)',
          borderWidth: 2,
          fill: true,
          tension: 0.4,
          yAxisID: 'y1', // Gắn với trục y1 bên trái
        },
        {
          type: 'bar',
          label: 'Total Reviews',
          data: reviewCounts,
          backgroundColor: 'rgba(14, 14, 235, 0.6)',
          borderColor: 'rgba(14, 14, 235, 1)',
          borderWidth: 1,
          yAxisID: 'y2', // Gắn với trục y2 bên phải
        },
      ],
    },
    options: {
      responsive: true,
      plugins: {
        legend: {
          display: true,
          position: 'top',
        },
      },
      scales: {
        x: {
          grid: {
            display: false,
          },
        },
        y1: {
          type: 'linear',
          position: 'left',
          grid: {
            display: false,
          },
          title: {
            display: true,
            text: 'Average Rating',
          },
          beginAtZero: true,
        },
        y2: {
          type: 'linear',
          position: 'right',
          grid: {
            drawOnChartArea: false, // Không vẽ lưới của trục y2 để tránh trùng lặp
          },
          title: {
            display: true,
            text: 'Number of Reviews',
          },
          beginAtZero: true,
        },
      },
    },
  });
};


const drawDestinationChart = () => {
  const ctx = document.getElementById('destinationChart').getContext('2d');
  const labels = cityDestinations.value.map(city => city.city_name);
  const numberOfDestinations = cityDestinations.value.map(city => city.number_of_destinations);

  new Chart(ctx, {
    data: {
      labels,
      datasets: [
        {
          type: 'bar',
          label: 'Number of Destinations',
          data: numberOfDestinations,
          backgroundColor: '#1d5e02',
          borderColor: '#1d5e02',
          borderWidth: 1
        }
      ],
    },
    options: {
      responsive: true,
      plugins: {
        legend: {
          display: true,
          position: 'top'
        }
      },
      scales: {
        x: {
          grid: {
            display: false
          }
        },
        y: {
          grid: {
            display: false
          },
          beginAtZero: true
        },
      },
    },
  });
};

const drawTagChart = () => {
  const ctx = document.getElementById('tagChart').getContext('2d');
  const labels = tagData.value.slice(0, 12).map(tag => tag.name);
  const data = tagData.value.slice(0, 12).map(tag => tag.destination_count);

  const backgroundColors = [
    '#FF6384', '#FF9F40', '#FFCD56', '#4BC0C0', '#36A2EB', '#9966FF', '#C9CBCF', '#FF5733', 
    '#FF914D', '#FFC300', '#FF5733', '#C70039'
  ];

  new Chart(ctx, {
    type: 'pie',
    data: {
      labels,
      datasets: [
        {
          data,
          backgroundColor: backgroundColors,  // Đặt màu sắc cho từng tag trong pie chart
          borderWidth: 1
        }
      ]
    },
    options: {
      responsive: true,
      plugins: {
        legend: {
          display: true,
          position: 'right',  // Đặt legend sang bên phải
          labels: {
            boxWidth: 20, // Độ rộng của hộp màu bên cạnh label
            padding: 15, // Khoảng cách giữa các mục trong legend
            font: {
              size: 12,  // Kích thước font cho các label
              family: 'Arial', // Font chữ của label
            }
          }
        }
      }
    }
  });
};

onMounted(() => {
  fetchCityRatings();
  fetchCityDestinations();
  fetchTagData();
});
</script>

<style scoped>
.dashboard-container {
  margin: 0 auto;
  padding: 20px;
  background: #f4f6f9;
  border-radius: 8px;
  width: 100%;
  height: 100vh;
  box-sizing: border-box;
}

.stats-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.charts-container {
  display: flex;
  gap: 20px;
  justify-content: space-between;
  width: 100%;
}

.chart-card {
  padding: 20px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  flex-grow: 1;
}

.chart-title {
  font-size: 1.5rem;
  margin-bottom: 10px;
  text-align: center;
  color: #333;
}

.pie-chart {
  max-width: 700px;
  max-height: 700px;
  width: 100%;
  height: auto;
  margin: 0 auto;
}

/* To ensure responsiveness */
@media (max-width: 768px) {
  .charts-container {
    flex-direction: column;
  }
  .chart-card {
    width: 100%;
  }
}
</style>
