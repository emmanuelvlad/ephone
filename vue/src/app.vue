<template>
	<div>
		<img
			id="cursor"
			src="images/cursor.png"
			width="32"
			height="32">

		<div id="container">
			<transition
				name="custom-classes-transition"
				enter-active-class="animated slideInUp"
				leave-active-class="animated slideOutDown">

				<phone v-if="show" />

			</transition>
		</div>
	</div>
</template>

<script>
export default {
	//
	// Name
	//
	name: "App",

	//
	// Components
	//
	components: {
		Phone: () => import("./phone/Phone")
	},

	//
	// Data
	//
	data() {
		return {
			show: true,
			debug: true,
			currentApp: "menu",
			action: "",
			date: "18:14",
			listener: null
		};
	},

	//
	// Methods
	//
	methods: {
		sendData(name, data) {
			var request = new XMLHttpRequest();
			request.open("POST", "http://ephone/" + name, true);
			request.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
			request.send(JSON.stringify(data));
		},

		playSound(sound, soundset) {
			this.sendData("playSound", { name: sound, set: soundset });
		},

		buttonPressed(button) {
			this.$root.$emit("buttonPressed", button);
		}
	},

	//
	// Created
	//
	created() {
		this.debugListener = window.addEventListener("keydown", ({ key }) => {
			switch (key) {
			case "ArrowUp":
				this.buttonPressed("up");
				break;
			case "ArrowRight":
				this.buttonPressed("right");
				break;
			case "ArrowDown":
				this.buttonPressed("down");
				break;
			case "ArrowLeft":
				this.buttonPressed("left");
				break;
			case "Backspace":
				this.buttonPressed("cancel");
				break;
			}
		});
		this.battery = 75;

		// In game listener
		this.listener = window.addEventListener("message", ({ data }) => {
			if (data.date) {
				this.date = `${("0" + data.date.hours).slice(-2)}:${("0" + data.date.minutes).slice(-2)}`;
			}

			this.charging = data.charging || false;

			if (data.battery >= 0) {
				this.battery = data.battery;
			}

			// Show phone
			if (data.show) {
				this.show = true;
				this.playSound("Pull_Out", "Phone_SoundSet_Michael");
			}
			// Hide phone
			else if (data.hide) {
				if (typeof this.apps[this.currentApp].terminate === "function") {
					this.apps[this.currentApp].terminate();
				}
				this.show = false;
				this.playSound("Put_Away", "Phone_SoundSet_Michael");
			}

			if (data.update) {
				this.update[data.update.name] = data.update;
			}

			if (data.buttonPressed) {
				this.buttonPressed(data.buttonPressed);
				this.action = data.buttonPressed;
			}
		});
	},

	//
	// Destroyed
	//
	destroyed() {
		window.removeEventListener("message", this.listener);
		window.removeEventListener("message", this.debugListener);
	},

	//
	// Watch
	//
	watch: {
		battery(value) {
			if (value <= 15 && value % 5 == 0 && !this.charging) {
				var audio = new Audio("../sounds/lowBattery.ogg");
				audio.volume = 0.15;
				audio.play();
			}
		},

		charging(value) {
			if (value) {
				var audio = new Audio("../sounds/chargerConnection.ogg");
				audio.volume = 0.15;
				audio.play();
			}
		}
	}
};
</script>

<style>
	#container {
		position: fixed;
		bottom: 0;
		right: 75px;
		bottom: 35px;
	}
</style>
