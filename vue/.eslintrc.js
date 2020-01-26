const isDev = process.env.NODE_ENV !== "production" ? true : false;
const warnError = isDev ? "warn" : "error";

module.exports = {
	root: true,
  env: {
    browser: true,
    node: true
	},
  parserOptions: {
    parser: "babel-eslint"
  },
  extends: [
    "eslint:recommended",
		"plugin:vue/strongly-recommended"
  ],
  plugins: [
		"vue"
		// "prettier"
  ],
	settings: {},
	//
	// Rules
	//
  rules: {
		// Uncomment when using prettier
		// "prettier/prettier": ["error"],
		"indent": ["error", "tab"],
		"semi": ["error", "always"],
		"no-unused-vars": warnError,
		"no-console": "off",
		//
		// Vue
		//
		"vue/script-indent": ["error", "tab"],
		"vue/html-indent": ["error", "tab"],
		"vue/multiline-html-element-content-newline": ["error", {
			"allowEmptyLines": true
		}],
		"vue/no-unused-components": warnError,
		"vue/html-closing-bracket-newline": ["error", {
	    "singleline": "never",
    	"multiline": "never"
		}],
		"linebreak-style": [
			"error",
			"unix"
		],
		"quotes": [
			"error",
			"double"
		]
	}
}
