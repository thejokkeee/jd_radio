fx_version 'cerulean'

game 'gta5'

author 'Jokke'
description 'Radio script for pma-voice'
version '0.0.1'

lua54 'yes'

shared_scripts{
    '@ox_lib/init.lua'
}

client_scripts{
    'client.lua',
    'config.lua'
}

server_script 'server.lua'

dependencies{
    'pma-voice',
    'ox_lib',
    'es_extended'
}
