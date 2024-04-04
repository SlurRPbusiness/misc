local ox_inventory = exports.ox_inventory
local Case = {}
local CaseForClient = {}



GetAccessindtheHome = function (src,home)
    return false
end

ESX.RegisterServerCallback("royal:getHome", function(src,cb)
    cb(CaseForClient)
end)

CreateThread(function ()
    local temp = json.decode(LoadResourceFile(GetCurrentResourceName(), "data.json"))
    if temp then
        for id_home, data in pairs(temp) do
            if not data then return end
            CreaCasa(id_home,data)
            exports.ox_inventory:RegisterStash('casa_personale_'.. id_home, 'Deposito Casa [PERSONALE]', 60, 100000, id_home.owner)
            MySQL.Async.fetchAll('SELECT name, slots, peso FROM flr_inventari WHERE name = @name',{       
                ['@name'] = 'casa_personale_'.. id_home
                }, function (risultato)
                    if (risultato[1] ~= nil) then
                        slotsfinal = risultato[1].slots
                        exports.ox_inventory:RegisterStash('casa_personale_'.. id_home, 'Deposito Casa [PERSONALE]', json.decode(slotsfinal), risultato[1].peso*1000, id_home.owner)
                    else
                        MySQL.Async.execute('INSERT INTO flr_inventari (name, slots, peso) VALUES (@name, @slots, @peso)',
                        {
                            ['@name']   = 'casa_personale_'.. id_home,
                            ['@slots'] = 60,
                            ['@peso'] = 100
                        }, function ()
                        --print('^2[royal-factions] ^0Inventario ^2' ..e.. ' ^0registrato con successo [^1CONFIG^0]')
                    end)
                end
            end)
            CaseForClient[id_home] = {
                owner =  Case[id_home].owner,
                enter =  Case[id_home].enter,
                shell =  Case[id_home].shell,
                price =  Case[id_home].price,
                vip = Case[id_home].vip
            }
        end
    end
end)



ESX.RegisterServerCallback("royal:JoinInHome",function (src,cb,id_home)
	if Case[id_home] then
        Case[id_home].joinInHome(src)
        cb(true)
    else
        --Questa abitazione non esiste
    end
end)

ESX.RegisterServerCallback("royal:VisitaInHome",function (src,cb,id_home)
	if Case[id_home] then
        Case[id_home].joinInHome(src, true)
        cb(true)
    else
        --Questa abitazione non esiste
    end
end)

RegisterServerEvent("royal:LeavefromHome",function (id_home)
    local src = source

	if Case[id_home] then
        Case[id_home].leaveHome(src)
    else
        --Questa abitazione non esiste
    end
end)

ESX.RegisterServerCallback("royal:Citifona",function (src,cb,id_home)
	if Case[id_home] then
        Case[id_home].requestJoin(src)
        cb(true)
    else
        --Questa abitazione non esiste
    end
end)

RegisterServerEvent("royal:JoinInTheHomeFromCitofono",function (idplayer,id_home)
	if Case[id_home] then
        Case[id_home].joinInHome(idplayer)
    else
        --Questa abitazione non esiste
    end
end)

RegisterServerEvent("royal:Buy",function (id_home)
    local src = source
	if Case[id_home] then
        local xPlayer = ESX.GetPlayerFromId(src)
        if Case[id_home].owner ~= false then
            xPlayer.showNotification('Qualcuno ha già acquistato questa proprietà!')
            return
        end
        if  xPlayer.getMoney() >= Case[id_home].price then
            --xPlayer.removeMoney(Case[id_home].price)
            xPlayer.removeInventoryItem('money', Case[id_home].price)
            CaseForClient[id_home].owner = xPlayer.identifier
            Case[id_home].updateOwner(xPlayer.identifier)
            exports.ox_inventory:RegisterStash('casa_personale_'.. id_home, 'Deposito Casa [PERSONALE]', 60, 100000, xPlayer.identifier)
            TriggerClientEvent("royal:updatehomeforall",-1,id_home,CaseForClient[id_home])
        else
            xPlayer.showNotification('Non hai abbastanza soldi in contanti!')
        end
    end
end)






