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
				test: /\.s(c|a)ss$/,
				use: [
					"vue-style-loader",
					"css-loader",
					{
						loader: "sass-loader",
						options: {
							implementation: require("sass"),
							sassOptions: {
								fiber: require("fibers"),
								indentedSyntax: true // optional
							},
						},
					},
				],
			},
			
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

			// {
			// 	test: /\.css$/,
			// 	use: ["vue-style-loader", "css-loader"]
			// },
		]
	},

	plugins: [
		new VueLoaderPlugin()
	]
};