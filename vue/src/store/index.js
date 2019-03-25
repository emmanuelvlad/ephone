import Vue from "vue";
import Vuex from "vuex";

import screen from "./screen";
import AppMenu from "./apps/menu";

Vue.use(Vuex);

export default new Vuex.Store({
	modules: { 
		screen,
		AppMenu
	}
});