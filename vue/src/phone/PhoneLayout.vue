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
		background-image: url(https://i.imgur.com/ALQvr7S.jpg);
		background-color: #dfdfdf;
		background-repeat: no-repeat;
		background-size: cover;
		background-position: center;
		height: 528px;
		width: 297px;
		margin: 30px auto 0;
		overflow: hidden;
	}

	#blackout {
		background: #0a0a0a;
		height: 100%;
		width: 100%;
		z-index: 5;
		border-radius: 10px 10px 0 0;
	}

	#statusBar
	{
		padding: 3px 10px;
		height: 18px;
		border-radius: 5px 5px 0 0;
		color: #fff;
	}

	#statusBar div
	{
		display: inline-flex;
		margin: 0 5px 0 5px;
		position: relative;
		height: 20px;
		overflow: hidden;
		text-align: center;
		font-size: 14px;
		line-height: 20px;
		align-items: center;
		vertical-align: middle;
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
