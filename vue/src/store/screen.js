//
// State
//
const state = {
	statusBar: {
		show: true,
		absolute: true,
		background: "inherit",
		color: "#fafafa"
	},
	battery: 15,
	silenced: true,
	network: 0,
	charging: false,
	currentApp: "AppSettings"
};

//
// Getters
//
const getters = {
	statusBar: state => state.statusBar,
	battery: state => state.battery,
	silenced: state => state.silenced,
	network: state => state.network,
	charging: state => state.charging,
	currentApp: state => state.currentApp
};

//
// Mutations
//
const mutations = {
	SET_STATUS_BAR: (state, payload) => state.statusBar = payload,
	SET_BATTERY: (state, payload) => state.battery = payload,
	SET_SILENCED: (state, payload) => state.silenced = payload,
	SET_NETWORK: (state, payload) => state.network = payload,
	SET_CHARGING: (state, payload) => state.charging = payload,
	SET_CURRENT_APP: (state, payload) => state.currentApp = payload,
};

//
// Actions
//
const actions = {
	updateStatusBar({ state, commit }, payload) {
		commit("SET_STATUS_BAR", { ...state.statusBar, ...payload });
	},

	changeApp({ commit }, payload) {
		commit("SET_CURRENT_APP", payload);
	}
};

export default {
	state,
	getters,
	mutations,
	actions
};