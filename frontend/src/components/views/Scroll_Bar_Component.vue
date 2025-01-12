<template>
    
</template>

<script>
    export default {
        name: "Scroll_Bar_Component",
    }
</script>
<style>
/* Tùy chỉnh thanh cuộn cho toàn bộ website */
::-webkit-scrollbar {
    width: 10px; /* Độ rộng của thanh cuộn dọc */
    height: 5px; /* Độ rộng của thanh cuộn ngang */
}

::-webkit-scrollbar-track {
    background: #EDF6F9; /* Màu nền của đường dẫn */
    border-radius: 10px; /* Độ bo góc */
}

::-webkit-scrollbar-thumb {
    background: #13357B; /* Màu của thanh trượt */
    border-radius: 10px; /* Độ bo góc */
}
</style>
