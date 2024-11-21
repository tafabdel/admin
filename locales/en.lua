local Translations = {
    menu = {
        title = "Admin Menu",
        close = "Close",
        player_management = "Player Management",
        server_management = "Server Management",
        vehicle_options = "Vehicle Options",
        dev_tools = "Developer Tools"
    },
    actions = {
        kill = "Kill",
        revive = "Revive",
        freeze = "Freeze",
        unfreeze = "Unfreeze",
        spectate = "Spectate",
        unspectate = "Stop Spectating",
        teleport = "Teleport To",
        bring = "Bring Player",
        giveitem = "Give Item",
        ban = "Ban",
        kick = "Kick",
        setjob = "Set Job",
        noclip = "Toggle Noclip",
        godmode = "Toggle God Mode",
        spawnvehicle = "Spawn Vehicle",
        fixvehicle = "Fix Vehicle",
        deletevehicle = "Delete Vehicle",
        setweather = "Set Weather",
        settime = "Set Time",
        announce = "Make Announcement"
    },
    info = {
        received_item = "You received %{amount}x %{item}",
        player_not_online = "Player is not online",
        player_not_found = "Player not found",
        success = "Action successful",
        failed = "Action failed",
        no_permission = "You don't have permission for this action",
        usage_setjob = "Usage: /setjob [playerId] [job] [grade]",
        usage_giveitem = "Usage: /giveitem [playerId] [item] [amount]",
        usage_ban = "Usage: /ban [playerId] [duration] [reason]",
        usage_kick = "Usage: /kick [playerId] [reason]",
        usage_announce = "Usage: /announce [message]"
    },
    confirmation = {
        ban_player = "Are you sure you want to ban this player?",
        kick_player = "Are you sure you want to kick this player?",
        delete_vehicle = "Are you sure you want to delete this vehicle?"
    }
}

if GetConvar('qb_locale', 'en') == 'en' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end

