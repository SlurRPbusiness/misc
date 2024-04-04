ESX.RegisterServerCallback("inventario:apripopolare", function(playerId, cb)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    exports.ox_inventory:RegisterStash('Popolare:'..xPlayer.identifier, Config.Label, Config.Slots, Config.Peso*1000, nil)
    Citizen.Wait(200)
    MySQL.Async.fetchAll('SELECT name, slots, peso FROM flr_inventari WHERE name = @name',{       
        ['@name'] = 'Popolare:'..xPlayer.identifier
        }, function (risultato)
            if (risultato[1] ~= nil) then
                slotsfinal = risultato[1].slots
                exports.ox_inventory:RegisterStash('Popolare:'..xPlayer.identifier, 'Deposito', json.decode(slotsfinal), risultato[1].peso*1000)
            else
                MySQL.Async.execute('INSERT INTO flr_inventari (name, slots, peso) VALUES (@name, @slots, @peso)',
                {
                    ['@name']   = 'Popolare:'..xPlayer.identifier,
                    ['@slots'] = Config.Slots,
                    ['@peso'] = Config.Peso
                }, function ()
                --print('^2[royal-factions] ^0Inventario ^2' ..e.. ' ^0registrato con successo [^1CONFIG^0]')
            end)
        end
    end)
    cb('Popolare:'..xPlayer.identifier)
end)

ESX.RegisterServerCallback('Mambi_Popolari:GetIdentifierForUpdate', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb('Popolare:'..xPlayer.identifier)
end)

RegisterNetEvent('Mambi_Popolari:UpdateStash')
AddEventHandler('Mambi_Popolari:UpdateStash', function(deposito, peso, slots, prezzo, metodo, tipo)
    local labelInv = Config.Label
    if tipo == 'personale' then
        labelInv = 'Deposito Casa [PERSONALE]'
    end
    local xPlayer = ESX.GetPlayerFromId(source)
    local nome = GetPlayerName(source)
    if xPlayer.getAccount(metodo).money >= prezzo then
        xPlayer.removeAccountMoney(metodo, prezzo)
        MySQL.Async.fetchAll('SELECT name, slots, peso FROM flr_inventari WHERE name = @name',{
        ['@name'] = deposito,
        }, function (risultato)
            slotsupdated1 = risultato[1].slots + slots
            pesoupdated1 = risultato[1].peso + peso
            MySQL.Async.execute("UPDATE flr_inventari SET `slots` = @slots, `peso`= @peso WHERE `name` = @name",{
                ['@name'] = deposito,
                ['@slots'] = slotsupdated1,
                ['@peso'] = pesoupdated1,
            }, function()
                xPlayer.showNotification('Hai aumentato correttamente il peso del deposito!')
                exports.ox_inventory:RegisterStash(deposito, labelInv, slotsupdated1, pesoupdated1 * 1000)
                local webhook = 'https://discord.com/api/webhooks/1055277587661860914/layyPImCR8-rBognU-2v0toWbXlhol8yD7dguu0EidIw_FzJWQqwMAHJvKibP-vQQEqa'
                local message = 'Il giocatore **' ..nome.. ' [' ..xPlayer.identifier.. ']** ha eseguito un update del deposito **' ..deposito.. '**.\n**Slots:** ' ..slotsupdated1.. '\n**Peso:** ' ..pesoupdated1
                ESX.Log(webhook, message)
            end)
        end)
    else
        if metodo == 'money' then
            metodo = 'Contanti'
        end
        if metodo == 'bank' then
            metodo = 'soldi in Banca'
        end
        xPlayer.showNotification('Non hai abbastanza ' ..metodo.. '!')
    end
end)

local webhook = 'https://discord.com/api/webhooks/1090767911842492478/GhjIC3oLjbhl18xvT_d0DyPh22CywIbYAy662AEsQt4svSL0QtORSWCChktWi8OzUu9U'

RegisterServerEvent('joinPopolare')
AddEventHandler('joinPopolare', function()
    SetPlayerRoutingBucket(source, source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** è entrato nella casa popolare.'
    ESX.Log(webhook, message)
end)

RegisterServerEvent('esciPopolare')
AddEventHandler('esciPopolare', function()
    SetPlayerRoutingBucket(source, 0)
    local xPlayer = ESX.GetPlayerFromId(source)
    local message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** è uscito dalla casa popolare.'
    ESX.Log(webhook, message)
end)