local bedOccupying = {}

RegisterServerEvent('royal_ambulance:checkIn', function(c)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not bedOccupying[c] then
        bedOccupying[c] = true
        xPlayer.removeAccountMoney('bank', 3000)
        local data = {coord = vector3(329.35299682617, -589.49658203125, 49.122852325439), model = 'v_med_bed1', cooord = vector3(329.35299682617, -589.49658203125, 49.122852325439), h = 342.9921}
        TriggerClientEvent('royal_ambulance:SendToBed', source, c, data)
        xPlayer.showNotification('Ti sono stati accreditati 3000$ per il check in!')
    else
        xPlayer.showNotification('Il letto è occupato in questo momento!')
    end
end)

RegisterServerEvent('royal_ambulance:setBedEmpty', function(g)
    bedOccupying[g] = false
end)