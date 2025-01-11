import { createApp } from "vue";
import App from "./App.vue";
import store from "./store";
import router from "./router"; // Đảm bảo router được import nếu không có sẵn
import Toast from "vue-toastification";
import "vue-toastification/dist/index.css";
import "@fortawesome/fontawesome-free/css/all.css";
import VueApexCharts from "vue3-apexcharts";
import "bootstrap/dist/css/bootstrap.min.css";
import "bootstrap";
// @ts-ignore
import vSelect from "vue-select";
import "vue-select/dist/vue-select.css"; // Import CSS của Vue Select

const app = createApp(App);

app.use(store);
app.use(router);
app.use(Toast, {
  position: "top-right",
  timeout: 5000,
  closeOnClick: true,
  pauseOnFocusLoss: true,
  pauseOnHover: true,
  draggable: true,
  draggablePercent: 0.6,
  showCloseButtonOnHover: false,
  hideProgressBar: false,
  closeButton: "button",
  icon: true,
  rtl: false,
});

// Đăng ký Vue ApexCharts
app.use(VueApexCharts);

// Đăng ký Vue Select
app.component("v-select", vSelect);

app.mount("#app");

