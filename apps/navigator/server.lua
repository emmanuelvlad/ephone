local app_name = "navigator"
local app_display_name = "Browser"
local app_description = ""
local app_icon = "language"
apps[app_name] = {}


--------------------------------------------------------------------------------
--
--									EVENTS
--
--------------------------------------------------------------------------------
AddEventHandler('onResourceStart', function(resource)
    if resource == "ephone" then
        MySQL.ready(function()
            addApp(app_name, app_display_name, app_description, app_icon)
        end)
        --apps[name].init()
    end
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason)
    TriggerClientEvent('ephone:userAddApp', source, app_name)
end)


--------------------------------------------------------------------------------
--
--								FUNCTIONS
--
--------------------------------------------------------------------------------
apps[app_name].init = function()
end
