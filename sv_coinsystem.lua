local ESX = exports.es_extended:getSharedObject()
local inProgress = false
Config.Webhook = 'https://discord.com/api/webhooks/1137176768437043230/hZbR59cjOcXhq2GTS5_rtkmnwk3NcWLWb_WXJfDxbfzw8cpTEc3wKgDOz9pkIrWlPkzk'

function Log(webhook, message)
    ESX.Log(webhook, message)
end

function tebex_handler_mambi(transaction, packageName)
	local tbxid = transaction
	local packTab = {}
	packTab[#packTab+1] = packageName
	MySQL.insert("INSERT INTO mambi_coins (transactionId, packagename) VALUES (?, ?)", {tbxid, json.encode(packTab)}, function(rowsChanged)
        Log(Config.Webhook, '**' ..packageName.. '** è stato acquistato e inserito nel database con la transazione: **' ..tbxid.. '**')
	end)
end

ESX.RegisterServerCallback('mambi_coins:is_code_real', function(source, cb, code)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.query('SELECT * FROM mambi_coins WHERE transactionId = @code', {
        ['@code'] = code
    }, function(result)
		if result[1] then
            Riscatta(source, result, code)
            cb(true)
        else
            cb(false)
        end
    end)
end)

function GeneraCoin(transaction, packageName)
    tebex_handler_mambi(transaction, packageName)
end

exports('GeneraCoin', GeneraCoin)

if Config.UseTebex then

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		local tebexConvar = GetConvar('sv_tebexSecret', '')
		if tebexConvar == '' then
			print('Tebex Secret Missing please set in server.cfg and try again. The script will not work without it.')
			os.exit()
		end
	end
end)

RegisterCommand('mambi_tebex_handler', function(source, args)
	if source == 0 then
		local dec = json.decode(args[1])
        GeneraCoin(dec.transid, dec.packagename)
    end
end, false)

end

function Riscatta(source, result, code)
    local xPlayer = ESX.GetPlayerFromId(source)
    local boughtPackages = json.decode(result[1].packagename)
	for _, i in pairs(boughtPackages) do
        if Config.Packages[i] ~= nil then
            for h, j in pairs(Config.Packages[i].Items) do
                if j.type == 'item' then
                    xPlayer.addInventoryItem(j.name, j.amount)
                elseif j.type == 'weapon' then
                    xPlayer.addInventoryItem(j.name, j.amount)
                elseif j.type == 'account' then
                    xPlayer.addAccountMoney(j.name, j.amount)
                    xPlayer.showNotification('Ti sono stati accreditati ' ..j.amount.. '$ in banca!')
                elseif j.type == 'doppiopg' then
                    TriggerEvent('esx_multicharacter:CambiaSlots', source, j.amount)
                    xPlayer.showNotification('Hai ricevuto il secondo personaggio correttamente!')
                    Log(Config.Webhook, 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** ha riscattato con successo il codice: **' ..code.. '**')
                    Wait(600)
                    TriggerClientEvent('peds:relog', source)
                elseif j.type == 'poteri' then
                    xPlayer.setGroup(j.tipo)
                    xPlayer.showNotification('Hai ricevuto i poteri correttamente!')
                    Log(Config.Webhook, 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** ha riscattato con successo il codice: **' ..code.. '**')
                    Wait(600)
                    TriggerClientEvent('peds:relog', source)
                elseif j.type == 'pass' then
                    TriggerEvent('royalpass:AggiungiPass', src, j.infinito)
                    Log(Config.Webhook, 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** ha riscattato con successo il codice: **' ..code.. '**')
                    xPlayer.showNotification('Hai ricevuto il pass con successo!')
                end
                Wait(100)
            end
            Log(Config.Webhook, 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** ha riscattato con successo il codice: **' ..code.. '**')
            xPlayer.showNotification('Hai riscattato con successo il codice ' ..code)
        else
            if string.find(i, 'auto-') then
                local model = string.gsub(i, 'auto-', '')
                local modello = string.sub(model, 3)
                local playerName = GetPlayerName(source)
                TriggerClientEvent('esx_giveownedcar:spawnVehicle', tonumber(source), source, modello, playerName, 'console', 'car')
                Log(Config.Webhook, 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** ha riscattato con successo il codice: **' ..code.. '**')
                xPlayer.showNotification('Hai riscattato con successo il codice ' ..code)
            elseif string.find(i, 'ped-') then
                local model = string.sub(i, 5)
                local playerName = GetPlayerName(source)
                exports.vario:setPed(source, model)
                Log(Config.Webhook, 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** ha riscattato con successo il codice: **' ..code.. '**')
                xPlayer.showNotification('Hai riscattato con successo il codice ' ..code)
            else
                xPlayer.showNotification('Errore, contatta il Developer su Discord: mambilosco')
            end
        end	
    end
    MySQL.query.await('DELETE FROM mambi_coins WHERE transactionId = @playerCode', {['@playerCode'] = code})
end