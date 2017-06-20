require "resources/mysql-async/lib/MySQL"

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
        addApp(app_name, app_display_name, app_description, app_icon)
        apps[app_name].init()
    end
end)

RegisterServerEvent('ephone:getContacts')
AddEventHandler('ephone:getContacts', function()
    getUserId(source, function(uid)
        getContacts(uid, function(data)
            print("getcontacts")
            TriggerClientEvent('ephone:loadContacts', source, data)
        end)
    end)
end)

RegisterServerEvent('ephone:addContact')
AddEventHandler('ephone:addContact', function(phone_number, name)
    getUserId(source, function(uid)
        contactAlreadyExists(uid, phone_number, function(bool)
            if not bool then
                getContactsCount(uid, function(data)
                    if data < contacts_limit - 1 then
                        addContact(uid, phone_number, name)
                        TriggerClientEvent('ephone:getContacts', source)
                    else
                        -- Notify limit of contacts
                    end
                end)
            else
                -- Notify phone number already exists in repertory
            end
        end)
    end)
end)

RegisterServerEvent('ephone:updateContact')
AddEventHandler('ephone:updateContact', function(phone_number, new_phone_number, name, new_name)
    getUserId(source, function(uid)
        updateContact(uid, phone_number, new_phone_number, name, new_name)
    end)
end)

RegisterServerEvent('ephone:deleteContact')
AddEventHandler('ephone:deleteContact', function(phone_number)
    getUserId(source, function(uid)
        deleteContact(uid, phone_number)
    end)
end)


--------------------------------------------------------------------------------
--
--								FUNCTIONS
--
--------------------------------------------------------------------------------
apps[app_name].init = function()
    MySQL.Async.execute("CREATE TABLE IF NOT EXISTS `ephone_app_contacts` (`user` int(11) NOT NULL, `phone_number` bigint(20) NOT NULL, `name` varchar(30) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;", {}, function(changes)
        checkColumn("ephone_app_contacts", "user", "int(11) NOT NULL")
        checkColumn("ephone_app_contacts", "phone_number", "bigint(20) NOT NULL AFTER `user`")
        checkColumn("ephone_app_contacts", "name", "varchar(30) NOT NULL AFTER `phone_number`")
    end)
end

function getContacts(uid, callback)
    MySQL.Async.fetchAll("SELECT * FROM ephone_app_contacts WHERE user = @user", {['@user'] = uid}, function(data)
        callback(data)
    end)
end

function getContactsCount(uid, callback)
    MySQL.Async.fetchScalar("SELECT COUNT(*) FROM ephone_app_contacts WHERE user = @user", {['@user'] = uid}, function(data)
        callback(uid, data)
    end)
end

function contactAlreadyExists(uid, phone_number, callback)
    MySQL.Async.fetchScalar("SELECT COUNT(1) FROM ephone_app_contacts WHERE user = @user AND phone_number = @phone_number", {['@user'] = uid, ['@phone_number'] = phone_number}, function(data)
        if data == 0 then
            callback(false)
        else
            callback(true)
        end
    end)
end

function addContact(uid, phone_number, name)
    MySQL.Async.execute("INSERT INTO ephone_app_contacts (`user`, `phone_number`, `name`) VALUES (@user, @phone_number, @name)", {['@user'] = uid, ['@phone_number'] = phone_number, ['@name'] = name})
end

function updateContact(uid, phone_number, new_phone_number, name, new_name)
    MySQL.Async.execute("UPDATE ephone_app_contacts SET phone_number = @new_phone_number, name = @new_name WHERE user = @user AND phone_number = @phone_number", {['@new_phone_number'] = new_phone_number, ['@new_name'] = new_name, ['@user'] = uid, ['@phone_number'] = phone_number})
end

function deleteContact(uid, phone_number)
    MySQL.Async.execute("DELETE FROM ephone_app_contacts WHERE user = @user AND phone_number = @phone_number", {['@user'] = uid, ['@phone_number'] = phone_number})
end
