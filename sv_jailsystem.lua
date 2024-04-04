local Jail = {}

local function JailPlayer(prison, time)
	local self = {}

	self.prison = prison
	self.time	= time

	local class = {}

	class.get = function(k)
		return self[k]
	end

	class.set = function(k, v)
		self[k] = v
	end

	return class
end

local function getUser(identifier, cb)
	if(Jail[identifier])then
		cb(Jail[identifier])
	else
		cb(false)
	end
end

AddEventHandler('playerDropped', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier
	if xPlayer then
		identifier = xPlayer.identifier
	else
		identifier = '1:' ..GetPlayerIdentifiers(source)[1]
	end

	for k, v in pairs(Jail) do
		if(k == identifier)then
			MySQL.Sync.execute('UPDATE users SET jail = @data WHERE identifier = @identifier', {
				identifier = identifier,
				data = json.encode({prison = v.get('prison'), time = v.get('time')})
			})
		end
	end
end)

AddEventHandler('onMySQLReady', function()
		local result = MySQL.Sync.fetchAll('SELECT * FROM users')

		if(result[1])then
			for _, v in ipairs(result) do
				if(v.jail and v.jail ~= 0)then
					local data = json.decode(v.jail)
					if(data and data ~= 0)then
						local identifier = v.identifier
						Jail[identifier] = JailPlayer(data.prison, data.time)
					end
				end
			end
		end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(src)
	local xPlayer = ESX.GetPlayerFromId(src)
	local identifier
	if xPlayer then
		identifier = xPlayer.identifier
	else
		identifier = '1:' ..GetPlayerIdentifiers(src)[1]
	end

	for k, v in pairs(Jail) do
		if(k == identifier)then

			local time = tonumber(v.get('time')) * 60
			TriggerClientEvent(v.get('prison'), src, time)
		end
	end
end)


RegisterServerEvent('updateJailTime')
AddEventHandler('updateJailTime', function(time)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local identifier
	if xPlayer then
		identifier = xPlayer.identifier
	else
		identifier = '1:' ..GetPlayerIdentifiers(src)[1]
	end

	getUser(identifier, function(user)
		user.set('time', time)
	end)
end)

RegisterServerEvent('unjailPlayer')
AddEventHandler('unjailPlayer', function()
	local src = source
	local identifier = GetPlayerIdentifiers(src)[1]
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET jail = @data WHERE identifier = @identifier', {data = 0, identifier = xPlayer.identifier})
	Jail[identifier] = nil

end)

RegisterServerEvent('jail:cortile')
AddEventHandler('jail:cortile', function(pl, tempo)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local zPlayer = ESX.GetPlayerFromId(pl)
    local defaultsecs = 5
	local spese = 235
	
	if xPlayer.job.name == 'police' or xPlayer.job.name == 'sceriffo' or xPlayer.job.name == 'fbi' or xPlayer.job2.name == 'dea' or xPlayer.job.name == 'cia' then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'.. xPlayer.job.name, function(account)
			societyAccount = account
		end)
	
		jTsecs = tempo * 60

		if tonumber(pl) ~= nil and tonumber(tempo) ~= nil then
			if xPlayer.job.name == 'police' or xPlayer.job.name == 'sceriffo' or xPlayer.job.name == 'fbi' or xPlayer.job2.name == 'dea' or xPlayer.job.name == 'cia' then
			TriggerClientEvent("JPC", pl, jTsecs)
			societyAccount.addMoney(spese)
			zPlayer.removeAccountMoney('bank', spese)
			TriggerClientEvent("esx:showNotification", source, 'Hai messo in carcere ' .. GetPlayerName(pl) .. '!')
			TriggerClientEvent("esx:showNotification", pl, 'Sei stato messo in carcere per ' .. tempo .. ' minuti!')
			TriggerClientEvent("esx:showNotification", _source, 'Il detenuto ha pagato 235$ di spese!')
			TriggerClientEvent("esx:showNotification", pl, 'Ti sono stati addebbitati 235$ di spese!')

			local identifier = zPlayer.identifier
			Jail[identifier] = JailPlayer("JPC", jTsecs)
			MySQL.Async.execute('UPDATE users SET jail = @data WHERE identifier = @identifier', {data = 1, identifier = zPlayer.identifier})
			local webhook = 'https://discord.com/api/webhooks/1055280223203119125/JdmtzY1xajBIZvpGQu0xfsYlWV9IiV9ymBoPH1YnlGvbYA1XGqgKwrRKhr0kcUR36Bei'
			local message = 'Il giocatore ** '..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** ha messo in carcere il giocatore **' ..GetPlayerName(pl).. ' [' ..zPlayer.identifier.. ']** per un totale di **' ..tempo.. '** minuti.'
			ESX.Log(webhook, message)
			end
		end
	end
end)

RegisterServerEvent('jail:libera')
AddEventHandler('jail:libera', function(achiquattro)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local zPlayer = ESX.GetPlayerFromId(achiquattro)
    local defaultsecs = 5
    local spese = 235

	if tonumber(achiquattro) ~= nil then
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'sceriffo' or xPlayer.job.name == 'fbi' or xPlayer.job2.name == 'dea' or xPlayer.job.name == 'cia' then
		TriggerClientEvent("UnJP", achiquattro)
		TriggerClientEvent("esx:showNotification", source, 'Hai scarcerato ' .. GetPlayerName(achiquattro))
		TriggerClientEvent("esx:showNotification", achiquattro, 'Sei stato scarcerato!')
		local identifier = zPlayer.identifier
		Jail[identifier] = nil
		MySQL.Async.execute('UPDATE users SET jail = @data WHERE identifier = @identifier', {data = 0, identifier = zPlayer.identifier})
		local webhook = 'https://discord.com/api/webhooks/1055281251830997042/_PIx8JAqRzkPBrX4DZx0wmOYqfCBXX2-wvuclBzETYYdqO5Vqs2cGHI378do91LZHzg_'
		local message = 'Il giocatore ** '..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** ha scarcerato il giocatore **' ..GetPlayerName(achiquattro).. ' [' ..zPlayer.identifier.. ']**'
		ESX.Log(webhook, message)
	end
end
end)