ui_page "html/index.html"

export 'GetPhoneBattery'
export 'IsPlayerInCall'
export 'IsPlayerUsingPhone'

files {
	"html/index.html",
	"html/main.js",
	"html/main.css",
	"sounds/lowBattery.ogg",
	"sounds/chargerConnection.ogg",
	"apps/menu/menu.js",
	"apps/contacts/contacts.js"
}

client_scripts {
	"main.lua",
	"animation.lua",
	"battery.lua"
}
