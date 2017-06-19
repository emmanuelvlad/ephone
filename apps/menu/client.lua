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
		apps = apps,
		menu = menu
	})
end)
