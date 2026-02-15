ESX = exports['es_extended']:getSharedObject()

local vehicles = nil
local minute, waitTime = 60000, 0

-- === SYSTÈME D'INSTALLATION AUTOMATIQUE DE LA BASE DE DONNÉES ===
local SQLLabels = {
	fr = {
		hammerwirecutter = 'Marteau & coupe fil',
		unlockingtool = 'Outils de cambriolage (Illégal)',
		jammer = 'Brouilleur de Signal (Illégal)',
		alarminterface = "Interface de système d'alarm",
		alarm1 = "système d'alarme de base avec haut-parleur",
		alarm2 = "module de liaison avec les urgences",
		alarm3 = "module de positionnement continu GPS"
	},
	en = {
		hammerwirecutter = 'Hammer & wire cutter',
		unlockingtool = 'Burglary tools (Illegal)',
		jammer = 'Signal jammer (Illegal)',
		alarminterface = "Alarm system interface",
		alarm1 = "basic alarm system with loudspeaker",
		alarm2 = "emergency liaison module",
		alarm3 = "GPS continuous positioning module"
	},
	br = {
		hammerwirecutter = 'Kit para arrombamento basico',
		unlockingtool = 'Kit para arrombamento sofisticado (Ilegal)',
		jammer = 'Bloqueador de sinal (Ilegal)',
		alarminterface = "Interface do sistema de alarme",
		alarm1 = "sistema básico de alarme com alto-falante",
		alarm2 = "módulo de ligação de emergência",
		alarm3 = "módulo de posicionamento contínuo GPS"
	},
	de = {
		hammerwirecutter = 'Hammer- und Drahtschneider',
		unlockingtool = 'Einbruchswerkzeuge (Illegal)',
		jammer = 'Signalstörer (illegal)',
		alarminterface = "Schnittstelle für Alarmsysteme",
		alarm1 = "Grundalarmsystem mit Lautsprecher",
		alarm2 = "Notfallverbindungsmodul",
		alarm3 = "GPS Continuous Positioning Module"
	}
}

-- Descriptions multilingues pour ox_inventory
local SQLDescriptions = {
	fr = {
		hammerwirecutter = "Outil basique pour forcer les véhicules. Haute chance de déclencher les alarmes.",
		unlockingtool = "Outils de cambriolage avancés. Meilleur taux de réussite avec moins de risque d'alarme.",
		jammer = "Coupe la transmission du signal pour empêcher les systèmes d'alarme d'appeler la police.",
		alarminterface = "Interface de gestion des systèmes d'alarme. Utilisée par la police et les mécaniciens.",
		alarm1 = "Système d'alarme de base avec haut-parleur. Émet une alarme sonore lorsqu'elle est déclenchée.",
		alarm2 = "Alarme avancée qui notifie la police et envoie la position du véhicule lorsqu'elle est déclenchée.",
		alarm3 = "Système d'alarme GPS high-tech avec suivi en temps réel pour la police."
	},
	en = {
		hammerwirecutter = "Basic tool for breaking into vehicles. High chance to trigger alarms.",
		unlockingtool = "Advanced burglary tools. Better success rate with lower alarm trigger chance.",
		jammer = "Cuts signal transmission to prevent alarm systems from calling police.",
		alarminterface = "Interface for managing vehicle alarm systems. Used by police and mechanics.",
		alarm1 = "Basic alarm system with loudspeaker. Emits audible alarm when triggered.",
		alarm2 = "Advanced alarm that notifies police and sends vehicle position when triggered.",
		alarm3 = "High-tech GPS alarm system with real-time tracking for police."
	},
	br = {
		hammerwirecutter = "Ferramenta básica para arrombar veículos. Alta chance de disparar alarmes.",
		unlockingtool = "Ferramentas de arrombamento avançadas. Melhor taxa de sucesso com menor chance de alarme.",
		jammer = "Corta a transmissão de sinal para evitar que os sistemas de alarme chamem a polícia.",
		alarminterface = "Interface para gerenciar sistemas de alarme de veículos. Usado por polícia e mecânicos.",
		alarm1 = "Sistema de alarme básico com alto-falante. Emite alarme audível quando acionado.",
		alarm2 = "Alarme avançado que notifica a polícia e envia a posição do veículo quando acionado.",
		alarm3 = "Sistema de alarme GPS de alta tecnologia com rastreamento em tempo real para a polícia."
	},
	de = {
		hammerwirecutter = "Grundlegendes Werkzeug zum Einbrechen in Fahrzeuge. Hohe Chance, Alarme auszulösen.",
		unlockingtool = "Fortgeschrittene Einbruchwerkzeuge. Bessere Erfolgsrate mit geringerer Alarmauslösechance.",
		jammer = "Unterbricht die Signalübertragung, um zu verhindern, dass Alarmsysteme die Polizei rufen.",
		alarminterface = "Schnittstelle zur Verwaltung von Fahrzeugalarmsystemen. Von Polizei und Mechanikern verwendet.",
		alarm1 = "Grundlegendes Alarmsystem mit Lautsprecher. Gibt hörbaren Alarm beim Auslösen ab.",
		alarm2 = "Fortgeschrittener Alarm, der die Polizei benachrichtigt und die Fahrzeugposition beim Auslösen sendet.",
		alarm3 = "High-Tech-GPS-Alarmsystem mit Echtzeit-Tracking für die Polizei."
	}
}

