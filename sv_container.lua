function SetupDatabase(event)
	print(event)
	MySQL.Sync.execute([[
        CREATE TABLE IF NOT EXISTS `flr_container` (
            `owner` varchar(60) DEFAULT NULL,
            `name` varchar(100) NOT NULL,
            `chiavi` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Possiede le chiavi',
            `propietario` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Possiede il deposito',
            `propietario2` tinyint(1) NOT NULL DEFAULT 0,
            UNIQUE KEY `owner` (`owner`,`name`) USING BTREE
          );
  	]], {})

      MySQL.Sync.execute([[
        CREATE TABLE IF NOT EXISTS `flr_inventari` (
            `name` varchar(100) NOT NULL,
            `peso` varchar(255) NOT NULL DEFAULT '0' COMMENT 'Peso',
            `slots` varchar(255) NOT NULL DEFAULT '0' COMMENT 'SLOTS',
            `upgrade` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Upgrade',
            UNIQUE KEY `name` (`name`) USING BTREE
          );
  	]], {})

    
      MySQL.Sync.execute([[
        CREATE TABLE IF NOT EXISTS `flr_listacontainer` (
            `owner` varchar(60) DEFAULT NULL,
            `name` varchar(100) NOT NULL,
            `pin` varchar(4) NOT NULL DEFAULT '0' COMMENT 'pin',
            `acquistato` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Acquistato o No',
            `prezzo` varchar(255) NOT NULL DEFAULT '0' COMMENT 'prezzo',
            UNIQUE KEY `owner` (`name`,`owner`) USING BTREE
          );
  	]], {})

      MySQL.Sync.execute([[
        INSERT INTO `flr_listacontainer` (`name`, `pin`, `acquistato`, `prezzo`) VALUES
        ('Container 3', '0', 0, '1000'),
        ('Container 2', '0', 0, '1000'),
        ('Container 1', '0', 0, '1000');
  	]], {})

end

local function SetupMode(arg)
	print(('^3=================================================================\n^0%s\n^3=================================================================^0'):format(arg))
end

local loop = true
local abilitaloop = true

Citizen.CreateThread(function()
    if Config.Setup then
        while loop do
            if abilitaloop then
        SetupMode([[               ^1Currently running in setup mode
    ^2If you're using for the first time, type '/flrcontainer install'
        
    ^1Remove 'Config.Setup = true' from config.lua and restart the server when you are done]])
            end
            Citizen.Wait(15000)
        end
    end
end)

Citizen.CreateThread(function()
    if source == 0 then
    end
end)

Citizen.CreateThread(function()
    if Config.Setup then
            RegisterCommand('flrcontainer', function(source, args)
                if source == 0 then
                if args[1] == nil then
                    print('^1Comando Non Valido! Parametro Corretto = ^2"flrcontainer install"')
                else
                    if args[1] == 'install' then
                        abilitaloop = false
                            MySQL.ready(function()
                                print('10%')
                                Citizen.Wait(4000)
                                print('40%')
                                Citizen.Wait(7000)
                                print('70%')
                                Citizen.Wait(3500)
                                print('90%')
                                Citizen.Wait(3500)
                                print('100%')
                                SetupDatabase('^2Setup Completato')
                                Citizen.Wait(1500)
                        abilitaloop = true
                    end)
                end
            end
        else
            print('^1| [FLRCONTAINER] | ID: '..source..' You cannot run commands from the client side')
        end
        end)
    end

if not Config.Setup then
    RegisterCommand('flrcontainer', function(source, args)
    if source == 0 then
        if args[1] == nil then
            SetupMode([[               ^1You are not currently running in setup mode
            
    ^1Set 'Config.Setup = true' from config.lua and restart the server when you are done to enable it]])
        else
            if args[1] then
                SetupMode([[               ^1You are not currently running in setup mode
            
    ^1Set 'Config.Setup = true' from config.lua and restart the server when you are done to enable it]])
            end
        end
    else
        print('^1| [FLRCONTAINER] | ID: '..source..' You cannot run commands from the client side')
    end
end)
end
end)

