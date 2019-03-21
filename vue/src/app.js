import Vue from "vue";
import App from "./app.vue";
import Vuex from "vuex";

Vue.use(Vuex);

const store = new Vuex.Store({
	modules: { 
		index: () => import("./store/index.js")
	}
});

new Vue({
	el: "#app",
	store,
	render: h => h(App)
});