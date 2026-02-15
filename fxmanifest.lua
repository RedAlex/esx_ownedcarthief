fx_version 'cerulean'
game 'gta5'

description 'esx_ownedcarthief'

version '1.1.0'

shared_scripts {
  '@es_extended/locale.lua',
  'locales/*.lua',
  'config/shared.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'config/server.lua',
  'server/vehicle_lock_manager.lua',
  'server/update.lua',
  'server/main.lua',
  'server/vehicle_lock_integration.lua'
}

client_scripts {
  'config/client.lua',
  'client/main.lua',
  'client/vehicle_lock_integration.lua'
}

dependencies {
  'es_extended',
  'esx_vehicleshop',
  'mysql-async'
}
