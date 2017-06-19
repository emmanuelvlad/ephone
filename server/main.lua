local number_length = 10
local number_prefix = 213

apps = {}

require "resources/mysql-async/lib/MySQL"

--------------------------------------------------------------------------------
--
--									EVENTS
--
--------------------------------------------------------------------------------
AddEventHandler('chatMessageEntered', function(name, color, message)
    addUser(source)
    userAddApp(source, "navigator")
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason)
    addUser(source)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == "ephone" then
        setupPhone()
    end
end)

AddEventHandler('onResourceStop', function(resource)

end)

RegisterServerEvent('addGroup')
AddEventHandler('addGroup', function(name, number)
    addGroup(name, number)
end)

RegisterServerEvent('changeUserPhoneNumber')
AddEventHandler('changeUserPhoneNumber', function(source, newnumber)
    changeUserPhoneNumber(source, newnumber)
end)

RegisterServerEvent('changeGroupPhoneNumber')
AddEventHandler('changeGroupPhoneNumber', function(name, newnumber)
    changeGroupPhoneNumber(name, newnumber)
end)

RegisterServerEvent('changeGroupName')
AddEventHandler('changeGroupName', function(name, newname)
    changeGroupPhoneNumber(name, newname)
end)


--------------------------------------------------------------------------------
--
--								FUNCTIONS
--
--------------------------------------------------------------------------------
function setupPhone()
    MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `ephone_users` (`id` int(11) NOT NULL AUTO_INCREMENT, `playerid` varchar(255) NOT NULL, `group` int(11) NOT NULL DEFAULT '0', `phone_number` int(11) NOT NULL, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;")
    checkColumn("ephone_users", "id", "int(11) NOT NULL AUTO_INCREMENT")
    checkColumn("ephone_users", "playerid", "varchar(255) NOT NULL AFTER `id`")
    checkColumn("ephone_users", "group", "int(11) NOT NULL DEFAULT '0' AFTER `playerid`")
    checkColumn("ephone_users", "phone_number", "int(11) NOT NULL AFTER `group`")

    MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `ephone_groups` (`id` int(11) NOT NULL AUTO_INCREMENT, `group_name` varchar(30) NOT NULL, `phone_number` int(11) NOT NULL, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;")
    checkColumn("ephone_groups", "id", "int(11) NOT NULL AUTO_INCREMENT")
    checkColumn("ephone_groups", "group_name", "varchar(30) NOT NULL AFTER `id`")
    checkColumn("ephone_groups", "phone_number", "int(11) NOT NULL AFTER `group_name`")

    MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `ephone_app` (`id` int(11) NOT NULL AUTO_INCREMENT, `name` varchar(20) NOT NULL, `display_name` varchar(20) NOT NULL, `description` text NOT NULL, `icon` varchar(20) NOT NULL, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;")
    checkColumn("ephone_app", "id", "int(11) NOT NULL AUTO_INCREMENT")
    checkColumn("ephone_app", "name", "varchar(20) NOT NULL AFTER `id`")
    checkColumn("ephone_app", "display_name", "varchar(20) NOT NULL AFTER `name`")
    checkColumn("ephone_app", "description", "text NOT NULL AFTER `display_name`")
    checkColumn("ephone_app", "icon", "varchar(20) NOT NULL AFTER `description`")
end

function checkTable(table, callback)
    MySQL.Async.fetchScalar("SELECT COUNT(1) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @table", {['@table'] = table}, function(data)
        if data == 0 then
            callback(false)
        else
            callback(true)
        end
    end)
end

function checkColumn(table, column, settings)
    MySQL.Async.fetchScalar("SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @table AND COLUMN_NAME = @column", {['@table'] = table, ['@column'] = column}, function(data)
        if data == 0 then
            MySQL.Async.execute(string.format("ALTER TABLE `%s` ADD `%s` %s", table, column, settings))
        end
    end)
end

function getApps(callback)
    MySQL.Async.fetchAll("SELECT * FROM ephone_app", {}, function(apps)
        callback(apps)
    end)
end

function getApp(name, callback)
    MySQL.Async.fetchAll("SELECT * FROM ephone_app WHERE name = @name", {['@name'] = name}, function(data)
        callback(data[1])
    end)
end

function checkApp(name, callback)
    MySQL.Async.fetchScalar("SELECT COUNT(1) FROM ephone_app WHERE name = @name", {['@name'] = name}, function(data)
        if data == 0 then
            callback(false)
        else
            callback(true)
        end
    end)
end

function addApp(name, display_name, description, icon)
    checkApp(name, function(bool, err)
        if bool == false then
            MySQL.Async.execute("INSERT INTO ephone_app (`name`, `display_name`, `description`, `icon`) VALUES (@name, @display_name, @description, @icon)", {['@name'] = name, ['@display_name'] = display_name, ['@description'] = description, ['@icon'] = icon})
        end
    end)
end

function getUserId(source, callback)
    MySQL.Async.fetchAll("SELECT * FROM ephone_users WHERE playerid = @source", {['@source'] = GetPlayerIdentifiers(source)[1]}, function(data)
        if data[1].id then
            callback(data[1].id)
        else
            callback(nil)
        end
    end)
end

function checkPhoneNumber(number, callback)
    MySQL.Async.fetchScalar("SELECT COUNT(1) FROM ephone_users WHERE phone_number = @number", {['@number'] = number}, function(data)
        if data == 0 then
            MySQL.Async.fetchScalar("SELECT COUNT(1) FROM ephone_groups WHERE phone_number = @number", {['@number'] = number}, function(data)
                if data == 0 then
                    callback(false)
                else
                    callback(true)
                end
            end)
        else
            callback(true)
        end
    end)
end

function generatePhoneNumber()
    local newnumber = tostring(number_prefix)

    for length=string.len(tostring(number_prefix)), number_length - 1 do
        newnumber = newnumber .. tostring(math.random(10))
    end
    checkPhoneNumber(newnumber, function(bool)
        if bool then
            return generatePhoneNumber()
        end
    end)
    return tonumber(newnumber)
end

function checkUser(source, callback)
    MySQL.Async.fetchScalar("SELECT COUNT(1) FROM ephone_users WHERE playerid = @identifier", {['@identifier'] = GetPlayerIdentifiers(source)[1]}, function(data)
        if data == 0 then
            callback(false)
        else
            callback(true)
        end
    end)
end

function addUser(source)
    checkUser(source, function(bool)
        if bool == false then
            MySQL.Async.execute("INSERT INTO ephone_users (`playerid`, `phone_number`) VALUES (@identifier, @number)", {['@identifier'] = GetPlayerIdentifiers(source)[1], ['@number'] = generatePhoneNumber()})
        end
    end)
end

function checkGroup(name, number, callback)
    MySQL.Async.fetchScalar("SELECT COUNT(1) FROM ephone_groups WHERE group_name = @name", {['@name'] = name}, function(data)
        if data == 0 then
            MySQL.Async.fetchScalar("SELECT COUNT(1) FROM ephone_groups WHERE phone_number = @number", {['@number'] = number}, function(data)
                if data == 0 then
                    callback(false)
                else
                    callback(true)
                end
            end)
        else
            callback(true)
        end
    end)
end

function addGroup(name, number)
    checkGroup(name, number, function(bool)
        if bool == false then
            MySQL.Async.execute("INSERT INTO ephone_groups (`group_name`, `phone_number`) VALUES (@name, @number)", {['@name'] = name, ['@number'] = tonumber(number)})
        end
    end)
end

function  changeUserPhoneNumber(source, newnumber)
    getUserId(source, function(uid)
        if uid then
            MySQL.Async.execute("UPDATE ephone_users SET phone_number=@newnumber WHERE playerid = @uid", {['newnumber'] = newnumber,  ['uid'] = uid})
        end
    end)
end

function  changeGroupPhoneNumber(name, newnumber)
    MySQL.Async.execute("UPDATE ephone_groups SET phone_number=@newnumber WHERE group_name = @name", {['newnumber'] = newnumber,  ['name'] = name})
end

function  changeGroupName(name, newname)
    MySQL.Async.execute("UPDATE ephone_groups SET group_name=@newname WHERE group_name = @name", {['newname'] = newname,  ['name'] = name})
end