Citizen.CreateThread(function()
if not Config.Setup then
    for k,v in pairs(Config.Container) do
        for e, f in pairs (v) do
	        exports.ox_inventory:RegisterStash(e, 'Deposito ' ..e, f.slots, f.peso*1000)
            MySQL.Async.fetchAll('SELECT name, slots, peso FROM flr_inventari WHERE name = @name',{
                
                ['@name'] = e

            }, function (risultato)
                if (risultato[1] ~= nil) then
                    slotsfinal = risultato[1].slots
                    exports.ox_inventory:RegisterStash(e, e, json.decode(slotsfinal), risultato[1].peso*1000)
                    print('^2[FLR_Container] ^0Inventario ^2' ..e.. ' ^0registrato con successo Slots: [^1SQL^0]')
                else
                    MySQL.Async.execute('INSERT INTO flr_inventari (name, slots, peso) VALUES (@name, @slots, @peso)',
                    {
                        ['@name']   = e,
                        ['@slots'] = f.slots,
                        ['@peso'] = f.peso
                    }, function ()
                        print('^2[FLR_Container] ^0Inventario ^2' ..e.. ' ^0registrato con successo [^1CONFIG^0]')
                    end)
                end
            end)
        end
    end
end
end)

if not Config.Setup then
RegisterNetEvent('fenixlarue:container:daichiave')
AddEventHandler('fenixlarue:container:daichiave', function(target, nomecontainer, source)
    local xTarget = ESX.GetPlayerFromId(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT owner FROM flr_container WHERE owner = @owner AND name = @name AND chiavi = @chiavi', {
		['@owner'] = xTarget.identifier,
		['@name'] = nomecontainer,
        ['@chiavi'] = 1
	}, function(result)
		if result[1] then
            xPlayer.showNotification(Lang_Server.ARLEADY_HAVE_KEYS.. ' '..nomecontainer)
		else
            MySQL.Async.execute('INSERT INTO flr_container (owner, name, chiavi, propietario) VALUES (@owner, @name, @chiavi, @propietario)',
            {
                ['@owner']   = xTarget.identifier,
                ['@name']   = nomecontainer,
                ['@chiavi'] = 1,
                ['@propietario'] = 0
            }, function ()
                if Webhook.Enable then
                FLR_LogSystem(Webhook.AggiunzioneChiavi, 'Il giocatore **' ..GetPlayerName(source).. '** [**' ..xPlayer.identifier.. '**] ha dato le chiavi del container **' ..nomecontainer.. '** al giocatore **' ..GetPlayerName(target).. '** [**' ..xTarget.identifier.. '**]')
                end
                    xPlayer.showNotification(Lang_Server.ASSIGNED_KEYS.. ' ' ..nomecontainer)
                    xTarget.showNotification(Lang_Server.RECEIVED_KEYS.. ' ' ..nomecontainer)
            end)
		end
	end)
end)

