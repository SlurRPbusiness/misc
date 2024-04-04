local takingHostage = {}
--takingHostage[source] = targetSource, source is takingHostage targetSource
local takenHostage = {}
--takenHostage[targetSource] = source, targetSource is being takenHostage by source

RegisterServerEvent("TakeHostage:sync")
AddEventHandler("TakeHostage:sync", function(targetSrc)
	local source = source

	if targetSrc == -1 then
		print('[MAMBI ANTI TRIGGER] Detected event "TakeHostage:sync" triggered with -1. ID: '..source)
		exports['vestiti_nuovi']:triggerBan(source, 'TakeHostage:sync')
		return
	end

	TriggerClientEvent("TakeHostage:syncTarget", targetSrc, source)
	takingHostage[source] = targetSrc
	takenHostage[targetSrc] = source
end)

RegisterServerEvent("TakeHostage:releaseHostage")
AddEventHandler("TakeHostage:releaseHostage", function(targetSrc)
	local source = source
	if targetSrc == -1 then
		print('[MAMBI ANTI TRIGGER] Detected event "TakeHostage:releaseHostage" triggered with -1. ID: '..source)
		exports['vestiti_nuovi']:triggerBan(source, 'TakeHostage:releaseHostage')
		return
	end

	if takenHostage[targetSrc] then 
		TriggerClientEvent("TakeHostage:releaseHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
	
end)

RegisterServerEvent("TakeHostage:killHostage")
AddEventHandler("TakeHostage:killHostage", function(targetSrc)
	local source = source
	if targetSrc == -1 then
		print('[MAMBI ANTI TRIGGER] Detected event "TakeHostage:killHostage" triggered with -1. ID: '..source)
		exports['vestiti_nuovi']:triggerBan(source, 'TakeHostage:killHostage')
		return
	end
	if takenHostage[targetSrc] then 
		TriggerClientEvent("TakeHostage:killHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
end)

RegisterServerEvent("TakeHostage:stop")
AddEventHandler("TakeHostage:stop", function(targetSrc)
	local source = source

	if targetSrc == -1 then
		print('[MAMBI ANTI TRIGGER] Detected event "TakeHostage:stop" triggered with -1. ID: '..source)
		exports['vestiti_nuovi']:triggerBan(source, 'TakeHostage:stop')
		return
	end

	if takingHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", targetSrc)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	elseif takenHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", targetSrc)
		takenHostage[source] = nil
		takingHostage[targetSrc] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	
	if takingHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", takingHostage[source])
		takenHostage[takingHostage[source]] = nil
		takingHostage[source] = nil
	end

	if takenHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", takenHostage[source])
		takingHostage[takenHostage[source]] = nil
		takenHostage[source] = nil
	end
end)
