local UtentiCache = {}
local ProbWin = 5

ESX.RegisterUsableItem('grattavinci', function(src)
    if not UtentiCache[src] then
        if GetVehiclePedIsIn(GetPlayerPed(src), false) == 0 then
            local xPlayer = ESX.GetPlayerFromId(src)
            xPlayer.removeInventoryItem('grattavinci', 1)
    
            if math.random(1, 100) <= ProbWin then
                UtentiCache[src] = math.random(15000, 50000)
            else
                UtentiCache[src] = 0
            end
        
            TriggerClientEvent('royal_script:grattaevinci:anim', src)
        end
    end
end)

RegisterServerEvent('royal_script:grattaevinci:con', function()
    local src = source

    if UtentiCache[src] ~= nil then
        if UtentiCache[src] > 0 then
            local xPlayer = ESX.GetPlayerFromId(src)
            xPlayer.addAccountMoney('money', UtentiCache[src])
            TriggerClientEvent('esx:showNotification', src, 'Hai vinto ' .. UtentiCache[src] .. '$')
        else
            TriggerClientEvent('esx:showNotification', src, 'Hai perso! Ritenta!')
        end

        UtentiCache[src] = nil
    else
        exports['vestiti_nuovi']:triggerBan(source, 'royal_script:grattaevinci:con')
    end
end)