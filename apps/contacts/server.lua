local app_name = "contacts"
local app_display_name = ""
local app_description = ""
local app_icon = ""
local contacts_limit = 100
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
        apps[app_name].init()
    end
end)

RegisterServerEvent('ephone:getContacts')
AddEventHandler('ephone:getContacts', function()
    local player = source
    getContacts(player, function(data)
        print("getcontacts")
        TriggerClientEvent('ephone:loadContacts', player, data)
    end)
end)

RegisterServerEvent('ephone:addContact')
AddEventHandler('ephone:addContact', function(phone_number, name)
    local player = source
    contactAlreadyExists(player, phone_number, function(bool)
        if not bool then
            getContactsCount(player, function(data)
                RconPrint(tostring(data))
                if data < contacts_limit - 1 then
                    addContact(player, phone_number, name)
                    TriggerClientEvent('ephone:getContacts', player)
                else
                    -- Notify limit of contacts
                end
            end)
        else
            -- Notify phone number already exists in repertory
        end
    end)
end)

RegisterServerEvent('ephone:updateContact')
AddEventHandler('ephone:updateContact', function(phone_number, new_phone_number, name, new_name)
    updateContact(source, phone_number, new_phone_number, name, new_name)
end)

RegisterServerEvent('ephone:deleteContact')
AddEventHandler('ephone:deleteContact', function(phone_number)
    deleteContact(source, phone_number)
end)


--------------------------------------------------------------------------------
--
--								FUNCTIONS
--
--------------------------------------------------------------------------------
apps[app_name].init = function()
    MySQL.ready(function ()
        MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `ephone_app_contacts` (`user` int(11) NOT NULL, `phone_number` bigint(20) NOT NULL, `name` varchar(30) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;", {}, function(changes)
            checkColumn("ephone_app_contacts", "user", "int(11) NOT NULL")
            checkColumn("ephone_app_contacts", "phone_number", "bigint(20) NOT NULL AFTER `user`")
            checkColumn("ephone_app_contacts", "name", "varchar(30) NOT NULL AFTER `phone_number`")
        end)
    end)
end

function getContacts(source, callback)
    local identifier = GetPlayerIdentifiers(source)

    if identifier[1] then
        MySQL.Async.fetchAll("SELECT * FROM ephone_app_contacts LEFT JOIN ephone_users ON ephone_users.id = user WHERE ephone_users.playerid = @playerid", {['@playerid'] = identifier[1]}, function(data)
            callback(data)
        end)
    end
end

function getContactsCount(source, callback)
    local identifier = GetPlayerIdentifiers(source)

    if identifier[1] then
        MySQL.Async.fetchScalar("SELECT COUNT(*) FROM ephone_app_contacts LEFT JOIN ephone_users ON ephone_users.id = user WHERE ephone_users.playerid = @playerid", {['@playerid'] = identifier[1]}, function(data)
            callback(data)
        end)
    end
end

function contactAlreadyExists(source, phone_number, callback)
    local identifier = GetPlayerIdentifiers(source)

    if identifier[1] then
        MySQL.Async.fetchScalar("SELECT COUNT(1) FROM ephone_app_contacts LEFT JOIN ephone_users ON ephone_users.id = user WHERE ephone_users.playerid = @playerid AND ephone_app_contacts.phone_number = @phone_number", {['@playerid'] = identifier[1], ['@phone_number'] = phone_number}, function(data)
            if data == 0 then
                callback(false)
            else
                callback(true)
            end
        end)
    end
end

function addContact(source, phone_number, name)
    RconPrint("user ... " .. source)
    getUser(source, function(user)
        MySQL.Async.execute("INSERT INTO ephone_app_contacts (`user`, `phone_number`, `name`) VALUES (@user, @phone_number, @name)", {['@user'] = user.id, ['@phone_number'] = phone_number, ['@name'] = name})
    end)
end

function updateContact(source, phone_number, new_phone_number, name, new_name)
    local identifier = GetPlayerIdentifiers(source)

    if identifier[1] then
        MySQL.Async.execute("UPDATE ephone_app_contacts LEFT JOIN ephone_users ON ephone_users.id = user SET ephone_app_contacts.phone_number = @new_phone_number, name = @new_name WHERE ephone_users.playerid = @playerid AND ephone_app_contacts.phone_number = @phone_number", {['@new_phone_number'] = new_phone_number, ['@new_name'] = new_name, ['@playerid'] = identifier[1], ['@phone_number'] = phone_number})
    end
end

function deleteContact(source, phone_number)
    local identifier = GetPlayerIdentifiers(source)

    if identifier[1] then
        MySQL.Async.execute("DELETE FROM ephone_app_contacts LEFT JOIN ephone_users ON ephone_users.id = user WHERE ephone_users.playerid = @playerid AND phone_number = @phone_number", {['@playerid'] = identifier[1], ['@phone_number'] = phone_number})
    end
end
