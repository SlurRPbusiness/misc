local rob = false
local robbers = {}

RegisterServerEvent('esx_holdup:tooFar')
AddEventHandler('esx_holdup:tooFar', function(currentStore)
	local _source = source
	rob = false
	if string.find(Stores[currentStore].nameOfStore, 'Gabriela') then
		webhook = "https://discord.com/api/webhooks/1047321454397632512/3988mCSE5Y0BMf_CxohKVgPKHxZlTl1bNAV6exvVK1TQEQEak-oVG8NEeVgyQc8r3b08"
	elseif string.find(Stores[currentStore].nameOfStore, 'Fleeca') then
		webhook = "https://discord.com/api/webhooks/1047321454397632512/3988mCSE5Y0BMf_CxohKVgPKHxZlTl1bNAV6exvVK1TQEQEak-oVG8NEeVgyQc8r3b08"
	elseif string.find(Stores[currentStore].nameOfStore, 'Blaine') then
		webhook = "https://discord.com/api/webhooks/1047321454397632512/3988mCSE5Y0BMf_CxohKVgPKHxZlTl1bNAV6exvVK1TQEQEak-oVG8NEeVgyQc8r3b08"
	elseif string.find(Stores[currentStore].nameOfStore, 'Pacific') then
		webhook = "https://discord.com/api/webhooks/1047321454397632512/3988mCSE5Y0BMf_CxohKVgPKHxZlTl1bNAV6exvVK1TQEQEak-oVG8NEeVgyQc8r3b08"
	else
		webhook = "https://discord.com/api/webhooks/1047321454397632512/3988mCSE5Y0BMf_CxohKVgPKHxZlTl1bNAV6exvVK1TQEQEak-oVG8NEeVgyQc8r3b08"
	end
	local msg = "Il player **"..GetPlayerName(_source).."** ha annullato una rapina al **"..Stores[currentStore].nameOfStore.."**"
	ESX.Log(webhook, msg)
	for _, xPlayer in pairs(ESX.GetExtendedPlayers('job', 'police')) do
		--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('robbery_cancelled_at', Stores[currentStore].nameOfStore))
		TriggerClientEvent('esx_holdup:killBlip', xPlayer.source)
	end
	for _, xPlayer in pairs(ESX.GetExtendedPlayers('job', 'sceriffo')) do
		--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('robbery_cancelled_at', Stores[currentStore].nameOfStore))
		TriggerClientEvent('esx_holdup:killBlip', xPlayer.source)
	end
	if robbers[_source] then
		TriggerClientEvent('esx_holdup:tooFar', _source)
		ESX.ClearTimeout(robbers[_source])
        robbers[_source] = nil
		TriggerClientEvent('esx:showNotification', _source, _U('robbery_cancelled_at', Stores[currentStore].nameOfStore))
	end
end)