-- Fonction d'initialisation de la base de données (exécution séquentielle)
CreateThread(function()
	local locale = Config.Locale or 'en'
	local labels = SQLLabels[locale] or SQLLabels['en']
	
	-- Étape 1: Vérifier que la table owned_vehicles existe (devrait exister via ESX)
	MySQL.Async.fetchAll("SHOW TABLES LIKE 'owned_vehicles'", {}, function(tableResult)
		if #tableResult == 0 then
			print("^1[esx_ownedcarthief] ERREUR: La table 'owned_vehicles' n'existe pas! Assurez-vous qu'ESX est correctement installé.^0")
			return
		end
		
		-- Étape 2: Ajouter la colonne 'security' si elle n'existe pas
		MySQL.Async.fetchAll("SHOW COLUMNS FROM owned_vehicles LIKE 'security'", {}, function(securityResult)
			if #securityResult == 0 then
				MySQL.Async.execute("ALTER TABLE owned_vehicles ADD security INT(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system level' AFTER owner", {}, function()
					-- Étape 3: Ajouter la colonne 'alarmactive' après 'security'
					addAlarmActiveColumn(labels)
				end)
			else
				-- La colonne security existe déjà, passer à la suivante
				addAlarmActiveColumn(labels)
			end
		end)
	end)
end)

-- Fonction pour ajouter la colonne alarmactive
function addAlarmActiveColumn(labels)
	MySQL.Async.fetchAll("SHOW COLUMNS FROM owned_vehicles LIKE 'alarmactive'", {}, function(alarmResult)
		if #alarmResult == 0 then
			MySQL.Async.execute("ALTER TABLE owned_vehicles ADD alarmactive INT(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system state' AFTER security", {}, function()
				-- Étape 4: Créer la table pawnshop_vehicles
				createPawnshopTable(labels)
			end)
		else
			-- La colonne alarmactive existe déjà, passer à la suivante
			createPawnshopTable(labels)
		end
	end)
end

