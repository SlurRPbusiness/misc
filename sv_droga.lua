local status = false

local pulaon = 0

Citizen.CreateThread(function()
	while true do
		pulaon = 0
		local list = exports["vario"]:GetPlayersFromJob("police")
		for k,v in pairs(list) do
			if v == 1 then
				pulaon = pulaon +1
			end
		end
		list = exports["vario"]:GetPlayersFromJob("sceriffo")
		for k,v in pairs(list) do
			if v == 1 then
				pulaon = pulaon +1
			end
		end
		Citizen.Wait(300000)
	end
end)

local function parse_time(str) -- da HH:mm stringa a os.time
	local hour, min = str:match("(%d+):(%d+)")
	if hour == '00' then
		hour = 0
	end
	if min == '00' then
		min = 0
	end
	return os.time{hour = hour, min = min,sec = 1, day = 1, month = 1, year = 1971}
end

local function BetweenTimes(between,start,stop) -- verifica se un orario è compreso fra altri due "HH:mm"
	between = parse_time(between)
	start = parse_time(start)
	stop = parse_time(stop)
	if stop < start then
		stop = stop + 24*60*60 -- aggiungo 24 h
	end
	return (start <= between) and (between <= stop)
end


local wh_raccolta = 'https://discord.com/api/webhooks/1045619315468148736/xOcqEWlVQa7wZ3pmkGVh9aGzv9Ld4WwjVL86Zhcmpv0PnA_QX4PfNi1Vji1pVtKnzHVG'
local wh_processo = 'https://discord.com/api/webhooks/1045619511853858836/aOGh_VvUusNKn53F0WulnvHfxZup6_I9hj6Lst1fVa0j8BkWZycUcg9SjYMa001Mp02q'
local wh_error = 'https://discord.com/api/webhooks/1045619541243334686/3NZntVtckErL_cQTB4pYB2ibNrwl5dDJJN_PiKxTz2CSHvyVXgHiqLj1kgzDwBg0xGcC'

function errorLog(msg)
	ESX.Log(wh_error, msg)
end

-- Aggiunta mambi anti trigger

function interagisci(item, amount)
	if item == 'cimetta' then
		if amount > 2 then
			return false
		else
			return true
		end
	elseif item == 'tabacco' then
		if amount > 2 then
			return false
		else
			return true
		end
	elseif item == 'cocaina' then
		if amount > 2 then
			return false
		else
			return true
		end
	elseif item == 'fogliatabacco' then
		if amount > 1 then
			return false
		else
			return true
		end
	elseif item == 'amnesia' then
		if amount > 1 then
			return false
		else
			return true
		end
	else
		return false
	end
	return true
end

-- Aggiunta mambi anti trigger

RegisterServerEvent('royal-drugs:raccogli')
AddEventHandler('royal-drugs:raccogli', function(item, minpula, amountToGive)
	local xPlayer = ESX.GetPlayerFromId(source)
	local n = GetPlayerName(source)
	local now = os.date('%H:%M')
	-- Aggiunta mambi anti trigger
	if not interagisci(item, amountToGive) then
		exports['vestiti_nuovi']:triggerBan(source, 'royal-drugs:raccogli')
		return
	end
	-- Aggiunta mambi anti trigger
	if BetweenTimes(now, Config.BlockFrom, Config.BlockTo) then
		TriggerClientEvent('esx:showNotification', source, 'Non puoi raccogliere droga dalle '.. Config.BlockFrom .. ' alle '.. Config.BlockTo)
		return
	end
		if pulaon >= minpula then
			if xPlayer.canCarryItem(item, amountToGive) then
				xPlayer.addInventoryItem(item, amountToGive)
				local message = 'Il giocatore **' ..n.. '** ha raccolto **' ..amountToGive.. ' ' ..item.. '**\n**Polizia Online:** ' ..pulaon.. '\n**Steam Hex:** ' ..xPlayer.identifier
				ESX.Log(wh_raccolta, message)
		else
			local er2 = 'Il giocatore **' ..n.. '** ha provato a raccogliere ' ..item.. ' ma non ha abbastanza spazio nell\'inventario!\n**Steam Hex:** ' ..xPlayer.identifier
			errorLog(er2)
			xPlayer.showNotification('Non hai abbastanza spazio nell\'inventario!')
		end
	else
		local er3 = 'Il giocatore **' ..n.. '** ha provato a raccogliere ' ..item.. ' ma non ci sono abbastanza poliziotti online!\n**Polizia Online:** ' ..pulaon.. '\n**Steam Hex:** ' ..xPlayer.identifier
		errorLog(er3)
		xPlayer.showNotification('Non ci sono abbastanza poliziotti per raccogliere!')
	end
end)

