require "resources/mysql-async/lib/MySQL"

local app_name = "contacts"
local app_display_name = ""
local app_description = ""
local app_icon = ""
apps[app_name] = {}


--------------------------------------------------------------------------------
--
--									EVENTS
--
--------------------------------------------------------------------------------
AddEventHandler('onResourceStart', function(resource)
    if resource == "ephone" then
        addApp(app_name, app_display_name, app_description, app_icon)
        apps[app_name].init()

    end
end)


--------------------------------------------------------------------------------
--
--								FUNCTIONS
--
--------------------------------------------------------------------------------
apps[app_name].init = function()
    MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `ephone_app_contacts` (`user` int(11) NOT NULL, `number` int(11) NOT NULL, `name` varchar(30) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;", function(changes)
        checkColumn("ephone_app_contacts", "user", "int(11) NOT NULL")
        checkColumn("ephone_app_contacts", "number", "int(11) NOT NULL AFTER `user`")
        checkColumn("ephone_app_contacts", "name", "varchar(30) NOT NULL AFTER `number`")
    end)
end
