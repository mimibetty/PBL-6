<template>
    <button :class="{ active: isActive, hover: isHovered }"
            @click.stop="handleHeartClick"
            @mouseover="isHovered = true"
            @mouseleave="isHovered = false">
      <svg width="40px" height="40px" viewBox="0 0 24 24" fill="#currentColor" xmlns="http://www.w3.org/2000/svg">
        <path d="M15.7 4C18.87 4 21 6.98 21 9.76C21 15.39 12.16 20 12 20C11.84 20 3 15.39 3 9.76C3 6.98 5.13 4 8.3 4C10.12 4 11.31 4.91 12 5.71C12.69 4.91 13.88 4 15.7 4Z" stroke="#currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
    </button>
  </template>

<script>
import { ref, onMounted } from "vue";
import useDestinationViewModel from "../viewModels/DestinationLikeViewModel";

export default {
  name: "btn_heart",
  props: {
    destID: {
      type: Number,
      required: true,
    },
  },
  setup(props, { emit }) {
    const isActive = ref(false); // Trạng thái "like"
    const isHovered = ref(false);
    const { like, unlike, checkLike } = useDestinationViewModel();

    // Hàm xử lý click vào nút
    const handleHeartClick = async () => {
      console.log("Destination ID:", props.destID);
      try {
        if (isActive.value) {
          await unlike(props.destID); // Unlike
          isActive.value = false;
        } else {
          await like(props.destID); // Like
          isActive.value = true;
        }
        // Emit sự kiện để thành phần cha biết trạng thái
        emit("heartStatusChanged", { destID: props.destID, isActive: isActive.value });
      } catch (error) {
        console.error("Error toggling like status:", error);
      }
    };

    // Kiểm tra trạng thái ban đầu
    const checkInitialLike = async () => {
      try {
        const result = await checkLike(props.destID);
        isActive.value = result; // Gán trạng thái "like" ban đầu
      } catch (error) {
        console.error("Error checking initial like status:", error);
      }
    };

    onMounted(() => {
      checkInitialLike(); // Gọi khi component được mount
    });

    return {
      isActive,
      isHovered,
      handleHeartClick,
    };
  },
};
</script>

<style scoped>
button {
    background-color: #EDF6F9;
    fill: #EDF6F9;
    stroke: #13357B;
    border: none;
    border-radius: 50%;
    padding: 10px;
    font-size: 16px;
    font-weight: bold;
    z-index: 16;
    transition: 0.5s;
}

button.hover:not(.active) {
    background-color: #CAF0F8;
    stroke: #E63946;
    fill: #CAF0F8;
    z-index: 16;
}

button.active {
    background-color: #CAF0F8;
    stroke: #E63946;
    fill: #E63946;
    z-index: 16;
}
</style>
