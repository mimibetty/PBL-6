import numpy as np
from pulp import *

def optimize_clustering_with_different_sizes(distance_matrix, center_indices, min_cluster_sizes):
    """
    distance_matrix: Ma trận khoảng cách giữa các điểm
    center_indices: List các chỉ số của điểm trung tâm
    min_cluster_sizes: Dictionary chứa kích thước tối thiểu cho từng cụm
                      Key là center_index, value là min_size
    """
    n_points = len(distance_matrix)
    n_centers = len(center_indices)
    
    # Kiểm tra dữ liệu đầu vào
    if not all(center in min_cluster_sizes for center in center_indices):
        raise ValueError("Phải chỉ định kích thước tối thiểu cho tất cả các trung tâm")
    
    # Tạo bài toán tối ưu
    prob = LpProblem("Clustering_with_Different_Sizes", LpMinimize)
    
    # Biến quyết định
    x = LpVariable.dicts("assignment",
                        ((i, j) for i in range(n_points) 
                         for j in center_indices),
                        cat='Binary')
    
    # Hàm mục tiêu
    prob += lpSum(distance_matrix[i][j] * x[i,j] 
                 for i in range(n_points) 
                 for j in center_indices)
    
    # Ràng buộc 1: Mỗi điểm phải thuộc đúng 1 cụm
    for i in range(n_points):
        prob += lpSum(x[i,j] for j in center_indices) == 1
    
    # Ràng buộc 2: Mỗi cụm phải có số điểm tối thiểu theo yêu cầu
    for j in center_indices:
        prob += lpSum(x[i,j] for i in range(n_points)) >= min_cluster_sizes[j]
    
    # Ràng buộc 3: Điểm trung tâm phải thuộc cụm của chính nó
    for j in center_indices:
        prob += x[j,j] == 1
    
    # Giải bài toán
    prob.solve()
    
    if LpStatus[prob.status] != 'Optimal':
        return None, None  # Không tìm được giải pháp
    
    # Lấy kết quả
    clusters = {j: [] for j in center_indices}
    for i in range(n_points):
        for j in center_indices:
            if value(x[i,j]) == 1:
                clusters[j].append(i)
    
    total_distance = sum(distance_matrix[i][j] 
                        for j in center_indices 
                        for i in clusters[j])
    
    return clusters, total_distance

# Hàm in kết quả (giữ nguyên như cũ)
def print_clustering_results(clusters, distance_matrix, locations=None):
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

# Ví dụ sử dụng với kích thước tối thiểu khác nhau
def example_usage_different_sizes():
    # Tạo dữ liệu mẫu
    locations = [
        "Trung tâm A",    # 0 - center 1
        "Điểm 1",         # 1
        "Điểm 2",         # 2
        "Điểm 3",         # 3
        "Trung tâm B",    # 4 - center 2
        "Điểm 4",         # 5
        "Điểm 5",         # 6
        "Trung tâm C",    # 7 - center 3
        "Điểm 6",         # 8
        "Điểm 7",         # 9
        "Điểm 8",         # 10
        "Điểm 9",         # 11
        "Điểm 10",        # 12
        "Điểm 11",        # 13
        "Điểm 12"         # 14
    ]
    
    # Ma trận khoảng cách mẫu (15x15)
    distance_matrix = np.random.rand(15, 15)
    # Đảm bảo ma trận đối xứng và đường chéo = 0
    distance_matrix = (distance_matrix + distance_matrix.T) / 2
    np.fill_diagonal(distance_matrix, 0)
    
    # Chỉ định các điểm trung tâm và kích thước tối thiểu cho từng cụm
    center_indices = [0, 4, 7]  # 3 trung tâm
    min_cluster_sizes = {
        0: 5,  # Cụm 1 tối thiểu 3 điểm
        4: 4,  # Cụm 2 tối thiểu 3 điểm
        7: 1   # Cụm 3 tối thiểu 7 điểm
    }
    
    # Thực hiện phân cụm
    clusters, total_distance = optimize_clustering_with_different_sizes(
        distance_matrix, 
        center_indices, 
        min_cluster_sizes
    )
    
    if clusters is None:
        print("Không tìm được giải pháp thỏa mãn các ràng buộc!")
        return
    
    # In kết quả
    print_clustering_results(clusters, distance_matrix, locations)
    print(f"\nTổng khoảng cách toàn bộ: {total_distance:.2f}km")
    
    # In thông tin về kích thước các cụm
    print("\nKích thước các cụm:")
    for center in center_indices:
        print(f"Cụm {center}: {len(clusters[center])} điểm "
              f"(yêu cầu tối thiểu: {min_cluster_sizes[center]})")

# Chạy ví dụ
example_usage_different_sizes()