RegisterNetEvent('fenixlarue:container:daiproprieta')
AddEventHandler('fenixlarue:container:daiproprieta', function(target, nomecontainer, source)
    local xTarget = ESX.GetPlayerFromId(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT owner FROM flr_container WHERE owner = @owner AND name = @name AND chiavi = @chiavi', {
		['@owner'] = xTarget.identifier,
		['@name'] = nomecontainer,
        ['@chiavi'] = 1
	}, function(result)
		if result[1] then
            MySQL.Async.fetchAll('SELECT owner FROM flr_container WHERE owner = @owner AND name = @name AND propietario = @propietario', {
                ['@owner'] = xTarget.identifier,
                ['@name'] = nomecontainer,
                ['@propietario'] = 1
            }, function(risultato2)
                if risultato2[1] then
                    xPlayer.showNotification(Lang_Server.ARLEADY_HAVE_PROPERTY_XPLAYER)
                    xTarget.showNotification(Lang_Server.ARLEADY_HAVE_PROPERTY_XTARGET)
                end
        end)
		else
            MySQL.Async.execute('INSERT INTO flr_container (owner, name, chiavi, propietario) VALUES (@owner, @name, @chiavi, @propietario)',
            {
                ['@owner']   = xTarget.identifier,
                ['@name']   = nomecontainer,
                ['@chiavi'] = 1,
                ['@propietario'] = 1
            }, function ()
                if Webhook.Enable then
                FLR_LogSystem(Webhook.AggiunzioneProprieta, 'Il giocatore **' ..GetPlayerName(source).. '** [**' ..xPlayer.identifier.. '**] ha dato la proprietà del container **' ..nomecontainer.. '** al giocatore **' ..GetPlayerName(target).. '** [**' ..xTarget.identifier.. '**]')
                end
                xPlayer.showNotification(Lang_Server.ASSIGNED_PROPERTY_XPLAYER..' ' ..nomecontainer)
                xTarget.showNotification(Lang_Server.ASSIGNED_PROPERTY_XTARGET.. ' ' ..nomecontainer)
            end)
		end
	end)
end)

RegisterNetEvent('fenixlarue:container:trasferisciproprieta')
AddEventHandler('fenixlarue:container:trasferisciproprieta', function(target, nomecontainer, source)
    local xTarget = ESX.GetPlayerFromId(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT owner FROM flr_container WHERE owner = @owner AND name = @name AND chiavi = @chiavi', {
		['@owner'] = xTarget.identifier,
		['@name'] = nomecontainer,
        ['@chiavi'] = 1
	}, function(result)
		if result[1] then
            MySQL.Async.fetchAll('SELECT owner FROM flr_container WHERE owner = @owner AND name = @name AND propietario = @propietario', {
                ['@owner'] = xTarget.identifier,
                ['@name'] = nomecontainer,
                ['@propietario'] = 1
            }, function(risultato2)
                if risultato2[1] then
                    MySQL.Sync.execute("DELETE FROM flr_container WHERE name=@name AND owner=@owner AND propietario=@propietario",
                    {
                        ['owner'] = xPlayer.identifier,
                        ['name'] = nomecontainer,
                        ['propietario'] = 1
                    }, function()
                        print('^2[FLR_Container] ^0' ..nomecontainer)
                    end)
                    if Webhook.Enable then
                    FLR_LogSystem(Webhook.TrasferimentoProprieta, 'Il giocatore **' ..GetPlayerName(source).. '** [**' ..xPlayer.identifier.. '**] ha trasferito la proprietà del container **' ..nomecontainer.. '** al giocatore **' ..GetPlayerName(target).. '** [**' ..xTarget.identifier.. '**]')
                    end
                    xPlayer.showNotification(Lang_Server.TRANSFER_PROPERTY_XPLAYER.. ' ' ..nomecontainer)
                    xTarget.showNotification(Lang_Server.TRANSFER_PROPERTY_XTARGET.. ' '..nomecontainer)
        end
    end)
		else
            MySQL.Sync.execute("DELETE FROM flr_container WHERE name=@name AND owner=@owner AND propietario=@propietario",
            {
                ['owner'] = xPlayer.identifier,
                ['name'] = nomecontainer,
                ['propietario'] = 1
            }, function()
                print('^2[FLR_Container] ^0' ..nomecontainer)
            end)
            MySQL.Async.execute('INSERT INTO flr_container (owner, name, chiavi, propietario, propietario2) VALUES (@owner, @name, @chiavi, @propietario. @propietario2)',
            {
                ['@owner']   = xTarget.identifier,
                ['@name']   = nomecontainer,
                ['@chiavi'] = 1,
                ['@propietario'] = 1,
                ['@propietario2'] = 1
            }, function ()
                if Webhook.Enable then
                FLR_LogSystem(Webhook.TrasferimentoProprieta, 'Il giocatore **' ..GetPlayerName(source).. '** [**' ..xPlayer.identifier.. '**] ha trasferito la proprietà del container **' ..nomecontainer.. '** al giocatore **' ..GetPlayerName(target).. '** [**' ..xTarget.identifier.. '**]')
                end
                xPlayer.showNotification(Lang_Server.TRANSFER_PROPERTY_XPLAYER.. ' ' ..nomecontainer)
                xTarget.showNotification(Lang_Server.TRANSFER_PROPERTY_XTARGET.. ' ' ..nomecontainer)
            end)
		end
	end)
