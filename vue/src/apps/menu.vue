<template>
	<div class="app-container">
		<video
			loop
			autoplay
			muted
			class="animated-background">
			<source
				src="/background.m4v"
				type="video/mp4">
		</video>
		<div class="menu-content">

			<div class="day-information">
				Monday, Mar 25 | <v-icon
					color="#ffec70"
					size="large">
					mdi-white-balance-sunny
				</v-icon> 6°C
			</div>
			<div
				class="menu">

				<div
					v-for="(app, index) in apps"
					:key="index"
					:class="'application app-' + app.name + ' ' + (selectedApp === index ? 'selected' : '')">

					<div
						class="icon"
						@click="$store.dispatch('changeApp', app.name)">
						<img
							v-if="app.image"
							:src="app.image"
							alt="settings">
						<span
							v-else
							:class="'mdi mdi-' + app.icon" />
					</div>
			
					<p>{{ app.display_name }}</p>

				</div>

			</div>
		</div>
	</div>
</template>

<script>
export default {
	//
	// Name
	//
	name: "Menu",

	//
	// Data
	//
	data() {
		return {
			selectedApp: 0,
			rows: 3,
			appsPerRow: 3,
			apps: [
				{
					name: "AppSettings",
					display_name: "Settings",
					image: "https://i.imgur.com/X50Hkzv.png", 
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				},
				{
					name: "test",
					display_name: "Lol",
					icon: "alpha-a-circle"
				}
			]
		};
	},

	computed: {
		appsPerPage() {
			return this.rows * this.appsPerRow;
		},

		battery() {
			return this.$store.getters.battery;
		}
	},

	//
	// Mounted
	//
	mounted() {
		this.$store.dispatch("updateStatusBar", {
			background: "inherit",
			absolute: true,
			color: "#fff"
		});

		this.$root.$on("buttonPressed", key => {
			console.log("pressed: " + key);
		});
	}
};
</script>

<style scoped>
	* {
		transition: all 0.15s ease-out;
	}

	.animated-background {
		height: 100%;
    width: 100%;
    object-fit: cover;
    z-index: 0;
    right: 0;
    bottom: 0;
    background-size: cover;
    overflow: hidden;
	}

	.menu-content {
		position: absolute;
		top: 0;
		z-index: 10;
	}

	.menu {
		display: flex;
		align-items: center;
		justify-content: space-evenly;
		flex-wrap: wrap;
	}

	.day-information {
		margin: 50px 0 20px;
		text-align: center;
		font-size: 18px;
		color: #fff;
	}

	.application {
		position: relative;
		margin: 8px 0 8px 0;
		font-size: 20px;
		width: 50px;
		text-align: center;
	}

	.application p {
		font-family: "Raleway";
		font-weight: 600;
		font-size: 12px;
		margin-top: 5px;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		color: #fff;
		user-select: none;
	}

	.icon {
		width: 42px;
		height: 42px;
		border-radius: 25px;
		font-family: 'Raleway';
		display: flex;
		justify-content: center;
		align-items: center;
		overflow: hidden;
		margin: auto;
		box-shadow: 2px 2px 2px 0px rgba(255,255,255,0.25);
	}

	.icon .mdi {
		color: #aaa;
	}

	.icon img {
		width: 100%;
	}

	.application .icon:hover {
		cursor: pointer;
		box-shadow: 2px 2px 5px 0px rgba(255,255,255,0.75);
	}

	.application .icon .mdi {
		font-size: 32px;
	}
</style>
