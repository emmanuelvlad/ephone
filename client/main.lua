--------------------------------------------------------------------------------
--
--								VARIABLES
--
--------------------------------------------------------------------------------
enable_phone = true
showPhone = false
inCall = false
inputBlocked = false
cursor = false
ringtone = false
currentApp = "menu"


--------------------------------------------------------------------------------
--
--									Threads
--
--------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do Citizen.Wait(1)
		if ringtone then
			print("playing ringtone")
			PlaySoundFromEntity(-1, "Text_Arrive_Tone", GetPlayerPed(-1), "Phone_SoundSet_Michael", 0, 2)
			Citizen.Wait(750)
		end
	end
end)

Citizen.CreateThread(function()
	while true do Citizen.Wait(1)
		if IsPlayerPlayingAnimation() and showPhone then
			ePhoneHide()
			SetPedCanRagdoll(GetPlayerPed(-1), false)
		else
			SetPedCanRagdoll(GetPlayerPed(-1), true)
		end

		-- Hide phone if player is dead
		if IsPlayerDead(PlayerId()) then
			ePhoneHide()
		end

		-- Test things
		if showPhone then
			DisableControlAction(0, 142, cursor)
			DisableControlAction(0, 106, cursor)
			DisableControlAction(0, 16, cursor)
			DisableControlAction(0, 17, cursor)
			DisableControlAction(0, 85, cursor)
			DisableControlAction(0, 99, cursor)
			DisableControlAction(0, 100, cursor)
		end

		-- Charge event
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) and not IsPedOnAnyBike(GetPlayerPed(-1)) then
			TriggerEvent("ephone:charging", true)
		else
			TriggerEvent("ephone:charging", false)
		end

		-- Enable phone
		if enable_phone then
			if IsControlJustPressed(3, 27) then
				ePhoneShow()
			elseif IsControlJustPressed(0, 322) then
				ePhoneHide()
			end
			if not inputBlocked then
				if IsControlJustPressed(3, 172) then
					ePhoneUp()
				elseif IsControlJustPressed(3, 181) then
					ePhoneWheelUp()
				elseif IsControlJustPressed(3, 173) then
					ePhoneDown()
				elseif IsControlJustPressed(3, 180) then
					ePhoneWheelDown()
				elseif IsControlJustPressed(3, 174) then
					ePhoneLeft()
				elseif IsControlJustPressed(3, 175) then
					ePhoneRight()
				elseif IsControlJustPressed(3, 176) then
					ePhoneSelect()
				elseif IsControlJustPressed(3, 177) then
					ePhoneCancel()
				elseif IsControlJustPressed(3, 178) then
					ePhoneOption()
				elseif IsControlJustPressed(3, 179) then
					ePhoneExtraOption()
				end
			end
		end

		-- Hide phone if player holds a weapon
		if GetCurrentPedWeapon(GetPlayerPed(-1)) then
			ePhoneHide()
		end

		-- Update phone date
		updateDate()

		-- Cursor handle
		if cursor then
			DisableControlAction(0, 1, cursor)
			DisableControlAction(0, 2, cursor)
			if IsDisabledControlJustReleased(0, 142) then
				SendNUIMessage({
					rightclick = true
				})
			end
			SetNuiFocus(cursor)
		end
	end
end)


--------------------------------------------------------------------------------
--
--									CALLBACKS
--
--------------------------------------------------------------------------------
RegisterNUICallback("playSound", function(data, cb)
	PlaySoundFrontend(-1, data.name, data.set,  true)
end)

RegisterNUICallback("phoneClose", function(data, cb)
	ePhoneHide()
end)

RegisterNUICallback("app-contacts", function(data, cb)
	SendNUIMessage({
		showApp = "contacts"
	})
	--inCall = true
	--ePhoneCallAnim()
end)

RegisterNUICallback("message", function(data, cb)
	TriggerEvent('chatMessage', '', {0,0,0}, data.message)
end)

RegisterNUICallback("enableCursor", function(data, cb)
	enableCursor(data.cursor)
end)

RegisterNUICallback("playRingtone", function(cb)
	playRingtone()
end)

RegisterNUICallback("stopRingtone", function(cb)
	stopRingtone()
end)


--------------------------------------------------------------------------------
--
--								FUNCTIONS
--
--------------------------------------------------------------------------------
function playRingtone()
	ringtone = true
end

function stopRingtone()
	ringtone = false
end

function enableCursor(enable)
    SetNuiFocus(enable)
    cursor = enable

    SendNUIMessage({
        type = "enableCursor",
        enable = enable
    })
end

function IsPlayerPlayingAnimation()
	if IsPlayerClimbing(PlayerId()) or IsPlayerDead(PlayerId()) or
	IsPedCuffed(GetPlayerPed(-1)) or IsPedJumpingOutOfVehicle(GetPlayerPed(-1))
	or IsPedTryingToEnterALockedVehicle(GetPlayerPed(-1)) or
	GetCurrentPedWeapon(GetPlayerPed(-1)) then
		return true
	else
		return false
	end
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function updateDate()
	SendNUIMessage({
		date = {
			hours = GetClockHours(),
			minutes = GetClockMinutes()
		}
	})
