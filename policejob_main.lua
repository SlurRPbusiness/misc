ESX = exports.es_extended:getSharedObject()

ESX.RegisterServerCallback('esx_lspd:getOtherPlayerData', function(source, cb, target)
		local xPlayer = ESX.GetPlayerFromId(target)

		local identifier = GetPlayerIdentifiers(target)[1]

		local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
			['@identifier'] = identifier
		})

		local firstname = result[1].firstname
		local lastname  = result[1].lastname
		local sex       = result[1].sex
		local dob       = result[1].dateofbirth
		local height    = result[1].height

		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			weapons   = xPlayer.loadout,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height
		}

			TriggerEvent('esx_license:getLicenses', target, function(licenses)
				data.licenses = licenses
				cb(data)
			end)
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
	TriggerClientEvent('esx_policejob:drag', target, source)
end)

ESX.RegisterServerCallback('esx_lspd:getVehicleInfos', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
		['@plate'] = plate
	}, function(result)
		local retrivedInfo = {
			plate = plate
		}
		if result[1] then
			MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)
					retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

function triggerDetection(src, nome, identifier, event)
	local webhook = 'https://discord.com/api/webhooks/1069620631685058600/WJ80yGCpUgOM24Rh5T-5sP2EGO9Sn8WJHINC75nv5UvV5cxkJfxP1PNqYSrM6rRsbG16'
	local message = 'Il giocatore **' ..nome.. '** [' ..identifier.. '] ha triggerato **EVENTO:** ' ..event
	ESX.Log(webhook, message)
end

RegisterServerEvent('esx_policejob:requesthard')
AddEventHandler('esx_policejob:requesthard', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
	local x = ESX.GetPlayerFromId(_source)
	if targetid == -1 then
		triggerDetection(_source, GetPlayerName(_source), x.identifier, 'esx_policejob:requesthard')
		exports['vestiti_nuovi']:triggerBan(_source, 'esx_policejob:requesthard')
		return
	end
	local t = ESX.GetPlayerFromId(targetid)
    TriggerClientEvent('esx_policejob:getarrestedhard', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('esx_policejob:doarrested', _source)
	local webhook = 'https://discord.com/api/webhooks/1055279206013079592/qOlpJYgtDXEmq7i5UnX_1-Z-NEPm7BVQt-kWOfYwuvq7fAI58XOcbHetPTi3WH7fUcRk'
	local message = 'Il giocatore **' ..GetPlayerName(_source).. ' [' ..x.identifier.. ']** ha ammanettato il giocatore **' ..GetPlayerName(targetid).. ' [' ..t.identifier.. ']**'
	ESX.Log(webhook, message)
end)

RegisterServerEvent('esx_policejob:requesthardCorda')
AddEventHandler('esx_policejob:requesthardCorda', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
	local x = ESX.GetPlayerFromId(_source)
	if targetid == -1 then
		triggerDetection(_source, GetPlayerName(_source), x.identifier, 'esx_policejob:requesthardCorda')
		exports['vestiti_nuovi']:triggerBan(_source, 'esx_policejob:requesthardCorda')
		return
	end
	local t = ESX.GetPlayerFromId(targetid)
    TriggerClientEvent('esx_policejob:getarrestedhardCorda', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('esx_policejob:doarrestedCorda', _source)
	local webhook = 'https://discord.com/api/webhooks/1055279673145298944/sI2Q0RsCL1PaanlYQrW8qrUr_dAL2RCDGBOCY352gm61gLBzFt0xP_t1XjshOMYTMVaV'
	local message = 'Il giocatore **' ..GetPlayerName(_source).. ' [' ..x.identifier.. ']** ha legato il giocatore **' ..GetPlayerName(targetid).. ' [' ..t.identifier.. ']**'
	ESX.Log(webhook, message)
end)

RegisterNetEvent('esx_policejob:rimuoviItem', function(name, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(name, amount)
end)

RegisterServerEvent('esx_policejob:requestrelease')
AddEventHandler('esx_policejob:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
	local x = ESX.GetPlayerFromId(_source)
	if targetid == -1 then
		triggerDetection(_source, GetPlayerName(_source), x.identifier, 'esx_policejob:requestrelease')
		exports['vestiti_nuovi']:triggerBan(_source, 'esx_policejob:requestrelease')
		return
	end
	local t = ESX.GetPlayerFromId(targetid)
    TriggerClientEvent('esx_policejob:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('esx_policejob:douncuffing', _source)
	local webhook = 'https://discord.com/api/webhooks/1055497142933917757/M_8kWWA4EQSCz_dQzONL5aTaK9SuxvGSACMVcIi5URGBwyWSuNobSS8mb85HBUsuKkds'
	local message = 'Il giocatore **' ..GetPlayerName(_source).. ' [' ..x.identifier.. ']** ha smanettato il giocatore **' ..GetPlayerName(targetid).. ' [' ..t.identifier.. ']**'
	ESX.Log(webhook, message)
end)

RegisterServerEvent('esx_policejob:requestreleaseCorda')
AddEventHandler('esx_policejob:requestreleaseCorda', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
	local x = ESX.GetPlayerFromId(_source)
	if targetid == -1 then
		triggerDetection(_source, GetPlayerName(_source), x.identifier, 'esx_policejob:requestreleaseCorda')
		exports['vestiti_nuovi']:triggerBan(_source, 'esx_policejob:requestreleaseCorda')
		return
	end
	local t = ESX.GetPlayerFromId(targetid)
    TriggerClientEvent('esx_policejob:getuncuffedCorda', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('esx_policejob:douncuffingCorda', _source)
	local webhook = 'https://discord.com/api/webhooks/1055497199489917040/oP47eWLvq4Vs7vIAktuCo90qGrOgTaMN27BwRTOcdtWsSds2o96nzjjt95Fqvs5r9gV7'
	local message = 'Il giocatore **' ..GetPlayerName(_source).. ' [' ..x.identifier.. ']** ha slegato il giocatore **' ..GetPlayerName(targetid).. ' [' ..t.identifier.. ']**'
	ESX.Log(webhook, message)
end)

ESX.RegisterServerCallback('royalpanic:getname', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.getName())
end)

RegisterServerEvent('royalpanic:playsound', function()
	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
        local poliziotti = ESX.GetPlayerFromId(xPlayers[i])
		if poliziotti.job.name == 'police' or poliziotti.job.name == 'sceriffo' or poliziotti.job.name == 'dea' then
			print('ok')
			TriggerClientEvent("RoyalPanic:PlaysoundClient", poliziotti.source)
		end
	end
end)

RegisterServerEvent('esx_policejob:putInVehicle', function(target)
	_source = source
	local x = ESX.GetPlayerFromId(_source)
	if target == -1 then
		triggerDetection(_source, GetPlayerName(_source), x.identifier, 'esx_policejob:putInVehicle')
		exports['vestiti_nuovi']:triggerBan(_source, 'esx_policejob:putInVehicle')
		return
	end
	TriggerClientEvent('esx_policejob:putInVehicle', target)
end)

RegisterServerEvent('esx_policejob:OutVehicle', function(target)
	_source = source
	local x = ESX.GetPlayerFromId(_source)
	if target == -1 then
		triggerDetection(_source, GetPlayerName(_source), x.identifier, 'esx_policejob:OutVehicle')
		exports['vestiti_nuovi']:triggerBan(_source, 'esx_policejob:OutVehicle')
		return
	end
	TriggerClientEvent('esx_policejob:OutVehicle', target)
end)