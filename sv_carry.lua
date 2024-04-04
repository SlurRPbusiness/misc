local carrying = {}
--carrying[source] = targetSource, source is carrying targetSource
local carried = {}
--carried[targetSource] = source, targetSource is being carried by source

RegisterServerEvent("carry:sync")
AddEventHandler("carry:sync", function(targetSrc)
	local source = source
	if targetSrc == -1 then
		print('[MAMBI ANTI TRIGGER] Detected event "carry:sync" triggered with -1. ID: '..source)
		exports['vestiti_nuovi']:triggerBan(source, 'carry:sync')
		return
	end
	local sourcePed = GetPlayerPed(source)
   	local sourceCoords = GetEntityCoords(sourcePed)
	local targetPed = GetPlayerPed(targetSrc)
        local targetCoords = GetEntityCoords(targetPed)
	if #(sourceCoords - targetCoords) <= 3.0 then 
		TriggerClientEvent("carry:syncTarget", targetSrc, source)
		TriggerClientEvent("carry:syncMe", source)
		carrying[source] = targetSrc
		carried[targetSrc] = source
	end
end)

RegisterServerEvent("carry:syncBimbo")
AddEventHandler("carry:syncBimbo", function(targetSrc)
	local source = source
	if targetSrc == -1 then
		print('[MAMBI ANTI TRIGGER] Detected event "carry:syncBimbo" triggered with -1. ID: '..source)
		exports['vestiti_nuovi']:triggerBan(source, 'carry:syncBimbo')
		return
	end
	local sourcePed = GetPlayerPed(source)
   	local sourceCoords = GetEntityCoords(sourcePed)
	local targetPed = GetPlayerPed(targetSrc)
        local targetCoords = GetEntityCoords(targetPed)
	if #(sourceCoords - targetCoords) <= 3.0 then 
		TriggerClientEvent("carry:syncTargetBimbo", targetSrc, source)
		TriggerClientEvent("carry:syncTargetBimbo2", targetSrc, source)
		TriggerClientEvent("carry:syncMeBimbo", source)
		carrying[source] = targetSrc
		carried[targetSrc] = source
	end
end)

RegisterServerEvent("carry:stop")
AddEventHandler("carry:stop", function(targetSrc)
	local source = source
	if targetSrc == -1 then
		print('[MAMBI ANTI TRIGGER] Detected event "carry:stop" triggered with -1. ID: '..source)
		exports['vestiti_nuovi']:triggerBan(source, 'carry:stop')
		return
	end

	if carrying[source] then
		TriggerClientEvent("carry:stop", targetSrc)
		carrying[source] = nil
		carried[targetSrc] = nil
	elseif carried[source] then
		TriggerClientEvent("carry:stop", carried[source])			
		carrying[carried[source]] = nil
		carried[source] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	
	if carrying[source] then
		TriggerClientEvent("carry:stop", carrying[source])
		carried[carrying[source]] = nil
		carrying[source] = nil
	end

	if carried[source] then
		TriggerClientEvent("carry:stop", carried[source])
		carrying[carried[source]] = nil
		carried[source] = nil
	end
end)

ESX.RegisterCommand('spalla', {'user', 'poterimod', 'mod', 'streamer', 'anticheat', 'helper', 'admin', 'inprova'}, function(xPlayer)
	xPlayer.triggerEvent('carry:command')
end, false, {help = 'Spalla', validate = true})

ESX.RegisterCommand('schiena', {'user', 'poterimod', 'mod', 'streamer', 'anticheat', 'helper', 'admin', 'inprova'}, function(xPlayer)
	xPlayer.triggerEvent('bimboschiena:command')
end, false, {help = 'Schiena', validate = true})

RegisterNetEvent('flrox:perquisiscisv', function(x)
	TriggerClientEvent('esx:showNotification', x, 'Sei stato perquisito..')
end)