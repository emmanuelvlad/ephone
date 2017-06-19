require "resources/mysql-async/lib/MySQL"

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
        addApp(app_name, app_display_name, app_description, app_icon)
        --apps[name].init()
    end
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason)
    TriggerEvent('ephone:userAddApp', source, app_name)
end)


--------------------------------------------------------------------------------
--
--								FUNCTIONS
--
--------------------------------------------------------------------------------
apps[app_name].init = function()
end