end)

RegisterNetEvent('fenixlarue:container:acquistacontainer')
AddEventHandler('fenixlarue:container:acquistacontainer', function(nomecontainer, source, pin, prezzo, metodo)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT owner FROM flr_listacontainer WHERE owner = @owner AND name = @name AND acquistato = @acquistato', {
		['@owner'] = xPlayer.identifier,
		['@name'] = nomecontainer,
        ['@acquistato'] = 1
	}, function(result)
		if result[1] then
            xPlayer.showNotification(Lang_Server.NON_AVAILABLE_CONTAINER)
		else
            if xPlayer.getAccount(metodo).money >= tonumber(prezzo) then
            MySQL.Async.execute('INSERT INTO flr_listacontainer (owner, name, acquistato, pin) VALUES (@owner, @name, @acquistato, @pin)',
            {
                ['@owner']   = xPlayer.identifier,
                ['@name']   = nomecontainer,
                ['@acquistato'] = 1,
                ['@pin'] = pin
            }, function ()
                    xPlayer.removeAccountMoney(metodo, tonumber(prezzo))
                    xPlayer.showNotification(Lang_Server.CONTAINER_BUYED.. ' ' ..nomecontainer)
                    if Webhook.Enable then
                    FLR_LogSystem(Webhook.AcquistoContainer, 'Il giocatore **' ..GetPlayerName(source).. '** [**' ..xPlayer.identifier.. '**] ha acquistato il container **' ..nomecontainer.. '** al prezzo di **' ..prezzo.. '$** \nCodice Pin: ||**' ..pin.. '**||')
                    end
            end)

            MySQL.Sync.execute("DELETE FROM flr_listacontainer WHERE name=@name AND NOT owner=@owner OR owner=NULL",
            {
                ['owner'] = xPlayer.identifier,
                ['name'] = nomecontainer
            }, function()
                print('^2[FLR_Container] ^0' ..nomecontainer)
            end)

            MySQL.Async.fetchAll('SELECT owner FROM flr_container WHERE owner = @owner AND name = @name AND chiavi = @chiavi', {
                ['@owner'] = xPlayer.identifier,
                ['@name'] = nomecontainer,
                ['@chiavi'] = 1
            }, function(result)
                    MySQL.Async.execute('INSERT INTO flr_container (owner, name, chiavi, propietario, propietario2) VALUES (@owner, @name, @chiavi, @propietario, @propietario2)',
                    {
                        ['@owner']   = xPlayer.identifier,
                        ['@name']   = nomecontainer,
                        ['@chiavi'] = 1,
                        ['@propietario'] = 1,
                        ['@propietario2'] = 1
                    }, function ()
                        print('^2[FLR_Container] ^0Steam Hex ' ..xPlayer.identifier.. ' ha ricevuto le chiavi del container ' ..nomecontainer)
                    end)
            end)
        else
            if metodo == 'money' then
                metodo = Lang_Server.money
            end
            if metodo == 'black_money' then
                metodo = Lang_Server.black_money
            end
            xPlayer.showNotification(Lang_Server.NOT_ENOUGH_MONEY.. ' ' ..metodo.. '!')
        end
		end
	end)
end)

