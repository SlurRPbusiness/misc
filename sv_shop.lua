RegisterServerEvent('royal_shops:buy')
AddEventHandler('royal_shops:buy', function(item, prezzo, society, quantity, label)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.job.name == society or xPlayer.job2.name == society then
	    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..society, function(account)
            local price = prezzo * quantity
            if account.money >= price then
                account.removeMoney(price)
                if item == 'bombolaossigeno' then
                    local metadata = {}
                    metadata.count = 10
                    exports.ox_inventory:AddItem(xPlayer.source, 'bombolaossigeno', 1, metadata)
                else
                    xPlayer.addInventoryItem(item, quantity)
                end
                TriggerClientEvent('esx:showNotification', _source, "Hai comprato correttamente " ..quantity.. "x " ..label)
                local webhook = 'https://discord.com/api/webhooks/1055276777808855090/2J82LCbxit_vvn98YTN_5Gxr2YoE3Rgrg14wYCY4xRBYU07nJBjhz9v2oykLw4og7F_-'
                local message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** ha comprato **' ..quantity.. 'x ' ..item.. '** dalla società: **' ..society.. '**'
                ESX.Log(webhook, message)
            else
                TriggerClientEvent('esx:showNotification', _source, "Non ci sono abbastanza soldi in società per acquistare.")
            end
	    end)
    else
        exports['vestiti_nuovi']:triggerBan(source, 'royal_shops:buy')
        return
    end
end)