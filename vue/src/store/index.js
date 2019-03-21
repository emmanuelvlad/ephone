//
// State
//
export const state = () => ({
	statusBar: {
		show: true,
		background: "rgba(0, 0, 0, 0.5)",
		color: "#fafafa"
	},
	battery: 15,
	silenced: true,
	network: 0,
	charging: false,
});

//
// Getters
//
export const getters = () =>({
	statusBar: state => state.statusBar,
	battery: state => state.battery,
	silenced: state => state.silenced,
	network: state => state.network,
	charging: state => state.charging
});

//
// Mutations
//
export const mutations = () => ({
	SET_STATUS_BAR: (state, payload) => state.statusBar = payload,
	SET_BATTERY: (state, payload) => state.battery = payload,
	SET_SILENCED: (state, payload) => state.silenced = payload,
	SET_NETWORK: (state, payload) => state.network = payload,
	SET_CHARGING: (state, payload) => state.charging = payload,
});

//
// Actions
//
export const actions = () => ({
	updateStatusBar({ state, commit }, payload) {
		commit("SET_STATUS_BAR", { ...state.statusBar, ...payload });
	}
});
