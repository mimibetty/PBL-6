import numpy as np
from sklearn.cluster import KMeans
from collections import defaultdict

class TravelPlanner:
    def __init__(self, locations, distances, num_days):
        self.locations = locations
        self.distances = distances
        self.num_days = num_days
        self.n = len(locations)
        
    def plan_trip(self):
        # Phân cụm các địa điểm theo số ngày
        coordinates = np.array([(loc[1], loc[2]) for loc in self.locations])
        kmeans = KMeans(n_clusters=self.num_days, n_init=10, random_state=42)
        clusters = kmeans.fit_predict(coordinates)
        
        # Gom các địa điểm theo cluster
        daily_locations = defaultdict(list)
        for idx, cluster in enumerate(clusters):
            daily_locations[cluster].append(idx)
            
        daily_routes = {}
        daily_distances = {}
        
        for day in range(self.num_days):
            points = daily_locations[day]
            if len(points) > 0:
                # Tạo ma trận khoảng cách cho các điểm trong ngày
                day_distances = [[self.distances[i][j] for j in points] for i in points]
                min_dist, route = self.optimize_daily_route(day_distances)
                if route:  # Kiểm tra xem có tìm được route không
                    actual_route = [points[i] for i in route]
                    daily_routes[day] = actual_route
                    daily_distances[day] = min_dist
                else:
                    daily_routes[day] = points  # Nếu không tìm được route, sử dụng thứ tự mặc định
                    daily_distances[day] = sum(self.distances[points[i]][points[i+1]] 
                                            for i in range(len(points)-1))
                
        return daily_routes, daily_distances
    
    def optimize_daily_route(self, distances):
        n = len(distances)
        if n == 0:
            return 0, []
        if n == 1:
            return 0, [0]
            
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
                        current_cost = distances[current_end][next_p]
                        if (new_mask, next_p) in dp:
                            current_cost += dp[(new_mask, next_p)]
                        if current_cost < min_cost:
                            min_cost = current_cost
                            next_point = next_p
                
                if next_point is None:  # Nếu không tìm được điểm tiếp theo
                    break
                    
                path.append(next_point)
                current_mask |= (1 << next_point)
                current_end = next_point
            
            return path if len(path) == n else None
        
        # Tìm điểm xuất phát tối ưu
        min_cost = float('inf')
        best_start = 0
        best_path = None
        
        for start in range(n):
            cost = solve(1 << start, start)
            if cost < min_cost:
                path = get_path(1 << start, start)
                if path and len(path) == n:  # Kiểm tra path hợp lệ
                    min_cost = cost
                    best_start = start
                    best_path = path
        
        return min_cost, best_path

    def format_result(self, daily_routes, daily_distances):
        result = []
        for day in range(self.num_days):
            if day in daily_routes:
                route = daily_routes[day]
                distance = daily_distances.get(day, 0)
                
                day_plan = f"\nNgày {day + 1}:"
                day_plan += f"\nLộ trình: {' -> '.join(self.locations[i][0] for i in route)}"
                day_plan += f"\nTổng khoảng cách: {distance:.2f} km"
                result.append(day_plan)
            
        return '\n'.join(result)

# Ví dụ sử dụng:
if __name__ == "__main__":
    # Danh sách địa điểm: (tên, vĩ độ, kinh độ)
    locations = [
        ("Hồ Hoàn Kiếm", 21.0285, 105.8542),
        ("Văn Miếu", 21.0293, 105.8355),
        ("Lăng Bác", 21.0367, 105.8346),
        ("Chùa Một Cột", 21.0358, 105.8333),
        ("Hoàng Thành Thăng Long", 21.0359, 105.8422),
        ("Nhà Thờ Lớn", 21.0286, 105.8493)
    ]
    
    # Ma trận khoảng cách (km)
    distances = [
        [0, 2.1, 3.2, 3.0, 2.8, 0.5],
        [2.1, 0, 1.5, 1.3, 1.1, 1.8],
        [3.2, 1.5, 0, 0.3, 0.7, 2.9],
        [3.0, 1.3, 0.3, 0, 0.9, 2.7],
        [2.8, 1.1, 0.7, 0.9, 0, 2.5],
        [0.5, 1.8, 2.9, 2.7, 2.5, 0]
    ]
    
    num_days = 2
    
    try:
        planner = TravelPlanner(locations, distances, num_days)
        daily_routes, daily_distances = planner.plan_trip()
        result = planner.format_result(daily_routes, daily_distances)
        print(result)
    except Exception as e:
        print(f"Có lỗi xảy ra: {str(e)}")