-- Fonction pour créer la table pawnshop_vehicles
function createPawnshopTable(labels)
	MySQL.Async.fetchAll("SHOW TABLES LIKE 'pawnshop_vehicles'", {}, function(tablePawnResult)
		if #tablePawnResult == 0 then
			MySQL.Async.execute([[
				CREATE TABLE pawnshop_vehicles (
					owner varchar(40) DEFAULT NULL,
					security int(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system level',
					plate varchar(12) NOT NULL,
					vehicle longtext,
					price int(15) NOT NULL,
					expiration int(15) NOT NULL,
					PRIMARY KEY (plate)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8
			]], {}, function()
				-- Étape 5: Vérifier que la table items existe avant d'insérer
				checkAndAddItems(labels)
			end)
		else
			-- La table existe déjà, passer aux items
			checkAndAddItems(labels)
		end
	end)
end

-- Fonction pour vérifier et ajouter les items
function checkAndAddItems(labels)
	-- Détecter si ox_inventory est installé et démarré
	local useOxInventory = GetResourceState('ox_inventory') == 'started'
	
	if useOxInventory then
		addItemsToOxInventory(labels)
	else
		addItemsToESX(labels)
	end
end

-- Fonction pour ajouter les items via ox_inventory
function addItemsToOxInventory(labels)
	local locale = Config.Locale or 'en'
	local descriptions = SQLDescriptions[locale] or SQLDescriptions['en']
	
	local itemsToAdd = {
		{name = 'hammerwirecutter', label = labels.hammerwirecutter, weight = 1000, description = descriptions.hammerwirecutter},
		{name = 'unlockingtool', label = labels.unlockingtool, weight = 1000, description = descriptions.unlockingtool},
		{name = 'jammer', label = labels.jammer, weight = 500, description = descriptions.jammer},
		{name = 'alarminterface', label = labels.alarminterface, weight = 200, description = descriptions.alarminterface},
		{name = 'alarm1', label = labels.alarm1, weight = 1500, description = descriptions.alarm1},
		{name = 'alarm2', label = labels.alarm2, weight = 2000, description = descriptions.alarm2},
		{name = 'alarm3', label = labels.alarm3, weight = 2500, description = descriptions.alarm3}
	}
	
	for _, item in ipairs(itemsToAdd) do
		-- Vérifier si l'item existe déjà dans ox_inventory
		local existingItem = exports.ox_inventory:Items(item.name)
		
		if not existingItem then
			-- L'item n'existe pas, on peut l'enregistrer
			local success, err = pcall(function()
				exports.ox_inventory:RegisterItem(item.name, {
					label = item.label,
					weight = item.weight,
					stack = true,
					close = true,
					description = item.description
				})
			end)
			
			if not success then
				print("^1[esx_ownedcarthief] ERREUR lors de l'enregistrement de l'item '" .. item.name .. "': " .. tostring(err) .. "^0")
			end
		end
		-- Si l'item existe déjà, on le saute silencieusement (pas de doublon)
	end
end

-- Fonction pour ajouter les items via ESX (méthode SQL)
function addItemsToESX(labels)
	-- Vérifier que la table items existe
	MySQL.Async.fetchAll("SHOW TABLES LIKE 'items'", {}, function(itemsTableResult)
		if #itemsTableResult == 0 then
			print("^1[esx_ownedcarthief] ERREUR: La table 'items' n'existe pas! Assurez-vous qu'ESX est correctement installé.^0")
			return
		end
		
		-- La table items existe, ajouter les items un par un
		local itemsToAdd = {
			{name = 'hammerwirecutter', label = labels.hammerwirecutter},
			{name = 'unlockingtool', label = labels.unlockingtool},
			{name = 'jammer', label = labels.jammer},
			{name = 'alarminterface', label = labels.alarminterface},
			{name = 'alarm1', label = labels.alarm1},
			{name = 'alarm2', label = labels.alarm2},
			{name = 'alarm3', label = labels.alarm3}
		}
		
		local itemIndex = 1
		
		-- Fonction récursive pour ajouter les items séquentiellement
		local function addNextItem()
			if itemIndex > #itemsToAdd then
				return
			end
			
			local item = itemsToAdd[itemIndex]
			MySQL.Async.fetchAll("SELECT * FROM items WHERE name = @name", {
				['@name'] = item.name
			}, function(result)
				if #result == 0 then
					MySQL.Async.execute("INSERT INTO items (name, label, weight) VALUES (@name, @label, 1)", {
						['@name'] = item.name,
						['@label'] = item.label
					}, function()
						itemIndex = itemIndex + 1
						addNextItem()
					end)
				else
					-- L'item existe déjà, passer au suivant
					itemIndex = itemIndex + 1
					addNextItem()
				end
			end)
		end
		
		addNextItem()
	end)
end


RegisterServerEvent('esx_ownedcarthief:callcops')
AddEventHandler('esx_ownedcarthief:callcops', function(gx, gy, gz)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == 'police' then
		  TriggerClientEvent('esx:showNotification', xPlayers[i], _U('911'))
		  TriggerClientEvent('esx_ownedcarthief:911', xPlayers[i], gx, gy, gz, 4)
		end
	end
end)

RegisterServerEvent('esx_ownedcarthief:alarmgps')
AddEventHandler('esx_ownedcarthief:alarmgps', function(status, txt, gx, gy, gz)
	Alarm(source, txt, status, gx, gy, gz)
end)

RegisterServerEvent('esx_ownedcarthief:VehBuy')
AddEventHandler('esx_ownedcarthief:VehBuy', function(data)
	local _source  = source
	local vehicle  = data
	local buyprice = math.floor(data.price / Config.ResellPercentage * Config.RebuyPercentage)
	local xPlayer  = ESX.GetPlayerFromId(_source)

	if xPlayer.getMoney() >= buyprice then
		xPlayer.removeMoney(buyprice)
		TriggerClientEvent('esx:showNotification', _source, _U('vehicle_buy', buyprice))
			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, security, plate, vehicle) VALUES (@owner, @security, @plate, @vehicle)',
				{
					['@owner']    = xPlayer.identifier,
					['@security'] = vehicle.security,
					['@plate']    = vehicle.plate,
					['@vehicle']  = vehicle.vehicle
				},	function (rowsChanged)
				end) 
			MySQL.Async.execute('DELETE FROM pawnshop_vehicles WHERE plate = @plate', {
				['@plate'] = vehicle.plate
			})
	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
	end
end)

