AddEventHandler("playerDropped", function(reason)
    local crds = GetEntityCoords(GetPlayerPed(source))
    local id = source
    local identifier = ""
    if Config.UseSteam then
        identifier = GetPlayerIdentifier(source, 0)
    else
        identifier = GetPlayerIdentifier(source, 1)
    end
    TriggerClientEvent("pixel_anticl", -1, id, crds, identifier, reason)
end)

RegisterServerEvent("vario:relog")
AddEventHandler("vario:relog",function()
    local src = source
    local crds = GetEntityCoords(GetPlayerPed(src))
    local id = src
    local identifier = ""
        
    reason = 'Relog'
    identifier = GetPlayerIdentifier(src, 0)

    TriggerClientEvent("pixel_anticl", -1, id, crds, identifier, reason)
end)

RegisterServerEvent("vario:respawn")
AddEventHandler("vario:respawn",function()
    local src = source
    local crds = GetEntityCoords(GetPlayerPed(src))
    local id = src
    local identifier = ""
        
    reason = 'Respawn'
    identifier = GetPlayerIdentifier(src, 0)

    TriggerClientEvent("pixel_anticl", -1, id, crds, identifier, reason)
end)