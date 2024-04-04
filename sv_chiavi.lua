--[[RegisterNetEvent('fenixlarue:conc:intestachiavi', function(x, p)
	local xPlayer = ESX.GetPlayerFromId(x)
	metadata = {}
	metadata.type = p
	metadata.targa = p
	metadata.description = 'Chiavi della macchina: ' ..p
	exports.ox_inventory:AddItem(xPlayer.source, 'chiavi', 1, metadata)
	xPlayer.showNotification('Il sistema chiavi è stato disabilitato.')
end)

ESX.RegisterUsableItem('chiavi', function(source, uno, data)
   	local _source  = source
   	local xPlayer  = ESX.GetPlayerFromId(_source)
	print(data.metadata.targa)
	if data.metadata.targa ~= nil then
		TriggerClientEvent("usachiave", source, data.metadata.targa)
	else
		xPlayer.showNotification("Le chiavi non sono collegate a nessuna macchina")
	end
end)

ESX.RegisterServerCallback('mambi:loggachiavi', function(source, cb, id, targa)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xT = ESX.GetPlayerFromId(id)
	local webhook = 'https://discord.com/api/webhooks/1080187915486896178/idBGW8nQwvgjzt9O2haID3aS6VgKqc9eWaykyb2BFmKAyljaM64ax6jbyT3uPJxAVOHW'
	local message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** ha givvato le chiavi con targa: **' ..targa.. '** al giocatore **' ..GetPlayerName(id).. ' [' ..xT.identifier.. ']**'
	ESX.Log(webhook, message)
end)

ESX.RegisterServerCallback('mambi:logschiavi', function(source,cb, x)
	local a = ESX.GetPlayerFromId(x)
	local xP = ESX.GetPlayerFromId(source)
	local webhook = 'https://discord.com/api/webhooks/1083681928722530304/B2PTopNae4SrUYvitBiECYzfs4Seick3dUvgNa4HEhCztuyUNRIIoXTPlDxytOSWkWU-'
	local message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xP.identifier.. ']** ha dato le chiavi con il menu concessionario al giocatore **' ..GetPlayerName(x).. ' [ ' ..a.identifier.. ']**'
	ESX.Log(webhook, message)
	cb()
end)]]

function GetxPlayerVehicles(identifier)
	local vehicles = {}
	local data = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier AND type=@type",{['@identifier'] = identifier, ['@type'] = 'car'})
	for _,v in pairs(data) do
		local vehicle = json.decode(v.vehicle)
		table.insert(vehicles, {id = v.id, plate = vehicle.plate, label = v.vehiclename})
	end
	return vehicles
end

ESX.RegisterServerCallback('mambi:getChiavi', function(source,cb, player)
	local x = ESX.GetPlayerFromId(player)
	cb(GetxPlayerVehicles(x.identifier))
end)