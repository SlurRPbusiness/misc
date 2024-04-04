local playerJobsLists = {}
local playerJobs = {}

RegisterServerEvent("mbc_joblister:registerJob")
AddEventHandler("mbc_joblister:registerJob", function(jobName)

	if not playerJobsLists[jobName] then playerJobsLists[jobName] = {} end

	
	if (playerJobs[source] ~= nil) then
		playerJobsLists[playerJobs[source]][source] = nil
	end

	playerJobs[source] = jobName
	playerJobsLists[jobName][source] = 1

end)


AddEventHandler("playerDropped", function()
	local job = playerJobs[source]
	if (job ~= nil and source ~= nil) then
		playerJobsLists[job][source] = nil
	end
end)

function GetPlayersFromJob(job)
	return playerJobsLists[job] or {}
end
 