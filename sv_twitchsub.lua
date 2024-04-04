local ESX = exports.es_extended:getSharedObject()

Config_Bello = {
	DiscordToken = "MTA4OTkxMzYwNTUxODAyMDczOQ.GaQfc7.aYLvhXOl-WNt0HDbY8USvP-aowBNY-kIntJBnY",
	GuildId = "877676429725270026",  

	-- Format: ["Role Nickname"] = "Role ID" You can get role id by doing \@RoleName
	Roles = {
		["👾｜Twitch Sub"] = "1125242398746869812",
	}
}


local FormattedToken = "Bot "..Config_Bello.DiscordToken

function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end

function GetRoles(user)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break
		end
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(Config_Bello.GuildId, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local roles = data.roles
			local found = true
			return roles
		else
			return false
		end
	else
		return false
	end
end

function IsRolePresent(user, role)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break
		end
	end

	local theRole = nil
	if type(role) == "number" then
		theRole = tostring(role)
	else
		theRole = Config_Bello.Roles[role]
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(Config_Bello.GuildId, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local roles = data.roles
			local found = true
			for i=1, #roles do
				if roles[i] == theRole then
					return true
				end
			end
			return false
		else
			return false
		end
	else
		return false
	end
end

Citizen.CreateThread(function()
	local guild = DiscordRequest("GET", "guilds/"..Config_Bello.GuildId, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		print("Permission system guild set to: "..data.name.." ("..data.id..")")
	else
		print("An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
end)


mambiroles = {}

function mambiroles.IsSub(src)
    if IsRolePresent(src, mambi_config.role) then
        return true
    else
        return false
    end
end

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    identifiers.token = GetPlayerToken(src, 0)

    return identifiers
end


ESX.RegisterServerCallback('mambi_twitchsub:get_role', function(source, cb)
	cb(true)
    --[[if mambiroles.IsSub(source) then
        cb(true)
    else
        cb(false)
    end]]
end)

function mambi_immagazzinadati(source)
    MySQL.Async.execute('INSERT INTO mambi_twitchsub (steamhex, status) VALUES (@hex, @status)',
    {
        ['@hex']   = GetPlayerIdentifiers(source)[1],
        ['@status'] = 1,
    }, function ()
    end)
end

ESX.RegisterServerCallback('mambi_twitchsub:get_auto', function(source, cb)
    MySQL.Async.fetchAll('SELECT steamhex, status FROM mambi_twitchsub WHERE steamhex = @steamhex',{
        ['@steamhex'] = GetPlayerIdentifiers(source)[1]
    }, function (risultato)
        if (risultato[1] ~= nil) then
            cb(false)
        else
            local playerName = GetPlayerName(source)
            TriggerClientEvent('esx_giveownedcar:spawnVehicle', tonumber(source), source, 'm2g87', playerName, 'console', 'car')
            mambi_immagazzinadati(source)
			local ids = ExtractIdentifiers(source)
			local webhook = 'https://discord.com/api/webhooks/1126678657050619985/P5MGAhw0z5WjP4Y-oxYlAO6GGmUYJM8VI_Cq0yxkYOu7Ivja3j-Q0LoxchEfHMxTB8o7'
			local message = "**<@" ..ids.discord:gsub("discord:", "").."> ha riscattato l'auto per i sub! Grazie per il supporto**\n\n<@&1035285004776898581>"
			PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Riscatto Auto", content = message}), { ['Content-Type'] = 'application/json' })
            cb(true)
        end
    end)
end)