ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Config = require('config')

-- Comprobar la versión del script
Citizen.CreateThread(function()
    local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
    local latestVersion = CheckVersion()

    if latestVersion ~= currentVersion then
        print(('^1[510-rentedhouses] La versión actual es %s, pero la última versión es %s. Por favor, actualiza el script.^7'):format(currentVersion, latestVersion))
    else
        print('^2[510-rentedhouses] Estás utilizando la última versión del script.^7')
    end
end)

function CheckVersion()
    local version = nil
    local url = 'https://raw.githubusercontent.com/510-rentedhouses/main/__resource.lua'

    PerformHttpRequest(url, function(statusCode, response, headers)
        if statusCode == 200 then
            version = string.match(response, "version '(%S+)'")
        else
            print('^1[510-rentedhouses] No se pudo comprobar la versión del script.^7')
        end
    end, 'GET', '')

    while version == nil do
        Citizen.Wait(100)
    end

    return version
end

ESX.RegisterServerCallback('esx_house:checkMoney', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = xPlayer.getMoney()

    if money >= Config.Price then
        xPlayer.removeMoney(Config.Price)
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('esx_house:rentHouse')
AddEventHandler('esx_house:rentHouse', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier

    MySQL.Async.execute('INSERT INTO houses (owner, rented) VALUES (@owner, @rented)', {
        ['@owner'] = identifier,
        ['@rented'] = 1
    }, function(rowsChanged)
        if rowsChanged > 0 then
            print('Casa alquilada por: ' .. identifier)
        end
    end)
end)