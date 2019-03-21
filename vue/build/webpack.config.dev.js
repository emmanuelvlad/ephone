"use strict";

const { VueLoaderPlugin } = require("vue-loader");

module.exports = {
	mode: "development",

	entry: [
		"./src/app.js"
	],

	module: {
		rules: [
			{
				enforce: "pre",
				test: /\.(js|vue)$/,
				loader: "eslint-loader",
				exclude: /(node_modules)/
			},
      
			{
				test: /\.vue$/,
				use: "vue-loader"
			},

			{
				test: /\.css$/,
				use: ["vue-style-loader", "css-loader"]
			}
		]
	},

	plugins: [
		new VueLoaderPlugin()
	]
};