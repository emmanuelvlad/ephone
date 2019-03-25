--------------------------------------------------------------------------------
--
--									CALLBACKS
--
--------------------------------------------------------------------------------
RegisterNUICallback("getContacts", function(data, cb)
	TriggerServerEvent('ephone:getContacts')
end)

RegisterNUICallback("addContact", function(data, cb)
	if data.phone_number and data.name then
		TriggerServerEvent('ephone:addContact', data.phone_number, data.name)
	end
end)

RegisterNUICallback("addContact", function(data, cb)
	if data.phone_number and data.name then
		TriggerServerEvent('ephone:updateContact', data.phone_number, data.name)
	end
end)

RegisterNUICallback("deleteContact", function(data, cb)
	if data.phone_number then
		TriggerServerEvent('ephone:deleteContact', data.phone_number)
	end
end)


--------------------------------------------------------------------------------
--
--									EVENTS
--
--------------------------------------------------------------------------------
RegisterNetEvent("ephone:loadContacts")
AddEventHandler("ephone:loadContacts", function(contacts)
	SendNUIMessage({
		update = {
			name = "contacts",
			data = contacts
		}
	})
end)

RegisterNetEvent('ephone:getContacts')
AddEventHandler('ephone:getContacts', function()
	TriggerServerEvent('ephone:getContacts')
end)

RegisterNetEvent('ephone:addContact')
AddEventHandler('ephone:addContact', function(phone_number, name)
	TriggerServerEvent('ephone:addContact', phone_number, name)
end)

RegisterNetEvent('ephone:updateContact')
AddEventHandler('ephone:updateContact', function(phone_number, new_phone_number, name, new_name)
	TriggerServerEvent('ephone:updateContact', phone_number, new_phone_number, name, new_name)
end)

RegisterNetEvent('ephone:deleteContact')
AddEventHandler('ephone:deleteContact', function(phone_number)
	TriggerServerEvent('ephone:deleteContact', phone_number)
end)
