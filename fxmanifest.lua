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
  'server/update.lua',
  'server/main.lua'
}

client_scripts {
  'config/client.lua',
  'client/main.lua'
}

dependencies {
  'es_extended',
  'esx_vehicleshop',
  'mysql-async'
}
