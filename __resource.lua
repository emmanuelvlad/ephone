ui_page "html/index.html"

exports {
	'getBattery',
	'IsPlayerInCall',
	'IsPlayerUsingPhone'
}

server_export 'generatePhoneNumber'

files {
	"html/index.html",
	"html/main.js",
	"html/main.css",
	"html/background.jpg",

	"html/cursor.png",
	"html/pointer.png",
	"html/text.png",

	"sounds/lowBattery.ogg",
	"sounds/chargerConnection.ogg",

	"apps/menu/js.js",
	"apps/menu/html.html",
	"apps/menu/css.css",

	"apps/contacts/js.js",
	"apps/contacts/html.html",
	"apps/contacts/css.css",

	"apps/contacts/creator/css.css",
	"apps/contacts/creator/html.html",

	"apps/navigator/js.js",
	"apps/navigator/html.html",
	"apps/navigator/css.css"
}

client_scripts {
	"client/main.lua",
	"client/animation.lua",
	"client/battery.lua",
	"apps/menu/client.lua",
	"apps/contacts/client.lua"
}

server_scripts {
	"server/main.lua",
	"apps/menu/server.lua",
	"apps/contacts/server.lua",
	"apps/navigator/server.lua"
}