RegisterServerEvent('esx_ownedcarthief:VehSold')
AddEventHandler('esx_ownedcarthief:VehSold', function(owned, price, plate)
	local _source    = source
	local xPlayer    = ESX.GetPlayerFromId(_source)
	local vehicle    = {}
	local expiration = (os.time() + (Config.ExpireVehicle * 86400))

	if Config.SellCarBlackMoney then
		xPlayer.addAccountMoney('black_money', price)
	else
		xPlayer.addMoney(price)
	end
	waitTime = (Config.WaitTime * minute)
	TriggerClientEvent('esx:showNotification', _source, _U('vehicle_sold', price))
	if owned then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', 
			{
				['@plate'] = plate
			}, function (result)
			if (result ~= nil) then
				for i=1, #result, 1 do
					vehicle = result[i]
					MySQL.Async.execute('INSERT INTO pawnshop_vehicles (owner, security, plate, vehicle, price, expiration) VALUES (@owner, @security, @plate, @vehicle, @price, @expiration)',
					{
						['@owner']      = vehicle.owner,
						['@security']   = vehicle.security,
						['@plate']      = vehicle.plate,
						['@vehicle']    = vehicle.vehicle,
						['@price']      = price,
						['@expiration'] = expiration
					},	function (rowsChanged)
					end) 
					MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
						['@plate'] = plate
					})
				end
			end
		end)
	end
end)

RegisterServerEvent('esx_ownedcarthief:togglealarm')
AddEventHandler('esx_ownedcarthief:togglealarm', function(plate, alarmactive)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT owner, security FROM owned_vehicles WHERE @plate = plate', {
		['@plate'] = plate
	}, function (result)
		if result[1] ~= nil then
			if result[1].owner == xPlayer.identifier and result[1].security > 0 then
				if alarmactive == 1 then
					TriggerClientEvent('esx:showNotification', _source, _U('alarmactive'))
				else
					TriggerClientEvent('esx:showNotification', _source, _U('alarmdisable'))
				end
				MySQL.Sync.execute("UPDATE owned_vehicles SET alarmactive=@alarmactive WHERE plate=@plate",{['@alarmactive'] = alarmactive, ['@plate'] = plate})
			elseif result[1].security == 0 then
				TriggerClientEvent('esx:showNotification', _source, _U('alarmisnotinstall'))
			else
				TriggerClientEvent('esx:showNotification', _source, _U('systemdeny'))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_work_with_npc'))
		end
	end)
end)

RegisterServerEvent('esx_ownedcarthief:installalarm')
AddEventHandler('esx_ownedcarthief:installalarm', function(plate, alarmtype)
	local xPlayer = ESX.GetPlayerFromId(source)
	local _source = source
	local _plate = plate
	MySQL.Async.fetchScalar('SELECT security FROM owned_vehicles WHERE @plate = plate', {
		['@plate'] = _plate
	}, function (result)
		if result ~= nil then
			if result == 3 then
				TriggerClientEvent('esx:showNotification', _source, _U('alarm_max_lvl'))
			elseif alarmtype-1 == result then
				if xPlayer.getInventoryItem('alarm'..tostring(alarmtype)).count > 0 then
					MySQL.Sync.execute("UPDATE owned_vehicles SET security=@alarmtype WHERE plate=@plate",{['@alarmtype'] = alarmtype, ['@plate'] = _plate})
					xPlayer.removeInventoryItem('alarm'..tostring(alarmtype), 1)
					TriggerClientEvent('esx:showNotification', _source, _U('alarm'..tostring(alarmtype)..'isinstall'))
				else
					TriggerClientEvent('esx:showNotification', _source, _U('alarm'..tostring(alarmtype)..'missing'))
				end
			else
				TriggerClientEvent('esx:showNotification', _source, _U('alarm_not_install'))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_work_with_npc'))
		end
	end)
end)

RegisterServerEvent('esx_ownedcarthief:buyitem')
AddEventHandler('esx_ownedcarthief:buyitem', function(item)
	local _source   = source
	local xPlayer   = ESX.GetPlayerFromId(_source)

	if xPlayer.getMoney() >= item.price then
		if xPlayer.canCarryItem(item.name, 1) then
			xPlayer.removeMoney(item.price)
			xPlayer.addInventoryItem(item.name, 1)
			xPlayer.showNotification(_U('bought', 1, _U(item.name), ESX.Math.GroupDigits(item.price)))
		else
			xPlayer.showNotification(_U('player_cannot_hold'))
		end
	else
		local missingMoney = item.price - xPlayer.getMoney()
		xPlayer.showNotification(_U('not_enough', ESX.Math.GroupDigits(missingMoney)))
	end
end)


