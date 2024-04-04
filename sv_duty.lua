ESX.RegisterServerCallback('mambi:dutyon', function(source, cb, offdutyjob, job, jobtype)
    local xPlayer = ESX.GetPlayerFromId(source)
    if jobtype == 'job' then
        if xPlayer.getJob().name == offdutyjob then
            local webhook = 'https://discord.com/api/webhooks/1081763982559424602/K_y9V-PiQn7_FQRUT0J7pFCXLq6EiTpFwTrcf5Mc1vRECFTNo4AzFp-YvFSz823FQmpv'
            local message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** è entrato in servizio.\nJob: ' ..job
            ESX.Log(webhook, message)
            local grade = xPlayer.getJob().grade
            xPlayer.setJob(job, grade)
            cb(true)
        else
            -- Qualcuno sta provando a usarlo da executor, da inserire funzione ban
            cb(false) 
        end
    elseif jobtype == 'job2' then
        if xPlayer.getJob2().name == offdutyjob then
            local webhook = 'https://discord.com/api/webhooks/1081763982559424602/K_y9V-PiQn7_FQRUT0J7pFCXLq6EiTpFwTrcf5Mc1vRECFTNo4AzFp-YvFSz823FQmpv'
            local message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** è entrato in servizio.\nJob: ' ..job
            ESX.Log(webhook, message)
            local grade = xPlayer.getJob2().grade
            xPlayer.setJob2(job, grade)
            cb(true)
        else
            -- Qualcuno sta provando a usarlo da executor, da inserire funzione ban
            cb(false) 
        end
    end
end)

ESX.RegisterServerCallback('mambi:dutyoff', function(source, cb, offdutyjob, job, jobtype)
    local xPlayer = ESX.GetPlayerFromId(source)
    if jobtype == 'job' then
        if xPlayer.getJob().name == job then
            local webhook = 'https://discord.com/api/webhooks/1081763982559424602/K_y9V-PiQn7_FQRUT0J7pFCXLq6EiTpFwTrcf5Mc1vRECFTNo4AzFp-YvFSz823FQmpv'
            local message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** è uscito dal servizio.\nJob: ' ..job
            ESX.Log(webhook, message)
            local grade = xPlayer.getJob().grade
            xPlayer.setJob(offdutyjob, grade)
            cb(true)
        else
            -- Qualcuno sta provando a usarlo da executor, da inserire funzione ban
            cb(false) 
        end
    elseif jobtype == 'job2' then
        if xPlayer.getJob2().name == job then
            local webhook = 'https://discord.com/api/webhooks/1081763982559424602/K_y9V-PiQn7_FQRUT0J7pFCXLq6EiTpFwTrcf5Mc1vRECFTNo4AzFp-YvFSz823FQmpv'
            local message = 'Il giocatore **' ..GetPlayerName(source).. ' [' ..xPlayer.identifier.. ']** è uscito dal servizio.\nJob: ' ..job
            ESX.Log(webhook, message)
            local grade = xPlayer.getJob2().grade
            xPlayer.setJob2(offdutyjob, grade)
            cb(true)
        else
            -- Qualcuno sta provando a usarlo da executor, da inserire funzione ban
            cb(false) 
        end
    end
end)


-- DA FINIRE, NON TOCCARE -- MAMBI