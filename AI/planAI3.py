import numpy as np
from pulp import *
from collections import defaultdict
import os
from dotenv import load_dotenv
import requests

# Tải các biến môi trường từ tệp .env
load_dotenv()
AZURE_CONNECTION_STRING = os.getenv('AZURE_CONNECTION_STRING')

GOONG_API_URL = os.getenv('GOONG_API_URL')
GOONG_MAP_URL = os.getenv('GOONG_MAP_URL')
GOONG_API_KEY = os.getenv('GOONG_API_KEY')
GOONG_MAP_KEY = os.getenv('GOONG_MAP_KEY')


def get_coordinate(location: str):
    """Lấy tọa độ (latitude, longitude) từ tên địa điểm."""
    api_link = f"{GOONG_API_URL}/Geocode?address={location}&api_key={GOONG_API_KEY}"
    response = requests.get(api_link)
    
    if response.status_code == 200:
        data = response.json()
        if data['results'] and len(data['results']) > 0:
            location_data = data['results'][0]['geometry']['location']
            return (location_data['lat'], location_data['lng'])
        else:
            raise ValueError("Không tìm thấy tọa độ cho địa điểm này.")
    else:
        raise Exception(f"Error fetching coordinates: {response.status_code} - {response.text}")

def get_distance_of_2_locations(latlong1, latlong2):
    """Lấy khoảng cách giữa hai tọa độ (latitude, longitude) sử dụng Goong API."""
    api_link = f"{GOONG_API_URL}/DistanceMatrix?origins={latlong1[0]},{latlong1[1]}&destinations={latlong2[0]},{latlong2[1]}&api_key={GOONG_API_KEY}"
    response = requests.get(api_link)
    
    if response.status_code == 200:
        data = response.json()
        if data['rows'] and len(data['rows']) > 0 and data['rows'][0]['elements'] and len(data['rows'][0]['elements']) > 0:
            distance = data['rows'][0]['elements'][0]['distance']['value']  # Giá trị khoảng cách tính bằng mét
            return distance / 1000  # Chuyển đổi sang km
        else:
            raise ValueError("Không tìm thấy khoảng cách giữa các địa điểm.")
    else:
        raise Exception(f"Error fetching distance: {response.status_code} - {response.text}")
def get_distances_between_all_locations(locations):
    """Lấy ra khoảng cách giữa tất cả các đường với nhau dưới dạng ma trận đối xứng."""
    n = len(locations)
    distances = [[0] * n for _ in range(n)]  # Khởi tạo ma trận n x n

    for i in range(n):
        for j in range(i + 1, n):  # Chỉ tính khoảng cách một lần cho mỗi cặp
            if (distances[i][j] == 0):
                distance = get_distance_of_2_locations(locations[i], locations[j])
                distances[i][j] = distance
                distances[j][i] = distance
    return distances


