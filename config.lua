Config = {

    linguaggio = 'en',
    color = { r = 230, g = 230, b = 230, a = 255 }, -- Text color [me]
    font = 0, -- Text font [me]
    time = 5000, -- Duration to display the text (in ms) [me]
    scale = 0.5, -- Text scale -- [me]
    dist = 250, -- Min. distance to draw -- [me]

}

Languages = {
    ['en'] = {
        commandName = 'me',
        commandDescription = 'Display an action above your head.',
        commandSuggestion = {{ name = 'action', help = '"tocca petto" per esempio.'}},
        prefix = ''
    },
}

Config.Locale = 'en'

Config.Admin = {
	{
		name = 'spawnveh',
		label = "Spawna Veicolo",
		command = function()
			local input =  lib.inputDialog('Menu Amministrazione',{
                { type = "input", label = "Codice Veicolo" },
                } 
            )
            if input then
					if not IsModelValid(input[1]) then
						ESX.ShowNotification('Veicolo non esistente')
					else
						ESX.Game.SpawnVehicle(input[1], GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), function(vehicle)
							TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
						end)
					end
				else
			end
		end
	},
	{
		name = 'repairveh',
		label = "Ripara veicolo",
		command = function()
			local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
			SetVehicleFixed(plyVeh)
			SetVehicleDirtLevel(plyVeh, 0.0)
		end
	},
	{
		name = 'noclip',
		label = "Noclip",
		command = function()
			ESX.UI.Menu.CloseAll()
			ExecuteCommand('noclip')
		end
	},	
	{
		name = 'showname',
		label = 'Mostra Nomi',
		command = function()
			TriggerServerEvent('MxM_ServerSide', 'mxm:nomi')
		end
	},	


	{
		name = 'invisibilita',
		label = 'Invisibilità',
		command = function()
			PlayerF5.ghostmode = not PlayerF5.ghostmode

			if PlayerF5.ghostmode then
				SetEntityVisible(PlayerPedId(), false, false)
				ESX.ShowNotification('Invisibilità Attivata')
			else
				SetEntityVisible(PlayerPedId(), true, false)
				ESX.ShowNotification('Invisibilità Disattivata')
			end
		end
	},

	{
		name = 'comandoskin',
		label = 'Skin Menu',
		command = function()
			Citizen.Wait(100)
			TriggerEvent('esx_skin:openSaveableMenu')
		end
	},

	{
		name = 'bringaplayer',
		label = 'Bringa Player',
		command = function()
			local input =  lib.inputDialog('Menu Amministrazione',{
                { type = "input", label = "ID" },
                } 
            )
            if input then
				ESX.TriggerServerCallback('flr:isplayeronline', function(result)
					if result then
						ExecuteCommand('bring ' ..input[1])
					else
						ESX.ShowNotification('ID non valido')
					end
				end, tonumber(input[1]))
				else
			end
		end
	},

	{
		name = 'gotoplayer',
		label = 'TP al Player',
		command = function()
			local input =  lib.inputDialog('Menu Amministrazione',{
                { type = "input", label = "ID" },
                } 
            )
            if input then
				ESX.TriggerServerCallback('flr:isplayeronline', function(result)
					if result then
						ExecuteCommand('goto ' ..input[1])
					else
						ESX.ShowNotification('ID non valido')
					end
				end, tonumber(input[1]))
				else
			end
		end
	},

	{
		name = 'givepuliti',
		label = 'Give Soldi Contanti',
		command = function()
			local id =  lib.inputDialog('Menu Amministrazione',{
                { type = "input", label = "ID" },
                } 
            )

			if id then
				ESX.TriggerServerCallback('flr:isplayeronline', function(result)
					if result then
						local input =  lib.inputDialog('Menu Amministrazione',{
							{ type = "input", label = "Importo" },
							})
						if input then
							if input[1] == nil or input[1] == '0' then
								ESX.ShowNotification('Importo non valido')
							else
								TriggerServerEvent('ff_menuf5:givesoldi', 'puliti', input[1], id[1], GetPlayerServerId(PlayerId()))
							end
						end
					else
						ESX.ShowNotification('ID non valido')
					end
				end, tonumber(id[1]))
			end
		end
	},

	{
		name = 'givesporchi',
		label = 'Give Soldi Sporchi',
		command = function()
			local id =  lib.inputDialog('Menu Amministrazione',{
                { type = "input", label = "ID" },
                } 
            )

			if id then
				ESX.TriggerServerCallback('flr:isplayeronline', function(result)
					if result then
						local input =  lib.inputDialog('Menu Amministrazione',{
							{ type = "input", label = "Importo" },
							})
						if input then
							if input[1] == nil or input[1] == '0' then
								ESX.ShowNotification('Importo non valido')
							else
								TriggerServerEvent('ff_menuf5:givesoldi', 'sporchi', input[1], id[1], GetPlayerServerId(PlayerId()))
							end
						end
					else
						ESX.ShowNotification('ID non valido')
					end
				end, tonumber(id[1]))
			end
		end
	},

	{
		name = 'pulizia',
		label = 'Pulisci tutti i Veicoli',
		command = function()
			ESX.TriggerServerCallback('Mambi:Pulizia', function()
				ESX.ShowNotification('Hai pulito con successo tutti i veicoli!')
			end, 'Vehicles')
		end
	},

	{
		name = 'puliziaoggetti',
		label = 'Pulisci tutti i Props (MODDER ONLY)',
		command = function()
			ESX.TriggerServerCallback('Mambi:Pulizia', function()
				ESX.ShowNotification('Hai pulito con successo tutti i prop!')
			end, 'Object')
		end
	},
}

Config.Marker                     = {type = 2, x = 0.8, y = 0.8, z = 0.5, r = 255, g = 255, b = 255, a = 100, rotate = false}
Config.ReviveReward               = 400  -- Revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- Enable anti-combat logging? (Removes Items when a player logs back after intentionally logging out while dead.)
Config.LoadIpl                    = false -- Disable if you're using fivem-ipl or other IPL loaders
    
Config.EarlyRespawnTimer          = 60000 * 5  -- time til respawn is available
Config.BleedoutTimer              = 490000 * 5 -- time til the player bleeds out
    
    
Config.RemoveWeaponsAfterRPDeath  = false
Config.RemoveCashAfterRPDeath     = false
Config.RemoveItemsAfterRPDeath    = false
    
    -- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 5000
    

Config.RespawnPoint = {coords = vector3(297.8374, -574.4176, 43.13037), heading = 119.0551}


--		██╗░░░░░░█████╗░░██████╗░ 	░██████╗██╗░░░██╗░██████╗████████╗███████╗███╗░░░███╗		--
--		██║░░░░░██╔══██╗██╔════╝░  	██╔════╝╚██╗░██╔╝██╔════╝╚══██╔══╝██╔════╝████╗░████║		--
--		██║░░░░░██║░░██║██║░░██╗░  	╚█████╗░░╚████╔╝░╚█████╗░░░░██║░░░█████╗░░██╔████╔██║		--
--		██║░░░░░██║░░██║██║░░╚██╗  	░╚═══██╗░░╚██╔╝░░░╚═══██╗░░░██║░░░██╔══╝░░██║╚██╔╝██║		--
--		███████╗╚█████╔╝╚██████╔╝  	██████╔╝░░░██║░░░██████╔╝░░░██║░░░███████╗██║░╚═╝░██║		--
--		╚══════╝░╚════╝░░╚═════╝░  	╚═════╝░░░░╚═╝░░░╚═════╝░░░░╚═╝░░░╚══════╝╚═╝░░░░░╚═╝		--

Config.ServerName = 'Royal Roleplay'
Config.IconUrl = 'https://cdn.discordapp.com/attachments/1035285197639385188/1143382805997424771/Logo_Royal_Rp_3.0_512x512.png'
Config.Color = 16777215 -- White
Config.Footer = 'Royal Roleplay'

Config.playerID = true				
Config.steamID = true				
Config.steamURL = true				
Config.discordID = true
Config.xblID = true	
Config.liveID = true
Config.licenseID = true
Config.license = true	
Config.IP = true

Config.DrawingTime = 60*1000 -- 20 secondi
Config.TextColor = {r=255, g=255,b=255} -- (Player Data) bianco
Config.AlertTextColor = {r=255, g=0, b=0} --  (Player Left Game) 255,0,0 rosso
Config.UseSteam = true
Config.AutoDisableDrawing = true
Config.AutoDisableDrawingTime = 15000

Config.DanniArma = {
    ["WEAPON_PUMPSHOTGUN"] = 2.50,
    ["WEAPON_PISTOL50"] = 0.7,
    ["WEAPON_HEAVYPISTOL"] = 0.7,
    ["WEAPON_VINTAGEPISTOL"] = 0.6,
    ["WEAPON_UNARMED"] = 0.1,
    ["WEAPON_NIGHTSTICK"] = 0.25,
    ["WEAPON_FLASHLIGHT"] = 0.2,
    ["WEAPON_KNIFE"] = 0.3,
    ["WEAPON_SWITCHBLADE"] = 0.3,
    ["WEAPON_BAT"] = 0.4,
    ["WEAPON_CROWBAR"] = 0.3,
    ["WEAPON_HAMMER"] = 0.3,
    ["WEAPON_BOTTLE"] = 0.3,
    ["WEAPON_WRENCH"] = 0.3,
}

-- MODIFICHE

-- name = 'a' aggiunto per la creazione del marker in grid

Config.BlipAcquistaGiubbotto = {
	{ name = 'a', x = 9.507693, y= -1107.007, z= 29.7854 },
	{ name = 'b',  x = 810.2637, y = -2156.387, z = 29.61682 },
	{ name = 'c', x = -328.07, y= 6078.07, z= 31.45 }, 
	{ name = 'd', x = -1311.191, y= -388.8528, z=36.69373 },
    { name = 'f', x = 1696.08, y= 3754.44, z= 34.70 },
	{ name = 'g', x = 844.83, y= -1027.87, z= 28.19 },
	{ name = 'h', x = -3168.06, y= 1083.49, z= 20.83 },
	{ name = 'i', x = 72.39, y= -1572.02, z= 29.60 },
	{ name = 'l', x = 247.4598, y= -45.7527, z= 69.9348 },
	{ name = 'm', x = -664.5380, y= -941.0549, z= 21.8292 },
	--{ name = 'n', x = -1052.242, y= 229.3451, z= 63.75464 }, rimosso blip argentini
	{ name = 'michoachana', x = 96.586334228516, y= 1235.0745849609, z= 207.17431640625},
}

