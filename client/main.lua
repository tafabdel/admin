local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local isMenuOpen = false

-- Function to open the admin menu
local function OpenAdminMenu()
    if isMenuOpen then return end
    QBCore.Functions.TriggerCallback('qb-admin:server:getrank', function(result)
        if result then
            isMenuOpen = true
            SetNuiFocus(true, true)
            SendNUIMessage({
                type = "openAdminPanel"
            })
            UpdatePlayerList()
            UpdateAdminOptions()
        else
            QBCore.Functions.Notify("You don't have permission to open the admin menu.", "error")
        end
    end)
end

-- Function to close the admin menu
local function CloseAdminMenu()
    if not isMenuOpen then return end
    isMenuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "closeAdminPanel"
    })
end

-- Function to update the player list
local function UpdatePlayerList()
    QBCore.Functions.TriggerCallback('qb-admin:server:getplayers', function(players)
        SendNUIMessage({
            type = "updatePlayerList",
            players = players
        })
    end)
end

-- Function to update admin options
local function UpdateAdminOptions()
    local options = {
        playerActions = {
            {id = "kill", label = "Kill"},
            {id = "revive", label = "Revive"},
            {id = "freeze", label = "Freeze"},
            {id = "spectate", label = "Spectate"},
            {id = "goto", label = "Go To"},
            {id = "bring", label = "Bring"},
            {id = "intovehicle", label = "Into Vehicle"},
            {id = "kick", label = "Kick"},
            {id = "ban", label = "Ban"},
        },
        serverManagement = {
            {id = "weather", label = "Set Weather"},
            {id = "time", label = "Set Time"},
            {id = "announce", label = "Make Announcement"},
        },
        vehicleOptions = {
            {id = "spawnvehicle", label = "Spawn Vehicle"},
            {id = "deletevehicle", label = "Delete Vehicle"},
            {id = "fixvehicle", label = "Fix Vehicle"},
        },
        devTools = {
            {id = "noclip", label = "Toggle NoClip"},
            {id = "coords", label = "Copy Coords"},
            {id = "givemoney", label = "Give Money"},
        }
    }
    SendNUIMessage({
        type = "updateAdminOptions",
        options = options
    })
end

