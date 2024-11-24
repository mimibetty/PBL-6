<template>
    <div id="map" style="width: 100%; height: 100vh;"></div>
</template>

<script>
import maplibregl from 'maplibre-gl'; // Nhớ cài đặt maplibre-gl

export default {
    props: {
        selectedLocation: {
            type: Array,
            default: () => [105.85242472181584, 21.029579719995272]
        }
    },
    data() {
        return {
            map: null,
            apiUrl: 'https://rsapi.goong.io',
            mapUrl: 'https://tiles.goong.io/assets/',
            apiKey: 'ArPlUISaEBAdJFTABi9dcNGcue8WQ4cOAuGcNoBE', // your API key
            mapKey: 'tLyW2vk0aY3yfQLu8ZPy986mAgaW8igMYufv3BLY', // your map key
            center: [105.85242472181584, 21.029579719995272], // Kinh độ, vĩ độ
            zoom: 17, // Độ zoom mặc định
            radiusInMeters: 100,
        };
    },
    mounted() {
        this.initMap();
    },
    watch: {
        selectedLocation: 'moveToLocation'
    },
    methods: {
        initMap() {
            this.map = new maplibregl.Map({
                container: 'map',
                style: `${this.mapUrl}goong_map_web.json?api_key=${this.mapKey}`,
                center: this.selectedLocation,
                zoom: this.zoom
            });

            this.map.on('load', () => {
                const lngLat = [...this.selectedLocation];
                this.moveToLocation(lngLat);
            });
        },
        moveToLocation(newLocation) {
            this.map.flyTo({
                center: newLocation,
                essential: true
            });
            this.addMarkerAndCircleAround(newLocation);
        },
        removeLayer(layerId) {
            if (this.map.getLayer(layerId)) {
                this.map.removeLayer(layerId);
            }
        },
        addMarker(lngLat) {
            new maplibregl.Marker()
                .setLngLat(lngLat)
                .addTo(this.map);
        },
        addMarkerAndCircleAround(lngLat) {

            // Xóa vòng tròn cũ nếu có
            this.removeLayer('circle');

            // Tạo dữ liệu cho vòng tròn
            const circleData = {
                'type': 'FeatureCollection',
                'features': [{
                    'type': 'Feature',
                    'geometry': {
                        'type': 'Polygon',
                        'coordinates': [[
                            [lngLat[0] - 0.0002, lngLat[1] + 0.0005], // Điểm dưới trái
                            [lngLat[0] + 0.0002, lngLat[1] + 0.0005], // Điểm dưới phải
                            [lngLat[0], lngLat[1] - 0.0002], // Điểm đỉnh
                            [lngLat[0] - 0.0002, lngLat[1] + 0.0005] // Quay lại điểm đầu
                        ]]
                    }
                }]
            };

            // Kiểm tra xem nguồn đã tồn tại chưa trước khi thêm
            if (this.map.getSource('circle')) {
                this.map.removeSource('circle');
            }

            // Thêm source cho vòng tròn
            this.map.addSource('circle', {
                'type': 'geojson',
                'data': circleData
            });

            // Thêm layer cho vòng tròn
            this.map.addLayer({
                id: 'circle',
                type: 'fill',
                source: 'circle',
                paint: {
                    'fill-color': '#FF0000', // Màu của mũi tên
                    'fill-opacity': 1 // Độ trong suốt
                }
            });

            // Di chuyển đến vị trí mới
            this.map.flyTo({ center: lngLat, zoom: this.zoom }); // Bạn có thể điều chỉnh zoom ở đây
        },
        drawCircle(center, radius) {
            const points = 64; // Số điểm để vẽ vòng tròn
            const coords = [];

            for (let i = 0; i <= points; i++) {
                const angle = (i / points) * 2 * Math.PI; // Tính toán góc
                const dx = radius * Math.cos(angle); // Tính toán độ dịch chuyển theo kinh độ
                const dy = radius * Math.sin(angle); // Tính toán độ dịch chuyển theo vĩ độ
                coords.push([
                    center[0] + dx / 111320, // Kinh độ
                    center[1] + dy / 110574  // Vĩ độ
                ]);
            }
            coords.push(coords[0]); // Đảm bảo vòng tròn khép kín

            return coords;
        }
    }
};
</script>

<style>
#map {
    width: 100%;
    height: 100vh;
    /* Chiều cao của bản đồ */
}
</style>