RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(playerId)
	playerId = tonumber(playerId)
	exports['vestiti_nuovi']:triggerBan(source, 'esx_ambulancejob:revive')
end)

RegisterServerEvent('esx_ambulancejob:log', function(reason, target)
	local webhook
	local message
	local xP = ESX.GetPlayerFromId(source)
	local xT = ESX.GetPlayerFromId(target)
	if reason == 'rianimazione' then
		message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xP.identifier.. ']** ha rianimato il giocatore **' ..GetPlayerName(target).. ' [' ..xT.identifier.. ']**'
		webhook = 'https://discord.com/api/webhooks/1056229799074484324/3b8Ce98F6891lCyFNsutNZiPAVKsIrwQCr31ggNlY8VlZKxdKZmeL5tYeO0kNn6skTt_'
	elseif reason == 'curapiccola' then
		message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xP.identifier.. ']** ha eseguito una cura piccola al giocatore **' ..GetPlayerName(target).. ' [' ..xT.identifier.. ']**'
		webhook = 'https://discord.com/api/webhooks/1056230352592572446/U-VKy4SUeRXG2dOSjjWPOMbmDMQ9oUAuaQJb-l4Px-FEhtq15yZMDnT6xIPDMg5cKPpg'
	elseif reason == 'curagrande' then
		message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xP.identifier.. ']** ha eseguito una cura grande al giocatore **' ..GetPlayerName(target).. ' [' ..xT.identifier.. ']**'
		webhook = 'https://discord.com/api/webhooks/1056230416060776448/E53bZMKEdU_f86qfgr59Eoa-5n65w1qD-zsEb4xeu_Ug-pPxi3-4Q6MvTUtlHmhr72K1'
	end
	ESX.Log(webhook, message)
end)

RegisterServerEvent('royal:logmedico', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local webhook = 'https://discord.com/api/webhooks/1056228525348241459/W0_XC1DxQEgmUn1BfdSoLgxkwYrSlyCwQici28rz8XNSzZHWPHNmFEN9QiiJVC9QocCk'
	local message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** si è rianimato con /medico.'
	ESX.Log(webhook, message)
end)

RegisterNetEvent('royal_ambulance:healMedico', function(target, type)
	local x = ESX.GetPlayerFromId(source)
	if x.job.name == 'ambulance' then
		TriggerClientEvent('royal_ambulance:heal', target, type)
	end
end)

ESX.RegisterServerCallback('mambi:loggarespawn', function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local msg = ""
	for i = 1, #xPlayer.inventory, 1 do
		if xPlayer.inventory[i] then
			if xPlayer.inventory[i].count > 0 then
				msg =
					msg.."Nome: **" ..
					xPlayer.inventory[i].name .. "** | Quantità: **" .. xPlayer.inventory[i].count .. "**\n"
			end
		end
	end
	local webhook = 'https://discord.com/api/webhooks/1075939148004868146/Sq-TGf6gQXlz-6ifkYh800R-gfnRcV1I8MdwfmNqkhH3FeRqtTzY1iQddPe6o5voWfaG'
	local message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier..']** è respawnato.\n\n' ..msg
	ESX.Log(webhook, message)
	cb()
end)

ESX.RegisterServerCallback('mambi-deathsystem:RimuoviTutto', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local msg = ""
	for i = 1, #xPlayer.inventory, 1 do
		if xPlayer.inventory[i] then
			if xPlayer.inventory[i].count > 0 then
				msg =
					msg.."Nome: **" ..
					xPlayer.inventory[i].name .. "** | Quantità: **" .. xPlayer.inventory[i].count .. "**\n"
			end
		end
	end
	exports.ox_inventory:ClearInventory(source)
	local webhook = 'https://discord.com/api/webhooks/1075939697311879211/EK7kmlzX1A6YB5pvxzoXuzBg0WI5V5byzbWq5sp4OBeknBNOdAbdAb3eVnd1FE6PZMHE'
	local message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier..']** è rientrato dopo aver sloggato da morto.\n\n' ..msg
	ESX.Log(webhook, message)
	cb()
end)

RegisterNetEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(item, 1)
end)


ESX.RegisterServerCallback('esx_ambulancejob:morente', function(source, cb, xTarget)
	local xT = ESX.GetPlayerFromId(xTarget)
	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = xT.identifier
	}, function(isDead)
		if isDead == true then
			print(xT.identifier.. ' è morto')
			cb(true)
		else
			print(xT.identifier.. ' è vivo')
			cb(false)
		end
	end)
end)