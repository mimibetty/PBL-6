<template>
    <div class="container-fluid setting-profile p-5">
        <div class="row">
            <div class="col-sm-6">
                <p>Username</p>
            </div>

            <div class="col-sm-6">
                <div class="container-fluid field-first-name">
                    <input class="field" type="text" placeholder="Your first name" v-model="currentUser.username" disabled>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-6">
                <p>Description</p>
            </div>

            <div class="col-sm-6">
                <div class="container-fluid field-first-name">
                    <input class="field" type="text" placeholder="Description about you" v-model="currentUser.user_info.description">
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-6">
                <p>Phone Number</p>
            </div>

            <div class="col-sm-6">
                <div class="container-fluid field-last-name">
                    <input class="field" type="text" placeholder="Your phone number" v-model="currentUser.user_info.phone_number">
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-6">
                <p>City</p>
            </div>

            <div class="col-sm-6">
                <div class="container-fluid">
                    <select v-model="currentUser.user_info.address.city_id"
                            class="field option">
                        <option v-for="city in cities" :key="city.id" :value="city.id">
                            {{ city.name }}
                        </option>
                    </select>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-6">
                <p>District</p>
            </div>

            <div class="col-sm-6">
                <div class="container-fluid field-last-name">
                    <input class="field" type="text" placeholder="Your district" v-model="currentUser.user_info.address.district">
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-6">
                <p>Ward</p>
            </div>

            <div class="col-sm-6">
                <div class="container-fluid field-last-name">
                    <input class="field" type="text" placeholder="Your ward" v-model="currentUser.user_info.address.ward">
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-6">
                <p>Street</p>
            </div>

            <div class="col-sm-6">
                <div class="container-fluid field-last-name">
                    <input class="field" type="text" placeholder="Your street" v-model="currentUser.user_info.address.street">
                </div>
            </div>
        </div>
        <div class="row annoucement">
            <div class="row">
                <p style="font-weight: bold;">
                    Click "Save" to confirm your changes
                </p>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <button class="btn-save" @click="save">Save</button>
                </div>
                <div class="col-sm-6">
                    <button class="btn-cancel">Cancel</button>
                </div>
            </div>
        </div> 
    </div>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import UserProfileViewModel from '../../viewModels/UserProfileViewModel';
const {user,
        loadUser,
        createUser,
        updateUser,
        loadCities} = UserProfileViewModel();
const isCreate = ref(false);
const cities = ref([]);
const currentUser = ref({
      id: "",
      username: "",
      email: "",
      role: "",
      user_info: {
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

onMounted(async () => {
    currentUser.value = await loadUser();
    console.log(currentUser.value);
    if(currentUser.value.user_info == null){
        isCreate.value = true;
        currentUser.value.user_info = {
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
        };
    }
    if(currentUser.value.user_info.image == null){
        currentUser.value.user_info.image = {
            id: 0,
            url: "",
        };
    }
    if(currentUser.value.user_info.address == null){
        currentUser.value.user_info.address = {
            district: "",
            street: "",
            ward: "",
            city_id: 0,
            id: 0,
        };
    }
    cities.value = await loadCities();
});
const save = async () => {
    if(isCreate.value){
        await createUser(currentUser.value);
    }else{
        await updateUser(currentUser.value);
    }
}
     
</script>


<style scoped>
.setting-profile {
    display: flex;
    flex-direction: column;
    gap: 40px;
    width: 100%;
    color: #13357B;
    font-size: 20px;
}

.col-sm-6 p {
    font-size: 25px;
    font-weight: 900;
    margin-left: 25%;
}

.col-sm-6 .field {
    color:#13357B !important;
    border-radius: 10px;
    border: 1px solid #13357B;
    background-color: #EDF6F9;
    padding: 10px 50px;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.20);
    width: 90%;
}
.option {
  /* Loại bỏ appearance mặc định */
  appearance: none;
  -webkit-appearance: none;
  /* Thêm không gian cho mũi tên select (nếu cần) */
  background-image: url("data:image/svg+xml;charset=UTF-8,%3Csvg width='800px' height='800px' viewBox='0 0 24 24' fill='none' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M19 9L14 14.1599C13.7429 14.4323 13.4329 14.6493 13.089 14.7976C12.7451 14.9459 12.3745 15.0225 12 15.0225C11.6255 15.0225 11.2549 14.9459 10.9109 14.7976C10.567 14.6493 10.2571 14.4323 10 14.1599L5 9' stroke='%23000000' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
  background-position: right 20px center;
  background-repeat: no-repeat;
  background-size: 20px;
}
.col-sm-6 .field::placeholder{
    color:#13357B;
}

.col-sm-6 .field:focus {
    color:#13357B;
    border-color: #13357B;
    outline: none;
    background-color: #8ECAE6;
}

.field-username {
    display: flex;
}

.field-username svg {
    position: relative;
    margin: 13px 0px 0 0;
    right: 580px;
}

.field:-webkit-autofill {
    -webkit-text-fill-color: #13357B;
    -webkit-box-shadow: 0 0 0px 1000px #EDF6F9 inset;
    transition: background-color 5000s ease-in-out 0s;
}

.field:-webkit-autofill:focus {
    -webkit-text-fill-color: #13357B;
}

.btn-reset{
    justify-content: center;
    color: #0077B6;
    border: none;
    background-color: transparent;
    font-weight: 900;
    text-align: center;
    margin-top: 100px;
}

.btn-reset:hover {
    color: #8ECAE6;
}

button {
    color: #EDF6F9;
    padding: 10px 30px;
    border-radius: 15px; 
    width: 250px;
    border: none;
}

.btn-save {
    background-color: #5fa8d3;
}

.btn-cancel {
    background-color: #E63946;
}

.btn-save:hover{
    background-color: #7FBADC;
}

.btn-cancel:hover{
    background-color: #ED6E78;
}

.annoucement {
    display: flex;
    flex-direction: column;
    gap: 20px;
    text-align: center;
    background-color: #9BD0E9;
    margin-top: 30px;
    padding: 100px 0px;
    border-radius: 20px;
    box-shadow: 0px 5px 15px rgba(19, 53, 123, 0.25);
}

</style>

