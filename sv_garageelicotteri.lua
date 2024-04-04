local ESX = exports.es_extended:getSharedObject()

RegisterNetEvent('royal_garageelicotteri:SalvaGarage', function(plate, garage)
	MySQL.Async.execute('UPDATE owned_elicotteri SET `garage` = @garage WHERE `plate` = @plate', {
		['@plate'] = plate,
		['@garage'] = garage
	}, function(rowsChanged)
	end)
end)

ESX.RegisterServerCallback('royal_garageelicotteri:isOwned', function(source, cb, plate)

	local s = source
	local x = ESX.GetPlayerFromId(s)

	local s = source
	local x = ESX.GetPlayerFromId(s)
	
	MySQL.Async.fetchAll('SELECT `vehicle` FROM owned_elicotteri WHERE `plate` = @plate AND `owner` = @owner', {['@plate'] = plate, ['@owner'] = x.identifier}, function(vehicle)
		if next(vehicle) then
			cb(true)
		else
			cb(false)
		end
	end)
end)

RegisterNetEvent('royal_garageelicotteri:changeState')
AddEventHandler('royal_garageelicotteri:changeState', function(plate, state)
	if state == false then
		state = 0
	else 
		state = 1
	end
	MySQL.Sync.execute("UPDATE owned_elicotteri SET `stored` = @state WHERE `plate` = @plate", 
	{
		['@state'] = state, 
		['@plate'] = plate
	})
end)

Citizen.CreateThread(function()
	MySQL.Async.execute('UPDATE owned_elicotteri SET `stored` = true WHERE `stored` = @stored', {
		['@stored'] = false
	}, function(rowsChanged)
		if rowsChanged > 0 then
			print(('ELICOTTERI: %s sono stati rimessi nel garage!'):format(rowsChanged))
		end
	end)
end)

ESX.RegisterServerCallback('royalgarage:veicolisequestrati', function(source, cb)
	local ownedCars = {}
	local s = source
	local x = ESX.GetPlayerFromId(s)
	
	MySQL.Async.fetchAll('SELECT * FROM veicoli_sequestrati WHERE `owner` = @owner ', {['@owner'] = x.identifier}, function(vehicles)

		for _,v in pairs(vehicles) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, {vehicle = vehicle, plate = v.plate, label = v.vehiclename, modelname = v.modelname})
		end
		cb(ownedCars)
	end)
end)

ESX.RegisterServerCallback('royal_garageelicotteri:loadVehicles', function(source, cb)
	local ownedCars = {}
	local s = source
	local x = ESX.GetPlayerFromId(s)
	
	MySQL.Async.fetchAll('SELECT * FROM owned_elicotteri WHERE `owner` = @owner AND `stored` = 1', {['@owner'] = x.identifier}, function(vehicles)

		for _,v in pairs(vehicles) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate, label = v.vehiclename, modelname = v.modelname})
		end
		cb(ownedCars)
	end)
end)

RegisterNetEvent('royal_garageelicotteri:saveProps')
AddEventHandler('royal_garageelicotteri:saveProps', function(plate, props)
	local xProps = json.encode(props)
	MySQL.Sync.execute("UPDATE owned_elicotteri SET `vehicle` = @props WHERE `plate` = @plate", {['@plate'] = plate, ['@props'] = xProps})
end)