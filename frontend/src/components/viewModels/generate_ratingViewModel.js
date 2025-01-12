import { ref, computed, onMounted } from 'vue';
import { getDestinationRatingStatic } from '../models/destinationModel.js';
import { getTourRatingStatic } from '../models/TourModel.js';
export default function () {
    class RatingModel {
        constructor(excellent, veryGood, medium, bad, terrible) {
            this.excellent = excellent;
            this.veryGood = veryGood;
            this.medium = medium;
            this.bad = bad;
            this.terrible = terrible;
        }
    
        // Tính tổng số đánh giá
        getTotal() {
            return (
                this.excellent + this.veryGood + this.medium + this.bad + this.terrible
            );
        }
    
        // Tính phần trăm cho mỗi loại đánh giá
        getPercentage(value) {
            return ((value / this.getTotal()) * 100).toFixed(2);
        }
    
        // Tính tổng rating
        getAverageRating() {
            const total =
                this.excellent * 5 +
                this.veryGood * 4 +
                this.medium * 3 +
                this.bad * 2 +
                this.terrible;
            return (total / this.getTotal()).toFixed(1);
        }
    }
    const fullStar = new URL('@/assets/svg/star_full.svg', import.meta.url).href;
    const halfStar = new URL('@/assets/svg/star_half.svg', import.meta.url).href;
    const emptyStar = new URL('@/assets/svg/star_none.svg', import.meta.url).href;
    const ratingModel = new RatingModel(3422, 2122, 5622, 2100, 300);
    const generateStars = (rating) => {
    
        let stars = [];
        for (let i = 1; i <= 5; i++) {
          if (rating >= i) {
            stars.push(fullStar);
          } else if ((rating > i - 1 && rating - i + 1 >= 0.5) && rating < i) {
            stars.push(halfStar);
          } else {
            stars.push(emptyStar);
          }
        }
        return stars;
      };
    
      // Tạo danh sách hình tròn
      const generateCircle = (rating) => {
        const fullCircle = new URL('@/assets/svg/circle-full.svg', import.meta.url).href;
        const halfCircle = new URL('@/assets/svg/circle-half.svg', import.meta.url).href;
        const emptyCircle = new URL('@/assets/svg/circle-none.svg', import.meta.url).href;
    
        let circles = [];
        for (let i = 1; i <= 5; i++) {
          if (rating >= i) {
            circles.push(fullCircle);
          } else if ((rating > i - 1 && rating - i + 1 >= 0.5) && rating < i) {
            circles.push(halfCircle);
          } else {
            circles.push(emptyCircle);
          }
        }
        return circles;
      };
      const stars = ref(generateStars(ratingModel.getAverageRating()));
  const circles = ref(generateCircle(ratingModel.getAverageRating()));

  const ratingDistribution = ref(null);
  const ratings = ref(null);
  const fetchRatingDistribution = async (destinationID) => {
    try {
      // Lấy dữ liệu từ API
      ratingDistribution.value = await getDestinationRatingStatic(destinationID);
  
      // Tổng số lượng rating
      const total = Object.values(ratingDistribution.value).reduce(
        (sum, count) => sum + count,
        0
      );
  
      // Lưu chi tiết vào ratingDistributionDetail
      ratings.value = {
        Excellent: {
          count: ratingDistribution.value.Excellent,
          percentage: total
            ? ((ratingDistribution.value.Excellent / total) * 100).toFixed(2)
            : "0.00",
        },
        VeryGood: {
          count: ratingDistribution.value.VeryGood,
          percentage: total
            ? ((ratingDistribution.value.VeryGood / total) * 100).toFixed(2)
            : "0.00",
        },
        Medium: {
          count: ratingDistribution.value.Medium,
          percentage: total
            ? ((ratingDistribution.value.Medium / total) * 100).toFixed(2)
            : "0.00",
        },
        Bad: {
          count: ratingDistribution.value.Bad,
          percentage: total
            ? ((ratingDistribution.value.Bad / total) * 100).toFixed(2)
            : "0.00",
        },
        Terrible: {
          count: ratingDistribution.value.Terrible,
          percentage: total
            ? ((ratingDistribution.value.Terrible / total) * 100).toFixed(2)
            : "0.00",
        },
      };
    } catch (error) {
      console.error("Error fetching rating details:", error);
      ratings.value = null; // Xử lý khi có lỗi
    }
  };

  const fetchRatingTour = async (tourID) => {
    try {
      // Lấy dữ liệu từ API
      ratingDistribution.value = await getTourRatingStatic(tourID);
  
      // Tổng số lượng rating
      const total = Object.values(ratingDistribution.value).reduce(
        (sum, count) => sum + count,
        0
      );
  
      // Lưu chi tiết vào ratingDistributionDetail
      ratings.value = {
        Excellent: {
          count: ratingDistribution.value.Excellent,
          percentage: total
            ? ((ratingDistribution.value.Excellent / total) * 100).toFixed(2)
            : "0.00",
        },
        VeryGood: {
          count: ratingDistribution.value.VeryGood,
          percentage: total
            ? ((ratingDistribution.value.VeryGood / total) * 100).toFixed(2)
            : "0.00",
        },
        Medium: {
          count: ratingDistribution.value.Medium,
          percentage: total
            ? ((ratingDistribution.value.Medium / total) * 100).toFixed(2)
            : "0.00",
        },
        Bad: {
          count: ratingDistribution.value.Bad,
          percentage: total
            ? ((ratingDistribution.value.Bad / total) * 100).toFixed(2)
            : "0.00",
        },
        Terrible: {
          count: ratingDistribution.value.Terrible,
          percentage: total
            ? ((ratingDistribution.value.Terrible / total) * 100).toFixed(2)
            : "0.00",
        },
      };
    } catch (error) {
      console.error("Error fetching rating details:", error);
      ratings.value = null; // Xử lý khi có lỗi
    }
  };



      return {
        generateStars,
        generateCircle,
        stars,
        circles,
        ratings,
        fullStar,
        halfStar,
        emptyStar,
        fetchRatingDistribution,
        fetchRatingTour,
      }
}