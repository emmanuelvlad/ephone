<template>
	<v-content
		fullscreen
		dark>
		<v-app-bar dense>
			<v-app-bar-nav-icon />
			<v-toolbar-title>
				Settings
			</v-toolbar-title>
		</v-app-bar>
	</v-content>
</template>

<script>
export default {
	mounted() {
		this.$store.dispatch("updateStatusBar", { absolute: false });
	}
};
</script>