ESX.RegisterServerCallback('esx_ownedcarthief:getpawnshopvehicle', function(source, cb)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local vehicles = {}
	local result   = MySQL.Sync.fetchAll('SELECT * FROM pawnshop_vehicles')
	
		for i=1, #result, 1 do
			local vehicle = result[i]
			if xPlayer.identifier == vehicle.owner or (vehicle.expiration) < os.time() then
				table.insert(vehicles, {vehicle = vehicle})
			end
		end
		cb(vehicles)
end)

ESX.RegisterServerCallback('esx_ownedcarthief:GetVehPrice', function (source, cb, plate)
	local _source  = source
	local vehiclefound = false
	if waitTime == 0 then
		howmanycops(function(cops)
			if cops >= Config.PoliceNumberRequired then
				if vehicles == nil then
					vehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles')
				end
				MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
					['@plate'] = plate
				}, function (result)
					cb(result[1] ~= nil, vehicles)
				end)
			else
				TriggerClientEvent('esx:showNotification', _source, _U('no_cops'))
			end
		end)
	else
		TriggerClientEvent('esx:showNotification', _source, _U('we_r_busy'))
	end

end)

ESX.RegisterServerCallback('esx_ownedcarthief:isPlateTaken', function (source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT owner, security, alarmactive, job FROM owned_vehicles WHERE @plate = plate', {
		['@plate'] = plate
	}, function (result)
		if result[1] ~= nil then
			local canInteract = xPlayer.identifier == result[1].owner or xPlayer.job.name == "police"
			cb(result[1] ~= nil, canInteract, result[1].security, result[1].alarmactive, result[1].job)
		else
			cb(result[1] ~= nil)
		end
	end)
end)


ESX.RegisterUsableItem('hammerwirecutter', function(source) --Hammer high time to unlock but 100% call cops and alarm start
	local _source = source
	howmanycops(function(cops)
		if cops >= Config.PoliceNumberRequired then
			TriggerClientEvent('esx_ownedcarthief:stealcar', _source, {name = "hammerwirecutter", warnCopsChance = 90, sucessChance = 25})
		else
			TriggerClientEvent('esx:showNotification', _source, _U('no_cops'))
		end
	end)
end)

ESX.RegisterUsableItem('unlockingtool', function(source) --unlockingtool Medium time to unlock and low chance to call cops
	local _source = source
		howmanycops(function(cops)
		if cops >= Config.PoliceNumberRequired then
			TriggerClientEvent('esx_ownedcarthief:stealcar', _source, {name = "unlockingtool", warnCopsChance = 25, sucessChance = 50})
		else
			TriggerClientEvent('esx:showNotification', _source, _U('no_cops'))
		end
	end)
	
end)

ESX.RegisterUsableItem('jammer', function(source) --GPS Jammer cut the signal of call cops
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	Wait(3000)
	Alarm(_source, "", false)
	xPlayer.removeInventoryItem('jammer', 1)
end)

ESX.RegisterUsableItem('alarminterface', function(source)
	TriggerClientEvent('esx_ownedcarthief:alarminterfacemenu', source)
end)

RegisterServerEvent('esx_ownedcarthief:itemused')
AddEventHandler('esx_ownedcarthief:itemused', function(item)
	local _source  = source
	local itemused = item
	local xPlayer  = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem(itemused, 1)
end)


CreateThread(function()
	while true do
		Wait(1 * minute)
		if waitTime > 0 then
			waitTime = waitTime - minute
		end
	end

end)


function Alarm(source, txt, status, gx, gy, gz)
	local _source = source
	local info = txt
	local AlarmStatus = status
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx_ownedcarthief:GPSBlip', xPlayers[i], _source, AlarmStatus)
			if AlarmStatus then
				TriggerClientEvent('esx_ownedcarthief:911', xPlayers[i], gx, gy, gz, 0.5)
				if info then
					TriggerClientEvent('esx:showNotification', xPlayers[i], _U('911'))
				end
			else
				TriggerClientEvent('esx:showNotification', _source, _U('alarmdisable'))
			end
		end
	end
end

function howmanycops(cb)
	local xPlayers = ESX.GetPlayers()
	local cops = 0
	for i=1, #xPlayers, 1 do
	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			cops = cops + 1
		end
	end
	cb(cops)
end
