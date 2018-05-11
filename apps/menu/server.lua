local app_name = "menu"
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
        apps[app_name].init()
    end
end)

RegisterServerEvent('ephone:getMenu')
AddEventHandler('ephone:getMenu', function()
    local player = source
    getUserMenu(player, function(data)
        getApps(function(apps)
            TriggerClientEvent('ephone:loadMenu', player, apps, data)
        end)
    end)
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason)
end)

RegisterServerEvent('ephone:userAddApp')
AddEventHandler('ephone:userAddApp', function(appname)
    local player = source
    userHasApp(player, appname, function(app, bool)
        if not bool then
            userAddApp(player, app)
        end
    end)
end)

RegisterServerEvent('ephone:userDeleteApp')
AddEventHandler('ephone:userDeleteApp', function(appname)
    local player = source
    getApp(appname, function(app)
        userDeleteApp(player, app)
    end)
end)


--------------------------------------------------------------------------------
--
--								FUNCTIONS
--
--------------------------------------------------------------------------------
apps[app_name].init = function ()
    MySQL.ready(function ()
        MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `ephone_app_menu` (`user` int(11) NOT NULL, `appid` int(11) NOT NULL, `index` int(11) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;", {}, function(changes)
            checkColumn("ephone_app_menu", "user", "int(11) NOT NULL")
            checkColumn("ephone_app_menu", "appid", "int(11) NOT NULL AFTER `user`")
            checkColumn("ephone_app_menu", "index", "int(11) NOT NULL AFTER `appid`")
        end)
    end)
end

function getUserMenu(source, callback)
    MySQL.Async.fetchAll("SELECT * FROM ephone_app_menu WHERE user = @id", {['@id'] = users[source].id}, function(data)
        callback(data)
    end)
end

function userHasApp(source, appname, callback)
    getApp(appname, function(app)
        MySQL.Async.fetchScalar("SELECT COUNT(1) FROM ephone_app_menu WHERE user = @id AND appid = @appid", {['@id'] = users[source].id, ['@appid'] = app.id}, function(data)
            if data == 0 then
                callback(app, false)
            else
                callback(app, true)
            end
        end)
    end)
end

function userAddApp(source, app)
    MySQL.Async.fetchScalar("SELECT COUNT(*) FROM ephone_app_menu WHERE user = @id", {['@id'] = users[source].id}, function(data)
        MySQL.Async.execute("INSERT INTO ephone_app_menu (`user`, `appid`, `index`) VALUES (@id, @appid, @index)", {['@id'] = users[source].id, ['appid'] = app.id, ['index'] = data + 1}, function(changes)
            TriggerClientEvent('ephone:getMenu', source)
        end)
    end)
end

function userDeleteApp(source, app)
    MySQL.Async.execute("DELETE FROM ephone_app_menu WHERE user = @id AND appid = @appid", {['@id'] = users[source].id, ['@appid'] = app.id})
end
