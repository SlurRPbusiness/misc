ESX = exports.es_extended:getSharedObject()


ESX.RegisterServerCallback('esx_impound:impound_vehicle', function(source, cb, plate)
  ImpoundVehicle(plate)
  cb()
end)

ESX.RegisterServerCallback('esx_impound:retrieve_vehicle', function(source, cb, plate)
  RetrieveVehicle(plate)
  cb()
end)

ESX.RegisterServerCallback('esx_impound:get_vehicle_list', function(source, cb)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local vehicles = {}

  MySQL.Async.fetchAll("SELECT * FROM veicoli_sequestrati", function(data)
    for _,v in pairs(data) do
      local vehicle = json.decode(v.vehicle)
      table.insert(vehicles, {vehicle = vehicle, state = v.state, can_release = VehicleEligableForRelease(v)})
    end
    cb(vehicles)
  end)
end)

ESX.RegisterServerCallback('esx_impound:check_money', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.get('money') >= Config.ImpoundFineAmount then
    xPlayer.removeAccountMoney('bank', Config.ImpoundFineAmount)
    cb(true)
  else
    cb(false)
  end
end)

ESX.RegisterServerCallback('esx_impound:cerca_targa', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM veicoli_sequestrati WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1] ~= nil then
			MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)
				cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
			end)
		else
			cb('Sconosciuto', false)
		end
	end)
end)

function ImpoundVehicle(plate)
  local current_time = os.time(os.date("!*t"))
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate LIMIT 1', {
      ['@plate'] = plate
    }, function(vehicles)
      ProcessImpoundment(plate, current_time, vehicles)
    end)
end

function ProcessImpoundment(plate, current_time, vehicles)
  local modello
  for index, vehicle in pairs(vehicles) do
    -- Insert vehicle into impound table
    MySQL.Async.execute("INSERT INTO `veicoli_sequestrati` (`plate`, `vehicle`, `owner`, `impounded_at`, `vehiclename`, `modelname`, `proprietario`) VALUES(@plate, @vehicle, @owner, @timestamp, @vehiclename, @modelname, @proprietario)", {
      ['@plate'] = plate,
      ['@vehicle'] = vehicle.vehicle,
      ['@owner'] = vehicle.owner,
      ['@timestamp'] = current_time,
      ['@vehiclename'] = vehicle.vehiclename,
      ['@modelname'] = vehicle.modelname,
      ['@proprietario'] = vehicle.proprietario,
    })
    modello = vehicle.modelname
    MySQL.Async.execute("DELETE FROM owned_vehicles WHERE plate=@plate LIMIT 1", {['@plate'] = vehicle.plate})
  end

  if modello == nil then
    modello = 'NULL'
  end
  
  local webhook = 'https://discord.com/api/webhooks/1063854262708342801/50LPgBvbp7-LDrLOLixrIA7w0ROPC6veH9wbtWXy8B8Rfn5p6m6NoWw_RKru1KDRTaMH'
  local message = 'Il veicolo **' ..modello.. '** con targa **' ..plate.. '** è stato sequestrato.'
  ESX.Log(webhook, message)
end

function RetrieveVehicle(plate)
  MySQL.Async.fetchAll('SELECT * FROM veicoli_sequestrati WHERE plate = @plate LIMIT 1', {
    ['@plate'] = plate
  }, function(vehicles)
    for index, vehicle in pairs(vehicles) do
      -- Insert vehicle into owned_vehicles table
      if Config.OwnedVehiclesHasPlateColumn then
        MySQL.Async.execute("INSERT INTO `owned_vehicles` (`plate`, `vehicle`, `owner`, `stored`, `vehiclename`, `modelname`, `proprietario`) VALUES(@plate, @vehicle, @owner, '0', @vehiclename, @modelname, @proprietario)",
          {
            ['@plate'] = plate,
            ['@vehicle'] = vehicle.vehicle,
            ['@owner'] = vehicle.owner,
            ['@vehiclename'] = vehicle.vehiclename,
            ['@modelname'] = vehicle.modelname,
            ['@proprietario'] = vehicle.proprietario,
          }
        )
      else
        MySQL.Async.execute("INSERT INTO `owned_vehicles` (`vehicle`, `owner`, `stored`, `vehiclename`, `modelname`, `proprietario`) VALUES (@vehicle, @owner, '0', @vehiclename, @modelname, @proprietario)",
          {
            ['@vehicle'] = vehicle.vehicle,
            ['@owner'] = vehicle.owner,
            ['@vehiclename'] = vehicle.vehiclename,
            ['@modelname'] = vehicle.modelname,
            ['@proprietario'] = vehicle.proprietario,
          }
        )
      end
      -- Delete vehicle from Impound Lot
      MySQL.Async.execute("DELETE FROM veicoli_sequestrati WHERE id=@id LIMIT 1", {['@id'] = vehicle.id})
    end
  end)
  local webhook = 'https://discord.com/api/webhooks/1063854262708342801/50LPgBvbp7-LDrLOLixrIA7w0ROPC6veH9wbtWXy8B8Rfn5p6m6NoWw_RKru1KDRTaMH'
  local message = 'Il veicolo con targa **' ..plate.. '** è stato dissequestrato.'
  ESX.Log(webhook, message)
end

function VehicleEligableForRelease(vehicle)
  local current_time = os.time(os.date("!*t"))
  return true
end