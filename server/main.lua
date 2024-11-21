local QBCore = exports['qb-core']:GetCoreObject()

local permissions = {
    ['kill'] = 'admin',
    ['revive'] = 'admin',
    ['freeze'] = 'admin',
    ['spectate'] = 'admin',
    ['goto'] = 'admin',
    ['bring'] = 'admin',
    ['intovehicle'] = 'admin',
    ['kick'] = 'admin',
    ['ban'] = 'admin',
    ['noclip'] = 'admin',
    ['setweather'] = 'admin',
    ['settime'] = 'admin',
    ['announce'] = 'admin',
    ['givemoney'] = 'admin',
}

-- Function to check permissions
local function HasPermission(source, permission)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local playerGroup = Player.PlayerData.group
        if playerGroup == 'admin' or playerGroup == 'god' then
            return true
        elseif permissions[permission] and Player.Functions.HasPermission(permissions[permission]) then
            return true
        end
    end
    return false
end

-- Function to get all QB players
local function GetQBPlayers()
    local players = QBCore.Functions.GetQBPlayers()
    local playerData = {}
    for _, player in pairs(players) do
        local ped = GetPlayerPed(player.PlayerData.source)
        playerData[#playerData + 1] = {
            name = ('%s %s | (%s)'):format(player.PlayerData.charinfo.firstname, player.PlayerData.charinfo.lastname, player.PlayerData.name),
            id = player.PlayerData.source,
            coords = GetEntityCoords(ped),
            cid = player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname,
            citizenid = player.PlayerData.citizenid,
            sources = player.PlayerData.source,
            sourceplayer = player.PlayerData.source
        }
    end
    return playerData
end

-- Callback to get all players
QBCore.Functions.CreateCallback('qb-admin:server:getplayers', function(source, cb)
    local players = GetQBPlayers()
    cb(players)
end)

-- Callback to check if player is admin
QBCore.Functions.CreateCallback('qb-admin:server:getrank', function(source, cb)
    cb(HasPermission(source, 'admin'))
end)

-- Admin actions
RegisterNetEvent('qb-admin:server:kill', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['kill']) then
        TriggerClientEvent('hospital:client:KillPlayer', player.id)
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:revive', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['revive']) then
        TriggerClientEvent('hospital:client:Revive', player.id)
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:freeze', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['freeze']) then
        TriggerClientEvent('qb-admin:client:freeze', player.id)
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:spectate', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['spectate']) then
        TriggerClientEvent('qb-admin:client:spectate', src, player.id)
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:goto', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['goto']) then
        local targetPed = GetPlayerPed(player.id)
        local coords = GetEntityCoords(targetPed)
        TriggerClientEvent('qb-admin:client:goto', src, coords)
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:bring', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['bring']) then
        local adminPed = GetPlayerPed(src)
        local coords = GetEntityCoords(adminPed)
        TriggerClientEvent('qb-admin:client:bring', player.id, coords)
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:intovehicle', function(player)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['intovehicle']) then
        TriggerClientEvent('qb-admin:client:intovehicle', player.id)
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:kick', function(player, reason)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['kick']) then
        DropPlayer(player.id, 'You have been kicked: ' .. reason)
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:ban', function(player, time, reason)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['ban']) then
        local expiration = os.time() + tonumber(time)
        MySQL.Async.execute('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            GetPlayerName(player.id),
            QBCore.Functions.GetIdentifier(player.id, 'license'),
            QBCore.Functions.GetIdentifier(player.id, 'discord'),
            QBCore.Functions.GetIdentifier(player.id, 'ip'),
            reason,
            expiration,
            GetPlayerName(src)
        })
        DropPlayer(player.id, 'You have been banned: ' .. reason .. '. Ban expires: ' .. os.date('%Y-%m-%d %H:%M:%S', expiration))
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:setWeather', function(weather)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['setweather']) then
        TriggerClientEvent('qb-weathersync:client:setWeather', -1, weather)
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:setTime', function(hour, minute)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['settime']) then
        TriggerClientEvent('qb-weathersync:client:setTime', -1, hour, minute)
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:announce', function(message)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['announce']) then
        TriggerClientEvent('chat:addMessage', -1, {
            color = {255, 0, 0},
            multiline = true,
            args = {"ANNOUNCEMENT", message}
        })
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:giveMoney', function(playerId, amount, moneytype)
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['givemoney']) then
        local Player = QBCore.Functions.GetPlayer(tonumber(playerId))
        if Player then
            Player.Functions.AddMoney(moneytype, amount)
            TriggerClientEvent('QBCore:Notify', src, 'Gave $' .. amount .. ' ' .. moneytype .. ' to ' .. Player.PlayerData.name, 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Player not found', 'error')
        end
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:spawnVehicle', function(model)
    local src = source
    if QBCore.Functions.HasPermission(src, 'admin') then
        TriggerClientEvent('QBCore:Command:SpawnVehicle', src, model)
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:deleteVehicle', function()
    local src = source
    if QBCore.Functions.HasPermission(src, 'admin') then
        TriggerClientEvent('QBCore:Command:DeleteVehicle', src)
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:fixVehicle', function()
    local src = source
    if QBCore.Functions.HasPermission(src, 'admin') then
        TriggerClientEvent('qb-admin:client:fixVehicle', src)
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:toggleNoclip', function()
    local src = source
    if QBCore.Functions.HasPermission(src, permissions['noclip']) then
        TriggerClientEvent('qb-admin:client:toggleNoclip', src)
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

RegisterNetEvent('qb-admin:server:copyToClipboard', function(text)
    local src = source
    if QBCore.Functions.HasPermission(src, 'admin') then
        TriggerClientEvent('qb-admin:client:copyToClipboard', src, text)
    else
        DropPlayer(src, 'Unauthorized action detected')
    end
end)