CreaCasa = function (id, data)
    if json.encode(data) == '[]' then return end
    local casa = {}
    
    casa.id = id

    casa.owner = data.owner or false
    casa.vip = data.vip or false
    casa.enter = data.enter
    casa.shell = data.shell
    casa.price = data.price or 0
    casa.players = {}

    if casa.owner then
        exports.ox_inventory:RegisterStash('casa_personale_'.. id, 'Deposito Casa [PERSONALE]', 60, 1000000, casa.owner)
    end
    
    casa.joinInHome = function (src, visita)
        src = tonumber(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        if casa.shell == 'LoftVip2' then
            TriggerClientEvent('Mambi:EntraCasaShell', src)
            Wait(800)
            SetEntityCoords(GetPlayerPed(src), Shells[casa.shell].coords)
        else
            TriggerClientEvent('Mambi:FaiAnimSchermo', src)
            Wait(800)
            SetEntityCoords(GetPlayerPed(src), Shells[casa.shell].coords)
        end
        SetPlayerRoutingBucket(src, casa.id)
        TriggerClientEvent("royal:update:ultimahome", src, casa.id)
        if not visita then
            for key, value in pairs(casa.players) do
                TriggerClientEvent("esx:showNotification", key, xPlayer.getName().." è entrato in casa!")
            end
            casa.players[src] = true  
        end
    end
    
    casa.leaveHome = function (src, invisita)
        local xPlayer = ESX.GetPlayerFromId(src)
        TriggerClientEvent('Mambi:FaiAnimSchermo', src)
        Wait(800)
        SetEntityCoords(GetPlayerPed(src), casa.enter.x, casa.enter.y, casa.enter.z)
        SetPlayerRoutingBucket(src, 0)
        casa.players[src] = nil
        if not invisita then
            for key, value in pairs(casa.players) do
                TriggerClientEvent("esx:showNotification", key, xPlayer.getName().." è uscito dalla casa!")
            end  
        end
    end
    
    casa.requestJoin = function (src)
        local xplayer = ESX.GetPlayerFromId(src)
        local xOwner = ESX.GetPlayerFromIdentifier(casa.owner)
        if xOwner then
            if casa.players[xOwner.source] then
                xOwner.triggerEvent("royal:RequestjoinHome", casa.id, xplayer.getName(), src)
                --hai mandato la richiesta al proprietario, attendi che accetti o rifiuti
            else
                TriggerClientEvent('esx:showNotification', 'Il proprietario non è in casa')
            end
        else
            --il proprietario non è in citta
        end
    end
    
    casa.updateShell = function (data)
        casa.shell = data
    end
    
    casa.updateOwner = function (data)
        casa.owner = data
    end
    
    casa.updateEnter = function (data)
        casa.enter = data
    end
    Case[id]  = casa
end

local GenerateHomeId = function ()
    ::regenerate::
    local i = math.random(9999,999999)
    if Case[i] then
        goto regenerate
    end
    return i
end


RegisterServerEvent('royal_misc:creacasa', function (fafa,prezzo)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not fafa or not prezzo then return end
    fafa = tostring(fafa) 
    prezzo = tonumber(prezzo)
    local src = source
    local coordsenter = GetEntityCoords(GetPlayerPed(src))
    local id_home = GenerateHomeId()
            CreaCasa(id_home, {owner = xPlayer.identifier, enter = coordsenter, shell = fafa, price = prezzo})
            local webhook = 'https://discord.com/api/webhooks/1083308052922519572/guJrrDo8kVOP7RCO9K-LhOtmzc-Aqx4wIcDkmODyRRvjEOQxVs5JYiynZGtlwxDNJ3Xf'
            ESX.Log(webhook, "Il player **".. GetPlayerName(src) .."** ha creato la casa id **".. id_home .."** al prezzo di **".. prezzo .."**")
            local new  = {
                owner =  Case[id_home].owner,
                enter =  Case[id_home].enter,
                shell =  Case[id_home].shell,
                price =  Case[id_home].price,
                vip = Case[id_home].vip
            }
            CaseForClient[id_home] = new
    TriggerClientEvent("royal:updatehomeforall",-1,id_home,CaseForClient[id_home])
     
    
end)



RegisterCommand("createhouse",function (src,args)
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.getGroup() == 'admin' then
        if args and args[1] and tonumber(args[2]) then


        if Shells[args[1]] then
            local vip = false
            local coordsenter = GetEntityCoords(GetPlayerPed(src))
            local price = tonumber(args[2])
            local id_home = GenerateHomeId()
            if Shells[args[1]].vip then
                vip = true
            else
                vip = false
            end
            print(Shells[args[1]].vip)
            CreaCasa(id_home, {enter = coordsenter, shell = args[1], price = price, vip = vip})
            local new  = {
                owner =  Case[id_home].owner,
                enter =  Case[id_home].enter,
                shell =  Case[id_home].shell,
                price =  Case[id_home].price,
                vip = Case[id_home].vip
            }
            CaseForClient[id_home] = new

            TriggerClientEvent("royal:updatehomeforall",-1,id_home,CaseForClient[id_home])
        else
           print('non esiste nessuna shels con questo nome')
        end
    else
        xPlayer.showNotification('Il corretto utilizzo è: /createhouse [SHELL] [PREZZO]')
    end
    end
end, false)



local SaveAllData = function()
	SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(CaseForClient, {indent = true}), -1)
end

RegisterCommand('saveallhouse', function(src)
    local x = ESX.GetPlayerFromId(src)
    if x.getGroup() == 'admin' then
        SaveAllData()
        x.showNotification('Hai salvato correttamente tutte le case!')
    end
end)


RegisterCommand('deletehouse', function(src, args)
    local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.getGroup() == 'admin' then
            if args[1] == nil then
                xPlayer.showNotification('Inserisci l\'id della casa!')
            else
                CaseForClient[args[1]] = nil
                SaveAllData()
                TriggerClientEvent("royal:updatehomeforall",-1, args[1],CaseForClient[args[1]])
                TriggerClientEvent('Mambi:unregistermarker', -1, args[1])
                SaveAllData()
            end
        end
    end)


SetInterval(function()
	SaveAllData()
end, 600000)


AddEventHandler('playerDropped', function()
	if GetNumPlayerIndices() == 0 then
		SaveAllData()
	end
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function()
	SaveAllData()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		SaveAllData()
    end
end)


RegisterServerEvent("royal:ChiaviGeneraChiavi",function (id_home,nota)
    local src = source
	if Case[id_home] then
        local xPlayer = ESX.GetPlayerFromId(src)
        ox_inventory:AddItem(xPlayer.source, "chiavecasa", 1, {description = nota, type = id_home, index = id_home})
    else
        exports['vestiti_nuovi']:triggerBan(src, 'royal:ChiaviGeneraChiavi')
    end
end)
