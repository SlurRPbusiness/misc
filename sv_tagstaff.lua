AdminPlayers = {}

local OwnerTables = {
    ["steam:110000109e33e84"] = true, -- chico
    ["steam:11000013c9531df"] = true, -- mambi
	["steam:11000015f439a92"] = true,  -- ZEUS
}

local CoOwnerTables = {
    ["steam:1100001448c1b9a"] = true, -- GALLO
	["steam:1100001432e2481"] = true, -- paolofazz
}

local FounderTables = {
	["steam:110000147bae517"] = true, -- davide
}

local CoFounderTables = {
    -- ["steam:11000015a4ae44b"] = true, -- ciro
	["steam:11000013b6ab3d9"] = true, -- blue
}

local ManagerTables = {
    ["steam:11000011190c733"] = true, -- tanzo
}


RegisterCommand('tagstaff', function(source,args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if AdminPlayers[source] == nil then
        if OwnerTables[GetPlayerIdentifiers(source)[1]] then
            AdminPlayers[source] = {source = source, group = 'owner'}
        elseif CoOwnerTables[GetPlayerIdentifiers(source)[1]] then
            AdminPlayers[source] = {source = source, group = 'coowner'}
        elseif FounderTables[GetPlayerIdentifiers(source)[1]] then
            AdminPlayers[source] = {source = source, group = 'founder'}
        elseif CoFounderTables[GetPlayerIdentifiers(source)[1]] then
            AdminPlayers[source] = {source = source, group = 'cofounder'}
        elseif ManagerTables[GetPlayerIdentifiers(source)[1]] then
            AdminPlayers[source] = {source = source, group = 'manager'}
        else
            AdminPlayers[source] = {source = source, group = xPlayer.getGroup()}
        end
    else
        AdminPlayers[source] = nil
    end
    TriggerClientEvent('relisoft_tag:set_admins',-1,AdminPlayers)
end)

ESX.RegisterServerCallback('relisoft_tag:getAdminsPlayers',function(source,cb)
    cb(AdminPlayers)
end)

AddEventHandler('esx:playerDropped', function(source)
    if AdminPlayers[source] ~= nil then
        AdminPlayers[source] = nil
    end
    TriggerClientEvent('relisoft_tag:set_admins',-1,AdminPlayers)
end)
