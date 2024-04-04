local ListaEMS = {}
local ListaLSPD = {}
local ListaFBI = {}
local ListaLSSD = {}

RegisterCommand('emson',function(source)
	local source = source
	local chiscrive = ESX.GetPlayerFromId(source)
    local grp = chiscrive.getGroup()
	if grp == 'admin' or grp == 'mod' or (chiscrive.job.name == 'ambulance' and chiscrive.job.grade >= 5) then
		TriggerClientEvent('royal:aprimenu:emson', source, ListaEMS)
	end
end, false)

RegisterCommand('lspdon',function(source)
	local source = source
	local chiscrive = ESX.GetPlayerFromId(source)
    local grp = chiscrive.getGroup()
	if grp == 'admin' or grp == 'mod' or (chiscrive.job.name == 'police' and chiscrive.job.grade >= 6) then
		TriggerClientEvent('royal:aprimenu:lspdon', source, ListaLSPD)
	end
end, false)

RegisterCommand('fbion',function(source)
	local source = source
	local chiscrive = ESX.GetPlayerFromId(source)
    local grp = chiscrive.getGroup()
	if grp == 'admin' or grp == 'mod' or (chiscrive.job.name == 'fbi' and chiscrive.job.grade >= 6) then
		TriggerClientEvent('royal:aprimenu:fbion', source, ListaFBI)
	end
end, false)

RegisterCommand('lssdon',function(source)
	local source = source
	local chiscrive = ESX.GetPlayerFromId(source)
    local grp = chiscrive.getGroup()
	if grp == 'admin' or grp == 'mod' or (chiscrive.job.name == 'sceriffo' and chiscrive.job.grade >= 6) then
		TriggerClientEvent('royal:aprimenu:lssdon', source, ListaLSSD)
	end
end, false)

CreateThread(function()
    while true do
        local temp = {}
        local xPlayers = GetCount('ambulance')
        for _, ply in pairs(xPlayers) do
            temp[#temp+1] = ply.name .. " [".. ply.source .."]"
        end
        ListaEMS = temp
        Wait(60 * 1000)
    end
end)

CreateThread(function()
    while true do
        local temp = {}
        local xPlayers = GetCount('police')
        for _, ply in pairs(xPlayers) do
            temp[#temp+1] = ply.name .. " [".. ply.source .."]"
        end
        ListaLSPD = temp
        Wait(60 * 1000)
    end
end)

CreateThread(function()
    while true do
        local temp = {}
        local xPlayers = GetCount('fbi')
        for _, ply in pairs(xPlayers) do
            temp[#temp+1] = ply.name .. " [".. ply.source .."]"
        end
        ListaFBI = temp
        Wait(60 * 1000)
    end
end)

CreateThread(function()
    while true do
        local temp = {}
        local xPlayers = GetCount('sceriffo')
        for _, ply in pairs(xPlayers) do
            temp[#temp+1] = ply.name .. " [".. ply.source .."]"
        end
        ListaLSSD = temp
        Wait(60 * 1000)
    end
end)

local JobsToCount = {
    ['ambulance'] = true,
    ['police'] = true,
    ['fbi'] = true,
    ['sceriffo'] = true
}
local Counts = {}

function GetCount(job)
    return Counts[job] or {}
end

exports('GetCount', GetCount)

CreateThread(function()
    while true do
        for k, v in pairs(JobsToCount) do
            Counts[k] = ESX.GetExtendedPlayers('job', k)
        end
		Wait(3 * 60000)
	end
end)