-- Vehicle Lock Integration - Server
-- Integrates VehicleLockManager to adapt code to the detected resource

local VehicleLockManager = require('server.vehicle_lock_manager')

-- Check if the system is enabled
Citizen.CreateThread(function()
    Wait(3000)
    
    if VehicleLockManager:isEnabled() then
        print("^2[esx_ownedcarthief] ^7Lock system enabled: " .. VehicleLockManager:getResourceName())
    else
        print("^1[esx_ownedcarthief] ^7⚠️ WARNING: No lock system detected!")
        print("^3[esx_ownedcarthief] ^7Vehicle theft will be limited without locking")
    end
end)

-- Export wrapper: Give keys to a vehicle owner
exports("GiveVehicleKeys", function(identifier, plate)
    if VehicleLockManager:isEnabled() then
        return VehicleLockManager:giveVehicleKeys(identifier, plate)
    end
    return false
end)

-- Export wrapper: Remove keys
exports("RemoveVehicleKeys", function(identifier, plate)
    if VehicleLockManager:isEnabled() then
        return VehicleLockManager:removeVehicleKeys(identifier, plate)
    end
    return false
end)

-- Export wrapper: Check if the player has keys
exports("PlayerHasKeys", function(identifier, plate)
    if VehicleLockManager:isEnabled() then
        return VehicleLockManager:playerHasKeys(identifier, plate)
    end
    return false
end)

-- Export wrapper: Lock/unlock a vehicle
exports("SetVehicleLockState", function(plate, locked)
    if VehicleLockManager:isEnabled() then
        return VehicleLockManager:setVehicleLockState(plate, locked)
    end
    return false
end)

-- Export wrapper: Get current resource
exports("GetLockResource", function()
    return VehicleLockManager:getResourceName()
end)

-- Export wrapper: Check if enabled
exports("IsVehicleLockEnabled", function()
    return VehicleLockManager:isEnabled()
end)

-- ============================================================
-- INTEGRATION EVENTS
-- ============================================================

-- Event: Vehicle purchase
RegisterNetEvent('esx_ownedcarthief:vehiclePurchased', function(plate, identifier, vehicleData)
    if not VehicleLockManager:isEnabled() then return end
    
    -- Give keys to the owner
    local success = exports['esx_ownedcarthief']:GiveVehicleKeys(identifier, plate)
    
    if success then
		print("^2[esx_ownedcarthief] ^7Keys given to owner for plate: " .. plate)
	else
		print("^3[esx_ownedcarthief] ^7Unable to give keys (incompatible resource)")
    
    -- Unlock the vehicle
    exports['esx_ownedcarthief']:SetVehicleLockState(plate, false)
end)

-- Event: Lockpick success
RegisterNetEvent('esx_ownedcarthief:lockpickSuccess', function(plate)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer or not VehicleLockManager:isEnabled() then return end
    
    -- Ensure this is not theft of their own vehicle
    local query = "SELECT owner FROM owned_vehicles WHERE plate = ?"
    MySQL.Async.fetchScalar(query, {plate}, function(owner)
        if not owner or owner == xPlayer.identifier then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                args = {"Erreur", "Vous ne pouvez pas voler ce véhicule"}
            })
            return
        end
        
        -- Give keys to the thief (temporary or permanent depending on the resource)
        local keysGiven = exports['esx_ownedcarthief']:GiveVehicleKeys(xPlayer.identifier, plate)
        
        if keysGiven then
            print("^2[esx_ownedcarthief] ^7Clés données au voleur pour la plaque: " .. plate)
        end
        
        -- Unlock the vehicle
        exports['esx_ownedcarthief']:SetVehicleLockState(plate, false)
        
        -- Trigger the alarm
        TriggerEvent('esx_ownedcarthief:triggerAlarm', plate, 1)
        
        TriggerClientEvent('chat:addMessage', source, {
            color = {0, 255, 0},
            args = {"Succès", "Vous avez crocheté le véhicule avec succès!"}
        })
    end)
end)

-- Event: Unauthorized access attempt
RegisterNetEvent('esx_ownedcarthief:unauthorizedAccessAttempt', function(plate)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer or not VehicleLockManager:isEnabled() then return end
    
    local hasKeys = exports['esx_ownedcarthief']:PlayerHasKeys(xPlayer.identifier, plate)
    
    if not hasKeys then
        -- Trigger the alarm
        TriggerEvent('esx_ownedcarthief:triggerAlarm', plate, 1)
        
        print("^1[ALARM] ^7Tentative d'accès non autorisé à: " .. plate .. " par " .. xPlayer.name)
    end
end)

-- Event: Vehicle seizure (police)
RegisterNetEvent('esx_ownedcarthief:vehicleSeized', function(plate)
    if not VehicleLockManager:isEnabled() then return end
    
    -- Remove keys from ALL players
    local query = "SELECT DISTINCT owner FROM owned_vehicles WHERE plate = ?"
    MySQL.Async.fetchAll(query, {plate}, function(results)
        if results then
            for _, row in ipairs(results) do
                exports['esx_ownedcarthief']:RemoveVehicleKeys(row.owner, plate)
            end
        end
    end)
    
    -- Lock the vehicle
    exports['esx_ownedcarthief']:SetVehicleLockState(plate, true)
    
	print("^2[esx_ownedcarthief] ^7Vehicle seized: " .. plate)
RegisterNetEvent('esx_ownedcarthief:soldToPawnshop', function(plate, thief)
    if not VehicleLockManager:isEnabled() then return end
    
    -- Remove keys from the thief
    exports['esx_ownedcarthief']:RemoveVehicleKeys(thief, plate)
    
    -- Lock the vehicle (pawnshop controls it)
    exports['esx_ownedcarthief']:SetVehicleLockState(plate, true)
    
	print("^2[esx_ownedcarthief] ^7Vehicle sold to pawnshop: " .. plate)
RegisterNetEvent('esx_ownedcarthief:transferKeys', function(plate, fromIdentifier, toIdentifier)
    if not VehicleLockManager:isEnabled() then return end
    
    -- Remove keys from the previous owner
    exports['esx_ownedcarthief']:RemoveVehicleKeys(fromIdentifier, plate)
    
    -- Give keys to the new owner
    exports['esx_ownedcarthief']:GiveVehicleKeys(toIdentifier, plate)
    
	print("^2[esx_ownedcarthief] ^7Keys transferred for: " .. plate)
-- LOGS AND DEBUGGING
-- ============================================================

-- Admin command to check status
RegisterCommand('vehiclelockstatus', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer or xPlayer.admin < 1 then
        return
    end
    
    local isEnabled = VehicleLockManager:isEnabled()
    local resourceName = VehicleLockManager:getResourceName()
    
    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 0},
		args = {"Lock System", "Status: " .. (isEnabled and "ACTIVE" or "INACTIVE")}
    if isEnabled then
        TriggerClientEvent('chat:addMessage', source, {
            color = {0, 255, 0},
            args = {"Système Verrouillage", "Ressource: " .. resourceName}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"Système Verrouillage", "⚠️ AUCUNE RESSOURCE DÉTECTÉE"}
        })
    end
end, false)

-- Command to force detection (debug)
RegisterCommand('redetectvehiclelock', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer or xPlayer.admin < 1 then
        return
    end
    
    print("^3[DEBUG] ^7Redétection des ressources de verrouillage...")
    VehicleLockManager:detectAvailableResource()
    
    TriggerClientEvent('chat:addMessage', source, {
        color = {255, 255, 0},
        args = {"DEBUG", "Redétection effectuée"}
    })
end, false)

print("^2[esx_ownedcarthief] ^7Server integration module loaded")
