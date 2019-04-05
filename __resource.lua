resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'esx_ownedcarthief'

version '1.0.1'

server_scripts {
  '@async/async.lua',
  '@mysql-async/lib/MySQL.lua',
  '@es_extended/locale.lua',
  'locales/fr.lua',
  'locales/en.lua',
  'config.lua',
  'server/main.lua'
}

client_scripts {
  '@es_extended/locale.lua',
  'locales/fr.lua',
  'locales/en.lua',
  'config.lua',
  'client/main.lua'
}

dependencies {
  'es_extended',
  'esx_vehicleshop'
}
