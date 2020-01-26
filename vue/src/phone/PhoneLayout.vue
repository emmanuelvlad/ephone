<template>
	<div id="phone-container">
		<div id="phone-body">
			<!-- Phone Top -->
			<slot name="top" />

			<div
				id="screen">
				<slot />
			</div>

		</div>
	</div>
</template>

<script>
export default {
	//
	// Name
	//
	name: "PhoneLayout",
};
</script>

<style>
	#phone-container {
		height: 624px;
		width: 351px;
	}

	#phone-body {
		position: absolute;
		padding: 5px;
	}

	#screen {
		position: relative;
		background-color: #111111;
		height: 100%;
		margin: auto;
		overflow: hidden;
	}

	#blackout {
		background: #0a0a0a;
		height: 100%;
		width: 100%;
		z-index: 5;
		border-radius: 10px 10px 0 0;
	}

	.statusBar-date
	{

	}

	.statusBar-battery
	{
	}

	.statusBar-battery.low
	{
		color: red;
	}

	.statusBar-battery.charge
	{
		color: green;
	}

	.battery-bar
	{
		width: 100%;
		border: 1px solid red;
	}

	#cursor {
		position: absolute;
		z-index: 999;
		display: none;
	}

	.cursor-pointer {
		cursor: pointer;
	}

	.cursor-text {
		cursor: text;
	}
</style>
