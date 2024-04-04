local lang = Languages[Config.linguaggio]

-- @desc Handle /me command
local function onMeCommand(source, args)
    local text = "" .. lang.prefix .. table.concat(args, " ") .. ""
    local nome = GetPlayerName(source)
    TriggerClientEvent('3dme:shareDisplay', -1, text, source)
    if not string.find(text, '~b~Sta perquisendo...') or not string.find(text, 'Ha passato ~r~Qualcosa') or not string.find(text, 'Ha preso') or not string.find(text, 'Ha inserito') then
        local message = "Il giocatore **" .. nome .. "** ha scritto: /me **" .. text .. "**"  
        local webhook = 'https://discord.com/api/webhooks/1044331323201945661/91VNGfG7ouAet2KWLVKddCwOLWZsY6Jh0orDTC-TGaBnxDRPpQ6IguSt_U9EyWhA5n7L'
        ESX.Log(webhook, message)
    end
end

RegisterServerEvent('ExecuteMePerNomi', function(text)
    local xPlayer = ESX.GetPlayerFromId(source)
    local text = "" .. lang.prefix .. table.concat(args, " ") .. ""
    local nome = GetPlayerName(source)
    TriggerClientEvent('3dme:shareDisplay', -1, text, xPlayer.source)
end)

RegisterCommand(lang.commandName, onMeCommand)

RegisterNetEvent('3dme:showMic', function(testo)
    TriggerClientEvent('3dme:showMicClient', source, testo)
end)

RegisterNetEvent('3dme:stopMic', function()
    TriggerClientEvent('3dme:stopMicC', source, source)
end)

RegisterNetEvent('3dme:customTimeS', function(testo, x, time)
    TriggerClientEvent('3dme:customTime', x, testo, x, time)
end)