RegisterNetEvent('fenixlarue:container:updatepin')
AddEventHandler('fenixlarue:container:updatepin', function(nomecontainer, newpin)
    local xPlayer = ESX.GetPlayerFromId(source)
    local nome = GetPlayerName(source)
        MySQL.Async.execute("UPDATE flr_listacontainer SET `pin` = @pin WHERE `name` = @name",{
            ['@name'] = nomecontainer,
            ['@pin'] = newpin
        }, function()
            if Webhook.Enable then
            FLR_LogSystem(Webhook.UpdatePin, 'Il giocatore **' ..nome.. '** [**' ..xPlayer.identifier.. '**] ha eseguito un update del PIN per il container **' ..nomecontainer.. '**\nCodice Pin: **' ..newpin.. '**')
            end
            xPlayer.showNotification(Lang_Server.PIN_UPDATED)
        end)
end)


RegisterNetEvent('fenixlarue:container:updatestash')
AddEventHandler('fenixlarue:container:updatestash', function(nomecontainer, peso, slots, prezzo, metodo)
    local xPlayer = ESX.GetPlayerFromId(source)
    local nome = GetPlayerName(source)
    if xPlayer.getAccount(metodo).money >= prezzo then
        xPlayer.removeAccountMoney(metodo, prezzo)
    MySQL.Async.fetchAll('SELECT name, slots, peso FROM flr_inventari WHERE name = name', function (risultato)
        slotsupdated1 = risultato[1].slots + slots
        pesoupdated1 = risultato[1].peso + peso
        MySQL.Async.execute("UPDATE flr_inventari SET `slots` = @slots, `peso`= @peso WHERE `name` = @name",{
            ['@name'] = nomecontainer,
            ['@slots'] = slotsupdated1,
            ['@peso'] = pesoupdated1,
        }, function()
            if Webhook.Enable then
            FLR_LogSystem(Webhook.UpdateStash, 'Il giocatore **' ..nome.. '** [**' ..xPlayer.identifier.. '**] ha eseguito un update per il container **' ..nomecontainer.. '** al costo di **' ..prezzo.. '$** \n**Peso Totale:** ' ..pesoupdated1.. '\n**Slots Totali:** ' ..slotsupdated1)
            end
            xPlayer.showNotification(Lang_Server.STASH_UPDATED)
            exports.ox_inventory:RegisterStash(nomecontainer, nomecontainer, slotsupdated1, pesoupdated1 * 1000)
        end)
    end)
else
    if metodo == 'money' then
        metodo = Lang_Server.money
    end
    if metodo == 'black_money' then
        metodo = Lang_Server.black_money
    end
    xPlayer.showNotification(Lang_Server.NOT_ENOUGH_MONEY.. ' ' ..metodo.. '!')
end
end)

