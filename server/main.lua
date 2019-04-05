ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local vehicles = nil
local WaitTime = 0
local minutes  = 60000

ESX.RegisterServerCallback('esx_ownedcarthief:GetVehPrice', function (source, cb, plate)
local _source  = source
local vehiclefound = false
local _model       = model
	if WaitTime == 0 then
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

RegisterServerEvent('esx_ownedcarthief:VehBuy')
AddEventHandler('esx_ownedcarthief:VehBuy', function(data)
	local vehicle  = data
	local buyprice = math.floor(data.price / Config.ResellPercentage * Config.RebuyPercentage)
	local _source  = source
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
	WaitTime = (Config.WaitTime * minutes)
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

RegisterServerEvent('esx_ownedcarthief:callcops')
AddEventHandler('esx_ownedcarthief:callcops', function(gx, gy, gz)
	  
	local xPlayers = ESX.GetPlayers()	  
		for i=1, #xPlayers, 1 do
			local xPlayer1 = ESX.GetPlayerFromId(xPlayers[i])		
			if xPlayer1.job.name == 'police' then
			  TriggerClientEvent('esx:showNotification', xPlayers[i], _U('911'))
			  TriggerClientEvent('esx_ownedcarthief:911', xPlayers[i], gx, gy, gz, 4)
			end
		end
end)

RegisterServerEvent('esx_ownedcarthief:alarmgps')
AddEventHandler('esx_ownedcarthief:alarmgps', function(status, txt, gx, gy, gz)
	local netID = source
	local info  = txt
	local AlarmStatus = status
	local xPlayers    = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx_ownedcarthief:GPSBlip', xPlayers[i], netID, AlarmStatus)
			if AlarmStatus then
				TriggerClientEvent('esx_ownedcarthief:911', xPlayers[i], gx, gy, gz, 0.5)
				if info then
					TriggerClientEvent('esx:showNotification', xPlayers[i], _U('911'))
				end
			end
		end
	end
end)

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

ESX.RegisterServerCallback('esx_ownedcarthief:isPlateTaken', function (source, cb, plate)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
        ['@plate'] = plate
    }, function (result)
		if result[1] ~= nil then
			cb(result[1] ~= nil, result[1].security)
		else
			cb(result[1] ~= nil)
		end
    end)
end)

RegisterServerEvent('esx_ownedcarthief:installalarm')
AddEventHandler('esx_ownedcarthief:installalarm', function(plate, alarmtype)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
        ['@plate'] = plate
    }, function (result)
		if result[1] ~= nil then
			if result[1].security == 3 then
				TriggerClientEvent('esx:showNotification', _source, _U('alarm_max_lvl'))
			elseif result[1].security == 2 then
				if alarmtype == 3 then
					MySQL.Sync.execute("UPDATE owned_vehicles SET security=@alarmtype WHERE plate=@plate",{['@alarmtype'] = alarmtype, ['@plate'] = plate})
					xPlayer.removeInventoryItem('alarm3', 1)
					TriggerClientEvent('esx:showNotification', _source, _U('alarm3_install'))
				elseif alarmtype == 2 or alarmtype == 1 then
					TriggerClientEvent('esx:showNotification', _source, _U('alarm_not_install'))
				end
			elseif result[1].security == 1 then
				if alarmtype == 3 then
					MySQL.Sync.execute("UPDATE owned_vehicles SET security=@alarmtype WHERE plate=@plate",{['@alarmtype'] = alarmtype, ['@plate'] = plate})
					xPlayer.removeInventoryItem('alarm3', 1)
					TriggerClientEvent('esx:showNotification', _source, _U('alarm3_install'))
				elseif alarmtype == 2 then
					MySQL.Sync.execute("UPDATE owned_vehicles SET security=@alarmtype WHERE plate=@plate",{['@alarmtype'] = alarmtype, ['@plate'] = plate})
					xPlayer.removeInventoryItem('alarm2', 1)
					TriggerClientEvent('esx:showNotification', _source, _U('alarm2_install'))
				elseif alarmtype == 1 then
					TriggerClientEvent('esx:showNotification', _source, _U('alarm_not_install'))
				end
			elseif result[1].security == 0 then
				if alarmtype == 3 then
					MySQL.Sync.execute("UPDATE owned_vehicles SET security=@alarmtype WHERE plate=@plate",{['@alarmtype'] = alarmtype, ['@plate'] = plate})
					xPlayer.removeInventoryItem('alarm3', 1)
					TriggerClientEvent('esx:showNotification', _source, _U('alarm3_install'))
				elseif alarmtype == 2 then
					MySQL.Sync.execute("UPDATE owned_vehicles SET security=@alarmtype WHERE plate=@plate",{['@alarmtype'] = alarmtype, ['@plate'] = plate})
					xPlayer.removeInventoryItem('alarm2', 1)
					TriggerClientEvent('esx:showNotification', _source, _U('alarm2_install'))
				elseif alarmtype == 1 then
					MySQL.Sync.execute("UPDATE owned_vehicles SET security=@alarmtype WHERE plate=@plate",{['@alarmtype'] = alarmtype, ['@plate'] = plate})
					xPlayer.removeInventoryItem('alarm1', 1)
					TriggerClientEvent('esx:showNotification', _source, _U('alarm1_install'))
				end
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_work_with_npc'))
		end
    end)
