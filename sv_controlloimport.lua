local ListaImport = {}

RegisterCommand('importon',function(source)
	local source = source
	local chiscrive = ESX.GetPlayerFromId(source)
    local grp = chiscrive.getGroup()
	if grp == 'admin' or grp == 'mod' then
		TriggerClientEvent('royal:aprimenu:importon', source, ListaImport)
	end
end, false)

CreateThread(function()
    while true do
        local temp = {}
        local xPlayers = GetCount2('import')
        for _, ply in pairs(xPlayers) do
            temp[#temp+1] = ply.name .. " [".. ply.source .."]"
        end
        ListaImport = temp
        Wait(60 * 1000)
    end
end)

local JobsToCount = {
    ['import'] = true,
}
local Counts = {}

function GetCount2(job)
    return Counts[job] or {}
end

CreateThread(function()
    while true do
        for k, v in pairs(JobsToCount) do
            Counts[k] = ESX.GetExtendedPlayers('job', k)
        end
		Wait(3 * 60000)
	end
end)