end

function ePhoneShow()
	if not showPhone then
		SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263)
		ePhoneInAnim()
		showPhone = true
		SendNUIMessage({
			show = true
		})
	end
end

function ePhoneHide()
	if showPhone then
		SendNUIMessage({
			hide = true
		})
		ePhoneOutAnim()
		showPhone = false
	end
end

function ePhoneUp()
	if showPhone and battery > 0 then
		SendNUIMessage({
			buttonPressed = "up"
		})
	end
end

function ePhoneWheelUp()
	if showPhone and battery > 0 then
		SendNUIMessage({
			buttonPressed = "wheelUp"
		})
	end
end

function ePhoneDown()
	if showPhone and battery > 0 then
		SendNUIMessage({
			buttonPressed = "down"
		})
	end
end

function ePhoneWheelDown()
	if showPhone and battery > 0 then
		SendNUIMessage({
			buttonPressed = "wheelDown"
		})
	end
end

function ePhoneLeft()
	if showPhone and battery > 0 then
		SendNUIMessage({
			buttonPressed = "left"
		})
	end
end

function ePhoneRight()
	if showPhone and battery > 0 then
		SendNUIMessage({
			buttonPressed = "right"
		})
	end
end

function ePhoneSelect()
	if showPhone and battery > 0 then
		SendNUIMessage({
			buttonPressed = "select"
		})
	end
end

function ePhoneCancel()
	if showPhone and battery > 0 then
		SendNUIMessage({
			buttonPressed = "cancel"
		})
	elseif showPhone then
		ePhoneHide()
	end
end

function ePhoneOption()
	if showPhone and battery > 0 then
		SendNUIMessage({
			buttonPressed = "option"
		})
	end
end

function ePhoneExtraOption()
	if showPhone and battery > 0 then
		SendNUIMessage({
			buttonPressed = "extraOption"
		})
	end
end

function IsPlayerInCall()
	if inCall then
		return true
	else
		return false
	end
end

function IsPlayerUsingPhone()
	if showPhone then
		return true
	else
		return false
	end
end

--------------------------------------------------------------------------------
--
--									EVENTS
--
--------------------------------------------------------------------------------
RegisterNetEvent("ephone:log")
AddEventHandler("ephone:log", function(str)
	Citizen.Trace(str)
end)

RegisterNetEvent("ephone:enable")
AddEventHandler("ephone:enable", function()
	enable_phone = true
end)

RegisterNetEvent("ephone:disable")
AddEventHandler("ephone:disable", function()
	enable_phone = false
	ePhoneHide()
end)

RegisterNetEvent("ephone:show")
AddEventHandler("ephone:show", function()
	ePhoneShow()
end)

RegisterNetEvent("ephone:hide")
AddEventHandler("ephone:hide", function()
	ePhoneHide()
end)

RegisterNetEvent("ephone:up")
AddEventHandler("ephone:up", function()
	ePhoneUp()
end)

RegisterNetEvent("ephone:wheelup")
AddEventHandler("ephone:wheelup", function()
	ePhoneWheelUp()
end)


RegisterNetEvent("ephone:down")
AddEventHandler("ephone:down", function()
	ePhoneDown()
end)

RegisterNetEvent("ephone:wheeldown")
AddEventHandler("ephone:wheeldown", function()
	ePhoneWheelDown()
end)

RegisterNetEvent("ephone:left")
AddEventHandler("ephone:left", function()
	ePhoneLeft()
end)

RegisterNetEvent("ephone:right")
AddEventHandler("ephone:right", function()
	ePhoneRight()
end)

RegisterNetEvent("ephone:cancel")
AddEventHandler("ephone:cancel", function()
	ePhoneCancel()
end)

RegisterNetEvent("ephone:select")
AddEventHandler("ephone:select", function()
	ePhoneSelect()
end)

RegisterNetEvent("ephone:option")
AddEventHandler("ephone:option", function()
	ePhoneOption()
end)

RegisterNetEvent("ephone:extra_option")
AddEventHandler("ephone:extra_option", function()
	ePhoneExtraOption()
end)

RegisterNetEvent('ephone:changePhoneNumber')
AddEventHandler('ephone:changePhoneNumber', function(new_phone_number)
	TriggerServerEvent('ephone:changePhoneNumber', new_phone_number)
end)

RegisterNetEvent('ephone:joinGroup')
AddEventHandler('ephone:joinGroup', function(name)
	TriggerServerEvent('ephone:joinGroup', name)
end)

RegisterNetEvent('ephone:leaveGroup')
AddEventHandler('ephone:leaveGroup', function(name)
	TriggerServerEvent('ephone:leaveGroup', name)
end)
