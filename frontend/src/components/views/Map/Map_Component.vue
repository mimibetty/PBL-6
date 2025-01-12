<template>
    <div class="map-container">
        <div v-if="!selectedLocations.length" class="loading-spinner">
            <p class="p-4">Loading Map...</p>
        </div>
        <div id="map"></div>
    </div>
</template>

<script>
import maplibregl from 'maplibre-gl';

export default {
    props: {
        selectedLocations: {
            type: Array,
            default: () => [] // Danh sách các địa điểm
        },
        select: {
            type: Number,
            default: 0
        }
    },
    data() {
        return {
            map: null,
            apiUrl: 'https://rsapi.goong.io',
            mapUrl: 'https://tiles.goong.io/assets/',
            apiKey: 'ArPlUISaEBAdJFTABi9dcNGcue8WQ4cOAuGcNoBE',
            mapKey: 'tLyW2vk0aY3yfQLu8ZPy986mAgaW8igMYufv3BLY',
            zoom: 16, // Độ zoom mặc định
            routes: []
        };
    },
    mounted() {
        if (this.selectedLocations.length > 0) {
            this.initMap();
        }
    },
    watch: {
        selectedLocations: {
            handler(newLocations) {
                if (newLocations.length > 0) {
                    if (this.map) {
                        // Cập nhật map center
                        this.map.setCenter(newLocations[0]);
                        console.log("Updated map center:", newLocations[0]);
                        this.updateMap(newLocations);
                    } else {
                        // Nếu map chưa được tạo, khởi tạo lại
                        this.initMap();
                    }
                }
            },
            immediate: true,
            deep: true
        }
    },
    methods: {
        initMap() {
            const defaultCenter = this.selectedLocations[0];
            console.log('Initializing map with center:', defaultCenter);
            this.map = new maplibregl.Map({
                container: 'map',
                style: `${this.mapUrl}goong_map_web.json?api_key=${this.mapKey}`,
                center: defaultCenter,
                zoom: this.zoom,
            });
            console.log('Map instance created:', this.map);
            this.map.on('load', () => {
                if (this.selectedLocations.length > 0) {
                    console.log('Selected Locations in MapComponent(child):', this.selectedLocations);
                    this.addMarkers(this.selectedLocations);
                    if (this.select == 0) {
                        this.drawLineBetweenPoints(this.selectedLocations);
                    }
                }
            });
        },
        updateMap(locations) {
            console.log('Updating map with new locations:', locations);

            // Gọi hàm addMarkers của bạn để cập nhật marker
            this.addMarkers(locations);

            if (this.select == 0) {
                // Cập nhật tuyến đường
                this.drawLineBetweenPoints(locations);
            }
            else {
                this.clearRoutes();
            }
        },
        // Hàm tạo marker có đánh số thứ tự
        addMarkers(locations) {
            const features = locations.map((location, index) => ({
                type: 'Feature',
                geometry: {
                    type: 'Point',
                    coordinates: location
                },
                properties: {
                    id: index + 1 // Số thứ tự
                }
            }));

            const geojsonData = {
                type: 'FeatureCollection',
                features: features
            };
            // Nếu nguồn đã tồn tại, chỉ cần cập nhật dữ liệu
            if (this.map.getSource('markers-source')) {
                this.map.getSource('markers-source').setData(geojsonData);
            } else {
                // Nếu chưa tồn tại, tạo mới nguồn
                this.map.addSource('markers-source', {
                    type: 'geojson',
                    data: geojsonData
                });
            }

            features.forEach((feature, index) => {
                const markerId = `marker-${index + 1}`; // Số thứ tự
                if (!this.map.hasImage(markerId)) {
                    // Tạo marker SVG với số thứ tự
                    const svgElement = `
                        <svg width="30px" height="30px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M19.0074 5.02083C17.2556 3.14583 14.6793 2 12 2C9.3207 2 6.74444 3.04167 4.99259 5.02083C3.54989 6.6875 2.82854 8.77083 3.03464 10.8542C3.03464 11.2708 3.13769 11.6875 3.24074 12C4.16819 16.375 8.9085 20.2292 10.9695 21.6875C11.2786 21.8958 11.5878 22 12 22C12.4122 22 12.7214 21.8958 13.0305 21.6875C14.9885 20.2292 19.8318 16.375 20.7593 12C20.8623 11.6875 20.8623 11.2708 20.9654 10.8542C21.1715 8.77083 20.4501 6.6875 19.0074 5.02083ZM12 13.9792C10.4542 13.9792 9.1146 12.7292 9.1146 11.0625C9.1146 9.39583 10.3512 8.14583 12 8.14583C13.6488 8.14583 14.8854 9.39583 14.8854 11.0625C14.8854 12.7292 13.5458 13.9792 12 13.9792Z" fill="#13357B"/>
                            <text x="12" y="20" font-size="8" fill="#EDF6F9" text-anchor="middle" font-family="Roboto">
                                ${feature.properties.id}
                            </text>    
                        </svg>
                    `;
                    const canvas = document.createElement('canvas');
                    canvas.width = 30;
                    canvas.height = 30;
                    const ctx = canvas.getContext('2d');
                    const svgBase64 = `data:image/svg+xml;base64,${btoa(svgElement)}`;
                    const img = new Image();
                    img.src = svgBase64;
                    img.onload = () => {
                        ctx.clearRect(0, 0, canvas.width, canvas.height);
                        ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
                        const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

                        this.map.addImage(markerId, {
                            width: canvas.width,
                            height: canvas.height,
                            data: imageData.data
                        });

                        this.map.addLayer({
                            id: `marker-layer-${index + 1}`,
                            type: "symbol",
                            source: "markers-source",
                            layout: {
                                "icon-image": markerId,
                                "icon-size": 1.5,
                                "icon-anchor": "bottom",
                            },
                            filter: ["==", "id", feature.properties.id],
                        });
                    };
                }
            });
        },
        // Hàm nối các điểm trên map
        drawLineBetweenPoints(locations) {
            this.routes = [];

            if (locations.length >= 2) {
                for (let i = 0; i < locations.length - 1; i++) {
                    const startCoords = locations[i];
                    const endCoords = locations[i + 1];
                    this.fetchRoute(startCoords, endCoords);
                }
                console.log('Vẽ tuyến đường.');
            } else {
                console.warn('Không đủ tọa độ để vẽ tuyến đường.');
            }
        },
        // Hàm lấy route
        fetchRoute(startCoords, endCoords) {
            const apiLink = `${this.apiUrl}/direction?origin=${startCoords[1]},${startCoords[0]}&destination=${endCoords[1]},${endCoords[0]}&vehicle=car&api_key=${this.apiKey}`;
            fetch(apiLink)
                .then(response => response.json())
                .then(data => {
                    if (data.routes && data.routes.length > 0) {
                        const route = this.decodePolyline(data.routes[0].overview_polyline.points);
                        this.displayRoute(route);
                    } else {
                        console.error('Không tìm thấy tuyến đường phù hợp.');
                    }
                })
                .catch(error => console.error('Lỗi khi lấy tuyến đường:', error));
        },
        // Hàm giải mã route
        decodePolyline(encoded) {
            let points = [];
            let index = 0, len = encoded.length;
            let lat = 0, lng = 0;

            while (index < len) {
                let b, shift = 0, result = 0;
                do {
                    b = encoded.charCodeAt(index++) - 63;
                    result |= (b & 0x1f) << shift;
                    shift += 5;
                } while (b >= 0x20);
                let dlat = (result & 1) ? ~(result >> 1) : (result >> 1);
                lat += dlat;

                shift = 0;
                result = 0;
                do {
                    b = encoded.charCodeAt(index++) - 63;
                    result |= (b & 0x1f) << shift;
                    shift += 5;
                } while (b >= 0x20);
                let dlng = (result & 1) ? ~(result >> 1) : (result >> 1);
                lng += dlng;

                points.push([lng * 1e-5, lat * 1e-5]);
            }
            return points;
        },
        // Hàm hiển thị route
        displayRoute(route) {
            this.routes.push(route);
            console.log('Routes: ', this.routes);
            const allRoutes = {
                type: 'FeatureCollection',
                features: this.routes.map(route => ({
                    type: 'Feature',
                    geometry: {
                        type: 'LineString',
                        coordinates: route
                    }
                }))
            };

            // Cập nhật hoặc thêm mới source
            if (this.map.getSource('routes')) {
                this.map.getSource('routes').setData(allRoutes);
            } else {
                this.map.addSource('routes', {
                    type: 'geojson',
                    data: allRoutes
                });

                this.map.addLayer({
                    id: 'routes',
                    type: 'line',
                    source: 'routes',
                    layout: {
                        'line-join': 'round',
                        'line-cap': 'round'
                    },
                    paint: {
                        'line-color': '#13357B',
                        'line-width': 6
                    }
                });
            }
        },
        clearRoutes() {
            // Xóa layer 'routes' nếu tồn tại
            if (this.map.getLayer('routes')) {
                this.map.removeLayer('routes');
                console.log('Layer routes removed');
            }

            // Xóa source 'routes' nếu tồn tại
            if (this.map.getSource('routes')) {
                this.map.removeSource('routes');
                console.log('Source routes removed');
            }

            // Xóa mảng routes trong component
            this.routes = [];
        },
    }
};
</script>

<style>
.map-container {
    width: 100%;
    height: 100%;
    border-radius: 10px;
    overflow: hidden;
}

#map {
    width: 100%;
    height: 68vh;
}
</style>
