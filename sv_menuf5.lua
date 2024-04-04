RegisterNetEvent('ff_menuf5:givesoldi')
AddEventHandler('ff_menuf5:givesoldi', function(tiposoldi, importo, target, staffer)
	local xPlayer = ESX.GetPlayerFromId(target)
	local xTarget = ESX.GetPlayerFromId(staffer)
	local gruppo = xTarget.getGroup()

	if gruppo ~= nil then
		if gruppo == 'mod' or gruppo == 'admin' or gruppo == 'superadmin' then 
			if tiposoldi == 'sporchi' then
				xPlayer.addAccountMoney('black_money', tonumber(importo))
				TriggerClientEvent('esx:showNotification', source, 'Hai givvato ' .. importo .. '$ sporchi al giocatore ' ..GetPlayerName(target))
				TriggerClientEvent('esx:showNotification', target, 'Hai ricevuto ' .. importo .. '$ sporchi dallo staffer ' ..GetPlayerName(staffer))
				local webhook = 'https://canary.discord.com/api/webhooks/1047902960119722014/96vK2iHX5u4HRiuoNIjuUZCr6Sbwr42f5F0Wa3hQXXcCw2MxETIA9RSv5WteKOHphiZH'
				local message = 'Lo staffer **' ..GetPlayerName(staffer).. ' [' ..xTarget.identifier.. ']** ha givvato **' ..importo.. '$ Sporchi** al giocatore **' ..GetPlayerName(target).. ' [' ..xPlayer.identifier.. ']**'
				ESX.Log(webhook, message)
			elseif tiposoldi == 'puliti' then
				xPlayer.addMoney(importo)
				TriggerClientEvent('esx:showNotification', source, 'Hai givvato ' .. importo .. '$ al giocatore ' ..GetPlayerName(target))
				TriggerClientEvent('esx:showNotification', target, 'Hai ricevuto ' .. importo .. '$ dallo staffer ' ..GetPlayerName(staffer))
				local webhook = 'https://canary.discord.com/api/webhooks/1047681527967920168/CH6pEfacUt5iBq4ON0zTQE6Ho4NTvESHVZ2hhCGrJOsFMNle5nR_PRqWcyzYWjppL8Oh'
				local message = 'Lo staffer **' ..GetPlayerName(staffer).. ' [' ..xTarget.identifier.. ']** ha givvato **' ..importo.. '$ Puliti** al giocatore **' ..GetPlayerName(target).. ' [' ..xPlayer.identifier.. ']**'
				ESX.Log(webhook, message)
			end
		else
			TriggerClientEvent('esx:showNotification', source, 'Non hai il permesso!')
		end
	end
end)

ESX.RegisterServerCallback('flr:getgroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer then
			local gruppo = xPlayer.getGroup()
			if gruppo ~= nil then 
				cb(gruppo)
			else
				cb('user')
			end
		end
end)

ESX.RegisterServerCallback('flr:isplayeronline', function(src, cb,target)
    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer then
        cb(true)
    else
        cb(false)   
    end
end)