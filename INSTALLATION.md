# 🔧 Automatic SQL Installation System

## 📋 Description

This script features an **automatic installation system** for the database that eliminates the need to manually import SQL files.

## ✨ Features

The system automatically checks and creates at startup:

### Tables and Columns
- ✅ Adding `security` column to `owned_vehicles`
- ✅ Adding `alarmactive` column to `owned_vehicles`
- ✅ Creating `pawnshop_vehicles` table
- ✅ Inserting necessary items into `items` table

### Supported Languages
- 🇫🇷 French (`fr`)
- 🇬🇧 English (`en`)
- 🇧🇷 Brazilian Portuguese (`br`)
- 🇩🇪 German (`de`)

## 🚀 Installation

### Step 1: Configuration
Open `config.lua` and set your language:
```lua
Config.Locale = 'fr' -- Choose: 'fr', 'en', 'br' or 'de'
```

### Step 2: Startup
Add the resource to your `server.cfg`:
```
start esx_ownedcarthief
```

### Step 3: That's it! 🎉
The script handles the rest automatically on first startup.

### 🎒 Bonus: ox_inventory Compatibility
If you use **ox_inventory**, the script will automatically detect it and register items via ox_inventory instead of the SQL table. No additional configuration needed!

👉 See [OX_INVENTORY.md](OX_INVENTORY.md) for more details.

## 🔍 How Does It Work?

At server startup, the script:

1. **Reads the configured language** from `config.lua`
2. **Checks the existence** of each column/table
3. **Creates only what's missing** (no duplication)
4. **Uses appropriate labels** based on the selected language
5. **Displays logs** in the console to track progress

## 📝 Console Logs

You will see messages like:
```
[esx_ownedcarthief] Checking database...
[esx_ownedcarthief] Adding 'security' column to owned_vehicles table...
[esx_ownedcarthief] 'security' column added successfully!
[esx_ownedcarthief] Item 'hammerwirecutter' added successfully!
[esx_ownedcarthief] Database check complete!
```

## ⚙️ Created Data Structure

### Columns added to `owned_vehicles`
```sql
security INT(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system level'
alarmactive INT(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system state'
```

### Table `pawnshop_vehicles`
```sql
CREATE TABLE pawnshop_vehicles (
    owner varchar(40) DEFAULT NULL,
    security int(1) NOT NULL DEFAULT '0',
    plate varchar(12) NOT NULL,
    vehicle longtext,
    price int(15) NOT NULL,
    expiration int(15) NOT NULL,
    PRIMARY KEY (plate)
)
```

### Items added (with labels based on language)
- `hammerwirecutter`
- `unlockingtool`
- `jammer`
- `alarminterface`
- `alarm1`
- `alarm2`
- `alarm3`

## 🛡️ Security

- ✅ Verification before each creation (no duplication)
- ✅ No overwriting existing data
- ✅ Compatible with previous manual installations
- ✅ Can be restarted without issue

## ❓ FAQ

**Q: What happens if I've already imported SQL files manually?**  
A: No problem! The system detects what already exists and only creates what's missing.

**Q: Can I change language after installation?**  
A: Yes, but only **new** items will be created with the new labels. Existing items will keep their old labels. To update all labels, you'll need to manually modify them in the database.

**Q: Are .sql files still needed?**  
A: No, they are kept for reference only. The system has replaced them.

**Q: How to verify installation succeeded?**  
A: Check the console logs or verify your database to confirm the presence of columns/tables.

## 🔧 Troubleshooting

**Problem:** Tables are not being created  
**Solution:** Verify that:
- MySQL-Async is properly installed and functional
- Your MySQL user has CREATE and ALTER permissions
- The `essentialmode` database exists

**Problem:** Labels are not in the correct language  
**Solution:** 
- Check `Config.Locale` in config.lua
- Supported languages are: 'fr', 'en', 'br', 'de'

## 📞 Support

For any questions or issues:
- First check the console logs
- Make sure you have the required resources installed
- See the main README for more information

---
**Created by:** RedAlex & EagleOnee  
**Automatic installation system added:** 2026
