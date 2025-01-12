<template>
    <div class="list-favourite-items">
        <Favourite_Item v-for="destID in likes" :key="destID" :destID="destID" />
    </div>
</template>

<script setup>
import DestinationLike from '../../viewModels/DestinationLikeViewModel';
import { ref, computed, onMounted, watch } from 'vue';
const {
    likeList,
} = DestinationLike();
const likes = ref([]);
onMounted(async () => {
    likes.value = await likeList();
});

</script>
<script>
import Favourite_Item from './Favourite_Item.vue';
export default {
    name: "Favourite_Profile",
    components: {
        Favourite_Item
    }
}
</script>

<style scoped>
.list-favourite-items {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
    align-items: center;
    width: 100%;
    height: 100%;
    margin-top: 70px;
    margin-bottom: 50px;
}
</style>