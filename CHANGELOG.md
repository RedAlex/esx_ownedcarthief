# Changelog

All notable changes to this project are documented in this file.

## [1.1.0] - 2026-02-15

### ✨ New Features

#### Automatic SQL Installation System
- **No manual setup required:** SQL files install automatically on the first server startup
- **Smart verification:** The system checks for the existence of tables and columns before creating them (no duplicates)
- **Multi-language support:** Item labels are automatically created based on the configured language
  - 🇫🇷 French (`fr`)
  - 🇬🇧 English (`en`)
  - 🇧🇷 Brazilian Portuguese (`br`)
  - 🇩🇪 German (`de`)

#### Automatic ox_inventory Compatibility
- **Auto-detection:** The script automatically detects if ox_inventory is installed
- **Dynamic registration:** Items are registered via ox_inventory exports if present
- **ESX fallback:** Uses standard ESX system if ox_inventory is not available
- **Zero configuration:** Everything is transparent to the user

### 🔄 Changes

#### Updated Dependencies
- **Before:** EssentialMode 5.0.3, Async 2.0, Esx
- **After:** 
  - es_extended (former ESX nomenclature)
  - mysql-async (or oxmysql as alternative) for database operations
- Removal of obsolete dependencies for better compatibility
- Added explicit database driver requirement

#### Documentation
- Updated README with new dependencies (including mysql-async/oxmysql)
- Added automatic SQL installation guide (INSTALLATION.md)
- Added ox_inventory compatibility guide (OX_INVENTORY.md)
- Clarified configuration instructions

#### Startup Instructions
- **Before:** `start esx_ownedcarthief`
- **After:** `ensure esx_ownedcarthief` (recommended) or `start esx_ownedcarthief`
- Improved startup robustness

### 🛠️ Technical Improvements

- **Enhanced logging:** Detailed console messages for SQL installation tracking
- **Error handling:** Better handling of cases where tables/columns already exist
- **Performance:** Installation system only creates what is missing
- **Compatibility:** Fully backward compatible with previous manual installations

### 📋 Technical Details

#### Columns Added to `owned_vehicles`
```sql
security INT(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system level'
alarmactive INT(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system state'
```

#### `pawnshop_vehicles` Table Created
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

### 🐛 Bug Fixes

- Fixed installation instructions to prevent manual errors
- Improved compatibility with modern ESX (es_extended)
- Stabilized script startup

### 📚 Documentation

- [INSTALLATION.md](INSTALLATION.md) - Complete guide for automatic SQL installation system
- [OX_INVENTORY.md](OX_INVENTORY.md) - ox_inventory compatibility guide
- [README.md](README.md) - General documentation with updated dependencies

### 🎯 Update Recommendations

If you are updating from a previous version:

1. Download the new version (1.1.0)
2. Replace your files (backup recommended)
3. Update the language in `config.lua` if necessary
4. Restart the server - automatic installation handles the rest!

**Note:** No SQL files to import manually, the system manages everything automatically.

---

## [1.0.4] - Previous Version
- Previous stable release with manual SQL installation
