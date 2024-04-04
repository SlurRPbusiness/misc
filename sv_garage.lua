local ESX = exports.es_extended:getSharedObject()

RegisterServerEvent('mambi_garage:pagaRecupero', function()
    local xP = ESX.GetPlayerFromId(source)
    xP.removeAccountMoney('bank', 1500)
end)

RegisterNetEvent('garage:SalvaGarage', function(plate, garage)
	MySQL.Async.execute('UPDATE owned_vehicles SET `garage` = @garage WHERE `plate` = @plate', {
		['@plate'] = plate,
		['@garage'] = garage
	}, function(rowsChanged)
	end)
end)

ESX.RegisterServerCallback('royal_garage:isOwned', function(source, cb, plate)

	local s = source
	local x = ESX.GetPlayerFromId(s)

	local s = source
	local x = ESX.GetPlayerFromId(s)
	
	MySQL.Async.fetchAll('SELECT `vehicle` FROM owned_vehicles WHERE `plate` = @plate AND `owner` = @owner', {['@plate'] = plate, ['@owner'] = x.identifier}, function(vehicle)
		if next(vehicle) then
			cb(true)
		else
			cb(false)
		end
	end)
end)

RegisterNetEvent('royal_garage:changeState')
AddEventHandler('royal_garage:changeState', function(plate, state)
	if state == false then
		state = 0
	else 
		state = 1
	end
	MySQL.Sync.execute("UPDATE owned_vehicles SET `stored` = @state WHERE `plate` = @plate", 
	{
		['@state'] = state, 
		['@plate'] = plate
	})
end)

ESX.RegisterServerCallback("betrayed_garage:validateVehicle", function(source, callback, vehicleProps, garage)
	local player = ESX.GetPlayerFromId(source)

	if player then
		local sqlQuery = [[
			SELECT
				owner
			FROM
				owned_vehicles
			WHERE
				plate = @plate and type = @type
		]]

		MySQL.Async.fetchAll(sqlQuery, {
			["@plate"] = vehicleProps["plate"],
			["@type"] = 'car'
		}, function(responses)
			if responses[1] then
				callback(true)
			else
				callback(false)
			end
		end)
	else
		callback(false)
	end
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

ESX.RegisterServerCallback('royal_garage:loadVehicles', function(source, cb)
	local ownedCars = {}
	local s = source
	local x = ESX.GetPlayerFromId(s)
	
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `owner` = @owner', {['@owner'] = x.identifier}, function(vehicles)

		for _,v in pairs(vehicles) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate, label = v.vehiclename, modelname = v.modelname})
		end
		cb(ownedCars)
	end)
end)

RegisterNetEvent('royal_garage:saveProps')
AddEventHandler('royal_garage:saveProps', function(plate, props)
	local xProps = json.encode(props)
	MySQL.Sync.execute("UPDATE owned_vehicles SET `vehicle` = @props WHERE `plate` = @plate", {['@plate'] = plate, ['@props'] = xProps})
end)

Citizen.CreateThread(function()
	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE `stored` = @stored', {
		['@stored'] = false
	}, function(rowsChanged)
	end)
end)