import math
from collections import defaultdict
from pulp import *
from geopy.geocoders import Nominatim

def get_coordinate(location: str):
    """Lấy tọa độ (latitude, longitude) từ tên địa điểm."""
    geolocator = Nominatim(user_agent="my_agent")
    try:
        location_data = geolocator.geocode(location)
        if location_data:
            return (location_data.latitude, location_data.longitude)
        else:
            raise ValueError("Không tìm thấy tọa độ cho địa điểm này.")
    except Exception as e:
        raise Exception(f"Error fetching coordinates: {str(e)}")

def haversine_distance(lat1, lon1, lat2, lon2):
    """Tính khoảng cách giữa 2 điểm dựa trên công thức Haversine."""
    R = 6371  # Bán kính trái đất tính bằng km

    # Chuyển đổi độ sang radian
    lat1, lon1, lat2, lon2 = map(math.radians, [lat1, lon1, lat2, lon2])
    
    # Công thức Haversine
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    a = math.sin(dlat/2)**2 + math.cos(lat1) * math.cos(lat2) * math.sin(dlon/2)**2
    c = 2 * math.asin(math.sqrt(a))
    
    return R * c

def get_distance_of_2_locations(latlong1, latlong2):
    """Lấy khoảng cách giữa hai tọa độ sử dụng công thức Haversine."""
    try:
        distance = haversine_distance(latlong1[0], latlong1[1], latlong2[0], latlong2[1])
        return distance
    except Exception as e:
        raise Exception(f"Error calculating distance: {str(e)}")

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
            print(f"Tọa độ của {location}: {coords}")

        # Xây dựng ma trận khoảng cách
        self.distances = get_distances_between_all_locations(self.coordinates)
        print("Ma trận khoảng cách:")
        for row in self.distances:
            print(row)
        # print(self.distances)
    
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
        # i check it ok at here
        print("Các nhóm:" , clusters)
        # Tối ưu lộ trình trong từng cluster
        cluster_routes = {}
        cluster_distances = {}
        
        for cluster_id, points in clusters.items():
            if len(points) > 0:
                cluster_distances_matrix = [[self.distances[i][j] for j in points] for i in points]
                print("check route  iiii")
                print(cluster_id)
                print(cluster_distances_matrix)

                min_dist, route = self.optimize_cluster_route(cluster_distances_matrix)
                print("check min dist")
                print(min_dist)
                # i check it is not ok at here, route is lack 1 location
                print("check route")
                print(route)

                actual_route = [points[i] for i in route]
                cluster_routes[cluster_id] = actual_route
                cluster_distances[cluster_id] = min_dist
        print("check route  ss") 
        print(cluster_routes)
        return cluster_routes, cluster_distances
    
    def optimize_cluster_route(self, distances):
        """Tối ưu lộ trình cho một cluster"""
        return self.optimize_daily_route(distances)
        
    def optimize_daily_route(self, distances):
        """
        Optimize the route for a single cluster using dynamic programming (Held-Karp algorithm).
        Ensures that all locations are included and the route forms a complete cycle.
        
        Args:
            distances (list of list of float): A symmetric distance matrix.
            
        Returns:
            tuple: (minimum total distance, optimal route as a list of indices)
        """
        n = len(distances)
        dp = {}
        parent = {}

        def solve(mask, last):
            if mask == (1 << n) - 1:
                return distances[last][0]  # Return to start
            if (mask, last) in dp:
                return dp[(mask, last)]
            
            min_cost = float('inf')
            for next_point in range(n):
                if not (mask & (1 << next_point)):
                    new_mask = mask | (1 << next_point)
                    cost = distances[last][next_point] + solve(new_mask, next_point)
                    if cost < min_cost:
                        min_cost = cost
                        parent[(mask, last)] = next_point
            dp[(mask, last)] = min_cost
            return min_cost

        def get_path():
            mask = 1  # Starting with the first node
            last = 0
            path = [last]
            while mask != (1 << n) - 1:
                next_point = parent.get((mask, last))
                if next_point is None:
                    break  # No path found
                path.append(next_point)
                mask |= (1 << next_point)
                last = next_point
            path.append(0)  # Return to start
            return path

        # Start the recursion with the first node as the starting point
        min_cost = solve(1, 0)
        path = get_path()

        # Verify that all points are included
        if len(path) != n + 1:
            print("Warning: The computed path does not include all locations.")
        
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


def test_travel_planner():
    """Hàm test với dữ liệu thực tế"""
    # Danh sách tên các địa điểm
    locations = [
        "Đại học bách khoa đà nẵng",
        "Đại học sư phạm đà nẵng",
        "Đại học y dược huế",
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
