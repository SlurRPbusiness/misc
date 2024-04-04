local blips = {}

ESX.RegisterUsableItem('bodycamlspd', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer.job.name == 'police' or xPlayer.job.name == 'sceriffo' or xPlayer.job.name == 'fbi' or xPlayer.job2.name == 'dea' or xPlayer.job.name == 'governo' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'royalfly' then
        local name = xPlayer.getName()
        TriggerClientEvent('royal_bodycam:controls', playerId, name)
    end
end)

RegisterServerEvent('royal_bodycam:bodycamlspd')
AddEventHandler('royal_bodycam:bodycamlspd', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == 'police' or xPlayer.job.name == 'sceriffo' or xPlayer.job.name == 'fbi' or xPlayer.job2.name == 'dea' or xPlayer.job.name == 'governo' or xPlayer.job.name == 'cia' or xPlayer.job.name == 'royalfly' then
        local name = xPlayer.getName()
        TriggerClientEvent('royal_bodycam:controls', source, name)
    end
end)
RegisterServerEvent('royal_bodycam:bodycamlspd2')
AddEventHandler('royal_bodycam:bodycamlspd2', function()
    local xPlayer = ESX.GetPlayerFromId(source)
        local name = xPlayer.getName()
        TriggerClientEvent('royal_bodycam:controls2', source, name)
end)


ESX.RegisterUsableItem('gopro', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = xPlayer.getName()
    TriggerClientEvent('royal_bodycam:controls2', source, name)
end)


ESX.RegisterUsableItem('mic', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = xPlayer.getName()
    TriggerClientEvent('royal_bodycam:controls2', source, name, 'microfono')
end)


ESX.RegisterServerCallback('royal_bodycam:getTempo', function(src, cb)
    local t = os.date ("*t")
    tempo = t.day..'/'..t.month..'/'..t.year..' '..t.hour..':'..t.min
    cb(tempo)
end)
