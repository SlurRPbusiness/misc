RegisterCommand('setped', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if tonumber(args[1]) and args[2] then 
        local xT = ESX.GetPlayerFromId(args[1])
        if xT then 
            if xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'mod' then 
                MySQL.update('UPDATE users SET skin = @skin WHERE identifier = @identifier', {['@skin'] = '{"model":"'..args[2]..'"}', ['@identifier'] = xT.identifier}, function(affectedRows)
                    if affectedRows then
                        TriggerClientEvent('peds:relog', args[1])
                        xPlayer.showNotification("Assegnato correttamente il ped " ..args[2].. ' al giocatore ' ..GetPlayerName(args[1]))
                        xT.showNotification('Hai rivevuto correttamente il ped ' ..args[2])
                        local webhook = 'https://discord.com/api/webhooks/1043544225645609022/yuAQTSJb5f5hs6P8APYalrARTXE22cixZWoLhUbuK-uVOHKkHofHy7YD_GAjt0MYN_Nd'
                        local message = 'Lo staffer **' ..GetPlayerName(source).. '** [**' ..xPlayer.identifier.. '**] ha impostato il ped **' ..args[2].. '** al giocatore **' ..GetPlayerName(args[1]).. '**'
                        ESX.Log(webhook, message)
                    end
                end)
            else
                xPlayer.showNotification("Non hai il permesso.")
            end
        else
            xPlayer.showNotification("Questo giocatore non è online")
        end
    else
        xPlayer.showNotification("Utilizza il formato /setped [id] [ped]")
    end
end)

function setPed(target, model)
    local xT = ESX.GetPlayerFromId(target)
    MySQL.update('UPDATE users SET skin = @skin WHERE identifier = @identifier', {['@skin'] = '{"model":"'..model..'"}', ['@identifier'] = xT.identifier}, function(affectedRows)
        if affectedRows then
            TriggerClientEvent('peds:relog', target)
            xT.showNotification('Hai rivevuto correttamente il ped ' ..target)
        end
    end)
end

exports('setPed', setPed)