import math
import itertools
from collections import defaultdict
from pulp import LpProblem, LpMinimize, LpVariable, lpSum, value, LpStatus
from geopy.geocoders import Nominatim


def get_coordinate(location: str):
    """
    Get the (latitude, longitude) coordinates from the location name using geopy.

    Args:
        location (str): The name of the location.

    Returns:
        tuple: (latitude, longitude)
    """
    geolocator = Nominatim(user_agent="my_agent")
    try:
        location_data = geolocator.geocode(location)
        if location_data:
            return (location_data.latitude, location_data.longitude)
        else:
            raise ValueError(f"Không tìm thấy tọa độ cho địa điểm: {location}.")
    except Exception as e:
        raise Exception(f"Lỗi khi lấy tọa độ cho '{location}': {str(e)}")


def haversine_distance(lat1, lon1, lat2, lon2):
    """
    Calculate the Haversine distance between two geographic coordinates.

    Args:
        lat1, lon1, lat2, lon2 (float): Coordinates in decimal degrees.

    Returns:
        float: Distance in kilometers.
    """
    R = 6371  # Radius of the Earth in km

    # Convert degrees to radians
    lat1_rad, lon1_rad, lat2_rad, lon2_rad = map(math.radians, [lat1, lon1, lat2, lon2])

    # Haversine formula
    dlat = lat2_rad - lat1_rad
    dlon = lon2_rad - lon1_rad
    a = math.sin(dlat / 2)**2 + math.cos(lat1_rad) * math.cos(lat2_rad) * math.sin(dlon / 2)**2
    c = 2 * math.asin(math.sqrt(a))

    return R * c


def get_distance_of_2_locations(latlong1, latlong2):
    """
    Get the distance between two coordinates using the Haversine formula.

    Args:
        latlong1, latlong2 (tuple): (latitude, longitude)

    Returns:
        float: Distance in kilometers.
    """
    try:
        distance = haversine_distance(latlong1[0], latlong1[1], latlong2[0], latlong2[1])
        return distance
    except Exception as e:
        raise Exception(f"Lỗi khi tính khoảng cách: {str(e)}")


def get_distances_between_all_locations(locations):
    """
    Generate a symmetric distance matrix for all locations.

    Args:
        locations (list of tuple): List of (latitude, longitude) coordinates.

    Returns:
        list of list of float: Distance matrix.
    """
    n = len(locations)
    distances = [[0] * n for _ in range(n)]  # Initialize n x n matrix

    for i in range(n):
        for j in range(i + 1, n):  # Calculate each pair only once
            if distances[i][j] == 0:
                distance = get_distance_of_2_locations(locations[i], locations[j])
                distances[i][j] = distance
                distances[j][i] = distance
    return distances