class TravelPlanner:
    def __init__(self, locations, centers, min_points_per_cluster=4):
        """
        locations: list các tên địa điểm
        centers: list of indices indicating center locations
        min_points_per_cluster: số điểm tối thiểu trong mỗi nhóm
        """
        self.locations = locations
        self.centers = centers
        self.min_points = min_points_per_cluster
        self.n = len(locations)
        self.m = len(centers)
        
        # Lấy tọa độ cho tất cả các địa điểm
        self.coordinates = []
        for location in locations:
            coords = get_coordinate(location)
            self.coordinates.append(coords)
            
        # Xây dựng ma trận khoảng cách
        self.distances = get_distances_between_all_locations(self.coordinates)
        print("Ma trận khoảng cách:")
        print(self.distances)
        
        self.distances = self.get_mock_distances()
        print("Ma trận khoảng cách:")
        print(self.distances)
    
    # def get_mock_distances(self):
    #     """Tạo ma trận khoảng cách giả cho các địa điểm ở Hà Nội"""
    #     # Ma trận khoảng cách giả (đơn vị: km)
    #     mock_distances = [
    #         [0.0, 2.5, 3.8, 3.5, 2.8, 0.5, 1.2],  # Hồ Hoàn Kiếm
    #         [2.5, 0.0, 3.2, 3.0, 2.5, 2.8, 2.9],  # Văn Miếu
    #         [3.8, 3.2, 0.0, 0.5, 1.2, 4.0, 3.5],  # Lăng Bác
    #         [3.5, 3.0, 0.5, 0.0, 1.0, 3.8, 3.3],  # Chùa Một Cột
    #         [2.8, 2.5, 1.2, 1.0, 0.0, 3.0, 2.5],  # Hoàng Thành
    #         [0.5, 2.8, 4.0, 3.8, 3.0, 0.0, 1.5],  # Nhà thờ Lớn
    #         [1.2, 2.9, 3.5, 3.3, 2.5, 1.5, 0.0],  # Bảo tàng Lịch sử
    #     ]
    #     return mock_distances

    def get_mock_distances(self):
        """Tạo ma trận khoảng cách giả cho các địa điểm"""
        n = len(self.locations)  # Lấy số lượng địa điểm thực tế
        mock_distances = []
        
        # Tạo ma trận với kích thước n x n
        for i in range(n):
            row = []
            for j in range(n):
                if i == j:
                    row.append(0.0)  # Khoảng cách từ điểm đến chính nó là 0
                else:
                    # Tạo khoảng cách giả ngẫu nhiên từ 0.5 đến 5.0 km
                    distance = 0.5 + (((i * 37 + j * 17) % 45) / 10.0)
                    row.append(round(distance, 1))
            mock_distances.append(row)
        
        # Đảm bảo ma trận đối xứng
        for i in range(n):
            for j in range(i + 1, n):
                mock_distances[j][i] = mock_distances[i][j]
        # print(mock_distances)            
        return mock_distances
    
    def plan_trip(self):
        # Tạo bài toán tối ưu
        prob = LpProblem("Clustering_with_Constraints", LpMinimize)
        
        # Biến quyết định x[i][j] = 1 nếu điểm i thuộc cluster j
        x = LpVariable.dicts("assign",
                           ((i, j) for i in range(self.n) for j in range(self.m)),
                           cat='Binary')
        
        # Hàm mục tiêu: Tối thiểu tổng khoảng cách
        prob += lpSum(self.distances[i][self.centers[j]] * x[i,j] 
                     for i in range(self.n) for j in range(self.m))
        
        # Ràng buộc 1: Mỗi điểm phải thuộc đúng 1 cluster
        for i in range(self.n):
            prob += lpSum(x[i,j] for j in range(self.m)) == 1
            
        # Ràng buộc 2: Mỗi cluster phải có ít nhất min_points điểm
        for j in range(self.m):
            prob += lpSum(x[i,j] for i in range(self.n)) >= self.min_points
            
        # Ràng buộc 3: Các điểm trung tâm phải thuộc cluster tương ứng
        for j in range(self.m):
            prob += x[self.centers[j], j] == 1
            
        # Giải bài toán
        prob.solve()
        
        # Xử lý kết quả
        clusters = defaultdict(list)
        for i in range(self.n):
            for j in range(self.m):
                if value(x[i,j]) == 1:
                    clusters[j].append(i)
                    
        # Tối ưu lộ trình trong từng cluster
        cluster_routes = {}
        cluster_distances = {}
        
        for cluster_id, points in clusters.items():
            if len(points) > 0:
                cluster_distances_matrix = [[self.distances[i][j] for j in points] for i in points]
                min_dist, route = self.optimize_cluster_route(cluster_distances_matrix)
                actual_route = [points[i] for i in route]
                cluster_routes[cluster_id] = actual_route
                cluster_distances[cluster_id] = min_dist
                
        return cluster_routes, cluster_distances
    
    def optimize_cluster_route(self, distances):
        """Tối ưu lộ trình cho một cluster"""
        return self.optimize_daily_route(distances)
        
    def optimize_daily_route(self, distances):
        n = len(distances)
        dp = {}
        
        def solve(mask, end):
            if mask == (1 << n) - 1:
                return 0
            if (mask, end) in dp:
                return dp[(mask, end)]
            ans = float('inf')
            for next_point in range(n):
                if not (mask & (1 << next_point)):
                    new_mask = mask | (1 << next_point)
                    current_cost = distances[end][next_point] + solve(new_mask, next_point)
                    ans = min(ans, current_cost)
            dp[(mask, end)] = ans
            return ans
        
        def get_path(mask, end):
            if mask == (1 << n) - 1:
                return [end]
            path = [end]
            current_mask = mask
            current_end = end
            while current_mask != (1 << n) - 1:
                min_cost = float('inf')
                next_point = None
                for next_p in range(n):
                    if not (current_mask & (1 << next_p)):
                        new_mask = current_mask | (1 << next_p)
                        cost = distances[current_end][next_p] + dp.get((new_mask, next_p), float('inf'))
                        if cost < min_cost:
                            min_cost = cost
                            next_point = next_p
                if next_point is None:
                    break
                path.append(next_point)
                current_mask |= (1 << next_point)
                current_end = next_point
            return path
        
        min_cost = float('inf')
        best_start = 0
        for start in range(n):
            cost = solve(1 << start, start)
            if cost < min_cost:
                min_cost = cost
                best_start = start
                
        path = get_path(1 << best_start, best_start)
        return min_cost, path
    
    # Hàm hỗ trợ in kết quả, địa điểm được mã hóa thành chữ cái đơn giản
    def format_result(self, cluster_routes, cluster_distances):
        result = []
        for cluster_id in range(self.m):
            route = cluster_routes[cluster_id]
            distance = cluster_distances[cluster_id]
            
            cluster_info = f"\nNhóm {cluster_id + 1} (Trung tâm: {self.locations[self.centers[cluster_id]][0]}):"
            cluster_info += f"\nLộ trình: {' -> '.join(self.locations[i][0] for i in route)}"
            cluster_info += f"\nTổng khoảng cách: {distance:.2f} km"
            result.append(cluster_info)
            
        return '\n'.join(result)

    # def format_result(self, cluster_routes, cluster_distances):
    #     """Format kết quả để in ra màn hình."""
    #     result = []
    #     for cluster_id in range(self.m):
    #         if cluster_id in cluster_routes and cluster_id in cluster_distances:
    #             route = cluster_routes[cluster_id]
    #             distance = cluster_distances[cluster_id]
                
    #             center_name = self.locations[self.centers[cluster_id]]
    #             result.append(f"Nhóm {cluster_id + 1} (Trung tâm: {center_name}):")
                
    #             # Tạo chuỗi lộ trình sử dụng tên đầy đủ của địa điểm
    #             route_names = [self.locations[idx] for idx in route]
    #             route_str = " -> ".join(route_names)
                
    #             result.append(f"Lộ trình: {route_str}")
    #             result.append(f"Tổng khoảng cách: {distance:.2f} km")
    #             result.append("")  # Thêm dòng trống giữa các nhóm
        
    #     return "\n".join(result)