end)

RegisterServerEvent('esx_ownedcarthief:buyitem')
AddEventHandler('esx_ownedcarthief:buyitem', function(item)
  local _item     = item
  local _source   = source
  local xPlayer   = ESX.GetPlayerFromId(_source)
  local limit     = xPlayer.getInventoryItem(_item).limit
  local qtty      = xPlayer.getInventoryItem(_item).count
  local pricelist = Config.Prices
  local itemprice = nil
  
	for i=1, #pricelist, 1 do
	local itemname = (pricelist[i])
		if itemname.name == _item then
			itemprice = itemname.price
		end
	end

	if qtty < limit and xPlayer.getMoney() >= itemprice then
		xPlayer.removeMoney(itemprice)
		xPlayer.addInventoryItem(_item, 1)
	else
		TriggerClientEvent('esx:showNotification', _source, _U('max_item'))
	end
end)

ESX.RegisterUsableItem('hammerwirecutter', function(source) --Hammer high time to unlock but 100% call cops and alarm start
    local _source = source
	howmanycops(function(cops)
		if cops >= Config.PoliceNumberRequired then
			TriggerClientEvent('esx_ownedcarthief:stealcar', _source, "hammerwirecutter")
		else
			TriggerClientEvent('esx:showNotification', _source, _U('no_cops'))
		end
	end)
end)

ESX.RegisterUsableItem('unlockingtool', function(source) --unlockingtool Medium time to unlock and low chance to call cops
    local _source = source
		howmanycops(function(cops)
		if cops >= Config.PoliceNumberRequired then
			TriggerClientEvent('esx_ownedcarthief:stealcar', _source, "unlockingtool")
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
		for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('esx_ownedcarthief:removeBlip', xPlayers[i])
			end
		end

	xPlayer.removeInventoryItem('jammer', 1)
	TriggerClientEvent('esx:showNotification', _source, _U('jammeruse'))
end)

ESX.RegisterUsableItem('alarminterface', function(source) --Alarm system interface for cop usage, can cut an car gps alarm
	local _source  = source
	local xPlayers = ESX.GetPlayers()
	
	TriggerClientEvent('esx:showNotification', _source, _U('rucops'))
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'police' then
		TriggerClientEvent('esx:showNotification', _source, _U('truecop'))
		for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('esx_ownedcarthief:removeBlip', xPlayers[i])
			end
		end
	else
		TriggerClientEvent('esx:showNotification', _source, _U('illegalusedetect'))
		TriggerClientEvent('esx:showNotification', _source, _U('memoryformating'))
		xPlayer.removeInventoryItem('alarminterface', 1)
	end
end)

ESX.RegisterUsableItem('alarm1', function(source)
	local _source  = source
	local xPlayers = ESX.GetPlayers()
	local xPlayer  = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'mechanic' then
		TriggerClientEvent('esx_ownedcarthief:useitemalarm', _source, 1)
	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_mecano'))
	end
end)

ESX.RegisterUsableItem('alarm2', function(source)
	local _source  = source
	local xPlayers = ESX.GetPlayers()
	local xPlayer  = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'mechanic' then
		TriggerClientEvent('esx_ownedcarthief:useitemalarm', _source, 2)
	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_mecano'))
	end
end)

ESX.RegisterUsableItem('alarm3', function(source)
	local _source  = source
	local xPlayers = ESX.GetPlayers()
	local xPlayer  = ESX.GetPlayerFromId(_source)
	if xPlayer.job.name == 'mechanic' then
		TriggerClientEvent('esx_ownedcarthief:useitemalarm', _source, 3)
	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_mecano'))
	end
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
		Wait(1 * minutes)
		if WaitTime > 0 then
			WaitTime = WaitTime - minutes
		end
	end

end)
