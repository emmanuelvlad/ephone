import Vue from "vue";
import vuetify from "@/plugins/vuetify";

import App from "./app.vue";
import store from "./store";


new Vue({
	el: "#app",
	vuetify,
	store,
	render: h => h(App)
});