Config.GiubbottoJob = {
	{ jobname = 'police', name = 'a', x =-407.64227294922, y = -380.11456298828, z = 25.098743438721 },
	{ jobname = 'sceriffo', name = 'b', x = -447.04061889648, y = 6018.65234375, z = 32.288707733154 },
	{ jobname = 'fbi', name = 'c', x =2524.114, y = -341.2615, z = 101.8857 },
	{ jobname = 'dea', name = 'd', x = 882.93286132813, y = 2860.2785644531, z = 59.888053894043},
}

-- MODIFICHE 





---- DROGHE ----

Config.BlockFrom 			= "02:00"
Config.BlockTo				= "10:00" 

Droghe = {
	Raccolta = {
		blazeit = {
			item = "tabacco",
			min_pula = 0,
			amountToGive = 2,
			tempo = 6000,
			texture = 'marker_raccolta',
			job = nil,
			msg = 'RACCOLTA TABACCO',
			pos = {
				vector3(364.90615844727, -1252.0093994141, 32.594062805176),
			},
			animation = function()
				animazione(6)
			end
		 },
		 marijuana = {
			item = "cimetta",
			min_pula = 0,
			amountToGive = 2,
			tempo = 6000,
			texture = 'marker_raccolta',
			job = nil,
			msg = 'RACCOLTA CIMETTA',
			pos = {
				vector3(2226.4567871094, 5576.8413085938, 53.867641448975),  -- 3031
				vector3(2221.8786621094, 5577.208984375, 53.845397949219),
				vector3(2229.4912109375, 5576.6909179688, 53.930812835693)
			},
			animation = function()
				animazione(6)
			end
		 }
	}, 
	Processo = {
		marijuana_processo = {
			min_pula = 0,
			amountToProcess = 3,
			itemToGive = 'marijuana',
			itemToRemove = 'cimetta',
			amountToGive = 2,
			amountToRemove = 3,
			msg = 'PROCESSA MARIJUANA',
			tempo = 8000,
			job = nil,
			texture = 'marker_processo',
			pos = {
				vector3(2403.5607910156, 3127.8698730469, 48.152935028076), -- 954
				vector3(2400.859375, 3124.9345703125, 48.15295791626)
			},
			animation = function()
				animazione(8)
			end
		},
		--[[cocaina = {
			min_pula = 0,
			amountToProcess = 3,
			itemToGive = 'cocainaprocessata',
			itemToRemove = 'cocaina',
			amountToGive = 2,
			amountToRemove = 3,
			msg = 'PROCESSA COCAINA',
			tempo = 15000,
			job = nil,
			texture = 'marker_processo',
			pos = {
				vector3(2433.7465820313, 4969.072265625, 42.347629547119), -- 2025,
			},
			animation = function()
				animazione(15)
			end
		},
		amnesia = {
			min_pula = 0,
			amountToProcess = 3,
			itemToGive = 'amnesiaprocessata',
			itemToRemove = 'amnesia',
			amountToGive = 2,
			amountToRemove = 3,
			msg = 'PROCESSA AMNESIA',
			tempo = 8000,
			job = nil,
			texture = 'marker_processo',
			pos = {
				vector3(3286.774, 5178.237, 18.52966), -- 2027
				vector3(3288.725, 5180.347, 18.51282),
				vector3(3290.967, 5183.367, 18.51282)
			},
			animation = function()
				animazione(8)
			end
		},
		--[[tabacco = {
			min_pula = 0,
			amountToProcess = 3,
			itemToGive = 'tabacco',
			itemToRemove = 'fogliatabacco',
			amountToGive = 2,
			amountToRemove = 3,
			tempo = 10000,
			job = 'daddytobacco',
			texture = 'tabacco',
			msg = 'Premi [E] per processare il tabacco',
			pos = {
				vector3(-57.011516571045, 2912.1064453125, 60.099090576172),
				vector3(-58.073139190674, 2910.2438964844, 60.099090576172),
				vector3(-54.880847930908, 2910.95703125, 60.099098205566),
				vector3(-55.812957763672, 2909.0197753906, 60.099098205566),
			},
			animation = function()
				FreezeEntityPosition(PlayerPedId(), true)
				ExecuteCommand('e picklock')
				Wait(10000)
				FreezeEntityPosition(PlayerPedId(), false)
				ExecuteCommand('e c')
			end
		},	]]
	},
	MixDrugs = {
		p_codeina = {
			label = 'Codeina e Cocaina',
			pos = vector3(0.00, 0.00, 0.00), 
			itemtogive = "cocainaprocessata",
			amount = 2,
			items = {
				['cocaina'] = 5,
				['codeina'] = 1,
			},
		},
	},
}

---- DROGHE ----


---- FLR CONTAINER ----

Config.Setup = false

--[[ se l'opzione config.usetarget è true automaticamente il marker della gestione container non viene registrato ]] --
Config.GestioneContainer  = {
    ["Gestione"] = { -- gestione per acquisti container
        coords = vector3(-1393.4165039063,-2309.5578613281,13.959177970886),    -- coordinate blip
        pin = "3333"                                                            -- pin per accesso
    },
}
--

-- il valore 'slots' e 'peso' viene utilizzato la prima volta che si crea l'inventario, dopo si farà tutto con sql

Config.Container = {
	["Container"] = {
		["Container 1"] = {
			coords = vector3(1176.791, -3021.02, 5.892334), 
            slots = 40,
            peso = 500    
		},
		["Container 2"] = {
			coords = vector3(1176.791, -3023.697, 5.892334),     
            slots = 40, 
            peso = 500
		},
        ["Container 3"] = {
			coords = vector3(1176.804, -3026.215, 5.892334),     
            slots = 40, 
            peso = 500
		},
		["Container 4"] = {
			coords = vector3(1176.791, -3028.932, 5.892334),     
            slots = 40, 
            peso = 500
		},
		["Container 5"] = {
			coords = vector3(1176.791, -3031.543, 5.892334),     
            slots = 40, 
            peso = 500
		},
		["Container 6"] = {
			coords = vector3(1176.725, -3036.976, 5.892334),     
            slots = 40, 
            peso = 500
		},
		["Container 7"] = {
			coords = vector3(1176.712, -3039.626, 5.892334),     
            slots = 40, 
            peso = 500
		},
		["Container 8"] = {
			coords = vector3(1176.725, -3042.29, 5.892334),     
            slots = 40, 
            peso = 500
		},
		["Container 9"] = {
			coords = vector3(1176.752, -3044.967, 5.892334),     
            slots = 40, 
            peso = 500
		},
		["Container 10"] = {
			coords = vector3(1176.672, -3047.578, 5.892334),     
            slots = 40, 
            peso = 500
		},
	}
}

Config.PriceForUpdate = 5000000
Config.SlotsUpdate = 200
Config.WeightUpdate = 500


--		░██████╗░████████╗░█████╗░██████╗░░██████╗░███████╗████████╗ 	--
--		██╔═══██╗╚══██╔══╝██╔══██╗██╔══██╗██╔════╝░██╔════╝╚══██╔══╝ 	--
--		██║██╗██║░░░██║░░░███████║██████╔╝██║░░██╗░█████╗░░░░░██║░░░ 	--
--		╚██████╔╝░░░██║░░░██╔══██║██╔══██╗██║░░╚██╗██╔══╝░░░░░██║░░░ 	--
--		░╚═██╔═╝░░░░██║░░░██║░░██║██║░░██║╚██████╔╝███████╗░░░██║░░░ 	--
--		░░░╚═╝░░░░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝░╚═════╝░╚══════╝░░░╚═╝░░░ 	--

Config.UseTarget = true
Config.Qtarget = 'qtarget'

npc = { -- Posizione degli npc per gestione acquisti container (NPC spawnato solo se Config.UseTarget = true)
    [1] = {
        coord = vector3(1176.6683349609, -3015.3796386719, 4.902138710022),
        heading = 324.36370849609,
        ped = 's_m_m_dockwork_01',
    },
}


--		██╗░░░░░░█████╗░░██████╗░ 	░██████╗██╗░░░██╗░██████╗████████╗███████╗███╗░░░███╗		--
--		██║░░░░░██╔══██╗██╔════╝░  	██╔════╝╚██╗░██╔╝██╔════╝╚══██╔══╝██╔════╝████╗░████║		--
--		██║░░░░░██║░░██║██║░░██╗░  	╚█████╗░░╚████╔╝░╚█████╗░░░░██║░░░█████╗░░██╔████╔██║		--
--		██║░░░░░██║░░██║██║░░╚██╗  	░╚═══██╗░░╚██╔╝░░░╚═══██╗░░░██║░░░██╔══╝░░██║╚██╔╝██║		--
--		███████╗╚█████╔╝╚██████╔╝  	██████╔╝░░░██║░░░██████╔╝░░░██║░░░███████╗██║░╚═╝░██║		--
--		╚══════╝░╚════╝░░╚═════╝░  	╚═════╝░░░░╚═╝░░░╚═════╝░░░░╚═╝░░░╚══════╝╚═╝░░░░░╚═╝		--

-- Per cambiare i webhook andare in server/webhook.lua/

Config.ServerName = 'Royal Roleplay'
Config.IconUrl = 'https://cdn.discordapp.com/attachments/1050015364488114216/1106707113998299188/Logo_512x512_Royal_Rp_2.0.png'
Config.Color = 16777215 -- White
Config.Footer = 'Royal Roleplay'

---- FLR CONTAINER ----

BlipMappa = {
	['Nadir Custom'] = {
		pos = vector3(546.5275, -166.7604, 54.48718),
		id = 643,
		color = 27,
		scale = 0.8
	},

	['Rising Sun Custom'] = {
		pos = vector3(-328.8, -129.7451, 39.0022),
		id = 643,
		color = 1,
		scale = 0.8
	},

	['Ospedale'] = {
		pos = vector3(309.53598022461, -589.01849365234, 43.277820587158),
		id = 61,
		color = 1,
		scale = 0.8
	},

	[''] = {
		pos = vector3(-3788.7629394531, -4021.7094726563, 57.432163238525),
		id = 303,
		color = 1,
		scale = 0.4
	},

	["Sofia's Land"] = {
		pos = vector3(-3568.7124023438, -1381.0330810547, 1.4807621240616),
		id = 303,
		color = 1,
		scale = 0.4
	},

	["Poseidon"] = {
		pos = vector3(-3087.66, 7479.27246, 14.7807522),
		id = 303,
		color = 1,
		scale = 0.4
	},

	['Vanilla Unicorn'] = {
		pos = vector3(133.13359069824,-1306.7082519531,  29.118326187134),
		id = 121,
		color = 61,
		scale = 0.8
	},

	['Stazione di Polizia'] = {
		pos = vector3(-391.6745300293, -342.36773681641, 38.42488861084),
		id = 60,
		color = 38,
		scale = 0.8
	},

	['Chiesa'] = {
		pos = vector3(-1684.3623046875, -280.98764038086, 62.836288452148),
		id = 305,
		color = 46,
		scale = 0.8
	},

	['FBI'] = {
		pos = vector3(2506.127, -386.6505, 94.11792),
		id = 60,
		color = 0,
		scale = 0.8
	},

	['Sceriffato'] = {
		pos = vector3(-448.4835, 6012.514, 36.98022),
		id = 60,
		color = 56,
		scale = 0.8
	},

	['Carcere'] = {
		pos = vector3(-1098.2418212891, -536.14044189453, 36.181552886963),
		id = 189,
		color = 1,
		scale = 0.8
	},

	['Governo'] = {
		pos = vector3(-544.68829345703, -204.82366943359, 38.216262817383),
		id = 438,
		color = 56,
		scale = 0.8
	},

	['Apple Store'] = {
		pos = vector3(-1274.6284179688, -1411.4064941406, 4.3676300048828),
		id = 606,
		color = 59,
		scale = 0.6
	},

	['Centro Impiego'] = {
		pos = vector3(1203.3096923828, -1259.5335693359, 35.226867675781),
		id = 408,
		color = 56,
		scale = 0.8
	},

	['Import/Export'] = {
		pos = vector3(1226.18, -3227.22, 5.89),
		id = 478,
		color = 56,
		scale = 0.8
	},

	--[[['Koi Sushi'] = {
		pos = vec3(-1034.9530029297, -1482.7436523438, 4.5796232223511),
		id = 93,
		color = 57,
		scale = 0.8
	},

	['Tabaccaio'] = {
		pos = vector3(266.7297, -774.1187, 30.93115),
		id = 469,
		color = 1,
		scale = 0.8
	},]]

	['Blaze It'] = {
		pos = vector3(368.80490112305, -1264.0174560547, 32.587219238281),
		id = 469,
		color = 2,
		scale = 0.8
	},

	['Bahamas'] = {
		pos = vector3(-1386.0323486328, -602.56457519531, 30.213953018188),  
		id = 93,
		color = 19,
		scale = 0.8
	},

	['Bennys'] = {
		pos = vector3(-201.9297, -1303.319, 31.25134),
		id = 643,
		color = 3,
		scale = 0.8
	},

	['Cockatoos'] = {
		pos = vector3(-442.3385, -31.22637, 46.18018),
		id = 93,
		color = 46,
		scale = 0.8
	},

	['Perla'] = {
		pos = vector3(-1842.12,-1199.18, 14.30),
		id = 266,
		color = 3,
		scale = 0.8
	},

	['Armeria 200'] = {
		pos = vector3(19.16044, -1111.793, 29.7854),
		id = 313,
		color = 1,
		scale = 0.8
	},

	['Armeria 366'] = {
		pos = vector3(-662.822, -934.9319, 21.81543),
		id = 313,
		color = 1,
		scale = 0.8
	},

	--[[['East Custom'] = {
		pos = vector3(867.3494, -2115.521, 30.4762),
		id = 446,
		color = 46,
		scale = 0.8
	},

	['Nikki Beach'] = {
		pos = vector3(-1474.76, -1258.998, 2.893066),
		id = 93,
		color = 3,
		scale = 0.8
	},]]

	['Case Popolari'] = {
		pos = vector3(-867.796875, -1274.90625, 5.1501750946045),
		id = 475,
		color = 0,
		scale = 0.8
	},

	['Grotti Auto Usate'] = {
		pos = vector3(-948.1451, -2053.16, 9.397095),
		id = 523,
		color = 1,
		scale = 0.8
	},

	['Bean Machine'] = {
		pos = vector3(120.59442901611, -1035.6409912109, 29.304903030396),
		id = 93,
		color = 25,
		scale = 0.8
	},

	['Rimozione Forzata'] = {
		pos = vector3(489.0593, -1330.958, 29.33044),
		id = 527,
		color = 46,
		scale = 0.8
	},

}


Config.TimerBeforeNewRob    = 1800 -- The cooldown timer on a store after robbery was completed / canceled, in seconds
Config.GiveBlackMoney = true -- give black money? If disabled it will give cash instead

Stores = {
	['paleto_twentyfourseven'] = {
		position = vector3(1729.4641113281, 6419.34375, 31.925020217896),
		reward = math.random(40000, 50000),
		nameOfStore = '24/7. (Paleto Bay)',
		secondsRemaining = 600, -- seconds
		cops = 2,
		lastRobbed = 0
	},
	['sandyshores_twentyfoursever'] = {
		position = vector3(1958.19140625, 3743.12109375, 29.231527328491),
		reward =  math.random(40000, 50000),
		nameOfStore = '24/7. (Sandy Shores)',
		secondsRemaining = 600, -- seconds
		cops = 2,
		lastRobbed = 0
	},
	['littleseoul_twentyfourseven'] = {
		position = vector3(-709.17, -904.21, 19.21),
		reward =  math.random(40000, 50000),
		nameOfStore = '24/7. (Little Seoul)',
		secondsRemaining = 600, -- seconds
		cops = 2,
		lastRobbed = 0
	},
	['bar_one'] = {
		position = vector3(1981.5880126953, 3051.3430175781, 47.215045928955),
		reward =  math.random(40000, 50000),
		nameOfStore = 'Yellow Jack. (Sandy Shores)',
		secondsRemaining = 600, -- seconds
		cops = 2,
		lastRobbed = 0
	},
	['ocean_liquor'] = {
		position = vector3(-2959.5927734375, 387.05838012695, 14.043291091919),
		reward = math.random(40000, 50000),
		nameOfStore = 'Robs Liquor. (Great Ocean Highway)',
		secondsRemaining = 600, -- seconds
		cops = 2,
		lastRobbed = 0
	},
	['rancho_liquor'] = {
		position = vector3(1126.8020019531, -980.35150146484, 45.4157371521),
		reward = math.random(40000, 50000),
		nameOfStore = 'Robs Liquor. (El Rancho Blvd)',
		secondsRemaining = 600, -- seconds
		cops = 2,
		lastRobbed = 0
	},
	['sanandreas_liquor'] = {
		position = vector3(-1220.7418212891, -915.99853515625, 11.326337814331),
		reward = math.random(40000, 50000),
		nameOfStore = 'Robs Liquor. (San Andreas Avenue)',
		secondsRemaining = 600, -- seconds
		cops = 2,
		lastRobbed = 0
	},
	['grove_ltd'] = {
		position = vector3(-43.400089263916, -1749.1999511719, 29.420375823975),
		reward = math.random(40000, 50000),
		nameOfStore = 'LTD Gasoline. (Grove Street)',
		secondsRemaining = 600, -- seconds
		cops = 2,
		lastRobbed = 0
	},
	['negozietto_575'] = {
		position = vector3(373.38388061523, 329.89758300781, 100.45426940918),
		reward = math.random(40000, 50000),
		nameOfStore = 'Negozietto 575',
		secondsRemaining = 600, -- seconds
		cops = 2,
		lastRobbed = 0
	},
	['mirror_ltd'] = {
		position = vector3(1160.6505126953, -314.40185546875, 69.205032348633),
		reward = math.random(40000, 50000),
		nameOfStore = 'LTD Gasoline. (Mirror Park Boulevard)',
		secondsRemaining = 600, -- seconds
		cops = 2,
		lastRobbed = 0
	},
	['gabriela'] = {
		position = vector3(1170.83, -295.76, 69.12 + 0.5),
		reward = math.random(60000, 75000),
		nameOfStore = 'Gabriela\'s Market',
		secondsRemaining = 600, -- seconds
		cops = 4,
		lastRobbed = 0
	},
	['blaine'] = {
		position = vector3(-105.34, 6476.72, 31.63 + 0.5),
		reward = 200000,
		nameOfStore = 'Blaine',
		secondsRemaining = 600, -- seconds
		cops = 8,
		lastRobbed = 0
	},	
	['fleeca584'] = {
		position = vector3(310.46853637695, -286.16751098633, 54.164863586426),
		reward = 120000,
		nameOfStore = 'Fleeca 584',
		secondsRemaining = 600, -- seconds
		cops = 7,
		lastRobbed = 0
	},	
	['fleeca529'] = {
		position = vector3(-354.23443603516, -57.129482269287, 49.036735534668),
		reward = 120000,
		nameOfStore = 'Fleeca 529',
		secondsRemaining = 600, -- seconds
		cops = 7,
		lastRobbed = 0
	},	
	['fleeca656'] = {
		position = vector3(-1209.9383544922, -338.14526367188, 37.781154632568),
		reward = 120000,
		nameOfStore = 'Fleeca 656',
		secondsRemaining = 600, -- seconds
		cops = 7,
		lastRobbed = 0
	},	
	['fleeca814'] = {
		position = vector3(-2954.7556152344, 481.40594482422, 15.69809627533),
		reward = 120000,
		nameOfStore = 'Fleeca 814',
		secondsRemaining = 600, -- seconds
		cops = 7,
		lastRobbed = 0
	},	
	--[[['pacific'] = {
		position = vector3(239.0637, 218.5319, 106.9575 + 0.5),
		reward = 1500000,
		nameOfStore = 'Pacific',
		secondsRemaining = 600, -- seconds
		cops = 15,
		lastRobbed = 0
	},]]
}



------------- Furto Auto
Config.CopsRequired = 2 -- cops required to start mission, not finished
Config.amountOfDropoff = 6 -- (amount of dropoffPoints)
Config.dropoffPoints = { -- x,y,z = where you leave the vehicle, sx,sy,sz,sh = x,y,z for vehicle spawn + heading for vehicle
	[1] = { x = 1787.83, y = 3888.49, z = 34.39, sx = 715.1, sy = -830.57, sz = 24.39, sh = 268.76, model = "flashgt"},
	[2] = { x = 639.75, y = 2779.08, z = 41.98, sx = -248.18, sy = 491.81, sz = 125.85, sh = 38.28, model = "entityxf"},
	[3] = { x = -2192.39, y = 4265.86, z = 47.72, sx = -1170.99, sy = -1179.14, sz = 5.62, sh = 189.35, model = "comet2"},
	[4] = { x = 1787.83, y = 3888.49, z = 34.39, sx = 420.85, sy = -1561.85, sz = 29.28, sh = 93.28, model = "elegy2"},
	[5] = { x = 639.75, y = 2779.08, z = 41.98, sx = 865.39, sy = -2989.05, sz = 5.9, sh = 283.86, model = "infernus"},
	[6] = { x = 639.75, y = 2779.08, z = 41.98, sx = 28.84, sy = -67.57, sz = 61.88, sh = 113.85, model = "exemplar"}
}



Config['PoleDance'] = { 
    ['Enabled'] = true,
    ['Locations'] = {
        -- VANILLA NUOVO

		{['Position'] = vector3(121.77, -1289.25, 29.26), ['Number'] = '1'},
		{['Position'] = vector3(116.66, -1292.19, 29.26), ['Number'] = '1'},
		{['Position'] = vector3(111.50, -1295.17, 29.26), ['Number'] = '1'},
		{['Position'] = vector3(127.195, -1294.079, 21.69) , ['Number'] = '1'},
		{['Position'] = vector3(116.336, -1300.352, 21.69), ['Number'] = '1'},
		{['Position'] = vector3(109.549, -1288.595, 21.69) , ['Number'] = '1'},
		{['Position'] = vector3(120.391, -1282.339, 21.69), ['Number'] = '1'},
		{['Position'] = vector3(114.499, -1277.792, 21.387) , ['Number'] = '1'},
		{['Position'] = vector3(108.674, -1281.162, 21.387)  , ['Number'] = '1'},
		{['Position'] = vector3(128.152, -1301.439, 21.387)  , ['Number'] = '1'},
		{['Position'] = vector3(122.327, -1304.808, 21.387), ['Number'] = '1'},
		{['Position'] = vector3(106.7449, -1313.185, 29.84712), ['Number'] = '1'},
		{['Position'] = vector3(109.5838,-1311.546, 29.84712), ['Number'] = '1'},
		{['Position'] = vector3(112.2671, -1309.997, 29.84712), ['Number'] = '1'},

		-- DOM PERIGNON
		{['Position'] = vector3(920.84, 54.08, 111.72), ['Number'] = '1'},
        {['Position'] = vector3(909.96, 53.2, 111.72), ['Number'] = '2'},
        {['Position'] = vector3(915.2, 41.92, 111.72), ['Number'] = '3'},
    }
}

Config.gsrUpdate                = 1 * 1000          -- Change first number only, how often a new shot is logged dont set this to low keep it above 1 min - raise if you experience performance issues (default: 1 min).
Config.waterClean               = true              -- Set to false if you dont want water to clean off GSR from people who shot
Config.waterCleanTime           = 30 * 1000         -- Change first number only, Set time in water needed to clean off GSR (default: 30 sec).
Config.gsrTime                  = 30 * 60           -- Change The first number only, if you want the GSR to be auto removed faster output is minutes (default: 30 min).
Config.gsrAutoRemove            = 10 * 60 * 1000    -- Change first number only, to set the auto clean up in minuets (default: 10 min).
Config.gsrUpdateStatus          = 5 * 60 * 1000     -- Change first number only, to change how often the client updates hasFired variable dont set it very high... 5-10 min should be fine. (default: 5 min).
Config.UseCharName				= true				-- This will show the suspects name in the PASSED or FAILED notification. Allows cop to make sure they checked the right person.

Config.weaponChecklist = {
		--Get models id here : https://pastebin.com/0wwDZgkF
		0x3656C8C1, -- stunGun
		0x678B81B1, -- nightStick
		0x84BD7BFD, -- crowBar
		0x60EC506, 	-- Fire Extinguisher
}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 27
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 0.5 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }
Config.EnableHandcuffTimer        = false -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.VenditaPawn = {

	['import'] = {
		pos = {
			vector3(1229.459, -3293.552, 5.487915),
			vector3(1229.644, -3286.167, 5.487915)
		},
		items = {
			['stones'] = 50,
		},
		msg = 'VENDITA'
	}

}

-- Allow below identifier player to execute commands
Config.AuthorizedRanks = {
  'superadmin',
  'admin',
  'mod',
}

Config.Locations18 = { -- Unicorn Girl tubo
	{ x = 112.66, y = -1310.76, z = 29.68, heading = 211.33 }	
	
}

Config.Locations19 = { -- Unicorn Girl tubo
	{ x = 109.79, y = -1312.34, z = 29.68, heading = 207.24 }	
	
}

Config.Locations20 = { -- Unicorn Girl tubo
	{ x = 106.98, y = -1314.11, z = 29.68, heading = 217.72 }	
	
}

config = {

    hide_own_blip = false,
    debug = false,

    blip_types = {
        ['police'] = {
            _can_see = { 'doc', 'ambulance' },
            _color = 3,
            _type = 1,
            _scale = 0.85,
            _alpha = 255,
            _show_off_screen = false,
            _show_local_direction = false,
        },
        ['ambulance'] = {
            _color = 1,
        },
        ['doc'] = {
            _color = 5,
        },
    },

    default_type = {
        _color = 0,
        _type = 1,
        _scale = 0.85,
        _alpha = 255,
        _show_off_screen = false,
        _show_local_direction = false,
    }
}

--- case popolari

Config.EntrataCasa = vector3(-867.79718017578, -1274.8072509766, 5.1501755714417) -- Blip  per entrare
Config.TeleportEntrata = vector3(-872.89221191406, -1276.6956787109, -37.812152862549) -- Teletrasporto entrata

Config.UscitaCasa = vector3(-872.89221191406, -1276.6956787109, -37.812152862549) -- Blip  per USCIRE
Config.TeleportUscita = vector3(-867.79718017578, -1274.8072509766, 5.1501755714417) -- Teletrasporto uscita

--- Lato Inventario

Config.InventarioPopolare = vector3(-873.02069091797, -1268.1177978516, -35.812149047852)     --- inventario
Config.Label = 'Casa Popolare'  -- Label
Config.Slots = 15  -- Slots
Config.Peso =  50 -- KG

--- Lato Mappa

Config.BlipMappa = false -- Se true abilita il blip in mappa
Config.Popolare = {{  -- Coordinate blip in mappa

    Blip = 475,
    Colore = 47,
    Grandezza = 0.8,
    Nome = 'Case Popolari',
    Coords = vector3(-867.46130371094, -1275.0098876953, 5.1501750946045)

}} 

--- case popolari

Config.BlacklistedVehicles = {
	
	[`ambulance91`] = true,
	[`ambucara`] = true,											
	[`policeb`] = true,		
	[`dodgeEMS`] = true,		
	[`amr_explorer`] = true,		
	[`emsnspeedo`] = true,		
	[`polamggtr`] = true,		
	[`aw139pb`] = true,		


	[`trhawk`] = true,		
	[`nm_rs7`] = true,		
	[`nm_esc`] = true,		
	[`hellborghese`] = true,		
	[`code320exp`] = true,		
	[`code318charg`] = true,		
	[`code3cvpi`] = true,		
	[`pbus`] = true,		


	[`valorcvpi`] = true,		
	[`valor18charg`] = true,		
	[`valor18tahoe`] = true,		
	[`code319silv`] = true,		
	[`nooseinsur`] = true,		
	[`as332`] = true,		


	[`uparmorhmvdes`] = true,		
	[`m1161growler`] = true,		
	[`hmmwv`] = true,			

}

Config.AntiSpamTimer = 2

-- Vérification et attribution d'une place libre / Verification and allocation of a free place
Config.TimerCheckPlaces = 3

-- Mise à jour du message (emojis) et accès à la place libérée pour l'heureux élu / Update of the message (emojis) and access to the free place for the lucky one
Config.TimerRefreshClient = 3

-- Mise à jour du nombre de points / Number of points updating
Config.TimerUpdatePoints = 6

----------------------------------------------------
------------ Nombres de points ---------------------
----------------------------------------------------

-- Nombre de points gagnés pour ceux qui attendent / Number of points earned for those who are waiting
Config.AddPoints = 1

-- Nombre de points perdus pour ceux qui sont entrés dans le serveur / Number of points lost for those who entered the server
Config.RemovePoints = 1

-- Nombre de points gagnés pour ceux qui ont 3 emojis identiques (loterie) / Number of points earned for those who have 3 identical emojis (lottery)
Config.LoterieBonusPoints = 25

-- Accès prioritaires / Priority access
Config.Points = {
	{'steam:11000013c9531df', 1000}, -- mambi
	{'steam:110000109e33e84', 1000}, -- Ciro
	{'steam:11000013ff52bd0', 1000}, -- ser donazione
	{'steam:11000011640c361', 1000}, -- mavjius donazione
	{'steam:110000145d46d2c', 1000}, -- lukitosss donazione
	{'steam:11000015b63e349', 1000}, -- 994939135582285864 donazione
	{'steam:11000011190c733', 1000}, -- tanzo donazione
}

----------------------------------------------------
------------- Textes des messages ------------------
----------------------------------------------------

-- Si steam n'est pas détecté / If steam is not detected
Config.NoSteam = "Steam non è stato rilevato. Riavvia Steam e FiveM, quindi riprova."

-- Message d'attente / Waiting text
Config.EnRoute = "Sei sulla buona strada. Hai già viaggiato"

Config.PointsRP = "Chilometri"

-- Position dans la file / position in the queue
Config.Position = "Sei in posizione "

-- Texte avant les emojis / Text before emojis
Config.EmojiMsg = "Se le emoji sono bloccate, riavvia il tuo client: "

Config.EmojiBoost = "!!! Urrà, " .. Config.LoterieBonusPoints .. " " .. Config.PointsRP .. " gagnés !!!"

-- Anti-spam message / anti-spam text
Config.PleaseWait_1 = "Attendere prego "
Config.PleaseWait_2 = " secondi. La connessione si avvierà automaticamente!"

-- Me devrait jamais s'afficher / Should never be displayed
Config.Accident = "Oops, hai appena avuto un incidente ... Se questo dovesse accadere di nuovo, puoi informare il supporto :)"

-- En cas de points négatifs / In case of negative points
Config.Error = " ERRORE: RIAVVIARE IL SISTEMA QUEUE E CONTATTARE IL SUPPORTO "


Config.EmojiList = {
	'🐌', 
	'🐍',
	'🐎', 
	'🐑', 
	'🐒',
	'🐘', 
	'🐙', 
	'🐛',
	'🐜',
	'🐝',
	'🐞',
	'🐟',
	'🐠',
	'🐡',
	'🐢',
	'🐤',
	'🐦',
	'🐧',
	'🐩',
	'🐫',
	'🐬',
	'🐲',
	'🐳',
	'🐴',
	'🐅',
	'🐈',
	'🐉',
	'🐋',
	'🐀',
	'🐇',
	'🐏',
	'🐐',
	'🐓',
	'🐕',
	'🐖',
	'🐪',
	'🐆',
	'🐄',
	'🐃',
	'🐂',
	'🐁',
	'🔥'
}

Config.SeeOwnLabel = true
Config.SeeDistance = 30
Config.TextSize = 0.8
Config.ZOffset = 1.2
Config.NearCheckWait = 1000
Config.GroupLabels = {
	streamer = "~p~[STREAMER]",
	anticheat = "~r~[ANTICHEAT]",
	momo = "~r~[FALLITO]",
    helper = "~g~[STAFF]",
    mod = "~b~[STAFF]",
    admin = "~r~[STAFF]",
    superadmin = "~p~[STAFF]",
    manager = "~y~[MANAGER]",
	cofounder = "~r~[CO-FOUNDER]",
	founder = "~r~[FOUNDER]",
	coowner = "~b~[CO-OWNER]",
    owner = "~b~[OWNER]",
}

-- Duty scrauso di mambi fatto al volo perchè non avevo voglia di fare sql

Config.DutyOn = {
	['ambulance'] = {
		coords = vector3(322.00927734375, -582.83093261719, 43.270523071289),
		offduty = 'offdutyambulance',
		job = 'ambulance',
	},
	['import'] = {
		coords = vector3(1225.661, -3276.158, 5.487915),
		offduty = 'offdutyimport',
		job = 'import',
	},
	['police'] = {
		coords = vector3(-402.77987670898, -375.58666992188, 25.098743438721),
		offduty = 'offdutypolice',
		job = 'police',
	},
	['dea'] = {
		coords = vector3(884.20733642578, 2866.5314941406, 59.88805770874),
		offduty = 'offdutydea',
		job = 'dea',
	},
	['cia'] = {
		coords = vector3(-1069.8608398438, -252.84893798828, 39.735450744629),
		offduty = 'offdutycia',
		job = 'cia',
	},
	['fbi'] = {
		coords = vector3(2528.1567382813, -335.79284667969, 101.89338684082),
		offduty = 'offdutyfbi',
		job = 'fbi',
	},
}

Config.DutyOff = {
	['ambulance'] = {
		coords = vector3(322.00927734375, -582.83093261719, 43.270523071289),
		offduty = 'offdutyambulance',
		job = 'ambulance',
	},
	['import'] = {
		coords = vector3(1229.024, -3275.881, 5.487915),
		offduty = 'offdutyimport',
		job = 'import',
	},
	['police'] = {
		coords = vector3(-402.77987670898, -375.58666992188, 25.098743438721),
		offduty = 'offdutypolice',
		job = 'police',
	},
	['dea'] = {
		coords = vector3(884.20733642578, 2866.5314941406, 59.88805770874),
		offduty = 'offdutydea',
		job = 'dea',
	},
	['cia'] = {
		coords = vector3(-1069.8608398438, -252.84893798828, 39.735450744629),
		offduty = 'offdutycia',
		job = 'cia',
	},
	['fbi'] = {
		coords = vector3(2528.1567382813, -335.79284667969, 101.89338684082),
		offduty = 'offdutyfbi',
		job = 'fbi',
	},
}

-- Duty scrauso di mambi fatto al volo perchè non avevo voglia di fare sql

Config.Recoil = {
    ["weapon_pistol"] = 0.04,
	["weapon_glockpistol"] = 0.04,
    ["weapon_pistol_mk2"] = 0.02,
	["weapon_combatpistol"] = 0.02,
    ["weapon_pistol50"] = 0.35,
	["weapon_mp7"] = 0.20,
	["weapon_ump"] = 0.20,
    ["weapon_heavypistol"] = 0.35,
    ["weapon_carbinerifle"] = 0.25,
    ["weapon_assaultrifle"] = 0.25,
    ["weapon_smg"] = 0.20,
    ["weapon_assaultsmg"] = 0.25,
    ["weapon_combatpdw"] = 0.25,
    ["weapon_specialcarbine"] = 0.25,
    ["weapon_doubleaction"] = 0.4,
    ["weapon_minismg"] = 0.3,
    ["weapon_microsmg"] = 0.25,
}

mambi_config = {}

mambi_config.role = "👾｜Twitch Sub"

Config.Teleport = {	

	ambulance = {
		Pos = {x = 330.1714, y = -601.1605, z = 43.2821},
		PosText = '[E] Piano 1',
		--
		PosOutText = '[E] Piano Terra',
		Posout = {x = 338.8615, y = -583.8593, z =  74.15088}
	},	

	mirror = {
		Pos = {x = -1311.679, y = -1032.738, z = 12.46375},
		PosText = '[E] Piano 1',
		--
		PosOutText = '[E] Piano Terra',		
		Posout = {x = -1313.222, y = -1025.13, z = 26.87036}
	},	

	dea = {
		Pos = {x = -2301.719, y = 3387.165, z = 31.25134},
		PosText = '[E] Entra',
		--
		PosOutText = '[E] Esci',		
		Posout = {x = -2286.04, y = 3380.545, z = 31.20068}
	},

	police = {
		Pos = {x = -2302.932, y = 3385.503, z = 31.25134},
		PosText = '[E] Entra',
		--
		PosOutText = '[E] Esci',		
		Posout = {x = -2292.659, y = 3370.813, z = 31.33557}
	},
}

Config.Ascensori = {

	['mirror_pubblico'] = {
		posIn = vector3(-1342.8, -1057.49, 11.45276), -- Sotto tippa a Sopra
		posInText = '[E] Piano 1',

		posOut = vector3(-1345.266, -1053.547, 19.92822), -- Sopra tippa a Sotto
		posOutText = '[E] Piano Terra',
	},	

	['magic_pubblico'] = {
		posIn = vector3(270.7648, -819.0857, 29.43152), -- Sotto tippa a Sopra
		posInText = '[E] Piano 1',

		posOut = vector3(253.4769, -806.1627, 75.80225), -- Sopra tippa a Sotto
		posOutText = '[E] Piano Terra',
	},

	--[[['ambulance_pubblico'] = {
		posIn = vector3(340.167, -584.6241, 28.79126), -- Sotto tippa a Sopra
		posInText = '[E] Piano 1',

		posOut = vector3(332.4264, -595.6483, 43.2821), -- Sopra tippa a Sotto
		posOutText = '[E] Piano Terra',
	},	]]

}

Config.CasePersonali = {

	['1:steam:11000010d68dfde'] = {
		posIn = vector3(-265.622, -735.4681, 34.41907), -- Sotto tippa a Sopra
		posInText = '[E] Piano 1',

		posOut = vector3(-286.2725, -723.1649, 125.4586), -- Sopra tippa a Sotto
		posOutText = '[E] Piano Terra',

		hex = {
			'1:steam:11000010d68dfde', -- mikilus
			'1:steam:1100001498df4a7', -- hames collins
			'1:steam:11000013c2c8151', -- bryan anselmi
			'1:steam:110000136cf330c' -- dario mori  
		},
	}

}

Config.UseTebex = false

Config.Packages = {
	["pacchetto-soldi-1"] = {
		Items = {
			{
				name = "bank",
				amount = 100000,
				type = "account"
			},
		},
	},
    ["pacchetto-soldi-2"] = {
		Items = {
			{
				name = "bank",
				amount = 300000,
				type = "account"
			},
		},
	},
    ["pacchetto-soldi-3"] = {
		Items = {
			{
				name = "bank",
				amount = 800000,
				type = "account"
			},
		},
	},
    ["pacchetto-soldi-4"] = {
		Items = {
			{
				name = "bank",
				amount = 2000000,
				type = "account"
			},
		},
	},
	["pacchetto-armi-1"] = {
		Items = {
			{
				name = "weapon_pistol",
				amount = 3,
				type = "weapon"
			},
			{
				name = "ammo-9",
				amount = 600,
				type = "weapon"
			},
		},
	},
	["pacchetto-armi-2"] = {
		Items = {
			{
				name = "weapon_pistol",
				amount = 8,
				type = "weapon"
			},
			{
				name = "ammo-9",
				amount = 1600,
				type = "weapon"
			},
		},
	},
	["pacchetto-armi-3"] = {
		Items = {
			{
				name = "weapon_pistol",
				amount = 6,
				type = "weapon"
			},
			{
				name = "ammo-9",
				amount = 1200,
				type = "weapon"
			},
			{
				name = "weapon_mp7",
				amount = 6,
				type = "weapon"
			},
			{
				name = "ammo-rifle",
				amount = 1200,
				type = "weapon"
			},
		},
	},
	["pacchetto-armi-4"] = {
		Items = {
			{
				name = "weapon_pistol",
				amount = 8,
				type = "weapon"
			},
			{
				name = "ammo-9",
				amount = 1600,
				type = "weapon"
			},
			{
				name = "weapon_mp7",
				amount = 10,
				type = "weapon"
			},
			{
				name = "ammo-rifle",
				amount = 2000,
				type = "weapon"
			},
		},
	},
	["pacchetto-starter-base"] = {
		Items = {
			{
				name = "money",
				amount = 50000,
				type = "account"
			},
			{
				name = "weapon_pistol",
				amount = 1,
				type = "weapon"
			},
			{
				name = "ammo-9",
				amount = 350,
				type = "weapon"
			},
		},
	},
	["pacchetto-starter-avanzato"] = {
		Items = {
			{
				name = "money",
				amount = 100000,
				type = "account"
			},
			{
				name = "weapon_pistol",
				amount = 2,
				type = "weapon"
			},
			{
				name = "ammo-9",
				amount = 600,
				type = "weapon"
			},
		},
	},
	["pacchetto-poteri-base"] = {
		Items = {
			{
				tipo = 'streamer',
				type = "poteri"
			},
		},
	},
	["pacchetto-poteri-avanzato"] = {
		Items = {
			{
				tipo = 'poterimod',
				type = "poteri"
			},
		},
	},
	["pacchetto-doppiopg"] = {
		Items = {
			{
				amount = 2,
				type = "doppiopg"
			},
		},
	},
	["pacchetto-triplopg"] = {
		Items = {
			{
				amount = 3,
				type = "doppiopg"
			},
		},
	},
	["pacchetto-pass-infinito"] = {
		Items = {
			{
				infinito = true,
				type = "pass"
			},
		},
	},
	["pacchetto-pass-mensile"] = {
		Items = {
			{
				infinito = false,
				type = "pass"
			},
		},
	},
}

Config.jobs = {
    "grotti"
}

Shells = {
    ['Villetta'] = {
	   coords = vec3(-270.60729980469, -968.12261962891, 77.231475830078), 
	   inventario = vec(-270.50839233398, -958.24340820313, 77.239990234375),
	   guardaroba = vector3(-264.1127, -947.9342, 71.024139),
	   vip = false
    },
	['LoftVip2'] = {
		coords = vec3(1972.2741699219, -1683.9714355469, 101.27258300781), 
		inventario = vec(1972.1044921875, -1671.4532470703, 101.2727355957),
		guardaroba = vector3(1971.2386474609, -1669.65625, 105.1573638916),
		vip = true
	 },		
}


Config.Smoking = {
    lighter = {
        name = "accendino",
        prop = "p_cs_lighter_01",
    },
    smokable_things = {
        ["cig_1"] = {
            prop_off = "prop_cs_ciggy_01",
            prop_on = "prop_cs_ciggy_01b",
            pulls = 5,
            effect_normal = "smoke",
            effect_pull = "pull",
            removeStress = 3,
            getAttachHand = function()

                return 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true
            end,
            getAttachMouth = function()

                return 0.015, -0.009, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true
            end
        },
        ["joint_cbd"] = {
            prop_off = "prop_cs_ciggy_01",
            prop_on = "prop_cs_ciggy_01b",
            pulls = 10,
            effect_normal = "smoke",
            effect_pull = "pull",
            removeStress = 7,
            getAttachHand = function()

                return 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true
            end,
            getAttachMouth = function()

                return 0.015, -0.009, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true
            end
        },
        ["cig_2"] = {
            prop_off = "prop_cigar_03",
            prop_on = "prop_cigar_03",
            pulls = 6,
            effect_normal = "smoke",
            effect_pull = "pull",
            removeStress = 4,
            getAttachHand = function()

                return 0.020, 0.02, -0.008, 100.0, 0.0, 280.0, true, true, false, true, 1, true
            end,
            getAttachMouth = function()

                return 0.01, 0.009, 0.003, 55.0, 0.0, 290.0, true, true, false, true, 1, true
            end
        },
        ["cig_3"] = {
            prop_off = "prop_cigar_02",
            prop_on = "prop_cigar_01",
            pulls = 8,
            effect_normal = "smoke_big",
            effect_pull = "pull_big",
            removeStress = 5,
            getAttachHand = function()

                return 0.020, 0.02, -0.008, 100.0, 0.0, 280.0, true, true, false, true, 1, true
            end,
            getAttachMouth = function()

                return 0.01, 0.009, 0.003, 55.0, 0.0, 290.0, true, true, false, true, 1, true
            end
        },
        ["joint"] = {
            prop_off = "p_cs_joint_02",
            prop_on = "p_cs_joint_01",
            pulls = 10,
            effect_normal = "smoke_big",
            effect_pull = "pull_big",
            removeStress = 6,
            getAttachHand = function()

                return 0.020, 0.02, -0.008, 100.0, 0.0, 100.0, true, true, false, true, 1, true
            end,
            getAttachMouth = function()

                return 0.015, -0.009, 0.003, 55.0, 0.0, 110.0, true, true, false, true, 1, true
            end,
            firstPullEffect = function()

                Citizen.Wait(2000)

                TriggerEvent("custom_hel-weed_effect:startEffect")
            end
        },
    }
}

Config.Effects = {
    ["lighter"] = {
        asset = "core",
        particle = "ent_amb_torch_fire",
        size = 0.03,
        time = 1200,
        getParticle = function(mode, netId)

            return StartParticleFxLoopedOnEntity(Config.Effects[mode].particle, NetToPed(netId), -0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Effects[mode].size, 0.0, 0.0, 0.0)
        end,
        cb = function(netId)
            
            Citizen.Wait(1900)
            RemoveParticleFxFromEntity(NetToPed(netId))
        end
    },
    ["pull"] = {
        asset = "core",
        particle = "exp_grd_bzgas_smoke",
        size = 0.1,
        time = 1000,
        getParticle = function(mode, netId)
            
            return StartParticleFxLoopedOnEntityBone(Config.Effects[mode].particle, NetToPed(netId), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(netId), 20279), Config.Effects[mode].size, 0.0, 0.0, 0.0)
        end,
        cb = function(smokable_thing, netId)
                     
            Citizen.Wait(1000)
			
            RemoveParticleFxFromEntity(NetToPed(netId))
        end
    },
    ["pull_big"] = {
        asset = "core",
        particle = "exp_grd_bzgas_smoke",
        size = 0.5,
        time = 1000,
        getParticle = function(mode, netId)
            
            return StartParticleFxLoopedOnEntityBone(Config.Effects[mode].particle, NetToPed(netId), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(NetToPed(netId), 20279), Config.Effects[mode].size, 0.0, 0.0, 0.0)
        end,
        cb = function(smokable_thing, netId)
                     
            Citizen.Wait(1000)
			
            RemoveParticleFxFromEntity(NetToPed(netId))
        end
    },
    ["smoke"] = {
        asset = "core",
        particle = "exp_grd_bzgas_smoke",
        size = 0.03,
        getParticle = function(mode, netId)

            return StartParticleFxLoopedOnEntity(Config.Effects[mode].particle, NetToPed(netId), -0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Effects[mode].size, 0.0, 0.0, 0.0)
        end
    },
    ["smoke_big"] = {
        asset = "core",
        particle = "exp_grd_bzgas_smoke",
        size = 0.1,
        getParticle = function(mode, netId)

            return StartParticleFxLoopedOnEntity(Config.Effects[mode].particle, NetToPed(netId), -0.050, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Effects[mode].size, 0.0, 0.0, 0.0)
        end
    },
}


Config.Keys = {
    [1] = { -- Smoke
        label = "~b~E ~w~- Fuma",
        key = 38,
        cb = function(playerPed, smokable_thing, counter)

            CURR.counter = CURR.counter - 1

            if CURR.isInMouth then

                Citizen.Wait(2200)

            else

                CURR:PlayAnim("amb@world_human_aa_smoke@male@idle_a", "idle_a", 2800)
				
                Citizen.Wait(4000)
            end
            ESX.ShowNotification('Ti stai rilassando, lo stress sta scendendo..')
            TriggerServerEvent("royal_smoking:SyncEffect", smokable_thing, Config.Smoking.smokable_things[smokable_thing].effect_pull, ObjToNet(playerPed))
            exports["royal_metabolism"]:RemoveToStatus("stress", Config.Smoking.smokable_things[smokable_thing].removeStress)  
        end
    },
    [2] = { -- Throw
        label = "~b~Z ~w~- Getta",
        key = 20,
        cb = function(playerPed, smokable_thing, counter)

            CURR:StopSmoking(smokable_thing, CURR.prop)
        end
    },
    [3] = { -- Change position
        label = "~b~Q ~w~- Posizione",
        key = 44,
        cb = function(playerPed, smokable_thing, counter)

            CURR:ChangePosition(smokable_thing)
        end
    },
}

Config.ImpoundLots = {
	Sandy = {
		Pos = {x=489.48, y= -1309.04, z= 29.32},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 2,
		DropoffPoint = {
			Pos = {x=489.48, y= -1309.04, z= 29.32},
			Color = {r=58,g=100,b=122},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 2
		},
		RetrievePoint = {
			Pos = {x=498.39, y= -1334.18, z= 29.0},
			Color = {r=0,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 2
		},
	},

	Sandy2 = {
		Pos = {x= 492.68, y = -1319.08, z = 29.04},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker = 2,
		DropoffPoint = {
			Pos = {x=481.68, y= -1316.8, z= 29.0},
			Color = {r=58,g=100,b=122},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 2
		},
		RetrievePoint = {
			Pos = {x=498.39, y= -1334.18, z= 29.0},
			Color = {r=0,g=0,b=0},
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Marker = 2
		},
	}
}


Config.Garage = {

    ['Garage_A'] = {
        ['ritiro'] = vector3(219.4549, -811.4374, 30.71204),
        ['deposito'] = vector3(231.65, -796.08, 30.57),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_B'] = {
        ['ritiro'] = vector3(-899.275, -153.0, 41.88),
        ['deposito'] = vector3(-901.989, -159.28, 41.46),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_C'] = {
        ['ritiro'] = vector3(275.182, -345.534, 45.173),
        ['deposito'] = vector3(266.498, -332.475, 43.43),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_D'] = {
        ['ritiro'] = vector3(-833.255, -2351.34, 14.57),
        ['deposito'] = vector3(-823.68, -2342.975, 13.803),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_E'] = {
        ['ritiro'] = vector3(-2162.82, -377.15,13.28),
        ['deposito'] = vector3(-2169.21, -372.25, 13.08),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_F'] = {
        ['ritiro'] = vector3(112.23, 6619.66, 31.82),
        ['deposito'] = vector3(115.81,6599.34, 32.01),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_G'] = {
        ['ritiro'] = vector3(2768.34, 3462.92, 55.63),
        ['deposito'] = vector3(2772.88, 3472.32, 55.46),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_H'] = {
        ['ritiro'] = vector3(1951.79, 3750.95, 32.16),
        ['deposito'] = vector3(1949.57, 3759.33, 32.21),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_I'] = {
        ['ritiro'] = vector3(1899.46, 2605.26, 45.97),
        ['deposito'] = vector3(1875.88, 2595.20, 45.67),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_J'] = {
        ['ritiro'] = vector3(-739.4506, -278.3868, 36.94653),
        ['deposito'] = vector3(-738.1714, -268.8791, 36.94653),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_K'] = {
        ['ritiro'] = vector3(570.24, 2797.07, 42.01),
        ['deposito'] = vector3(588.78, 2791.1, 42.16),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_L'] = {
        ['ritiro'] = vector3(889.24, -53.87, 78.91),
        ['deposito'] = vector3(886.12, -62.68, 78.76),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_M'] = {
        ['ritiro'] = vector3(-1184.85, -1510.05, 4.65),
        ['deposito'] = vector3(-1183.01, -1495.34, 4.38),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_N'] = {
        ['ritiro'] = vector3(362.28, 298.39, 103.88),
        ['deposito'] = vector3(377.9, 288.46, 103.17),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    --[[['Garage_O'] = { -- RIMOSSO CAUSA campo coca
        ['ritiro'] = vector3(2434.69, 5011.78, 64.84),
        ['deposito'] = vector3(2451.71, 5033.78, 44.91),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },]]

    ['Garage_P'] = {
        ['ritiro'] = vector3(-73.28, -1835.79, 26.94),
        ['deposito'] = vector3(-60.76, -1834.67, 26.75),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_Q'] = {
        ['ritiro'] = vector3(1036.67, -763.43, 57.99),
        ['deposito'] = vector3(1020.1, -766.99, 57.93),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_R'] = {
        ['ritiro'] = vector3(1366.22, -1833.79, 57.92),
        ['deposito'] = vector3(1359.46, -1849.11, 57.23),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_S'] = {
        ['ritiro'] = vector3(-73.04, 909.85, 235.63),
        ['deposito'] = vector3(-68.1, 897.9, 235.56),
        ['heading'] = 150.0,
        ['showBlip'] = false
    },

    
    ['Garage_T'] = {
        ['ritiro'] = vector3(-281.08157348633, -888.11169433594, 31.3180103302),
        ['deposito'] = vector3(-300.7912, -887.6176, 31.06592),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_Sofia'] = { -- 801
        ['ritiro'] = vector3(-3192.29, 822.778, 8.925293),
        ['deposito'] = vector3(-3197.604, 816.6989, 8.925293),
        ['heading'] = 175.748,
        ['showBlip'] = false
    },

    ['Garage_U'] = {
        ['ritiro'] = vector3(2763, 1346.56, 24.52),
        ['deposito'] = vector3(2732.62, 1329.28, 24.52),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_V'] = {
        ['ritiro'] = vector3(392.31, -1631.9, 29.29),
        ['deposito'] = vector3(391.43, -1620.23, 29.29),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_W'] = {
        ['ritiro'] = vector3(-1676.86, 66.82, 63.89),
        ['deposito'] = vector3(-1671.11, 74.16, 63.72),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_X'] = {
        ['ritiro'] = vector3(100.1011, -1073.367, 29.36414),
        ['deposito'] = vector3(132.3033, -1080.765, 29.17871),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_Y'] = {
        ['ritiro'] = vector3(-1679.68, 494.712, 128.87),
        ['deposito'] = vector3(-1668.27, 499.63, 128.39),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_Z'] = {
        ['ritiro'] = vector3(-3051.178, 135.6, 11.57068),
        ['deposito'] = vector3(-3037.398, 142.5626, 11.60437),
        ['heading'] = 150.0,
        ['showBlip'] = true
    },

    ['Garage_Ospedale'] = {
        ['ritiro'] = vector3(247.411, -577.8593, 43.29895),
        ['deposito'] = vector3(241.2791, -565.5428, 43.26526),
        ['heading'] = 215.4331,
        ['showBlip'] = true
    },

    ['Garage_bennys'] = {
        ['ritiro'] = vector3(-220.4703, -1285.793, 31.28503),
        ['deposito'] = vector3(-216.1319, -1296.752, 31.28503),
        ['heading'] = 232.4409,
        ['showBlip'] = true
    },

    ['Garage_Vanilla'] = {
        ['ritiro'] = vector3(161.9209, -1305.798, 29.34729),
        ['deposito'] = vector3(151.0286, -1307.116, 29.19556),
        ['heading'] = 93.5433,
        ['showBlip'] = true
    },
   --[[ ['Garage_Armeria128'] = {
        ['ritiro'] = vector3(79.6088, -1545.125, 29.44836),
        ['deposito'] = vector3(76.11429, -1548.989, 29.44836),
        ['heading'] = 93.5433,
        ['showBlip'] = true
    },]]

   --[[ ['Centro Impieghi'] = {
        ['ritiro'] = vector3(1200.448, -1277.459, 35.56482),
        ['deposito'] = vector3(1204.576, -1288.154, 35.21094),
        ['heading'] = 269.2914,
        ['showBlip'] = true
    },]] ---- RIMOSSO PERCHE' FA CONFUSIONE CON I BLIP DEL LAVORO NOWL

    ['Garage_Garage1'] = { -- Garage Cosa nostra
        ['ritiro'] = vector3(-2549.684, 1913.565, 169.3187),
        ['deposito'] = vector3(-2539.081, 1904.862, 168.9817),
        ['heading'] = 167.2441,
        ['showBlip'] = false
    },

    ['Garage_Lux'] = { -- Garage
        ['ritiro'] = vector3(-340.8132, 266.8088, 85.67615),
        ['deposito'] = vector3(-334.5758, 285.1385, 85.79419),
        ['heading'] = 170.0787,
        ['showBlip'] = true
    },

    ['Garage_SpeedGarage'] = { -- Garage speed
        ['ritiro'] = vector3(51.87693, -1587.033, 29.27991),
        ['deposito'] = vector3(43.09451, -1574.387, 29.27991),
        ['heading'] = 8.503937,
        ['showBlip'] = false
    },

    ['Garage_Asgard'] = { -- Garage asgard
        ['ritiro'] = vector3(-1743.56, -718.3253, 10.42493),
        ['deposito'] = vector3(-1733.433, -726, 10.40808),
        ['heading'] = 306.1417,
        ['showBlip'] = true
    },

    ['Garage_Attico1'] = { -- Garage attico tizoi93
        ['ritiro'] = vector3(-795.2967, 307.4242, 85.69299),
        ['deposito'] = vector3(-795.9692, 302.189, 85.69299),
        ['heading'] = 181.4173,
        ['showBlip'] = false
    },

    ['Garage_Villa2'] = { -- Garage villa alef
        ['ritiro'] = vector3(-878.3077, -49.66154, 38.07544),
        ['deposito'] = vector3(-867.5472, -51.96923, 38.56409),
        ['heading'] = 274.9606,
        ['showBlip'] = false
    },

    ['Garage_AlamoResort_1'] = { -- Garage alamo resort
        ['ritiro'] = vector3(2406.804, 4293.231, 35.12671),
        ['deposito'] = vector3(2416.272, 4291.147, 35.1604),
        ['heading'] =  235.2756,
        ['showBlip'] = false
    },

    ['Garage_AlamoResort_2'] = { -- Garage alamo resort
        ['ritiro'] = vector3(2055.969, 3930.435, 33.07104),
        ['deposito'] = vector3(2040.936, 3925.437, 33.10474),
        ['heading'] =  119.0551,
        ['showBlip'] = false
    },

    --[[['Garage_Villa648'] = { -- Garage villa 648
        ['ritiro'] = vector3(-1535.71, 96.38242, 56.76196),
        ['deposito'] = vector3(-1528.352, 93.44176, 56.59338),
        ['heading'] = 249.44,
        ['showBlip'] = false
    },]]

    ['Garage_Usato'] = { -- usato richiesto da mokambo
        ['ritiro'] = vector3(-915.6264, -2058.607, 9.296021),
        ['deposito'] = vector3(-905.222, -2055.547, 9.296021),
        ['heading'] = 289.1339,
        ['showBlip'] = false
    },

    ['Garage_TunerShop'] = { -- Garage east
        ['ritiro'] = vector3(857.3539, -2094.857, 30.52673),
        ['deposito'] = vector3(856.444, -2101.833, 30.52673),
        ['heading'] = 297.6378,
        ['showBlip'] = true
    },

    ['Garage_Rimozione'] = { -- Garage Rimozione
        ['ritiro'] = vector3(497.5385, -1302.04, 29.27991),
        ['deposito'] = vector3(519.2967, -1308.804, 29.6842),
        ['heading'] = 155.9055,
        ['showBlip'] = false
    },

    ['Garage_Import'] = { -- Garage import richiesto da tizoi93
        ['ritiro'] = vector3(1225.965, -3234.62, 6.0271),
        ['deposito'] = vector3(1226.624, -3223.938, 5.79126),
        ['heading'] = 357.1653,
        ['showBlip'] = true
    },

    ['Garage_NikkiBeach'] = { -- nikki
        ['ritiro'] = vector3(-1427.38, -1219.002, 3.870361),
        ['deposito'] = vector3(-1423.226, -1218.132, 3.887207),
        ['heading'] = 175.748,
        ['showBlip'] = false
    },

    ['Garage_BullsCustom'] = { -- garage bulls
        ['ritiro'] = vector3(-355.4769, -120.6989, 38.68201),
        ['deposito'] = vector3(-364.7209, -115.0418, 38.68201),
        ['heading'] = 99.21259,
        ['showBlip'] = false
    },

    ['Garage_Casa844'] = { -- garage 844
        ['ritiro'] = vector3(-1531.952, 869.9868, 181.6696),
        ['deposito'] = vector3(-1540.932, 881.4857, 181.4169),
        ['heading'] = 286.2992,
        ['showBlip'] = false
    },

    ['Garage_Paolo'] = { -- garage richiesto da paolofazz
        ['ritiro'] = vector3(4970.097, -5737.965, 19.87769),
        ['deposito'] = vector3(4973.881, -5740.312, 19.87769),
        ['heading'] = 153.0709,
        ['showBlip'] = false
    },

    ['Garage_Eva'] = { -- garage richiesto da Eva
        ['ritiro'] = vector3(-950.47076416016, 189.27824401855, 66.594261169434),
        ['deposito'] = vector3(-955.96197509766, 188.1316986084, 66.583381652832),
        ['heading'] =  86.863243103027,
        ['showBlip'] = false
    },

	
    ['Garage_Phantoms'] = { -- garage richiesto da tonyme27
        ['ritiro'] = vector3(-1124.7374267578, 375.06747436523, 70.731307983398),
        ['deposito'] = vector3(-1125.9340820313, 379.93508911133, 70.677917480469),
        ['heading'] =  23.058891296387,
        ['showBlip'] = false
    },


}


Config.GarageElicotteri = {

    ['Garage_Elicottero_RoyalFly'] = {
        ['ritiro'] = vector3(1768.6403808594, 3316.2841796875, 41.432765960693),
        ['deposito'] = vector3(1774.28125, 3332.19921875, 42.090919494629),
        ['heading'] = 302.08526611328,
        ['showBlip'] = true
    },

    ['Garage_Elicottero_Aereoporto'] = {
        ['ritiro'] = vector3(-1119.5554199219, -2842.8498535156, 13.945662498474),
        ['deposito'] = vector3(-1145.9488525391, -2864.3151855469, 13.94601726532),
        ['heading'] = 151.67256164551,
        ['showBlip'] = true
    },

    ['Garage_Elicottero_386'] = {
        ['ritiro'] = vector3(-708.60290527344, -1462.3858642578, 5.000527381897),
        ['deposito'] = vector3(-724.67236328125, -1443.9373779297, 5.0005178451538),
        ['heading'] = 142.24114990234,
        ['showBlip'] = true
    },
    
}


Config.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

Config.ReviveAnimation = {
    lib1_char_a = 'mini@cpr@char_a@cpr_def', 
    lib2_char_a = "mini@cpr@char_a@cpr_str", 
    lib1_char_b = "mini@cpr@char_b@cpr_def", 
    lib2_char_b = "mini@cpr@char_b@cpr_str", 
    anim_start = "cpr_intro", 
    anim_pump = "cpr_pumpchest", 
    anim_success = "cpr_success",
}

Config.KnockTime = 120

Config.RespawnTime = 5

Config.CoordsRespawn = vector3(322.73120117188, -587.01647949219, 44.20397567749)

Config.CallCooldown = 180

Config.TimeSyringe = 1000

Config.BleedOut = 10

Config.Shops = {
    ['armeria366'] = {
        Negozi = {
            ["shop_armeria366_1"] = {
                coords = vec3(-660.46722412109, -932.72436523438, 21.829359054565),
                grado_minimo_accesso = 0,
                items = {
                    {label = ('Colpi Pistola SNS'), item = 'ammo-45', prezzo = 20, selectQuantity = true, icon = 'pistol', iconColor = 'orange'},
					{label = ('Colpi Pistola'), item = 'ammo-9', prezzo = 20, selectQuantity = true, icon = 'pistol', iconColor = 'green'},
                },
            },
        },
    },
	['armeria200'] = {
        Negozi = {
            ["shop_armeria200_1"] = {
                coords = vec3(14.60952091217, -1104.8795166016, 29.797189712524),
                grado_minimo_accesso = 0,
                items = {
                    {label = ('Colpi Pistola SNS'), item = 'ammo-45', prezzo = 20, selectQuantity = true, icon = 'pistol', iconColor = 'orange'},
					{label = ('Colpi Pistola'), item = 'ammo-9', prezzo = 20, selectQuantity = true, icon = 'pistol', iconColor = 'green'},
                },
            },
        },
    },
	['ambulance'] = {
        Negozi = {
            ["shop_ambulance_1"] = {
                coords = vec3(306.84759521484, -570.9033203125, 43.263134002686),
                grado_minimo_accesso = 0,
                items = {
                    {label = ('Antidolorifico'), item = 'antidolorifico', prezzo = 4500, selectQuantity = false, icon = 'ambulance', iconColor = 'red'},
					{label = ('Antibiotico'), item = 'antibiotico', prezzo = 3000, selectQuantity = false, icon = 'ambulance', iconColor = 'green'},
					{label = ('Siringa'), item = 'siringa', prezzo = 2000, selectQuantity = false, icon = 'syringe', iconColor = 'yellow'},
                },
            },
        },
    },
	['cartellonarcos'] = {
        Negozi = {
            ["shop_cartellonarcos_1"] = {
                coords = vec3(-1546.1275634766, 137.49510192871, 60.789821624756),
                grado_minimo_accesso = 5,
                items = {
                    {label = ('Pistola 9mm'), item = 'WEAPON_PISTOL', prezzo = 55000, selectQuantity = false, icon = 'pistol', iconColor = 'red'},
					{label = ('Pistola SNS'), item = 'WEAPON_SNSPISTOL', prezzo = 45000, selectQuantity = false, icon = 'pistol', iconColor = 'red'},
					{label = ('Navy Revolver'), item = 'WEAPON_NAVYREVOLVER', prezzo = 140000, selectQuantity = false, icon = 'pistol', iconColor = 'red'},
					{label = ('Colpi Pistola SNS'), item = 'ammo-45', prezzo = 20, selectQuantity = true, icon = 'pistol', iconColor = 'orange'},
					{label = ('Colpi Pistola 9mm'), item = 'ammo-9', prezzo = 20, selectQuantity = true, icon = 'pistol', iconColor = 'orange'},
					{label = ('Colpi Pistola Revolver'), item = 'ammo-44', prezzo = 20, selectQuantity = true, icon = 'pistol', iconColor = 'orange'},
                },
            },
        },
    },
}

Giubbi = {
	-- armeria 200 {name="Giubbotto Antiproiettile",color=38, id=461,x = 18.04,  y = -1111.08,  z = 29.8},
	{name="Giubbotto Antiproiettile",color=38, id=461,x = -328.62,  y = 6078.57,  z = 31.45},
	-- armeria 578 {name="Giubbotto Antiproiettile",color=38, id=461,x = 247.47,  y = -45.75,  z = 69.94},
	-- armeria 646 {name="Giubbotto Antiproiettile",color=38, id=461,x = -1310.49,  y = -390.59,  z = 36.7},
	{name="Giubbotto Antiproiettile",color=38, id=461,x = 844.77,  y = -1030.21,  z = 28.19},
	{name="Giubbotto Antiproiettile",color=38, id=461,x = -3167.9, y= 1083.37, z= 20.84},
	{name="Giubbotto Antiproiettile",color=38, id=461,x = 1695.53, y= 3754.64, z= 34.71},
}

Config.Debug = {
    enable = false,
    SendToServer = false
}

Config.defaultReasons = {

    ['police'] = {default = 'Guida pericolosa', otherReasons = {'Eccesso limite di velocità', 'Rapina in banca', 'Omicidio'}},
    ['fbi'] = {default = 'Guida pericolosa', otherReasons = {'Eccesso limite di velocità', 'Rapina in banca', 'Omicidio'}},
    ['sceriffo'] = {default = 'Guida pericolosa', otherReasons = {'Eccesso limite di velocità', 'Rapina in banca', 'Omicidio'}},
    ['ambulance'] = {default = 'Soccorso stradale', otherReasons = {'Cure mediche', 'Bende', 'Visita medica'}},
    ['cardealer'] = {default = "Vendita Auto", otherReasons = {'Vendita Moto'}, {'Vendita Auto'}},
    ['lsmotors'] = {default = "Vendita Auto", otherReasons = {'Vendita Moto'}, {'Vendita Auto'}},
    ['grotti'] = {default = "Vendita Auto", otherReasons = {'Vendita Moto'}, {'Vendita Auto'}},
    ['bahamas'] = {default = "Cibo e bevande", otherReasons = {'Cibo e bevande', 'Cibo', 'Bevande'}},
    ['armeria366'] = {default = 'Vendita Taurus', otherReasons = {}},
    ['armeria200'] = {default = 'Vendita Taurus', otherReasons = {}},
	['blazeit'] = {default = 'Vendita Sigarette', otherReasons = {}},
    ['rimozione'] = {default = 'Rimozione veicolo', otherReasons = {}},
    ['agenteimmobiliare'] = {default = 'Vendita Casa', otherReasons = {}},
    ['vanilla'] = {default = "Cibo e bevande", otherReasons = {'Cibo e bevande', 'Cibo', 'Bevande'}},
    ['governo'] = {default = "Tasse", otherReasons = {'Tasse', 'Attività'}},
    ['bennys'] = {default = "Modifiche e Riparazione", otherReasons = {'Modifiche e Riparazione', 'Modifiche', 'Riparazione'}},
    ['nadir'] = {default = "Modifiche e Riparazione", otherReasons = {'Modifiche e Riparazione', 'Modifiche', 'Riparazione'}},
	['risingsun'] = {default = "Modifiche e Riparazione", otherReasons = {'Modifiche e Riparazione', 'Modifiche', 'Riparazione'}},
    ['beanmachine'] = {default = "Cibo e bevande", otherReasons = {'Cibo e bevande', 'Cibo', 'Bevande'}},
    ['import'] = {default = "Kit Cibo", otherReasons = {'Kit Drink', 'Tessuto', 'Pezzo Arma'}},
    ['perla'] = {default = "Cibo e bevande", otherReasons = {'Cibo e bevande', 'Cibo', 'Bevande'}},
    ['cockatoos'] = {default = "Cibo e bevande", otherReasons = {'Cibo e bevande', 'Cibo', 'Bevande'}},
}

Config.Item = {
    name = 'fattura' -- name of the bill item
}

Config.Account = {
    bank = 'bank',
    money = 'money',
    remove = 'bank' -- can be a custom value, thats the where the money get removed when the player receives a fine.
}

Fine = {
    CanDoFine = { -- jobs that can send an automatic bill (money get removed from the player when the bill is sent)
    -- EXAMPLE 'ambulance'
        'police',
        'ambulance',
        'sceriffo',
        'dea',
        'fbi',
        'agenteimmobiliare',
    }
}

Bill = {
    CanDoBill = { -- jobs that can send bill
        'cardealer',
        'beanmachine',
        'vanilla',
        'armeria200',
		'armeria366',
        'bahamas',
        'import',
        'sceriffo',
		'risingsun',
        'bennys',
        'tuning',
        'perla',
        'cockatoos',
        'grotti',
        'governo',
        'rimozione',
        'pawn',
        'nadir',
        'lsmotors',
		'blazeit'
    },

    CanOpenMenu = { -- jobs that can open the billing menu
    'cardealer',
    'police',
    'ambulance',
    'beanmachine',
    'vanilla',
    'agenteimmobiliare',
	'risingsun',
    'bahamas',
    'import',
    'bennys',
    'armeria366',
    'perla',
    'armeria200',
    'cockatoos',
    'grotti',
    'governo',
    'rimozione',
    'fbi',
    'nadir',
    'lsmotors',
	'blazeit'
}
}

Config.language = {

    ['customer_id'] = "Numero del cliente",
    ['player_server_id'] = "(ID del giocatore)",
    ['include_jobname'] = "Aggingi il nome della società nella fattura",
    ['invoice'] = "Fattura",
    ['amount'] = "Importo",
    ['reason'] = "Motivo",
    ['invoice_amount'] = "Importo fattura",
    ['invoice_reason'] = "Motivo della fattura",
    ['premade'] = "Frequenti",
    ['create_invoice'] = "Invia fattura",
    ['invoice_accepted'] = "La fattura è stata firmata",
    ['invoice_not_accepted'] = "La fattura è stata strappata",
    ['not_enabled'] = "Non sei abilitato a fare fatture!",
    ['want_sign'] = "Vuoi firmare la fattura?",
    ['not_enough_money'] = "Non hai abbastanza soldi!",
    ['lib_menu_title'] = "Billing Menu",
    ['lib_menu_bill'] = "Bill",
}

Config.EnableElicotteri = false

Config.AbilitaANTIVDM = false