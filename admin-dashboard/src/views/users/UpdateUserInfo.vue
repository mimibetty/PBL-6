<template>
  <div class="user-management container">
    <h2 class="text-center my-4 title-effect">User Management</h2>

    <!-- Update User Info Form -->
    <div class="form-container">
      <h3 class="text-center">Update User Info</h3>
      <form @submit.prevent="submitUpdateUser" class="form-style">
        
        <!-- Disabled Inputs for Basic Info -->
        <div class="form-floating mb-3">
          <input type="text" v-model="currentUser.username" disabled class="form-control" id="username" />
          <label for="username">Username</label>
        </div>
        <div class="form-floating mb-3">
          <input type="email" v-model="currentUser.email" disabled class="form-control" id="email" />
          <label for="email">Email</label>
        </div>
        <div class="form-floating mb-3">
          <input type="text" v-model="currentUser.role" disabled class="form-control" id="role" />
          <label for="role">Role</label>
        </div>

        <!-- User Info Section -->
        <div class="form-floating mb-3">
          <textarea v-model="currentUser.userInfo.description" placeholder=" " class="form-control" id="description"></textarea>
          <label for="description">Description</label>
        </div>
        <div class="form-floating mb-3">
          <input type="text" v-model="currentUser.userInfo.phone_number" placeholder=" " class="form-control" id="phone" />
          <label for="phone">Phone Number</label>
        </div>

        <!-- Image Section -->
        <div class="form-group mb-3">
          <label for="currentImage">Current Image:</label>
          <div v-if="currentUser.userInfo.image.url">
            <img
              :src="currentUser.userInfo.image.url"
              alt="Current Image"
              class="img-thumbnail"
              style="width: 150px; height: auto; margin-bottom: 10px"
            />
          </div>
          <label for="imageUpload">Upload New Image:</label>
          <input
            type="file"
            @change="handleImageUpload"
            accept="image/*"
            id="imageUpload"
            class="form-control"
          />
        </div>

        <!-- Address Section -->
        <div class="form-floating mb-3">
          <select
            v-model="currentUser.userInfo.address.city_id"
            class="form-select"
            id="city"
          >
            <option v-for="city in cities" :key="city.id" :value="city.id">
              {{ city.name }}
            </option>
          </select>
          <label for="city">City</label>
        </div>
        <div class="form-floating mb-3">
          <input type="text" v-model="currentUser.userInfo.address.district" placeholder=" " class="form-control" id="district" />
          <label for="district">District</label>
        </div>
        <div class="form-floating mb-3">
          <input type="text" v-model="currentUser.userInfo.address.ward" placeholder=" " class="form-control" id="ward" />
          <label for="ward">Ward</label>
        </div>
        <div class="form-floating mb-3">
          <input type="text" v-model="currentUser.userInfo.address.street" placeholder=" " class="form-control" id="street" />
          <label for="street">Street</label>
        </div>

        <!-- Form Buttons -->
        <div class="button-group d-flex justify-content-between">
          <button type="submit" class="btn btn-primary">Update</button>
          <button type="button" @click="cancelAction" class="btn btn-danger">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</template>

  
  <script>
  import UserManagementController from "@/controllers/UserManagementController";
  import { ref, computed, onMounted } from "vue";
  import { useRoute } from "vue-router";
  import { useToast } from "vue-toastification";
  
  export default {
    setup() {
      const users = ref([]);
      const route = useRoute();
      const toast = useToast();
      const cities = ref([]);
      const userID = route.params.id;
  
      const {
        fetchUsers,
        actionStep,
        createInfo,
        updateInfo,
        confirmCreateInfo,
        confirmUpdateInfo,
        deleteInfo,
        addUser,
        confirmAddUser,
        changeStatus,
        fetchCities,
      } = UserManagementController();
  
      const currentUser = ref({
        id: "",
        username: "",
        email: "",
        role: "",
        userInfo: {
          id: 0,
          description: "",
          phone_number: "",
          image: {
            id: 0,
            url: "",
          },
          address: {
            district: "",
            street: "",
            ward: "",
            city_id: 0,
            id: 0,
          },
        },
        status: "",
      });
  
      const uploadedImageFile = ref(null);
  
  
      const loadCity = async () => {
        cities.value = await fetchCities();
      };
  
      onMounted(loadCity);
  
      onMounted(async () => {
        if (currentUser.value.userInfo.image.url) {
          uploadedImageFile.value = currentUser.value.userInfo.image.url;
        } else {
          uploadedImageFile.value = "";
        }
      });

      onMounted(async () => {
        
        await showUpdateForm(userID);
      });
  
  
  
  
      const getCityName = (city_id) => {
        const city = cities.value.find((c) => c.id === city_id);
        return city ? city.name : "Unknown City";
      };
  
  
      const showUpdateForm = async (userID) => {
        const user = await updateInfo(userID);
  
        currentUser.value = {
          ...user,
          userInfo: {
            id: user.userInfo?.id || 0,
            description: user.userInfo?.description || "",
            phone_number: user.userInfo?.phone_number || "",
            image: {
              url: user.userInfo?.image?.url || "",
            },
            address: {
              district: user.userInfo?.address?.district || "",
              street: user.userInfo?.address?.street || "",
              ward: user.userInfo?.address?.ward || "",
              city_id: user.userInfo?.address?.city_id ?? 0,
            },
          },
          status: user.status || "",
        };
        console.log(currentUser.value);
      };
  
  
      const submitUpdateUser = async () => {
        await confirmUpdateInfo(currentUser.value, uploadedImageFile.value);
      };
  
      const cancelAction = () => {
        window.history.back();
      };
  
      const handleImageUpload = (event) => {
        const file = event.target.files[0];
        if (file) {
          uploadedImageFile.value = file;
          currentUser.value.userInfo.image.url = URL.createObjectURL(file);
        }
      };
  
      return {
        users,
        currentUser,
        showUpdateForm,
        submitUpdateUser,
        cancelAction,
        handleImageUpload,
        cities,
        getCityName,
      };
    },
  };
  </script>
  
  <style scoped>
.user-management {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  background: #ffffff;
  border-radius: 10px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.form-container {
  padding: 20px;
}

h2 {
  text-align: center;
  color: #333;
}

.form-floating label {
  transition: all 0.3s ease;
}

.form-floating input:focus + label,
.form-floating input:not(:placeholder-shown) + label {
  transform: translateY(-1.5rem);
  font-size: 0.8rem;
  color: #0b31f0;
}

.button-group {
  display: flex;
  justify-content: space-between;
}
.title-effect {
  font-size: 2.5rem; /* Cỡ chữ lớn và dễ đọc */
  font-weight: 500; /* Độ đậm vừa phải */
  color: #343a40; /* Màu chữ xám đậm, dễ nhìn */
  text-transform: capitalize; /* Viết hoa chữ cái đầu tiên */
  letter-spacing: 1px; /* Khoảng cách giữa các chữ cái */
  text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.1); /* Bóng đổ nhẹ nhàng */
  transition: transform 0.3s ease, color 0.3s ease; /* Hiệu ứng khi hover */
}

.title-effect:hover {
  transform: scale(1.05); /* Phóng to nhẹ khi hover */
  color: #0b31f0; /* Đổi màu chữ khi hover */
}
</style>
  