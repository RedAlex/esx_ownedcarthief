-- Vehicle Lock Integration - Client
-- Manages client interactions with the detected lock system

local VehicleLockEnabled = false
local CurrentLockResource = nil

-- ============================================================
-- DETECTION AND INITIALIZATION
-- ============================================================

Citizen.CreateThread(function()
    Wait(2000) -- Wait for loading
    
    -- Detect client-side resources
    local resources = {
        'ox_vehiclelock',
        'esx_carkeys',
        'esx_lockpick',
        'tsn_carlock',
        'vms_carlock',
        'bd_carlock',
        'esx_vehiclelock'
    }
    
    for _, resourceName in ipairs(resources) do
        local state = GetResourceState(resourceName)
        if state == 'started' or state == 'starting' then
            print("^2[VehicleLock-Client] ^7" .. _U('vehicle_lock_resource_detected', resourceName))
            VehicleLockEnabled = true
            CurrentLockResource = resourceName
            break
        end
    end
    
    if not VehicleLockEnabled then
        print("^1[VehicleLock-Client] ^7" .. _U('vehicle_lock_no_resource'))
        print("^3[VehicleLock-Client] ^7" .. _U('vehicle_lock_default_unlocked'))
    else
        print("^2[VehicleLock-Client] ^7" .. _U('vehicle_lock_system_adapted', CurrentLockResource))
    end
end)

-- ============================================================
-- HELPER FUNCTIONS
-- ============================================================

---Unlocks a vehicle's doors
---@param vehicle number Vehicle ID
local function UnlockVehicleDoors(vehicle)
    if vehicle == 0 then return end
    
    SetVehicleDoorsLocked(vehicle, 1) -- Unlocked
end

---Locks a vehicle's doors
---@param vehicle number Vehicle ID
local function LockVehicleDoors(vehicle)
    if vehicle == 0 then return end
    
    SetVehicleDoorsLocked(vehicle, 2) -- Cannot be opened
end

---Gets a vehicle by plate
---@param plate string Vehicle plate
---@return number Vehicle ID or 0
local function GetVehicleWithPlate(plate)
    local vehicles = GetGamePool('CVehicle')
    if vehicles then
        for _, vehicle in ipairs(vehicles) do
            if GetVehicleNumberPlateText(vehicle) == plate then
                return vehicle
            end
        end
    end
    return 0
end

-- ============================================================
-- UNIVERSAL EVENTS
-- ============================================================

-- Event: A player approaches a vehicle (event currently not used)
-- RegisterNetEvent('esx_ownedcarthief:playerNearVehicle', function(plate, distance)
-- 	if not VehicleLockEnabled then return end
-- 	
-- 	local vehicle = GetVehicleWithPlate(plate)
-- 	if vehicle == 0 then return end
-- 	
-- 	-- Show interaction prompt
-- 	if distance < 3.0 then
-- 		DrawLocalText(_U('vehicle_lock_interaction'), 0.5, 0.95)
-- 	end
-- end)

-- Event: Vehicle purchased (To trigger from server with TriggerClientEvent)
-- To activate, add in server: TriggerClientEvent('esx_ownedcarthief:vehiclePurchasedClient', source, plate)
RegisterNetEvent('esx_ownedcarthief:vehiclePurchasedClient', function(plate)
    local vehicle = GetVehicleWithPlate(plate)
    if vehicle ~= 0 then
        UnlockVehicleDoors(vehicle)
        
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            args = {_U('vehicle_lock_purchase_title'), _U('vehicle_lock_purchase_message')}
        })
    end
end)

-- Event: Lockpick success (To trigger from server with TriggerClientEvent)
-- To activate, add in server: TriggerClientEvent('esx_ownedcarthief:lockpickSuccessClient', source, plate)
RegisterNetEvent('esx_ownedcarthief:lockpickSuccessClient', function(plate)
    local vehicle = GetVehicleWithPlate(plate)
    if vehicle ~= 0 then
        UnlockVehicleDoors(vehicle)
    end
end)

-- Event: Alarm triggered (To trigger from server with TriggerClientEvent)
-- To activate, add in server: TriggerClientEvent('esx_ownedcarthief:alarmTriggeredClient', source, plate)
RegisterNetEvent('esx_ownedcarthief:alarmTriggeredClient', function(plate)
    local vehicle = GetVehicleWithPlate(plate)
    if vehicle == 0 then return end
    
    -- Play alarm sound
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
    
    -- Flash the lights
    for i = 1, 5 do
        SetVehicleIndicatorLights(vehicle, 0, true)
        SetVehicleIndicatorLights(vehicle, 1, true)
        Wait(200)
        SetVehicleIndicatorLights(vehicle, 0, false)
        SetVehicleIndicatorLights(vehicle, 1, false)
        Wait(200)
    end
    
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        args = {_U('vehicle_lock_alarm_title'), _U('vehicle_lock_alarm_message')}
    })
end)

-- Event: Vehicle seized (To trigger from server with TriggerClientEvent)
-- To activate, add in server: TriggerClientEvent('esx_ownedcarthief:vehicleSeizedClient', source, plate)
RegisterNetEvent('esx_ownedcarthief:vehicleSeizedClient', function(plate)
    local vehicle = GetVehicleWithPlate(plate)
    if vehicle ~= 0 then
        SetVehicleDoorsLocked(vehicle, 2) -- Lock the vehicle
        
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {_U('vehicle_lock_police_title'), _U('vehicle_lock_police_message')}
        })
    end
end)

-- Event: Lock state update
RegisterNetEvent('esx_ownedcarthief:updateVehicleLockState', function(plate, locked)
    local vehicle = GetVehicleWithPlate(plate)
    if vehicle == 0 then return end
    
    if locked then
        SetVehicleDoorsLocked(vehicle, 2) -- Locked
    else
        SetVehicleDoorsLocked(vehicle, 1) -- Unlocked
    end
end)

-- ============================================================
-- INTERACTION DETECTION (Fallback if no resource)
-- ============================================================

if not VehicleLockEnabled then
    -- If no resource, all vehicles are accessible
    Citizen.CreateThread(function()
        while true do
            Wait(1000) -- Reduced frequency to avoid performance issues
            
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            
            for _, vehicle in ipairs(GetGamePool('CVehicle')) do
                local vehCoords = GetEntityCoords(vehicle)
                local distance = #(playerCoords - vehCoords)
                
                if distance < 3.0 then
                    -- All vehicles unlocked
                    SetVehicleDoorsLocked(vehicle, 1) -- Unlocked
                end
            end
        end
    end)
end

-- ============================================================
-- HELPER FUNCTION: Draw text (currently not used)
-- ============================================================

-- function DrawLocalText(text, x, y)
--     SetTextFont(0)
--     SetTextProportional(1)
--     SetTextScale(0.0, 0.35)
--     SetTextColour(255, 255, 255, 255)
--     SetTextDropshadow(0, 0, 0, 0, 255)
--     SetTextEdge(1, 0, 0, 0, 255)
--     SetTextDropShadow()
--     SetTextOutline()
--     SetTextCentre(true)
--     BeginTextCommandDisplayText("STRING")
--     AddTextComponentSubstringPlayerName(text)
--     EndTextCommandDisplayText(x, y)
-- end

print("^2[esx_ownedcarthief] ^7" .. _U('vehicle_lock_client_loaded'))
