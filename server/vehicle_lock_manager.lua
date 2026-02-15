-- Vehicle Lock Manager - Automatic detection of lock resources
-- This module detects and adapts to the available resource

local VehicleLockManager = {}

-- Supported resources configuration
VehicleLockManager.SupportedResources = {
    {
        name = 'ox_vehiclelock',
        priority = 1, -- Highest priority (modern, best)
        exports = {
            GiveVehicleKeys = 'GiveVehicleKeys',
            RemoveVehicleKeys = 'RemoveVehicleKeys',
            SetVehicleLockState = 'SetVehicleLockState',
            GetVehicleLockState = 'GetVehicleLockState',
            PlayerHasKeys = 'PlayerHasKeys',
        },
        events = {
            lockVehicle = 'ox_vehiclelock:lockVehicle',
            unlockVehicle = 'ox_vehiclelock:unlockVehicle',
        }
    },
    {
        name = 'esx_carkeys',
        priority = 2,
        exports = {
            GiveVehicleKeys = 'GiveVehicleKeys',
            RemoveVehicleKeys = 'RemoveVehicleKeys',
        },
        events = {
            lockVehicle = 'esx_carkeys:lockVehicle',
            unlockVehicle = 'esx_carkeys:unlockVehicle',
        }
    },
    {
        name = 'esx_lockpick',
        priority = 3,
        isSpecial = true, -- Lockpicking system, no direct key management
        exports = {
            -- esx_lockpick has no key exports
        },
        events = {
            lockpickSuccess = 'esx_lockpick:success',
            lockpickFailed = 'esx_lockpick:failed',
        }
    },
    {
        name = 'tsn_carlock',
        priority = 4,
        exports = {
            SetVehicleLockState = 'SetVehicleLockState',
        },
        events = {
            lockVehicle = 'tsn_carlock:lockVehicle',
            unlockVehicle = 'tsn_carlock:unlockVehicle',
        }
    },
    {
        name = 'vms_carlock',
        priority = 5,
        exports = {
            -- vms_carlock is generally client-side
        },
        events = {
            lockVehicle = 'vms_carlock:lockVehicle',
            unlockVehicle = 'vms_carlock:unlockVehicle',
        }
    },
    {
        name = 'bd_carlock',
        priority = 6,
        exports = {
            -- bd_carlock minimal
        },
        events = {
            toggleLock = 'bd_carlock:toggleVehicleLock',
        }
    },
    {
        name = 'esx_vehiclelock',
        priority = 7,
        exports = {
            LockVehicle = 'LockVehicle',
            UnLockVehicle = 'UnLockVehicle',
        },
        events = {
            lockVehicle = 'esx_vehiclelock:lockVehicle',
            unlockVehicle = 'esx_vehiclelock:unlockVehicle',
        }
    }
}

-- Current manager state
VehicleLockManager.currentResource = nil
VehicleLockManager.locked = false -- Disabled by default
VehicleLockManager.enabled = false

---@return table|nil Detected resource or nil
function VehicleLockManager:detectAvailableResource()
    -- Sort by priority
    table.sort(self.SupportedResources, function(a, b)
        return a.priority < b.priority
    end)
    
    -- Test each resource by priority order
    for _, resource in ipairs(self.SupportedResources) do
        local resourceState = GetResourceState(resource.name)
        
        if resourceState == 'started' or resourceState == 'starting' then
            print("^2[VehicleLockManager] ^7Ressource détectée: " .. resource.name .. " (Priorité: " .. resource.priority .. ")")
            self.currentResource = resource
            self.enabled = true
            return resource
        end
    end
    
    print("^1[VehicleLockManager] ^7AUCUNE ressource de verrouillage de véhicules détectée!")
    print("^3[VehicleLockManager] ^7Ressources supportées:")
    for _, resource in ipairs(self.SupportedResources) do
        print("  - " .. resource.name)
    end
    
    self.enabled = false
    self.locked = true -- Lock the module if no resource
    return nil
end

---@param identifier string Player identifier
---@param plate string Vehicle plate
function VehicleLockManager:giveVehicleKeys(identifier, plate)
    if not self.enabled or not self.currentResource then
        return false
    end
    
    local resource = self.currentResource
    
    -- Avoid lockpick-only resources
    if resource.isSpecial then
		print("^3[VehicleLockManager] ^7Resource " .. resource.name .. " does not handle keys")
        exports['ox_vehiclelock']:GiveVehicleKeys(identifier, plate)
        return true
    elseif resource.name == 'esx_carkeys' and exports['esx_carkeys'] then
        exports['esx_carkeys']:GiveVehicleKeys(identifier, plate)
        return true
    elseif resource.name == 'esx_vehiclelock' and exports['esx_vehiclelock'] then
        -- Adapt as needed for esx_vehiclelock
        return true
    end
    
    return false
end

---@param identifier string Player identifier
---@param plate string Vehicle plate
function VehicleLockManager:removeVehicleKeys(identifier, plate)
    if not self.enabled or not self.currentResource then
        return false
    end
    
    local resource = self.currentResource
    
    if resource.isSpecial then
        return false
    end
    
    if resource.name == 'ox_vehiclelock' and exports['ox_vehiclelock'] then
        exports['ox_vehiclelock']:RemoveVehicleKeys(identifier, plate)
        return true
    elseif resource.name == 'esx_carkeys' and exports['esx_carkeys'] then
        exports['esx_carkeys']:RemoveVehicleKeys(identifier, plate)
        return true
    end
    
    return false
end

---@param identifier string Player identifier
---@param plate string Vehicle plate
---@return boolean
function VehicleLockManager:playerHasKeys(identifier, plate)
    if not self.enabled or not self.currentResource then
        return false
    end
    
    local resource = self.currentResource
    
    if resource.isSpecial then
        return false
    end
    
    if resource.name == 'ox_vehiclelock' and exports['ox_vehiclelock'] then
        return exports['ox_vehiclelock']:PlayerHasKeys(identifier, plate)
    elseif resource.name == 'esx_carkeys' and exports['esx_carkeys'] then
        -- esx_carkeys has no direct export, check via DB
        return true -- To be implemented with DB check
    end
    
    return false
end

---@param plate string Vehicle plate
---@param locked boolean Lock state
function VehicleLockManager:setVehicleLockState(plate, locked)
    if not self.enabled or not self.currentResource then
        return false
    end
    
    local resource = self.currentResource
    
    if resource.name == 'ox_vehiclelock' and exports['ox_vehiclelock'] then
        exports['ox_vehiclelock']:SetVehicleLockState(plate, locked)
        return true
    elseif resource.name == 'tsn_carlock' and exports['tsn_carlock'] then
        exports['tsn_carlock']:SetVehicleLockState(plate, locked)
        return true
    elseif resource.name == 'esx_carkeys' then
        -- esx_carkeys handles locking automatically
        TriggerEvent('esx_carkeys:lockVehicle', plate, locked)
        return true
    end
    
    return false
end

---@return table|nil Current resource
function VehicleLockManager:getCurrentResource()
    return self.currentResource
end

---@return boolean
function VehicleLockManager:isEnabled()
    return self.enabled and not self.locked
end

---@return string
function VehicleLockManager:getResourceName()
    if self.currentResource then
        return self.currentResource.name
    end
    return 'NONE'
end

-- Initialize on startup
Citizen.CreateThread(function()
    Wait(1000) -- Wait for resources to start
    VehicleLockManager:detectAvailableResource()
end)

return VehicleLockManager
