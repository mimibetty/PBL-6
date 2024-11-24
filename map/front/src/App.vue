<template>
  <div>
    <AutocompleteComponent @location-selected="updateLocation" />
    <MapComponent :selectedLocation="location" />
  </div>
</template>

<script>
import AutocompleteComponent from './components/Autocomplete.vue'; // Tên chính xác
import MapComponent from './components/MapComponent.vue';

export default {
  components: {
    AutocompleteComponent, // Sử dụng tên thống nhất
    MapComponent
  },
  data() {
    return {
      location: [105.85242472181584, 21.029579719995272] // Vị trí mặc định
    };
  },
  methods: {
    updateLocation(newLocation) {
      this.location = [newLocation.lng, newLocation.lat]; // Chuyển đổi thành mảng
    }    
  }
};
</script>