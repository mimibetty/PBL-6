import axios from 'axios';
export default function () {

  const heartFull = new URL('@/assets/heart-full.svg', import.meta.url).href;
  const heartEmpty = new URL('@/assets/heart-none.svg', import.meta.url).href;
  
  const buttons = ['Drink', 'Museum', 'Outdoor', 'Adventure', 'Beach', 'Hotel', 'Food', 'F&B', 'Movie'];

  // Danh sách tỉnh thành
  const regions = [
    'Việt Nam', 'Hà Nội', 'TP. Hồ Chí Minh', 'Đà Nẵng', 'Hải Phòng', 
    'Cần Thơ', 'Huế', 'Quảng Ninh', 'Bình Định', 'Khánh Hòa',
    // Thêm các tỉnh thành khác
  ];

  let selectedRegion = 'Việt Nam'; // Mặc định là Việt Nam
  let dropdownVisible = false; // Kiểm soát dropdown có hiển thị hay không

  // Hàm xử lý khi chọn tỉnh thành
  const selectRegion = (region) => {
    selectedRegion = region;
    dropdownVisible = false; // Ẩn dropdown sau khi chọn
  };

  // Hàm mở/tắt dropdown
  const toggleDropdown = () => {
    dropdownVisible = !dropdownVisible;
  };

  const fetchEntertainments = async () => {
    try {
      const response = await axios.get('http://localhost:3000/entertainments');
      return response.data.map(entertainment => ({
        id: entertainment.id,
        name: entertainment.name,
        reviewNumber: entertainment.reviewNumber,
        tag: entertainment.tag,
        rating: entertainment.rating,
        description: entertainment.description,
        imageUrl: entertainment.imageUrl,
      }));
    } catch (error) {
      console.error('Error fetching entertainments:', error);
      return [];
    }
  };

  const generateStars = (rating) => {
    const fullCircle = new URL('@/assets/circle-full.svg', import.meta.url).href;
    const halfCircle = new URL('@/assets/circle-half.svg', import.meta.url).href;
    const emptyCircle = new URL('@/assets/circle-none.svg', import.meta.url).href;

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

  return {
    heartFull,
    heartEmpty,
    
    buttons,
    regions, // Danh sách tỉnh thành
    selectedRegion, // Tỉnh thành được chọn
    dropdownVisible, // Trạng thái của dropdown
    toggleDropdown, // Hàm bật/tắt dropdown
    selectRegion, // Hàm chọn tỉnh thành
    fetchEntertainments,
    generateStars
  };
}
