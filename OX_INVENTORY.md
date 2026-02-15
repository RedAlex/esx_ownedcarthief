# 🎒 ox_inventory Compatibility

## 📋 Description

This script **automatically** detects if you use ox_inventory and registers items appropriately without manual configuration.

## ✨ Features

### Automatic Detection
- ✅ Automatic detection of ox_inventory at startup
- ✅ Automatic registration of items via ox_inventory export
- ✅ No modification needed in ox_inventory files
- ✅ Compatible with standard ESX if ox_inventory is not present

## 🚀 Installation

### Case 1: You use ox_inventory

No additional action required! The script:
1. Detects ox_inventory automatically
2. Registers items directly via export
3. Displays in console: `ox_inventory detected! Using ox_inventory for items.`

### Case 2: You use standard ESX

The script works as before:
1. Detects the absence of ox_inventory
2. Uses the classic SQL `items` table
3. Displays in console: `Using standard ESX items system.`

## 📦 Registered Items

The following 7 items are registered automatically:

| Item | Label (EN) | Poids | Description |
|------|-----------|-------|-------------|
| `hammerwirecutter` | Hammer & wire cutter | 1000g | Basic tool for breaking into vehicles |
| `unlockingtool` | Burglary tools | 1000g | Advanced burglary tools (Illegal) |
| `jammer` | Signal jammer | 500g | Signal jammer device (Illegal) |
| `alarminterface` | Alarm interface | 200g | Alarm system interface |
| `alarm1` | Basic alarm | 1500g | Basic alarm system with loudspeaker |
| `alarm2` | Emergency module | 2000g | Advanced alarm with police notification |
| `alarm3` | GPS module | 2500g | GPS tracking alarm system |

## 🔧 Item Properties (ox_inventory)

All items are registered with the following properties:
```lua
{
    label = "Item Label",     -- Multilingual label based on Config.Locale
    weight = 1000,            -- Weight in grams
    stack = true,             -- Stackable
    close = true,             -- Closes inventory after use
    description = "..."       -- Item description
}
```

## 🎨 Item Images

To add images in ox_inventory:

1. Create or download images (PNG format, 100x100px recommended)
2. Place them in: `ox_inventory/web/images/`
3. Name files exactly as the items:
   - `hammerwirecutter.png`
   - `unlockingtool.png`
   - `jammer.png`
   - `alarminterface.png`
   - `alarm1.png`
   - `alarm2.png`
   - `alarm3.png`

Items will be automatically associated with the images.

## 📝 Reference File

An `items.lua` file is provided with the resource containing the complete item definitions for reference. You can:

### Option A (Recommended): Let the script handle everything automatically
- No action needed
- The script registers items at startup

### Option B: Add manually to ox_inventory
If you prefer to manage items manually:

1. Open `ox_inventory/data/items.lua`
2. Copy the content from `esx_ownedcarthief/items.lua`
3. Add it to the return of items.lua

⚠️ **Note**: This method is not necessary if you let the script run normally.

## 📊 Console Logs

### With ox_inventory:
```
[esx_ownedcarthief] Checking database...
[esx_ownedcarthief] ox_inventory detected! Using ox_inventory for items.
[esx_ownedcarthief] Item 'hammerwirecutter' registered in ox_inventory!
[esx_ownedcarthief] Item 'unlockingtool' registered in ox_inventory!
...
[esx_ownedcarthief] Database check completed successfully!
```

### Without ox_inventory (standard ESX):
```
[esx_ownedcarthief] Checking database...
[esx_ownedcarthief] Using standard ESX items system.
[esx_ownedcarthief] Adding item 'hammerwirecutter'...
[esx_ownedcarthief] Item 'hammerwirecutter' added successfully!
...
```

## 🔄 Migration from ESX to ox_inventory

If you're migrating from standard ESX to ox_inventory:

1. ✅ Install ox_inventory
2. ✅ Restart your server
3. ✅ Items will be automatically registered in ox_inventory
4. ℹ️ Old items in the SQL table will not be deleted but will no longer be used

## ⚙️ Technical Configuration

### Detection Code
```lua
local useOxInventory = GetResourceState('ox_inventory') == 'started'
```

The script checks the state of ox_inventory resource:
- `'started'` → Uses ox_inventory
- Other state → Uses standard ESX

### Item Registration
```lua
exports.ox_inventory:RegisterItem(item_name, {
    label = item_label,
    weight = item_weight,
    stack = true,
    close = true,
    description = item_description
})
```

## ❓ FAQ

**Q: Do I need to modify anything in ox_inventory?**  
A: No, the script handles everything automatically.

**Q: Will items be duplicated if I add them manually?**  
A: The script uses pcall to avoid errors if an item already exists. No duplication issues.

**Q: Are labels multilingual with ox_inventory?**  
A: Yes, labels use the language defined in `Config.Locale`.

**Q: What happens if I add ox_inventory after using ESX?**  
A: Simply restart the server. The script will detect ox_inventory and use the new method.

**Q: Are item weights customizable?**  
A: Yes, modify the values in the `addItemsToOxInventory` function in `server/main.lua` file.

**Q: Can I disable auto-detection?**  
A: You can force ESX usage by commenting out the detection line, but it's not recommended.

## 🛡️ ox_inventory Advantages

- 🎯 Modern and intuitive interface
- 📊 Item weight management
- 🎨 Custom image support
- 🔒 Slot system
- 📦 Better inventory organization
- ⚡ Optimized performance

## 🔧 Troubleshooting

**Problem**: Items don't appear in ox_inventory  
**Solution**: 
- Verify that ox_inventory is started: `ensure ox_inventory` in server.cfg
- Check console logs for errors
- Make sure esx_ownedcarthief starts AFTER ox_inventory

**Problem**: Error "attempt to call a nil value (field 'RegisterItem')"  
**Solution**: 
- ox_inventory is not properly installed or configured
- Update ox_inventory to the latest version

**Problem**: Images don't display  
**Solution**: 
- Verify that PNG files are in `ox_inventory/web/images/`
- File names must match exactly the item names
- Restart ox_inventory after adding images

## 📞 Support

For ox_inventory specific issues:
- [ox_inventory Documentation](https://overextended.dev/ox_inventory)
- [ox_inventory GitHub](https://github.com/overextended/ox_inventory)

---
**Created by:** RedAlex & EagleOnee  
**ox_inventory compatibility added:** 2026
