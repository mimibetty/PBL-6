<template>
  <div class="tag-management container">
    <h2 class="title-effect">Tag Management</h2>

    <!-- Form Container -->
    <div class="form-container">
      <form @submit.prevent="submitAddTag" class="form-style">
        <!-- Tag Name -->
        <div class="form-floating mb-3">
          <input type="text" v-model="tag.name" placeholder=" " class="form-control" id="tagName" required />
          <label for="tagName">Tag Name</label>
        </div>

        <!-- Form Buttons -->
        <div class="button-group d-flex justify-content-between">
          <button type="submit" class="btn btn-success">Create</button>
          <button type="button" @click="cancelAction" class="btn btn-danger">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</template>
  
  <script setup>
import { ref, onMounted } from "vue";
import TagManagementController from "@/controllers/TagManagementController";

const {
  confirmCreate,
} = TagManagementController();

const tag = ref({
  id: 0,
  name: "",
});


const submitAddTag = async () => {
  await confirmCreate(tag.value);
};



const cancelAction = () => {
  window.history.back();
};


</script>

  
<style scoped>
.tag-management {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 10px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}

.title-effect {
  text-align: center;
  color: #343a40;
  font-size: 2rem;
  margin-bottom: 20px;
  font-weight: 700;
  text-transform: capitalize;
  letter-spacing: 1px;
  transition: transform 0.3s ease, color 0.3s ease;
}

.title-effect:hover {
  transform: scale(1.05);
  color: #007bff;
}

.form-floating {
  position: relative;
}

.form-floating input, 
.form-floating select {
  border-radius: 8px;
  border: 1px solid #ddd;
  padding: 10px;
  width: 100%;
  font-size: 1rem;
}

.form-floating label {
  position: absolute;
  top: 50%;
  left: 10px;
  transform: translateY(-50%);
  font-size: 1rem;
  color: #6c757d;
  pointer-events: none;
  transition: all 0.3s ease;
}

.form-floating input:focus + label,
.form-floating input:not(:placeholder-shown) + label,
.form-floating select:focus + label,
.form-floating select:not(:placeholder-shown) + label {
  top: 0;
  transform: translateY(-45%);
  font-size: 0.75rem;
  color: #007bff;
}

.button-group .btn {
  width: 48%;
}
</style>
  