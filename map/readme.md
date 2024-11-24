# Chú thích file/folder:
- index.html: đây là file html có tạo marker, và tạo hình tròn xung quanh marker
- frontend/: vuejs có chức năng giống index.html nhưng bị lỗi chức năng thêm marker, thành ra phải sửa tạm hình tròn thành hình tam giác cho giống marker
- backend/: chạy FastAPI tham khảo

# Mục tiêu:
- Hiểu được luồng: Nhận detail từ AutoCompleteComponent -> truyền kinh độ, vĩ độ vào MapComponent -> show ra marker/hình tam giác trên bản đồ
- Ứng dụng vào địa điểm cho từng destination
- Phát triển thêm để hoàn thiện chức năng map cho tạo chuyến đi bằng AI - hiển thị nhiều marker trên 1 map (hiện tại đang lỗi marker)

# Step 1: install requirement

# Step 2: cd back + Run the backend


```
uvicorn main:app --reload --port 8000

```


# Step 3: cd front + Run the frontend
```
npm run serve

```