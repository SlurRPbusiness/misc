ESX.RegisterServerCallback('royal:check:lavori', function(source,cb)
    local count = 0
    local xPlayers = ESX.GetExtendedPlayers()
    for _, xPlayer in pairs(xPlayers) do
        local gi = ESX.GetPlayerFromId(xPlayer.source)
        if gi.job.name == 'vanilla' or gi.job.name == 'bellevue' or gi.job.name == 'bronxbar' or gi.job.name == 'bahamas' or gi.job.name == 'cockatoos' or gi.job.name == 'perla' or gi.job.name == 'nikkibeach' or gi.job.name == 'koi' or gi.job.name == 'moore' or gi.job.name == 'crastenburg'  then
            count = count + 1
        end
    end
    if count >= 4 then
        print('Il conteggio totale di dipendenti nei locali è ' ..count)
        cb(true)
    else
        count = 0
        cb(false)
    end
end)