RegisterNetEvent('fenixlarue:container:rimuovichiave')
AddEventHandler('fenixlarue:container:rimuovichiave', function(target, nomecontainer, source)
    local xTarget = ESX.GetPlayerFromId(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Sync.execute("DELETE FROM flr_container WHERE owner=@owner AND name=@name",
    {
        ['owner'] = xTarget.identifier,
        ['name'] = nomecontainer
    }, function()
        print('^2[FLR_Container] ^0Steam Hex ' ..xPlayer.identifier.. ' ha rimosso le chiavi del container ' ..nomecontainer.. ' allo Steam Hex ' ..xTarget.identifier)
    end)
    if Webhook.Enable then
    FLR_LogSystem(Webhook.RimozioneChiavi, 'Il giocatore **' ..GetPlayerName(source).. '** [**' ..xPlayer.identifier.. '**] ha rimosso le chiavi del container **' ..nomecontainer.. '** al giocatore **' ..GetPlayerName(target).. '** [**' ..xTarget.identifier.. '**]')
    end
    xTarget.showNotification(Lang_Server.REMOVED_KEYS.. ' ' ..nomecontainer)
    xPlayer.showNotification(Lang_Server.REMOVING_KEYS.. ' ' ..nomecontainer)
end)

RegisterNetEvent('fenixlarue:container:rimuoviproprieta')
AddEventHandler('fenixlarue:container:rimuoviproprieta', function(target, nomecontainer, source)
    local xTarget = ESX.GetPlayerFromId(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Sync.execute("DELETE FROM flr_container WHERE owner=@owner AND name=@name",
    {
        ['owner'] = xTarget.identifier,
        ['name'] = nomecontainer
    }, function()
        print('^2[FLR_Container] ^0Steam Hex ' ..xPlayer.identifier.. ' ha rimosso la proprieta del container ' ..nomecontainer.. ' allo Steam Hex ' ..xTarget.identifier)
    end)
    if Webhook.Enable then
    FLR_LogSystem(Webhook.RimozioneProprieta, 'Il giocatore **' ..GetPlayerName(source).. '** [**' ..xPlayer.identifier.. '**] ha rimosso la proprietà del container **' ..nomecontainer.. '** al giocatore **' ..GetPlayerName(target).. '** [**' ..xTarget.identifier.. '**]')
    end
    xTarget.showNotification(Lang_Server.REMOVED_PROPERTY_XTARGET.. ' ' ..nomecontainer)
    xPlayer.showNotification(Lang_Server.REMOVED_PROPERTY_XPLAYER.. ' ' ..nomecontainer)
end)

ESX.RegisterServerCallback('fenixlarue:container:isowner', function(target, cb, nomecontainer)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT owner FROM flr_container WHERE owner = @owner AND name = @name AND propietario = @propietario', {
		['@owner'] = xPlayer.identifier,
		['@name'] = nomecontainer,
        ['@propietario'] = 1
	}, function(result)
		if result[1] then
			cb(result[1].owner == xPlayer.identifier)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('fenixlarue:container:ispropietario', function(target, cb, nomecontainer)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT owner FROM flr_container WHERE owner = @owner AND name = @name AND propietario2 = @propietario2', {
		['@owner'] = xPlayer.identifier,
		['@name'] = nomecontainer,
        ['@propietario2'] = 1
	}, function(result)
		if result[1] then
			cb(result[1].owner == xPlayer.identifier)
		else
			cb(false)
		end
	end)
end)


ESX.RegisterServerCallback('fenixlarue:container:hachiavi', function(target, cb, nomecontainer)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT owner FROM flr_container WHERE owner = @owner AND name = @name AND chiavi = @chiavi', {
		['@owner'] = xPlayer.identifier,
		['@name'] = nomecontainer,
        ['@chiavi'] = 1
	}, function(result)
		if result[1] then
			cb(result[1].owner == xPlayer.identifier)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('fenixlarue:container:lista', function(source, cb)
	MySQL.Async.fetchAll('SELECT name, acquistato, prezzo FROM flr_listacontainer', {}, function(result)
        cb(result)
	end)
end)

ESX.RegisterServerCallback('fenixlarue:container:ottienipin', function(source, cb, nomecontainer)
	MySQL.Async.fetchAll('SELECT name, pin FROM flr_listacontainer WHERE name = @name', {
        ['@name'] = nomecontainer
    }, function(result)
        cb(result)
	end)
end)

end

FLR_LogSystem = function(webhook, messaggio)
    mandasudiscord(webhook, messaggio)
end

function mandasudiscord(webhook, messaggio)
	local contenuto = {{
		author = {
			name = Config.ServerName,
			icon_url = Config.IconUrl
		},
		description = messaggio,
		color = Config.Color,
		footer = {
			text = Config.Footer.. " | "..os.date("%x | %X %p"),
		}
	}}
	PerformHttpRequest(webhook , function(err, text, headers) end, 'POST', json.encode({username = name, embeds = contenuto}), { ['Content-Type'] = 'application/json' })
end