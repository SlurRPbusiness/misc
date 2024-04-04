ESX = exports.es_extended:getSharedObject()

for k,v in pairs(Config.Smoking.smokable_things) do
    ESX.RegisterUsableItem(k, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getInventoryItem('accendino').count >= 1 then
            TriggerClientEvent('royal_smoking:StartSmoking', source, k)
            xPlayer.removeInventoryItem(k, 1)
        else
            xPlayer.showNotification('Non hai un accendino con te!')
        end
    end)
end

RegisterServerEvent('royal_smoking:SyncEffect', function(smokable_thing, effect, net)
    TriggerClientEvent('royal_smoking:SyncEffect', -1, smokable_thing, effect, net)
end)