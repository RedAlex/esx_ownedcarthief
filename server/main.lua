ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local vehicles = nil
local minute, waitTime = 60000, 0


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
					['@owner']    = GetPlayerIdentifiers(source)[1],
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
			if xPlayer.getIdentifier() == vehicle.owner or (vehicle.expiration) < os.time() then
				table.insert(vehicles, {vehicle = vehicle})
			end
		end
		cb(vehicles)
end)

ESX.RegisterServerCallback('esx_ownedcarthief:GetVehPrice', function (source, cb, plate)
local _source  = source
local vehiclefound = false
local _model       = model
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

	Citizen.Wait(3000)
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