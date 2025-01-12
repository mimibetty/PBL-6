<script>
import MapComponent from './Map_Component.vue';
import { ref, defineComponent, watch } from 'vue';
import { getMapbyID } from '../../viewModels/mapViewModel.js';

export default defineComponent({
  components: {
    MapComponent,
  },
  props: {
    destinationID: {
      type: [Number, Array],
      required: true,
    },
    select: {
      type: Number,
      default: 0
    }
  },
  setup(props) {
    const selectedLocation = ref([]);

    // Hàm fetch location dựa trên destinationID
    const fetchLocations = async () => {
      console.log('Fetching locations for Destination ID:', props.destinationID);
      selectedLocation.value = []; // Reset lại mảng trước khi fetch
      const destListID = Array.isArray(props.destinationID) ? props.destinationID : [props.destinationID];
      try {
        for (const destinationID of destListID) {
          const location = await getMapbyID(destinationID);
          console.log('Fetched Location:', location);
          if (location && location[0]) {
            selectedLocation.value.push([location[0].longitude, location[0].latitude]);
          } else {
            console.warn(`No valid data for destination ID: ${destinationID}`);
          }
        }
        console.log('Updated Selected Locations:', selectedLocation.value);
      } catch (error) {
        console.error('Error fetching locations:', error);
      }
    };

    // Watcher theo dõi sự thay đổi của destinationID
    watch(
      () => props.destinationID,
      (newValue, oldValue) => {
        console.log('Destination ID changed from', oldValue, 'to', newValue);
        fetchLocations();
      },
      { immediate: true } // Chạy watcher ngay lần đầu tiên
    );

    return { selectedLocation };
  },
});
</script>

<template>
  <div>
    <MapComponent :selectedLocations="selectedLocation" :select="select" />
  </div>
</template>
