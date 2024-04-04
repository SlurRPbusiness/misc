local itemUsed = {}

ESX.RegisterUsableItem('bombolaossigeno', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    if itemUsed[xPlayer.identifier] == nil then
        xPlayer.showNotification('Hai abilitato la bombola d\'ossigeno!')
        itemUsed[xPlayer.identifier] = 1
        TriggerClientEvent('Mambi:UtilizzaBombolaOssigeno', source, true)
    else
        itemUsed[xPlayer.identifier] = nil
        xPlayer.showNotification('Hai disabilitato la bombola d\'ossigeno!')
        TriggerClientEvent('Mambi:UtilizzaBombolaOssigeno', source, false)
    end
end)

ESX.RegisterServerCallback('Mambi:UpdateMetadata', function(source, cb, bool)
    local xPlayer = ESX.GetPlayerFromId(source)
    local bombola = exports.ox_inventory:Search(source, 1, 'bombolaossigeno')
    local metadatone = {}
    local slot = nil
    for k,v in pairs(bombola) do
        metadatone = v.metadata
        slot = v.slot
    end
    if metadatone.count < 1 then
        xPlayer.showNotification('La tua bombola si è usurata!')
        exports.ox_inventory:RemoveItem(source, 'bombolaossigeno', 1, metadatone, slot)
    end
    if not bool or bool == false then
        cb(metadatone.count)
        return
    end
    metadatone.count = metadatone.count - 1
    exports.ox_inventory:SetMetadata(source, slot, metadatone)
    cb(metadatone.count)
end)

ESX.RegisterServerCallback('Mambi:AddBombola', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local metadata = {}
    metadata.count = 10
    exports.ox_inventory:AddItem(xPlayer.source, 'bombolaossigeno', 1, metadata)
    cb()
end)