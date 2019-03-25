//
// State
//
const state = {
	appsPerRow: 4,
	rowsPerPage: 5
};

//
// Getters
//
const getters = {
	appsPerRow: state => state.appsPerRow,
	rowsPerPage: state => state.rowsPerPage
};

//
// Mutations
//
const mutations = {
	SET_APPS_PER_ROW: (state, payload) => state.appsPerRow = payload,
	SET_ROWS_PER_PAGE: (state, payload) => state.rowsPerPage = payload
};

//
// Actions
//
const actions = {

};

export default {
	state,
	getters,
	mutations,
	actions
};