def test_travel_planner():
    """Hàm test với dữ liệu thực tế"""
    # Danh sách tên các địa điểm
    locations = [
        "Hồ Hoàn Kiếm, Hà Nội",
        "Văn Miếu Quốc Tử Giám, Hà Nội",
        "Lăng Chủ tịch Hồ Chí Minh, Hà Nội",
        "Chùa Một Cột, Hà Nội",
        "Hoàng Thành Thăng Long, Hà Nội",
        "Nhà thờ Lớn Hà Nội",
        "Bảo tàng Lịch sử Quốc gia, Hà Nội",
    ]

    
    # Chọn các điểm làm trung tâm (index của các địa điểm)
    centers = [0,2]  # Hồ Hoàn Kiếm và Hoàng Thành Thăng Long làm trung tâm
    
    # Khởi tạo planner
    planner = TravelPlanner(locations, centers, min_points_per_cluster=2)
    
    # Lập kế hoạch
    cluster_routes, cluster_distances = planner.plan_trip()
    
    # In kết quả
    result = planner.format_result(cluster_routes, cluster_distances)
    print(result)

if __name__ == "__main__":
    test_travel_planner()


    #     locations = [
    #     "Hồ Hoàn Kiếm, Hà Nội",
    #     "Văn Miếu Quốc Tử Giám, Hà Nội",
    #     "Lăng Chủ tịch Hồ Chí Minh, Hà Nội",
    #     "Chùa Một Cột, Hà Nội",
    #     "Hoàng Thành Thăng Long, Hà Nội",
    #     "Nhà thờ Lớn Hà Nội",
    #     "Bảo tàng Lịch sử Quốc gia, Hà Nội",
    #     "Phố cổ Hà Nội",
    #     "Nhà hát lớn Hà Nội",
    #     "Chợ Đồng Xuân, Hà Nội"
    # ]