class TravelPlanner:
    def __init__(self, locations, centers, min_points_per_cluster=4):
        """
        Initialize the TravelPlanner with locations, centers, and cluster constraints.

        Args:
            locations (list of str): List of location names.
            centers (list of int): List of center indices.
            min_points_per_cluster (int): Minimum number of points per cluster.
        """
        self.locations = locations
        self.centers = centers
        self.min_points = min_points_per_cluster
        self.n = len(locations)
        self.m = len(centers)

        # Get coordinates for all locations
        self.coordinates = []
        for location in locations:
            coords = get_coordinate(location)
            self.coordinates.append(coords)
            print(f"Tọa độ của '{location}': {coords}")

        # Build distance matrix
        self.distances = get_distances_between_all_locations(self.coordinates)
        print("\nMa trận khoảng cách:")
        for row in self.distances:
            print(row)

    def plan_trip(self):
        """
        Plan the trip by clustering locations and optimizing routes within each cluster.

        Returns:
            tuple: (cluster_routes, cluster_distances)
        """
        # Define the optimization problem
        prob = LpProblem("Clustering_with_Constraints", LpMinimize)

        # Decision variables: x[i][j] = 1 if location i is assigned to cluster j
        x = LpVariable.dicts("assign",
                             ((i, j) for i in range(self.n) for j in range(self.m)),
                             cat='Binary')

        # Objective: Minimize the total distance from each location to its cluster center
        prob += lpSum(self.distances[i][self.centers[j]] * x[i, j]
                     for i in range(self.n) for j in range(self.m)), "Total_Distance"

        # Constraint 1: Each location must belong to exactly one cluster
        for i in range(self.n):
            prob += lpSum(x[i, j] for j in range(self.m)) == 1, f"One_cluster_per_location_{i}"

        # Constraint 2: Each cluster must have at least min_points_per_cluster locations
        for j in range(self.m):
            prob += lpSum(x[i, j] for i in range(self.n)) >= self.min_points, f"Min_points_cluster_{j}"

        # Constraint 3: Each center must be assigned to its respective cluster
        for j in range(self.m):
            prob += x[self.centers[j], j] == 1, f"Center_assignment_{j}"

        # Solve the optimization problem
        prob.solve()

        # Check if the problem has an optimal solution
        if LpStatus[prob.status] != 'Optimal':
            raise Exception("Không tìm được giải pháp tối ưu.")

        # Process the results
        clusters = defaultdict(list)
        for i in range(self.n):
            for j in range(self.m):
                if value(x[i, j]) == 1:
                    clusters[j].append(i)
        print("\nCác nhóm (Clusters):", clusters)

        # Optimize the route within each cluster
        cluster_routes = {}
        cluster_distances = {}

        for cluster_id, points in clusters.items():
            if len(points) > 0:
                # Create a distance matrix for the current cluster
                cluster_distance_matrix = [[self.distances[i][j] for j in points] for i in points]
                print(f"\nĐang tối ưu hóa lộ trình cho Nhóm {cluster_id + 1} với các điểm {points}")
                print("Ma trận khoảng cách nhóm:")
                for row in cluster_distance_matrix:
                    print(row)

                # Optimize the route
                min_dist, route = self.optimize_cluster_route(cluster_distance_matrix)
                print(f"Khoảng cách tối thiểu cho Nhóm {cluster_id + 1}: {min_dist:.2f} km")
                print(f"Lộ trình cho Nhóm {cluster_id + 1}: {route}")

                # Map the route indices back to original location indices
                actual_route = [points[i] for i in route]
                cluster_routes[cluster_id] = actual_route
                cluster_distances[cluster_id] = min_dist

        print("\nTất cả các lộ trình nhóm:", cluster_routes)
        return cluster_routes, cluster_distances

    def optimize_cluster_route(self, distances):
        """
        Optimize the route for a single cluster.

        Args:
            distances (list of list of float): Distance matrix for the cluster.

        Returns:
            tuple: (minimum total distance, optimal route as a list of indices)
        """
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
        dp = {}      # Dictionary to store the minimum cost to reach a subset ending at a point
        parent = {}  # Dictionary to store the parent of each state for path reconstruction

        def solve(mask, last):
            """
            Recursively solve for the minimum cost to reach 'last' with visited nodes represented by 'mask'.
            """
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
            """
            Reconstruct the optimal path from the parent pointers.
            """
            mask = 1          # Starting with the first node (index 0)
            last = 0          # Starting node
            path = [last]     # Initialize path with the starting node
            while mask != (1 << n) - 1:
                next_point = parent.get((mask, last))
                if next_point is None:
                    break  # No path found
                path.append(next_point)
                mask |= (1 << next_point)
                last = next_point
            path.append(0)  # Return to start to complete the cycle
            return path

        # Start the recursion with the first node as the starting point
        min_cost = solve(1, 0)
        path = get_path()

        # Verify that all points are included
        if len(path) != n + 1:
            print("Warning: The computed path does not include all locations.")

        return min_cost, path

    def format_result(self, cluster_routes, cluster_distances):
        """
        Format the result for display.

        Args:
            cluster_routes (dict): Cluster ID mapped to list of location indices in order.
            cluster_distances (dict): Cluster ID mapped to total distance.

        Returns:
            str: Formatted result string.
        """
        result = []
        for cluster_id in range(self.m):
            route = cluster_routes.get(cluster_id, [])
            distance = cluster_distances.get(cluster_id, 0)

            if not route:
                cluster_info = f"\nNhóm {cluster_id + 1} (Trung tâm: {self.locations[self.centers[cluster_id]]}):"
                cluster_info += f"\nKhông có địa điểm nào trong nhóm."
                result.append(cluster_info)
                continue

            cluster_info = f"\nNhóm {cluster_id + 1} (Trung tâm: {self.locations[self.centers[cluster_id]]}):"
            # Convert location indices to names
            route_names = ' -> '.join(self.locations[i] for i in route)
            cluster_info += f"\nLộ trình: {route_names}"
            cluster_info += f"\nTổng khoảng cách: {distance:.2f} km"
            result.append(cluster_info)

        return '\n'.join(result)


def run_travel_planner(locations, m, centers=None, min_points_per_cluster=4):
    """
    Run the TravelPlanner with given parameters.

    Args:
        locations (list of str): List of location names.
        m (int): Number of clusters/days.
        centers (list of int, optional): List of center indices. If None or empty, the first 'm' locations are used as centers.
        min_points_per_cluster (int, optional): Minimum number of points per cluster (default is 4).

    Returns:
        str: Formatted trip plan result.
    """
    # If centers are not provided, use the first 'm' locations as centers
    if not centers:
        if m > len(locations):
            raise ValueError("Số ngày đi (m) không được vượt quá số địa điểm.")
        centers = list(range(m))
        print(f"\nKhông có danh sách trung tâm. Sử dụng {m} địa điểm đầu tiên làm trung tâm: {centers}")
    else:
        if len(centers) != m:
            raise ValueError("Số trung tâm phải bằng số ngày đi (m).")
        if any(center >= len(locations) or center < 0 for center in centers):
            raise ValueError("Các chỉ số trung tâm phải nằm trong khoảng từ 0 đến số địa điểm - 1.")

    # Initialize the TravelPlanner
    planner = TravelPlanner(locations, centers, min_points_per_cluster)

    # Plan the trip
    cluster_routes, cluster_distances = planner.plan_trip()

    # Format and return the result
    result = planner.format_result(cluster_routes, cluster_distances)
    return result


# Example usage:
if __name__ == "__main__":
    # Example list of location names
    locations = [
        "Đại học Bách Khoa Đà Nẵng",
        "Đại học Y Dược Huế",
        "Đại học Sư phạm Đà Nẵng",
        "Chùa Một Cột, Hà Nội",
        "Hoàng Thành Thăng Long, Hà Nội",
        "Nhà Thờ Lớn Hà Nội",
        "Bảo tàng Lịch sử Quốc gia, Hà Nội",
    ]

    # Number of travel days (clusters)
    m = 2  # Example: 2 days

    # Optional: Specify centers by their indices. If empty or None, the first 'm' locations are used as centers
    centers = []  # Example: [] or [0, 2]

    # Run the travel planner
    try:
        trip_plan = run_travel_planner(locations, m, centers, min_points_per_cluster=2)
        print("\nKế hoạch chuyến đi:")
        print(trip_plan)
    except Exception as e:
        print(f"Đã xảy ra lỗi: {e}")