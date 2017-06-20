require "resources/mysql-async/lib/MySQL"

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
    getUserId(source, function(uid)
        getUserMenu(uid, function(data)
            getApps(function(apps)
                TriggerClientEvent('ephone:loadMenu', source, apps, data)
            end)
        end)
    end)
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason)
end)

RegisterServerEvent('ephone:userAddApp')
AddEventHandler('ephone:userAddApp', function(appname)
    getUserId(source, function(uid)
        userHasApp(uid, appname, function(app, bool)
            if not bool then
                userAddApp(uid, app)
            end
        end)
    end)
end)

RegisterServerEvent('ephone:userDeleteApp')
AddEventHandler('ephone:userDeleteApp', function(appname)
    getUserId(source, function(uid)
        getApp(appname, function(app)
            userDeleteApp(uid, app)
        end)
    end)
end)


--------------------------------------------------------------------------------
--
--								FUNCTIONS
--
--------------------------------------------------------------------------------
apps[app_name].init = function ()
    MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `ephone_app_menu` (`user` int(11) NOT NULL, `appid` int(11) NOT NULL, `index` int(11) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;", {}, function(changes)
        checkColumn("ephone_app_menu", "user", "int(11) NOT NULL")
        checkColumn("ephone_app_menu", "appid", "int(11) NOT NULL AFTER `user`")
        checkColumn("ephone_app_menu", "index", "int(11) NOT NULL AFTER `appid`")
    end)
end

function getUserMenu(uid, callback)
    MySQL.Async.fetchAll("SELECT * FROM ephone_app_menu WHERE user = @user", {['@user'] = uid}, function(data)
        callback(data)
    end)
end

function userHasApp(uid, appname, callback)
    getApp(appname, function(app)
        MySQL.Async.fetchScalar("SELECT COUNT(1) FROM ephone_app_menu WHERE user = @user AND appid = @appid", {['@user'] = uid, ['@appid'] = app.id}, function(data)
            if data == 0 then
                callback(app, false)
            else
                callback(app, true)
            end
        end)
    end)
end

function userAddApp(uid, app)
    MySQL.Async.fetchScalar("SELECT COUNT(*) FROM ephone_app_menu WHERE user = @user", {['@user'] = uid}, function(data)
        MySQL.Async.execute("INSERT INTO ephone_app_menu (`user`, `appid`, `index`) VALUES (@uid, @appid, @index)", {['@uid'] = uid, ['appid'] = app.id, ['index'] = data + 1}, function(changes)
            TriggerClientEvent('ephone:getMenu', source)
        end)
    end)
end

function userDeleteApp(uid, app)
    MySQL.Async.execute("DELETE FROM ephone_app_menu WHERE user = @user AND appid = @appid", {['@user'] = uid, ['@appid'] = app.id})
end
