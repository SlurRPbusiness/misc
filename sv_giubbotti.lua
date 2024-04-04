ESX.RegisterServerCallback('cb:giubb', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem('cartacredito').count >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

local webhook = 'https://discord.com/api/webhooks/1046499045910265876/LvcuFPSg5M-j6IBSIWFXFpJN_UrrgcTRcmgO9E3rLDJraS29iCO7Aapb_E151pLOIM_J'

RegisterNetEvent('compra1')
AddEventHandler('compra1', function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getAccount('bank').money >= 500 then
        xPlayer.removeAccountMoney('bank', 500)
        TriggerClientEvent("giubbottoleggero", source)
        TriggerClientEvent('esx:showNotification', source, 'Hai pagato usando la carta di credito!')
        local message = 'Il giocatore **' ..GetPlayerName(_source).. ' [' ..xPlayer.identifier.. ']** ha acquistato un giubbotto leggero!'
        ESX.Log(webhook, message)
    else
        TriggerClientEvent('esx:showNotification', source, 'Non hai abbastanza soldi!')
    end
end)

RegisterNetEvent('compra2')
AddEventHandler('compra2', function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
            if xPlayer.getAccount('bank').money >= 1000 then
                xPlayer.removeAccountMoney('bank', 1000)
                TriggerClientEvent("giubbottomedio", source)
                TriggerClientEvent('esx:showNotification', source, 'Hai pagato usando la carta di credito!')
                local message = 'Il giocatore **' ..GetPlayerName(_source).. ' [' ..xPlayer.identifier.. ']** ha acquistato un giubbotto medio!'
                ESX.Log(webhook, message)
            else
                TriggerClientEvent('esx:showNotification', source, 'Non hai abbastanza soldi!')
            end
end)

RegisterNetEvent('compra3')
AddEventHandler('compra3', function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
            if xPlayer.getAccount('bank').money >= 2000 then
                xPlayer.removeAccountMoney('bank', 2000)
                TriggerClientEvent("giubbottopesante", source)
                TriggerClientEvent('esx:showNotification', source, 'Hai pagato usando la carta di credito!')
                local message = 'Il giocatore **' ..GetPlayerName(_source).. ' [' ..xPlayer.identifier.. ']** ha acquistato un giubbotto pesante!'
                ESX.Log(webhook, message)
            else
                TriggerClientEvent('esx:showNotification', source, 'Non hai abbastanza soldi!')
            end
end)

----- COMANDO GIUBB

RegisterCommand('giveg', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local gruppo = xPlayer.getGroup()

    if gruppo == 'admin' or gruppo == 'superadmin' then
        if args[1] ~= nil then
            local xT = ESX.GetPlayerFromId(args[1])
            if xT then
                local targetplayer = tonumber(args[1])
                local xT = ESX.GetPlayerFromId(targetplayer)
                TriggerClientEvent('giubbottogg', targetplayer)
                TriggerClientEvent('esx:showNotification', targetplayer, 'Hai ricevuto un giubbotto!')
                xPlayer.showNotification('Hai givvato un giubbotto al giocatore ' ..GetPlayerName(targetplayer))
                local webhooks = 'https://discord.com/api/webhooks/1046499505165570158/Ehf115dKSlOKjBXVUi5vGjPDzgcKI4alnUnHgc_75rsvCx59S5VjiDYnAtnINhPMniBx'
                local message = 'Lo staffer **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** ha givvato un giubbotto al giocatore **' ..GetPlayerName(targetplayer).. ' [' ..xT.identifier.. ']**'
                ESX.Log(webhooks, message)
            else
                TriggerClientEvent('esx:showNotification', source, "Non c'è nessun giocatore online con questo ID!")
            end
        else
            TriggerClientEvent('giubbottogg', source)
            xPlayer.showNotification('Ti sei givvato un giubbotto!')
            local webhooks = 'https://discord.com/api/webhooks/1046499505165570158/Ehf115dKSlOKjBXVUi5vGjPDzgcKI4alnUnHgc_75rsvCx59S5VjiDYnAtnINhPMniBx'
            local message = 'Lo staffer **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** ha givvato un giubbotto a se stesso.'
            ESX.Log(webhooks, message)
        end
    end

end)