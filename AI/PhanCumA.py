import numpy as np
from pulp import *

def optimize_clustering(distance_matrix, center_indices, min_cluster_size=4):
    """
    distance_matrix: Ma trận khoảng cách giữa các điểm
    center_indices: List các chỉ số của điểm trung tâm
    min_cluster_size: Kích thước tối thiểu của mỗi cụm (mặc định = 4)
    """
    n_points = len(distance_matrix)  # Tổng số điểm
    n_centers = len(center_indices)  # Số điểm trung tâm
    
    # Tạo bài toán tối ưu
    prob = LpProblem("Clustering_with_Constraints", LpMinimize)
    
    # Biến quyết định: x[i][j] = 1 nếu điểm i thuộc cụm có tâm j
    x = LpVariable.dicts("assignment",
                        ((i, j) for i in range(n_points) 
                         for j in center_indices),
                        cat='Binary')
    
    # Hàm mục tiêu: Tối thiểu tổng khoảng cách
    prob += lpSum(distance_matrix[i][j] * x[i,j] 
                 for i in range(n_points) 
                 for j in center_indices)
    
    # Ràng buộc 1: Mỗi điểm phải thuộc đúng 1 cụm
    for i in range(n_points):
        prob += lpSum(x[i,j] for j in center_indices) == 1
    
    # Ràng buộc 2: Mỗi cụm phải có ít nhất min_cluster_size điểm
    for j in center_indices:
        prob += lpSum(x[i,j] for i in range(n_points)) >= min_cluster_size
    
    # Ràng buộc 3: Điểm trung tâm phải thuộc cụm của chính nó
    for j in center_indices:
        prob += x[j,j] == 1
    
    # Giải bài toán
    prob.solve()
    
    # Lấy kết quả
    clusters = {j: [] for j in center_indices}
    for i in range(n_points):
        for j in center_indices:
            if value(x[i,j]) == 1:
                clusters[j].append(i)
    
    # Tính tổng khoảng cách
    total_distance = sum(distance_matrix[i][j] 
                        for j in center_indices 
                        for i in clusters[j])
    
    return clusters, total_distance

# Hàm hỗ trợ in kết quả
def print_clustering_results(clusters, distance_matrix, locations=None):
    """
    In kết quả phân cụm
    locations: list tên các địa điểm (tùy chọn)
    """
    print("\nKết quả phân cụm:")
    for center, members in clusters.items():
        print(f"\nNhóm với trung tâm {center}:")
        total_distance = 0
        
        if locations:
            print(f"Trung tâm: {locations[center]}")
            print("Các thành viên:")
            for point in members:
                if point != center:
                    dist = distance_matrix[point][center]
                    total_distance += dist
                    print(f"- {locations[point]} (khoảng cách: {dist:.2f}km)")
        else:
            print(f"Trung tâm: Point {center}")
            print("Các thành viên:")
            for point in members:
                if point != center:
                    dist = distance_matrix[point][center]
                    total_distance += dist
                    print(f"- Point {point} (khoảng cách: {dist:.2f}km)")
        
        print(f"Tổng khoảng cách trong nhóm: {total_distance:.2f}km")
        print(f"Số lượng thành viên: {len(members)}")

# Ví dụ sử dụng:
def example_usage():
    # Tạo dữ liệu mẫu
    locations = [
        "Bệnh viện A",    # 0 - trung tâm 1
        "Nhà thuốc 1",    # 1
        "Nhà thuốc 2",    # 2
        "Nhà thuốc 3",    # 3
        "Bệnh viện B",    # 4 - trung tâm 2
        "Nhà thuốc 4",    # 5
        "Nhà thuốc 5",    # 6
        "Nhà thuốc 6",    # 7
        "Nhà thuốc 7",    # 8
        "Nhà thuốc 8"     # 9
    ]
    
    # Ma trận khoảng cách mẫu (đơn vị: km)
    distance_matrix = np.array([
        [0, 2, 3, 4, 8, 7, 6, 5, 9, 8],
        [2, 0, 2, 3, 7, 6, 5, 4, 8, 7],
        [3, 2, 0, 2, 6, 5, 4, 3, 7, 6],
        [4, 3, 2, 0, 5, 4, 3, 2, 6, 5],
        [8, 7, 6, 5, 0, 2, 3, 4, 5, 4],
        [7, 6, 5, 4, 2, 0, 2, 3, 4, 3],
        [6, 5, 4, 3, 3, 2, 0, 2, 3, 2],
        [5, 4, 3, 2, 4, 3, 2, 0, 2, 3],
        [9, 8, 7, 6, 5, 4, 3, 2, 0, 2],
        [8, 7, 6, 5, 4, 3, 2, 3, 2, 0]
    ])
    
    # Chỉ định các điểm trung tâm (ví dụ: bệnh viện 0 và 4)
    center_indices = [0, 5, 6]
    
    # Thực hiện phân cụm
    clusters, total_distance = optimize_clustering(
        distance_matrix, 
        center_indices, 
        min_cluster_size=3
    )
    
    # In kết quả
    print_clustering_results(clusters, distance_matrix, locations)
    print(f"\nTổng khoảng cách toàn bộ: {total_distance:.2f}km")

# Chạy ví dụ
example_usage()