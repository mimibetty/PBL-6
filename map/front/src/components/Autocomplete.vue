<template>
  <div>
    <input v-model="query" @input="onInput" placeholder="Search location..." />
    <div v-if="results.length" class="results">
      <div v-for="result in results" :key="result.place_id" @click="selectPlace(result)">
        {{ result.description }}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AutocompleteComponent', // Đổi tên ở đây
  data() {
    return {
      query: '',
      results: []
    };
  },
  methods: {
    async onInput() {
      if (this.query.length >= 2) {
        const response = await fetch('http://localhost:8000/autocomplete', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ input: this.query })
        });
        const data = await response.json();
        this.results = data.predictions || [];
      } else {
        this.results = [];
      }
    },
    async selectPlace(place) {
      const response = await fetch('http://localhost:8000/place-detail', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ place_id: place.place_id })
      });
      const data = await response.json();
      const location = data.result.geometry.location;
      this.$emit('location-selected', location); // Emit sự kiện cho nơi khác trong ứng dụng
      this.results = []; // Xóa kết quả
      this.query = place.description; // Cập nhật ô input
    }
  }
}
</script>

<style>
.results {
  border: 1px solid #ccc;
  max-height: 200px;
  overflow-y: auto;
}
.results div {
  padding: 8px;
  cursor: pointer;
}
.results div:hover {
  background-color: #f0f0f0;
}
</style>