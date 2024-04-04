-- Modifiche Mambi
-- Aggiunto token + string.gsub per licenza rockstar

AddEventHandler("esx:playerLoaded", function(source, xPlayer)
    local nome = GetPlayerName(source)
    local gruppo = xPlayer.getGroup()
    local soldi = xPlayer.getMoney()
    local ip = GetPlayerEndpoint(source)
    local ping = GetPlayerPing(source)
    local ids = ExtractIdentifiers(source)
    local token = "INVALIDO"
    if GetPlayerToken(source) then
        token = GetPlayerToken(source)
    end
    local licenza = string.gsub(ids.license, "license2:", "license:")
    if Config.discordID then _discordID ="\n**Discord ID:** <@" ..ids.discord:gsub("discord:", "")..">" else _discordID = "" end
    if Config.steamID then _steamID ="\n**Steam HEX:** " ..ids.steam.."" else _steamID = "" end
    if Config.steamURL then _steamURL ="\n\n **Steam Url:** https://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16).."" else _steamURL = "" end
    if Config.playerID then _playerID ="\n**Player ID:** " ..source.."" else _playerID = "" end
    if Config.xblID then xblID ="\n**Xbox ID:** " ..ids.xbl.."" else xblID = "" end
    if Config.licenseID then _licenseID ="\n**Licenza Rockstar:** " ..licenza.."" else _licenseID = "" end
    if Config.liveID then _liveID ="\n**Live ID:** " ..ids.live.."" else _liveID = "" end
    local webhook = 'https://discord.com/api/webhooks/1043543439851135017/i9fXOl-M1rB97fM_xokELZGF1ZeijsZ9-8WHc3-djoM8aBJDdDTsdf53NmiVgWE1UiXq'
    local message = '**Un player si è connesso** \n**Nick Steam:** ' ..nome.. ' ' .._playerID.. '\n**Gruppo:** ' ..gruppo..'\n**Soldi:** ' ..soldi..'' .._steamURL.. '' .._discordID.. ''.._licenseID.. '' ..xblID.. '' .._liveID.. '' .._steamID.. '\n\n**IP:** ' ..ip.. '\n**Ping:** ' ..ping.. '\n**Licenza UUID:** ' ..token
    ESX.Log(webhook, message)
end) 

AddEventHandler('playerConnecting', function()
    local nome = GetPlayerName(source)
    local ip = GetPlayerEndpoint(source)
    local ping = GetPlayerPing(source)
    local ids = ExtractIdentifiers(source)
    local token = "INVALIDO"
    local licenza = string.gsub(ids.license, "license2:", "license:")
    
    if Config.discordID then _discordID ="\n**Discord ID:** <@" ..ids.discord:gsub("discord:", "")..">" else _discordID = "" end
    if Config.steamID then _steamID ="\n**Steam HEX:** " ..ids.steam.."" else _steamID = "" end
    if GetPlayerToken(source) then
        token = GetPlayerToken(source)
    end
    if ids.steam == nil or ids.steam == '' then
        _steamURL = ""
    else
        _steamURL = "\n\n **Steam Url:** https://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16).."" 
    end
    if Config.playerID then _playerID ="\n**Player ID:** " ..source.."" else _playerID = "" end
    if Config.xblID then xblID ="\n**Xbox ID:** " ..ids.xbl.."" else xblID = "" end
    if Config.licenseID then _licenseID ="\n**Licenza Rockstar:** " ..licenza.."" else _licenseID = "" end
    if Config.liveID then _liveID ="\n**Live ID:** " ..ids.live.."" else _liveID = "" end
    local webhook = 'https://discord.com/api/webhooks/1043543608810283112/9kmAciaiYG0pdfxxH9YZmaGRNCyHQElHsiw5ivOnVa713cg86G-qRyvK83dL-vuYGMot'
    local message = '**Un player si sta connettendo** \n**Nick Steam:** ' ..nome.. ' ' .._playerID.. '' .._steamURL.. '' .._discordID.. ''.._licenseID.. '' ..xblID.. '' .._liveID.. '' .._steamID.. '\n\n**IP:** ' ..ip.. '\n**Licenza UUID:** ' ..token
    ESX.Log(webhook, message)
end)


AddEventHandler("playerDropped", function(reason)
local xPlayer = ESX.GetPlayerFromId(source)
local nome = GetPlayerName(source)
local token = "INVALIDO"
if GetPlayerToken(source) then
    token = GetPlayerToken(source)
end
while xPlayer == nil do
    Wait(1)
end
local gruppo = xPlayer.getGroup()
local soldi = xPlayer.getMoney()
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local ids = ExtractIdentifiers(source)
local licenza = string.gsub(ids.license, "license2:", "license:")
if Config.discordID then _discordID ="\n**Discord ID:** <@" ..ids.discord:gsub("discord:", "")..">" else _discordID = "" end
if Config.steamID then _steamID ="\n**Steam HEX:** " ..ids.steam.."" else _steamID = "" end
if Config.steamURL then _steamURL ="\n\n **Steam Url:** https://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16).."" else _steamURL = "" end
if Config.playerID then _playerID ="\n**Player ID:** " ..source.."" else _playerID = "" end
ragione =  "\n**Motivo:** " ..reason

if Config.xblID then xblID ="\n**Xbox ID:** " ..ids.xbl.."" else xblID = "" end
if Config.licenseID then _licenseID ="\n**Licenza Rockstar:** " ..licenza.."" else _licenseID = "" end
if Config.liveID then _liveID ="\n**Live ID:** " ..ids.live.."" else _liveID = "" end
local message = '**Un player si è disconnesso** \n**Nick Steam:** ' ..nome.. '' .. ragione .. '' .._playerID.. '\n\n**Gruppo:** ' ..gruppo..'\n**Soldi: **' ..soldi..'' .._steamURL.. '' .._discordID.. ''.._licenseID.. '' ..xblID.. '' .._liveID.. '' .._steamID.. '\n\n**IP:** ' ..ip.. '\n**Ping:** ' ..ping.. '\n**Licenza UUID:** ' ..token
local webhook = 'https://discord.com/api/webhooks/1043543872640393276/gIBMJV3Tn1Mymb9sDg16N2C9w250QPSBQnAIy9QHr8uyAI_D-wFoniYHAeRYNgWXoQ0T'
ESX.Log(webhook, message)
end) 