RegisterServerEvent('esx_holdup:robberyStarted')
AddEventHandler('esx_holdup:robberyStarted', function(currentStore)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	if Stores[currentStore] then
		local store = Stores[currentStore]
		if (os.time() - store.lastRobbed) < Config.TimerBeforeNewRob and store.lastRobbed ~= 0 then
			TriggerClientEvent('esx:showNotification', _source, _U('recently_robbed', Config.TimerBeforeNewRob - (os.time() - store.lastRobbed)))
			return
		end
		if not rob then
			local xPlayers = ESX.GetExtendedPlayers('job', 'police')
			local xPlayers2 = ESX.GetExtendedPlayers('job', 'sceriffo')
			if #xPlayers + #xPlayers2 >= store.cops then
				local webhook = nil
				rob = true
				for _, xPlayer in pairs(xPlayers) do
					TriggerClientEvent('esx:showNotification', xPlayer.source, _U('rob_in_prog', store.nameOfStore))
					TriggerClientEvent('esx_holdup:setBlip', xPlayer.source, Stores[currentStore].position)
				end
				for _, xPlayer in pairs(xPlayers2) do
					TriggerClientEvent('esx:showNotification', xPlayer.source, _U('rob_in_prog', store.nameOfStore))
					TriggerClientEvent('esx_holdup:setBlip', xPlayer.source, Stores[currentStore].position)
				end
				if string.find(store.nameOfStore, 'Gabriela') then
					webhook = "https://discord.com/api/webhooks/1047321728226959520/TI03VswaO7HFjd10jOP1p6TrvUO-iigz11Z5h8m7KpW4NHpgE-XvAkswSHi0YqPWCcIM"
				elseif string.find(store.nameOfStore, 'Fleeca') then
					webhook = "https://discord.com/api/webhooks/1047321807876788234/rdViz_IBw9PGWI8zZDjz3WN6zyau-jDkqJYlrR1fcgxKl1M6E2xLGjodYvf-2tAjzO2j"
				elseif string.find(store.nameOfStore, 'Blaine') then
					webhook = "https://discord.com/api/webhooks/1047321915339059321/s5F4x-gQXBIgrlDiMHHFJjZ2R9Ai-EfuADRctKDSxKyJPAoMKd1qawe18Qkv2e6_yshM"
				elseif string.find(store.nameOfStore, 'Pacific') then
					webhook = "https://discord.com/api/webhooks/1077994611160645713/ydnxqA-rsHwkNBtRPTzlEWBXif2dAjdevLuw6lexov09FvwL1XPaZiYX4MVVWgotUTkA"
				else
					webhook = "https://discord.com/api/webhooks/1047322001511039097/5yL06FlkxZ3HuSvshdaORgsOq1fGHZPo72l0uMVW0MCgUGagwBPnGLWTOGgQyiFafdzC"
				end
				local msg = "Il player **"..GetPlayerName(_source).."** ha avviato una rapina al **"..store.nameOfStore.."**"
				ESX.Log(webhook, msg)
				TriggerClientEvent('esx:showNotification', _source, _U('started_to_rob', store.nameOfStore))
				TriggerClientEvent('esx:showNotification', _source, _U('alarm_triggered'))
				TriggerClientEvent('esx_holdup:currentlyRobbing', _source, currentStore)
				TriggerClientEvent('esx_holdup:startTimer', _source)
				TriggerClientEvent('flr:iniziarap', _source)
				Stores[currentStore].lastRobbed = os.time()
				Stores[currentStore].RobberSource = _source
				robbers[_source] = ESX.SetTimeout(store.secondsRemaining * 1000, function()
					rob = false
                    if xPlayer and Stores[currentStore].RobberSource then
						Stores[currentStore].RobberSource = nil
                        TriggerClientEvent('esx_holdup:robberyComplete', _source, store.reward)
                        if Config.GiveBlackMoney then
                            xPlayer.addInventoryItem('black_money', store.reward)
                        else
                            xPlayer.addMoney(store.reward)
                        end
                        local xPlayers = ESX.GetExtendedPlayers('job', 'police')
						local xPlayers2 = ESX.GetExtendedPlayers('job', 'sceriffo')
                        for _, xPlayer in pairs(xPlayers) do
                            TriggerClientEvent('esx:showNotification', xPlayer.source, _U('robbery_complete_at', store.nameOfStore))
                            TriggerClientEvent('esx_holdup:killBlip', xPlayer.source)
                        end
						
						for _, xPlayer in pairs(xPlayers2) do
                            TriggerClientEvent('esx:showNotification', xPlayer.source, _U('robbery_complete_at', store.nameOfStore))
                            TriggerClientEvent('esx_holdup:killBlip', xPlayer.source)
                        end
                    end
				end)
			else
				TriggerClientEvent('flr:stopparap', _source)
				TriggerClientEvent('esx:showNotification', _source, _U('min_police', store.cops))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, 'I Poliziotti sono impegnati in altre rapine al momento!')
		end
	end
end)

RegisterServerEvent('esx_holdup:StopTimer', function(market)
	local _source = source
	if Stores[market].RobberSource then
		local xPlayer  = ESX.GetPlayerFromId(Stores[market].RobberSource)
		TriggerClientEvent('esx_holdup:ConfirmStop', Stores[market].RobberSource)
		TriggerClientEvent('esx_holdup:robberyComplete', Stores[market].RobberSource, Stores[market].reward)
		if Config.GiveBlackMoney then
			xPlayer.addInventoryItem('black_money', Stores[market].reward)
		else
			xPlayer.addMoney(Stores[market].reward)
		end
		local xPlayers = ESX.GetExtendedPlayers('job', 'police')
		local xPlayers2 = ESX.GetExtendedPlayers('job', 'sceriffo')
		for _, xPlayer in pairs(xPlayers) do
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('robbery_complete_at', Stores[market].nameOfStore))
			TriggerClientEvent('esx_holdup:killBlip', xPlayer.source)
		end
		for _, xPlayer in pairs(xPlayers2) do
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('robbery_complete_at', Stores[market].nameOfStore))
			TriggerClientEvent('esx_holdup:killBlip', xPlayer.source)
		end
		Stores[market].RobberSource = nil
	else
		TriggerClientEvent('esx:showNotification', _source, 'Non è in corso nessuna rapina qua!')
	end
end)
