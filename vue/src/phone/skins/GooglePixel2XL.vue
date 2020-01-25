<template>
	<phone-layout>

		<!-- Top -->
		<template slot="top">
			<div class="camera" />
			<div class="speaker" />
		</template>

		<!-- Screen -->
		<screen>
			<div>
				hello
			</div>
		</screen>

	</phone-layout>
</template>

<script>
export default {
	//
	// Name
	//
	name: "PhoneSkinDefault",

	//
	// Components
	//
	components: {
		PhoneLayout: () => import("../PhoneLayout"),
		Screen: () => import("../Screen")
	}
};
</script>

<style>
#phone-body {
	background: -webkit-linear-gradient(left, #4A4F57 0%,#3d4247 100%);
	border-radius: 30px;
	height: 588px;
	padding: 0 7px!important;
	width: 300px;
}

#phone-body::after {
	position: absolute;
	z-index: -1;
	content: '';
	background: -webkit-linear-gradient(left, #2a2f38 0%,#2e313d 100%);
	border-radius: 30px;
	top: -4px;
	right: -4px;
	bottom: 0;
	left: 0;
}

#screen {
	border-width: 1px 1px 0px 1px;
	border-style: solid;
	border-color: #5d5d5d;
	border-radius: 20px;
}

.camera {
	position: absolute;
	border-radius: 100%;
	z-index: 9;
	background: -webkit-radial-gradient(center, ellipse cover, #333 0%,#222 100%);
	width: 18px;
	height: 18px;
	top: 6px;
	right: 0;
	bottom: 0;
	left: 35px;
}

.speaker {
	position: absolute;
	border-radius: 5px;
	z-index: 9;
	background: -webkit-radial-gradient(center, ellipse cover, #333 0%,#222 100%);
	width: 125px;
	height: 4px;
	top: 10px;
	right: 0;
	bottom: 0;
	left: 100px;
}
</style>
