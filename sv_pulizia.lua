ESX.RegisterServerCallback('Mambi:Pulizia', function(source, cb, type)
    if type == 'Object' then
        local entity = GetAllObjects()
            for _,entita in pairs(entity) do
                DeleteEntity(entita)
            end
        elseif type == 'Vehicles' then
            local entity = GetAllVehicles()
            for _,entita in pairs(entity) do
                if not IsPedAPlayer(GetPedInVehicleSeat(entita, -1)) then
                    if GetVehicleType(entita) == 'trailer' then
                    else
                        DeleteEntity(entita)
                    end
                end
            end
        end
    cb()
end)