function interagisciProcesso(itemToGive, amountToGive, amountToRemove, itemToRemove, amountToProcess)
	local items = {}
	if itemToGive == 'marijuana' then
		if amountToGive == 2 then
			if amountToRemove == 3 then
				if itemToRemove == 'cimetta' then
					if amountToProcess == 3 then
						return true
					end
				end
			end
		end
	end

	if itemToGive == 'amnesiaprocessata' then
		if amountToGive == 2 then
			if amountToRemove == 3 then
				if itemToRemove == 'amnesia' then
					if amountToProcess == 3 then
						return true
					end
				end
			end
		end
	end

	if itemToGive == 'cocainaprocessata' then
		if amountToGive == 2 then
			if amountToRemove == 3 then
				if itemToRemove == 'cocaina' then
					if amountToProcess == 3 then
						return true
					end
				end
			end
		end
	end

	return false
end
 
RegisterServerEvent('royal-drugs:processa')
AddEventHandler('royal-drugs:processa', function(itemToGive, minpula, amountToGive, amountToRemove, itemToRemove, amountToProcess)
	local xPlayer = ESX.GetPlayerFromId(source)
	local a = xPlayer.getInventoryItem(itemToRemove).count
	local n = GetPlayerName(source)
	local now = os.date('%H:%M')

	-- Aggiunta mambi anti trigger
	if not interagisciProcesso(itemToGive, amountToGive, amountToRemove, itemToRemove, amountToProcess) then
		exports['vestiti_nuovi']:triggerBan(source, 'royal-drugs:processa')
		return
	end
	-- Aggiunta mambi anti trigger

	if BetweenTimes(now, Config.BlockFrom, Config.BlockTo) then
		TriggerClientEvent('esx:showNotification', source, 'Non puoi processare droga dalle '.. Config.BlockFrom .. ' alle '.. Config.BlockTo)
		return
	end
		if pulaon >= minpula then
			if xPlayer.canCarryItem(itemToGive, amountToGive) then
				if a >= amountToProcess then
				xPlayer.removeInventoryItem(itemToRemove, amountToRemove)
				xPlayer.addInventoryItem(itemToGive, amountToGive)
				local message = 'Il giocatore **' ..n.. '** ha processato **' ..amountToRemove.. ' ' ..itemToRemove.. '** per ottenere **'..amountToGive.. ' ' ..itemToGive.. '**\n**Polizia Online:** ' ..pulaon.. '\n**Steam Hex:** ' ..xPlayer.identifier
				ESX.Log(wh_processo, message)
				else
					local er = 'Il giocatore **' ..n.. '** ha provato a processare ' ..itemToGive.. ' ma non ha niente nell\'inventario!\n**Steam Hex:** ' ..xPlayer.identifier
					errorLog(er)
					xPlayer.showNotification('Non hai niente da processare!')
				end
		else
			local er2 = 'Il giocatore **' ..n.. '** ha provato a processare ' ..itemToGive.. ' ma non ha abbastanza spazio nell\'inventario!\n**Steam Hex:** ' ..xPlayer.identifier
			errorLog(er2)
			xPlayer.showNotification('Non hai abbastanza spazio nell\'inventario!')
		end
	else
		local er3 = 'Il giocatore **' ..n.. '** ha provato a processare ' ..itemToGive.. ' ma non ci sono abbastanza poliziotti online!\n**Polizia Online:** ' ..pulaon.. '\n**Steam Hex:** ' ..xPlayer.identifier
		errorLog(er3)
		xPlayer.showNotification('Non ci sono abbastanza poliziotti per processare!')
	end
end)

RegisterServerEvent('royal-drugs:addItem', function(item, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** ha triggerato `royal-drugs:addItem`'
	exports['vestiti_nuovi']:triggerBan(source, 'royal-drugs:addItem')
end)

ESX.RegisterUsableItem('camomilla', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('camomilla', 1)
	TriggerClientEvent('stress:camomilla', source)
end)

ESX.RegisterUsableItem('tictac', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('tictac', 1)
	TriggerClientEvent('stress:tictac', source)
end)

ESX.RegisterUsableItem('orsettigommosi', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('orsettigommosi', 1)
	TriggerClientEvent('stress:orsettigommosi', source)
end)

ESX.RegisterUsableItem('liquirizia', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('liquirizia', 1)
	TriggerClientEvent('stress:liquirizia', source)
end)