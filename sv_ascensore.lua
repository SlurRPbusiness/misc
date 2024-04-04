-- Kit riparazione
ESX.RegisterUsableItem('fixkit', function(source)
	TriggerClientEvent('royal:riparastocazzodiveicolo', source)
end)

ESX.RegisterUsableItem('kitpulizia', function(source)
    local src = source
    TriggerClientEvent("royal:pulisciveicolo", src)
end)

local autorizzati = {
    '1:steam:11000013c9531df', -- mambi
    '1:steam:110000109e33e84', -- chico
}

function Autorizzato(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	for k, hex in pairs(autorizzati) do
		if hex == xPlayer.identifier then
			return true
		end
	end
end

RegisterCommand('dairegalo', function(source, args, rawCommand)
    local xPlayers = ESX.GetExtendedPlayers()
    if Autorizzato(source) then
        for _, xPlayer in pairs(xPlayers) do
            local gi = ESX.GetPlayerFromId(xPlayer.source)
            gi.showNotification('Hai ricevuto un regalo per un totale di ' ..args[1].. '$')
            gi.addAccountMoney('bank', tonumber(args[1]))
        end
        local webhook = 'https://discord.com/api/webhooks/1066712306836316230/Cvt53hzb3k7YamYoYTa74SQaCQaphxBBgThgyvkQCNZdgA78ZyuyQ7hacJmZAS12f9nR'
        local message = 'Lo staffer **' ..GetPlayerName(source).. '** ha givvato a tutti giocatori un totale di **' ..args[1].. '$**' 
        ESX.Log(webhook, message)
    end
end)

local spectating = {}

function puospectare(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.group ~= 'user' then
        return true
    else
        return false
    end
end

RegisterCommand("spectate", function(source, args, rawCommand)
	local target = args[1]
	local type = "1"
	if spectating[source] then type = "0" end
	TriggerEvent('erp_adminmenu:spectate', target, type == "1", source)
    local webhook = 'https://discord.com/api/webhooks/1132691992275595315/2fMnWnMYHjNCRj27kDVmx8LTUf24K_Qkb-CpmvV1MU3P8-dfOKzyDMfgRLala_4nBjNf'
    local message = 'Lo staffer **' ..GetPlayerName(source).. '** ha spectato il giocatore **' ..GetPlayerName(target).. '$**' 
    ESX.Log(webhook, message)
end)

AddEventHandler('erp_adminmenu:spectate', function(target, on, src)
    local source = src
    if puospectare(source) and target then
        local tPed = GetPlayerPed(target)
        if tPed and DoesEntityExist(tPed) then
            if not on then
                SetEntityDistanceCullingRadius(tPed, 0.0)
                TriggerClientEvent('erp_adminmenu:cancelSpectate', source)
                spectating[source] = nil
            elseif on then
                SetEntityDistanceCullingRadius(tPed, 10000000000000000.0)
                Wait(500)
                TriggerClientEvent('erp_adminmenu:requestSpectate', source, NetworkGetNetworkIdFromEntity(tPed), target, GetPlayerName(target))
                spectating[source] = true
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(30*60000) -- 30 minuti alla pulizia
        TriggerClientEvent('pulisciveh', -1, 1)
        Citizen.Wait(15*60000) -- 15 minuti alla pulizia
        TriggerClientEvent('pulisciveh', -1, 2)
        Citizen.Wait(5*60000) -- 10 minuti alla pulizia
        TriggerClientEvent('pulisciveh', -1, 3)
        Citizen.Wait(5*60000) -- 5 minuti alla pulizia
        TriggerClientEvent('pulisciveh', -1, 4)
        Citizen.Wait(5*60000) -- 5 minuti alla pulizia
        local entity = GetAllVehicles()
        for _,entita in pairs(entity) do
            if not IsPedAPlayer(GetPedInVehicleSeat(entita, -1)) then
                DeleteEntity(entita)
            end
        end
        MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE `stored` = @stored', {
            ['@stored'] = false
        }, function(rowsChanged)
            if rowsChanged > 0 then
                print(('Pulizia veicoli: %s sono stati rimessi nel garage!'):format(rowsChanged))
            end
        end)
	end
end)

--[[RegisterCommand('tokentest', function(source)
    local tokens = {}
    for i=1,GetNumPlayerTokens(source) do
        table.insert(tokens, GetPlayerToken(source, i))
    end
    MySQL.Async.execute('UPDATE bannati SET `tokens` = @tokens WHERE `token` = @token', {
        ['@token'] = GetPlayerToken(source),
        ['@tokens'] = json.encode(tokens)
    }, function(rowsChanged)
    end)
    MySQL.Async.fetchAll('SELECT token, tokens, motivazione, name, banid, bannedby FROM bannati WHERE token = @token',{
        ['@token'] = GetPlayerToken(source)
    }, function (risultato)
        if (risultato[1] ~= nil) then
            if risultato[1].tokens then
                local Playertokens = {}
                for i=1,GetNumPlayerTokens(source) do
					table.insert(Playertokens, GetPlayerToken(source, i))
				end
                local tokensbelli = json.encode(Playertokens)
                if string.find(tokensbelli, risultato[1].tokens) then
                        print('sono uguali negroooo')
                end
            else
                print('nigr')
            end
        end
    end)
end)]]