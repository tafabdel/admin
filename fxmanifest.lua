fx_version 'cerulean'
game 'gta5'

description 'QB-AdminMenu'
version '1.0.0'

ui_page 'html/panel.html'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua', -- add other language files here
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- if you're using MySQL
    'server/main.lua'
}

files {
    'html/panel.html',
    'html/panel.css',
    'html/panel.js'
}

dependency 'qb-core'

lua54 'yes'