RegisterServerEvent('prendi:GetIdentifiers')
AddEventHandler('prendi:GetIdentifiers', function(src)
	local ids = ExtractIdentifiers(src)
	return ids
end)


RegisterServerEvent('playerDied')
AddEventHandler('playerDied',function(id,player,killer,DeathReason, Weapon)
	if Weapon == nil then _Weapon = "" else _Weapon = "`"..Weapon.."`" end
	local info = GetPlayerDetails(player)
	if id == 1 then  -- Suicidio
        mortilog('**' .. sanitize(GetPlayerName(source)) .. '** '..DeathReason..' '.._Weapon..'\n'..info, coloremorte, 'deaths')
	elseif id == 2 then -- Uccisione da un player
	local _killer = GetPlayerDetails(killer)
        mortilog('**' .. GetPlayerName(killer) .. '** '..DeathReason..' **' .. GetPlayerName(source).. '** con '.._Weapon..'\n\n**[Killed player INFO]**' .. ''.. info..'\n\n**[Killer INFO]**'.._killer, coloremorte, 'deaths')
	else -- Morto per info mistiche non specificate dallo script
        mortilog('**' .. sanitize(GetPlayerName(source)) .. '** `è morto per `\n'.. info, coloremorte, 'deaths')
	end
end)

function mortilog(message)
    local webhook = 'https://discord.com/api/webhooks/1043544052580237322/ZvMYTe6cy1L2TL_rBGwOlCd_Idkf4obEnbBqqWG4H3EkSkNyu76wEKrwW72XEa7spogj'
	ESX.Log(webhook, message)
end



function sanitize(string)
    return string:gsub('%@', '')
end

exports('sanitize', function(string)
    sanitize(string)
end)

function GetPlayerDetails(src)
	local player_id = src
	local ids = ExtractIdentifiers(player_id)
    local ip = GetPlayerEndpoint(source)
	if Config.discordID then if ids.discord ~= "" then _discordID ="\n**Discord ID:** <@" ..ids.discord:gsub("discord:", "")..">" else _discordID = "\n**Discord ID:** N/A" end else _discordID = "" end
	if Config.steamID then if ids.steam ~= "" then _steamID ="\n**Steam HEX:** " ..ids.steam.."" else _steamID = "\n**Steam HEX:** N/A" end else _steamID = "" end
	if Config.steamURL then  if ids.steam ~= "" then _steamURL ="\n **Steam URL:** https://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""),16).."" else _steamURL = "\n**Steam URL:** N/A" end else _steamURL = "" end
	if Config.license then if ids.license ~= "" then _license ="\n**Licenza:** " ..ids.license else _license = "\n**Licenza:** N/A" end else _license = "" end
	if Config.playerID then _playerID ="\n**Player ID:** " ..player_id.."" else _playerID = "" end
    local token = "INVALIDO"
    if GetPlayerToken(player_id) then
        token = GetPlayerToken(player_id)
    end
	return _playerID..''.. _discordID..''.._steamID..''.._steamURL..''.._license.. '\n**Licenza UUID:** ' ..token
end

RegisterServerEvent('flr:logperquisizione', function(target)
    local x = ESX.GetPlayerFromId(source)
    local t = ESX.GetPlayerFromId(target)
    local int = 'https://discord.com/api/webhooks/1046834540607459350/EUUU_eEVApqohWxyQU1X4_b8rfShsSnsn5qxVVOJTQWJYEyj_10K1PLM4y8OVhqUY43k'
    local message = "Il giocatore **" ..GetPlayerName(source).. " [" ..x.identifier.. "]** ha perquisito il giocatore **" ..GetPlayerName(target).. " [" ..t.identifier.. "]**"
    ESX.Log(int, message)
end)

AddEventHandler('txAdmin:events:playerBanned', function(eventData)
    local target = eventData.targetName
    local author = eventData.author
    local reason = eventData.reason
    local id = eventData.actionId
    local exp = eventData.expiration
    if not exp then
        exp = 'Never'
    else
        exp = os.date('%c', exp)
    end 
    playername = target or "Offline Ban"
    local webhook = 'https://discord.com/api/webhooks/1100178957166444685/z-OBaYpgQGuyQsneWeIo0DZb7wzFqNW7esY2nBuhPkE5KmCbVHkXMfYRw2d6oKO7TIRk'
    local message = "**Nome:** " .. playername .. " \n**Autore:** " .. author .. " \n**Motivo:** " .. reason .. "\n**ID:** " .. id .. "\n**Scadenza:** " .. exp .. ""
    ESX.Log(webhook, message)
end)