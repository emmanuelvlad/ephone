<template>
	<component :is="skin">
		<slot name="content" />
	</component>

</template>

<script>
export default {
	//
	// Name
	//
	name: "Phone",

	//
	// Components
	//
	components: {
		GooglePixel2XL: () => import("./skins/GooglePixel2XL")
	},

	//
	// Props
	//
	props: {
		skin: {
			type: String,
			default: "GooglePixel2XL"
		}
	}
};
</script>

