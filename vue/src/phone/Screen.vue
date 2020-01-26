<template>
	<div class="container-fluid">
		<div
			id="status-bar"
			v-if="statusBar.show"
			:style="`
				position: ${(statusBar.absolute) ? 'absolute' : 'inherit'};
				background-color: ${statusBar.background};
				color: ${statusBar.color};
				`">

			<div
				id="status-bar-content"
				class="d-flex">
				<div
					id="status-bar-date"
					class="mr-auto">
					{{ date }}
				</div>

				<!-- Silenced -->
				<div
					v-if="silenced"
					id="status-bar-silence">
					<span class="mdi mdi-bell-off-outline" />
				</div>

				<!-- Network strenght -->
				<div id="status-bar-network">
					<span :class="'mdi mdi-network-strength-' + (network ? network : 'outline')" />
				</div>

				<!-- Battery -->
				<div
					id="status-bar-battery"
					:class="charging ? 'charge' : battery <= 15 ? 'low' : ''">
					<span :class="'mdi mdi-battery' + (charging ? '-charging' : '') + (batteryDecimal ? batteryDecimal === 100 ? '' : '-' + batteryDecimal : '-outline')" />
					<span>{{ battery }}%</span>
				</div>

			</div>
		</div>

		<component :is="currentApp" />

		<div
			v-if="currentApp != 'AppMenu'"
			id="bottom-bar"
			@click="$store.dispatch('changeApp', 'AppMenu');" />
	</div>
</template>

<script>
import allApps from "../apps/index";
export default {
	//
	// Name
	//
	name: "Screen",

	//
	// Mixins
	//
	mixins: [allApps],

	//
	// Data
	//
	data () {
		return {
			skin: "",
			date: "18:14",
		};
	},

	//
	// Computed
	//
	computed: {
		battery: {
			get () {
				return this.$store.getters.battery;
			},

			set (newValue) {
				return this.$store.commit("SET_BATTERY", newValue);
			}
		},

		currentApp () {
			return this.$store.getters.currentApp;
		},

		network () {
			return this.$store.getters.network;
		},

		silenced () {
			return this.$store.getters.silenced;
		},

		charging () {
			return this.$store.getters.charging;
		},

		statusBar () {
			return this.$store.getters.statusBar;
		},

		batteryDecimal () {
			if (this.battery >= 100) return 100;
			return Math.floor(this.battery / 10) * 10;
		}
	},

	//
	// Methods
	//
	methods: {
		home () {
			// this.$store.actions
		}
	}
};
</script>

<style>
.container-fluid {
	width: 100%;
	height: 100%;
}

.app-container {
	height: 100%;
}

#bottom-bar {
	position: absolute;
	z-index: 99;
	right: 0;
	left: 0;
	bottom: 5px;
	height: 8px;
	width: 33%;
	margin: 0 auto;
	border-radius: 5px;
	background: red;
	cursor: pointer;
}

#status-bar {
	position: absolute;
	right: 0;
	left: 0;
	top: 0;
	padding: 2px 10px;
	color: #fff;
}

#status-bar div {
	display: inline-flex;
	margin: 0 5px 0 5px;
	position: relative;
	height: 20px;
	overflow: hidden;
	text-align: center;
	font-size: 0.8rem;
	font-weight: 500;
	line-height: 20px;
	align-items: center;
	vertical-align: middle;
}

#status-bar-date {
}

#status-bar-battery {
}

#status-bar-battery.low {
	color: red;
}

#status-bar-battery.charge {
	color: green;
}

.battery-bar {
	width: 100%;
	border: 1px solid red;
}
</style>

