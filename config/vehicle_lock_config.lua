-- Configuration of the Lock Resource Integration System
-- This file configures how esx_ownedcarthief integrates with different resources

Config.VehicleLockIntegration = {
    -- ============================================================
    -- GENERAL CONFIGURATION
    -- ============================================================
    
    -- Enable automatic integration system
    Enabled = true,
    
    -- Resource detection priority order
    -- 1 = Highest priority (tested first)
    -- Only one resource will be used
    ResourcePriority = {
        'ox_vehiclelock',      -- Priority 1: Modern, best
        'esx_carkeys',         -- Priority 2: ESX native, excellent
        'esx_lockpick',        -- Priority 3: Integrated lockpicking
        'tsn_carlock',         -- Priority 4: Very detailed
        'vms_carlock',         -- Priority 5: Flexible
        'bd_carlock',          -- Priority 6: Simple
        'esx_vehiclelock',     -- Priority 7: Basic
    },
    
    -- Detailed logs (for debug)
    DebugMode = false,
    
    -- ============================================================
    -- BEHAVIOR WHEN RESOURCE IS MISSING
    -- ============================================================
    
    -- If no resource is detected
    FallbackBehavior = {
        -- Are all vehicles accessible? (true = yes, false = locked)
        AllVehiclesAccessible = true,
        
        -- Show a warning
        ShowWarning = true,
        
        -- Disable systems that depend on locking
        DisableLockpick = false,  -- Lockpicking still possible
        DisableAlarm = false,     -- Alarm still possible
    },
    
    -- ============================================================
    -- RESOURCE-SPECIFIC CONFIGURATION
    -- ============================================================
    
    ResourceConfigs = {
        -- ox_vehiclelock configuration
        ox_vehiclelock = {
            enabled = true,
            features = {
                GiveKeys = true,
                RemoveKeys = true,
                CheckKeys = true,
                SetLockState = true,
                Alarm = true,
                MultiDoors = true,
            }
        },
        
        -- esx_carkeys configuration
        esx_carkeys = {
            enabled = true,
            features = {
                GiveKeys = true,
                RemoveKeys = true,
                CheckKeys = true,
                SetLockState = false,  -- Automatic without keys
                Alarm = true,
                MultiDoors = false,
            }
        },
        
        -- esx_lockpick configuration
        esx_lockpick = {
            enabled = true,
            isLockpickSystem = true,  -- Special lockpicking system
            features = {
                GiveKeys = false,      -- No direct management
                RemoveKeys = false,
                Lockpick = true,
                MiniGame = true,
                ItemManagement = true,
            }
        },
        
        -- tsn_carlock configuration
        tsn_carlock = {
            enabled = true,
            features = {
                GiveKeys = false,
                RemoveKeys = false,
                SetLockState = true,
                Alarm = true,
                Animations = true,
                MultiDoors = true,
                PinCode = true,
            }
        },
        
        -- vms_carlock configuration
        vms_carlock = {
            enabled = true,
            isClientSide = true,      -- Essentially client-side
            features = {
                GiveKeys = false,
                RemoveKeys = false,
                SetLockState = true,
                Animations = true,
                Notifications = true,
                MultiDoors = true,
            }
        },
        
        -- bd_carlock configuration
        bd_carlock = {
            enabled = true,
            features = {
                GiveKeys = false,
                RemoveKeys = false,
                SetLockState = true,
                Simple = true,
            }
        },
        
        -- esx_vehiclelock configuration
        esx_vehiclelock = {
            enabled = true,
            features = {
                GiveKeys = false,
                RemoveKeys = false,
                SetLockState = true,
                Basic = true,
            }
        }
    },
    
    -- ============================================================
    -- INTEGRATION WITH esx_ownedcarthief SYSTEMS
    -- ============================================================
    
    -- Systems that use locking
    Systems = {
        -- Vehicle lockpicking
        Lockpick = {
            enabled = true,
            requireKeys = false,    -- Lockpicking can give keys
            triggerAlarm = true,    -- Trigger alarm on failure
        },
        
        -- Alarm system
        Alarm = {
            enabled = true,
            triggerOnUnauthorizedAccess = true,
            notifyPolice = true,
            distance = 100.0,
        },
        
        -- Key management
        Keys = {
            enabled = true,
            giveOnPurchase = true,        -- Give keys on purchase
            giveOnLockpick = true,        -- Give keys on lockpicking
            removeOnSeizure = true,       -- Remove on seizure
            transferOnResale = true,      -- Transfer on resale
        },
        
        -- Pawnshop (resale of stolen vehicles)
        Pawnshop = {
            enabled = true,
            requiresValidKeys = false,   -- Shop can resell without keys
            keepsKeys = false,           -- Shop does not keep keys
        }
    },
    
    -- ============================================================
    -- ADVANCED OPTIONS
    -- ============================================================
    
    Advanced = {
        -- Auto-restart module if a resource loads late
        AllowReload = true,
        
        -- Periodically check if a resource has started
        PeriodicCheck = true,
        CheckInterval = 60000, -- 1 minute
        
        -- Allow admins to manually force a resource
        AdminOverride = true,
        
        -- Save key transfer history in DB
        LogKeyTransfers = true,
        LogAlarmTriggers = true,
    }
}

-- ============================================================
-- INFORMATION MESSAGES
-- ============================================================

print("^2[esx_ownedcarthief] ^7Integration configuration loaded")
print("^3[esx_ownedcarthief] ^7Supported resources:")
for i, resource in ipairs(Config.VehicleLockIntegration.ResourcePriority) do
    print("  " .. i .. ". " .. resource)
end
