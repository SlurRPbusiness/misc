RegisterCommand('daiveicolo', function(source, args)
	givevehicle(source, args, 'car')
end)


function givevehicle(_source, _args, vehicleType)
	if havePermission(_source) then
		local xPlayer = ESX.GetPlayerFromId(_source)
		if _args[1] == nil or _args[2] == nil then
			xPlayer.showNotification('Inserisci i parametri validi! /daiveicolo [ID] [CODICE]')
		else
			local playerName = GetPlayerName(_args[1])
			TriggerClientEvent('esx_giveownedcar:spawnVehicle', _source, _args[1], _args[2], playerName, 'player', vehicleType)
			local message = "Lo staffer **"..GetPlayerName(_source).. " [" ..xPlayer.identifier.. "]** ha givvato il veicolo **" .._args[2].. "** al giocatore **"..GetPlayerName(_args[1]).."**"
			local webhook = 'https://discord.com/api/webhooks/1170819328300564581/6RmEiVNuAcH2cO4w7oaU5LF7U8FLOlTTGjP3wLxYoLbt-ICrL4r98ZbBUKSFiRaZILEx'
			ESX.Log(webhook, message)
		end
	else
		TriggerClientEvent('esx:showNotification', _source, 'Non hai il permesso di eseguire questo comando.')
	end
end		

RegisterServerEvent('esx_giveownedcar:setVehicle')
AddEventHandler('esx_giveownedcar:setVehicle', function (vehicleProps, playerID, vehicleType, modelname, label)
	local _source = playerID
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, stored, type, modelname, proprietario, vehiclename) VALUES (@owner, @plate, @vehicle, @stored, @type, @modelname, @proprietario, @vehiclename)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@stored']  = 1,
		['type'] = vehicleType,
		['@modelname'] = modelname,
		['@proprietario'] = xPlayer.getName(),
		['@vehiclename'] = label,
	}, function()
		TriggerClientEvent('esx:showNotification', _source, "Hai ricevuto " ..label.. " con targa ".. string.upper(vehicleProps.plate))
	end)
end)

RegisterServerEvent('esx_giveownedcar:printToConsole')
AddEventHandler('esx_giveownedcar:printToConsole', function(msg)
	print(msg)
end)

function havePermission(_source)
	local xPlayer = ESX.GetPlayerFromId(_source)
	local playerGroup = xPlayer.getGroup()
	local isAdmin = false
	for k,v in pairs(Config.AuthorizedRanks) do
		if v == playerGroup then
			isAdmin = true
			break
		end
	end
	
	return isAdmin
end