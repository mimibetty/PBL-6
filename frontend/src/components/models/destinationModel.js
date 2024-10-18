import axios from 'axios';
import { ref, computed, onMounted } from 'vue';
export default function () {
  
  const heartFull = new URL('@/assets/heart-full.svg', import.meta.url).href;
  const heartEmpty = new URL('@/assets/heart-none.svg', import.meta.url).href;
  
  const fullDescription = `Hanoi, the capital city of Vietnam, is a vibrant blend of tradition and modernity. 
Nestled along the banks of the Red River, Hanoi is known for its centuries-old architecture, rich history, and deep-rooted culture. 
The city's Old Quarter, with its narrow streets and colonial buildings, offers a glimpse into its French colonial past, 
while iconic landmarks like the Ho Chi Minh Mausoleum, the Temple of Literature, and the One Pillar Pagoda reflect its ancient heritage. 
Hanoi is also famous for its lively street markets, traditional cuisine, and serene lakes, such as Hoan Kiem Lake and West Lake, 
where locals gather to exercise and socialize. The city's unique charm lies in its ability to blend the bustling energy 
of a modern metropolis with the peaceful, timeless beauty of its historical sites. Whether you're exploring its vibrant neighborhoods 
or tasting its world-renowned street food, Hanoi offers an authentic and captivating experience for visitors.`;

  

  const getTruncatedDescription = () => {
    return fullDescription.split(' ').slice(0, 40).join(' ') + '...';
  };

  const getDescription = (isReadMore) => {
    return isReadMore.value ? fullDescription : getTruncatedDescription();
  };

  const buttons = ['Drink', 'Museum', 'Outdoor', 'Adventure', 'Beach', 'Hotel', 'Food', 'F&B', 'Movie'];

  const fetchEntertainments = async () => {
    try {
      const response = await axios.get('http://localhost:3000/entertainments');
      return response.data.map(entertainment => ({
        id: entertainment.id,
        name: entertainment.name,
        reviewNumber: entertainment.reviewNumber,
        tag: entertainment.tag,
        rating: entertainment.rating,
        imageUrl: entertainment.imageUrl,
      }));
    } catch (error) {
      console.error('Error fetching entertainments:', error);
      return [];
    }
  };

  const fetchImages = async () => {
    try {
      const response = await axios.get('http://localhost:3000/images');
      return response.data.map(image => ({
        id: image.id,
        imageUrl: image.imageUrl,
      }));
    } catch (error) {
      console.error('Error fetching entertainments:', error);
      return [];
    }
  };


  const generateStars = (rating) => {
    const fullStar = new URL('@/assets/star_full.svg', import.meta.url).href;
    const halfStar = new URL('@/assets/star_half.svg', import.meta.url).href;
    const emptyStar = new URL('@/assets/star_none.svg', import.meta.url).href;

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

  return {
    fetchImages,
    heartFull,
    heartEmpty,
    fullDescription,
    getTruncatedDescription,
    getDescription,
    buttons,
    fetchEntertainments,
    generateStars
  };
}