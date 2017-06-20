--------------------------------------------------------------------------------
--
--									CALLBACKS
--
--------------------------------------------------------------------------------
RegisterNUICallback("getMenu", function(data, cb)
	TriggerServerEvent('ephone:getMenu')
end)


--------------------------------------------------------------------------------
--
--									EVENTS
--
--------------------------------------------------------------------------------
RegisterNetEvent("ephone:loadMenu")
AddEventHandler("ephone:loadMenu", function(apps, menu)
	SendNUIMessage({
		update = {
			name = "menu",
			data = {
				apps = apps,
				menu = menu
			}
		}
	})
end)

RegisterNetEvent('ephone:getMenu')
AddEventHandler('ephone:getMenu', function()
	TriggerServerEvent('ephone:getMenu')
end)

RegisterNetEvent('ephone:userAddApp')
AddEventHandler('ephone:userAddApp', function(appname)
	TriggerServerEvent('ephone:userAddApp', appname)
end)

RegisterNetEvent('ephone:userDeleteApp')
AddEventHandler('ephone:userDeleteApp', function(appname)
	TriggerServerEvent('ephone:userDeleteApp', appname)
end)
