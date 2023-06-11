ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
end)

local Config = require('config')
local rented = false

Citizen.CreateThread(function()
    local houseMarker = Config.HouseMarker
    local exitMarker = Config.ExitMarker

    -- Crear blip
    local blip = AddBlipForCoord(houseMarker)
    SetBlipSprite(blip, 369)
    SetBlipColour(blip, 3) -- Color azul
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Casa en alquiler")
    EndTextCommandSetBlipName(blip)

    while true do
        Citizen.Wait(100)
        local playerCoords = GetEntityCoords(PlayerPedId())

        if #(playerCoords - houseMarker) < 1.0 then
            ESX.ShowHelpNotification("Pulsa ~INPUT_CONTEXT~ para alquilar.")
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback('esx_house:checkMoney', function(hasEnoughMoney)
                    if hasEnoughMoney then
                        rented = not rented
                        SetEntityCoords(PlayerPedId(), exitMarker)
                        TriggerServerEvent('esx_house:rentHouse')
                    else
                        ESX.ShowNotification("No tienes suficiente dinero para alquilar.")
                    end
                end)
            end
        elseif rented and #(playerCoords - exitMarker) < 1.0 then
            ESX.ShowHelpNotification("Pulsa ~INPUT_CONTEXT~ para salir de casa.")
            if IsControlJustReleased(0, 38) then
                SetEntityCoords(PlayerPedId(), houseMarker)
            end
        end
    end
end)