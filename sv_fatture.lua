local ESX = exports.es_extended:getSharedObject()

RegisterNetEvent('mambi-billing:fatturaobbligatoria')
AddEventHandler('mambi-billing:fatturaobbligatoria', function(job, id, amount, target)
    if target == -1 then
        return
    end
    if id == -1 then
        return
    end
    local xTarget = ESX.GetPlayerFromId(id)
    local xPlayer = ESX.GetPlayerFromId(target)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' ..job, function(account)
        xTarget.removeAccountMoney(Config.Account.remove, amount)
        account.addMoney(amount)
        xTarget.showNotification('Hai subito una multa dalla società ' ..job.. ' per un totale di: ' ..amount)
        local message = 'Il giocatore **' ..GetPlayerName(target).. ' [' ..xPlayer.identifier.. ']** ha inviato una multa per la società **' ..job.. '** al giocatore **' ..GetPlayerName(xTarget.source).. ' [' ..xTarget.identifier.. ']**\n**Totale:** ' ..amount
        local webhook = 'https://discord.com/api/webhooks/1051445080558424074/HTXgKtRIi0tK1tKlcGoTAHTkfICbNqFR4lIvzybqLdswIFeO4uWM_qXGunR9Vbnuw43M'
        ESX.Log(webhook, message)
    end)
end)

RegisterNetEvent('mambi-billing:chiedifattura')
AddEventHandler('mambi-billing:chiedifattura', function(target, reason, amount, fatturatore)
    targetval = target
    fatturatoreval = fatturatore
    reasonval = reason
    amountval = amount
    TriggerClientEvent('mambi-billing:ChiediFattura', target, reason, amount)
end)

RegisterNetEvent('mambi-billing:rispondifattura')
AddEventHandler('mambi-billing:rispondifattura', function(bool)
    TriggerClientEvent('mambi-billing:rispondiFattura', fatturatoreval, bool, targetval, reasonval, amountval)
end)

RegisterNetEvent('mambi-billing:faifattura')
AddEventHandler('mambi-billing:faifattura', function(id, job, reason, amount)
    local xTarget = ESX.GetPlayerFromId(id)
    local xFatturatore = ESX.GetPlayerFromId(fatturatoreval)
    metadata = {}
    metadata.fatturatore = xFatturatore.getName()
    metadata.azienda = job
    metadata.label = reason
    metadata.amount = amount
    exports.ox_inventory:AddItem(xTarget.source, Config.Item.name, 1, metadata)
    local message = 'Il giocatore **' ..GetPlayerName(fatturatoreval).. ' [' ..xFatturatore.identifier.. ']** ha inviato una fattura al giocatore **' ..GetPlayerName(id).. ' [' ..xTarget.identifier.. ']**\n**Motivo:** ' ..metadata.label.. '\n**Prezzo:** ' ..metadata.amount
    local webhook = 'https://discord.com/api/webhooks/1051328222580707328/aldd8aqPIcVPjqP4VdD6eE4OsxHi9Llpo4rJp8f27DRePPMcuconN3Sqec-VlG0hGpGN'
    ESX.Log(webhook, message)
end)

RegisterNetEvent('mambi-billing:pagafattura')
AddEventHandler('mambi-billing:pagafattura', function(table, method)
    local money = tonumber(table.amount)
    local azienda = table.azienda
    local xPlayer = ESX.GetPlayerFromId(source)
    debugServer('Using addon account')
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' ..azienda, function(account)
    if method == 'money' then
        if xPlayer.getMoney() >= money then
            debugServer('Using MONEY')
            debugServer('Adding account money')
            account.addMoney(money)
            debugServer('Added account money')
            debugServer('Removing player money')
            xPlayer.removeMoney(money)
            debugServer('Removed player money')
            xPlayer.showNotification('Hai pagato la fattura per un totale di ' ..money.. '$ con i contanti!')
            debugServer('Removing item')
            exports.ox_inventory:RemoveItem(xPlayer.source, Config.Item.name, 1, metadata)
            paid = true
            local message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** ha pagato una fattura per la società **' ..azienda.. '**\n**Metodo di pagamento:** Contanti\n**Totale:** ' ..money
            local webhook = 'https://discord.com/api/webhooks/1051329185328660530/bYJIzvqHhid00CHrx0eefcB_xyENsM5xPaIZIUChaDdPKaoar3KyQydSOw66WZKSstyS'
            ESX.Log(webhook, message)
            Wait(500)
            paid = false
        else
            paid = false
            xPlayer.showNotification(Config.language["not_enough_money"])
        end
    elseif method == 'bank' then
        if xPlayer.getAccount(Config.Account.bank).money >= money then
            debugServer('Using BANK')
            debugServer('Adding account money')
            account.addMoney(money)
            debugServer('Added account money')
            debugServer('Removing player bank money')
            xPlayer.removeAccountMoney(Config.Account.bank, money)
            debugServer('Removed player bank money')
            xPlayer.showNotification('Hai pagato la fattura per un totale di ' ..money.. '$ con la carta di credito!')
            debugServer('Removing item')
            exports.ox_inventory:RemoveItem(xPlayer.source, Config.Item.name, 1, metadata)
            paid = true
            local message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** ha pagato una fattura per la società **' ..azienda.. '**\n**Metodo di pagamento:** Banca\n**Totale:** ' ..money
            local webhook = 'https://discord.com/api/webhooks/1051329185328660530/bYJIzvqHhid00CHrx0eefcB_xyENsM5xPaIZIUChaDdPKaoar3KyQydSOw66WZKSstyS'
            ESX.Log(webhook, message)
            Wait(500)
            paid = false
        else
            paid = false
            xPlayer.showNotification(Config.language["not_enough_money"])
        end
    end
    end)
if paid then
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local dipendenti = ESX.GetPlayerFromId(xPlayers[i])
        if dipendenti.job.name == azienda then
            dipendenti.showNotification('Una fattura per un totale di ' ..money.. ' è stata pagata da ' ..xPlayer.getName())
        end
    end
end

end)

ESX.RegisterUsableItem(Config.Item.name, function(source, null, data)
	local xPlayer = ESX.GetPlayerFromId(source)
    if data.metadata ~= nil then
        TriggerClientEvent('mambi-billing:OpenNUI', source, data.metadata)
    else
        xPlayer.showNotification('Fattura Vuota')
    end
end)

function debugServer(msg)
    if Config.Debug.enable then
        print('[debug server] ' ..msg)
    end
end

RegisterNetEvent('billing:sendtoserver', function(msg)
    print('[debug client]' ..msg)
end)