-- NUI Callback for performing actions
RegisterNUICallback('performAction', function(data, cb)
    local action = data.action
    local playerId = data.playerId

    if action == "kill" then
        TriggerServerEvent("qb-admin:server:kill", {id = playerId})
    elseif action == "revive" then
        TriggerServerEvent("qb-admin:server:revive", {id = playerId})
    elseif action == "freeze" then
        TriggerServerEvent("qb-admin:server:freeze", {id = playerId})
    elseif action == "spectate" then
        TriggerServerEvent("qb-admin:server:spectate", {id = playerId})
    elseif action == "goto" then
        TriggerServerEvent("qb-admin:server:goto", {id = playerId})
    elseif action == "bring" then
        TriggerServerEvent("qb-admin:server:bring", {id = playerId})
    elseif action == "intovehicle" then
        TriggerServerEvent("qb-admin:server:intovehicle", {id = playerId})
    elseif action == "kick" then
        local reason = exports['qb-input']:ShowInput({
            header = "Kick Player",
            submitText = "Confirm",
            inputs = {
                {
                    type = 'text',
                    name = 'reason',
                    text = 'Reason',
                    isRequired = true
                }
            }
        })
        if reason then
            TriggerServerEvent("qb-admin:server:kick", {id = playerId}, reason.reason)
        end
    elseif action == "ban" then
        local input = exports['qb-input']:ShowInput({
            header = "Ban Player",
            submitText = "Confirm",
            inputs = {
                {
                    type = 'number',
                    name = 'time',
                    text = 'Ban Duration (hours)',
                    isRequired = true
                },
                {
                    type = 'text',
                    name = 'reason',
                    text = 'Reason',
                    isRequired = true
                }
            }
        })
        if input then
            TriggerServerEvent("qb-admin:server:ban", {id = playerId}, input.time * 3600, input.reason)
        end
    elseif action == "weather" then
        local input = exports['qb-input']:ShowInput({
            header = "Set Weather",
            submitText = "Confirm",
            inputs = {
                {
                    type = 'text',
                    name = 'weather',
                    text = 'Weather Type',
                    isRequired = true
                }
            }
        })
        if input then
            TriggerServerEvent("qb-admin:server:setWeather", input.weather)
        end
    elseif action == "time" then
        local input = exports['qb-input']:ShowInput({
            header = "Set Time",
            submitText = "Confirm",
            inputs = {
                {
                    type = 'number',
                    name = 'hour',
                    text = 'Hour (0-23)',
                    isRequired = true
                },
                {
                    type = 'number',
                    name = 'minute',
                    text = 'Minute (0-59)',
                    isRequired = true
                }
            }
        })
        if input then
            TriggerServerEvent("qb-admin:server:setTime", input.hour, input.minute)
        end
    elseif action == "announce" then
        local input = exports['qb-input']:ShowInput({
            header = "Make Announcement",
            submitText = "Confirm",
            inputs = {
                {
                    type = 'text',
                    name = 'message',
                    text = 'Announcement Message',
                    isRequired = true
                }
            }
        })
        if input then
            TriggerServerEvent("qb-admin:server:announce", input.message)
        end
    elseif action == "spawnvehicle" then
        local input = exports['qb-input']:ShowInput({
            header = "Spawn Vehicle",
            submitText = "Confirm",
            inputs = {
                {
                    type = 'text',
                    name = 'model',
                    text = 'Vehicle Model',
                    isRequired = true
                }
            }
        })
        if input then
            TriggerServerEvent("qb-admin:server:spawnVehicle", input.model)
        end
    elseif action == "deletevehicle" then
        TriggerServerEvent("qb-admin:server:deleteVehicle")
    elseif action == "fixvehicle" then
        TriggerServerEvent("qb-admin:server:fixVehicle")
    elseif action == "noclip" then
        TriggerServerEvent("qb-admin:server:toggleNoclip")
    elseif action == "coords" then
        local coords = GetEntityCoords(PlayerPedId())
        local heading = GetEntityHeading(PlayerPedId())
        local coordstring = string.format("vector4(%f, %f, %f, %f)", coords.x, coords.y, coords.z, heading)
        TriggerServerEvent("qb-admin:server:copyToClipboard", coordstring)
    elseif action == "givemoney" then
        local input = exports['qb-input']:ShowInput({
            header = "Give Money",
            submitText = "Confirm",
            inputs = {
                {
                    type = 'number',
                    name = 'amount',
                    text = 'Amount',
                    isRequired = true
                },
                {
                    type = 'select',
                    name = 'type',
                    text = 'Money Type',
                    options = {
                        { value = "cash", text = "Cash" },
                        { value = "bank", text = "Bank" }
                    }
                }
            }
        })
        if input then
            local amount = tonumber(input.amount)
            local moneytype = input.type
            if amount and moneytype then
                TriggerServerEvent("qb-admin:server:giveMoney", playerId, amount, moneytype)
            end
        end
    end

    cb('ok')
end)

-- NUI Callback for closing the admin panel
RegisterNUICallback('closeAdminPanel', function(_, cb)
    CloseAdminMenu()
    cb('ok')
end)

-- Event handler to open the admin menu
RegisterNetEvent('qb-adminmenu:client:openMenu', function()
    OpenAdminMenu()
end)

-- Command to open the admin menu
RegisterCommand('adminmenu', function()
    OpenAdminMenu()
end, false)

-- Event handler for when the player loads
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

-- Event handler for when player data updates
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
end)

-- Close menu when resource stops
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        CloseAdminMenu()
    end
end)
