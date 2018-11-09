ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

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
			if AlarmStatus and info then
				TriggerClientEvent('esx_ownedcarthief:911', xPlayers[i], gx, gy, gz, 1)
				if info then
					TriggerClientEvent('esx:showNotification', xPlayers[i], _U('911'))
				end
			end
		end
	end
end)

RegisterServerEvent('esx_ownedcarthief:howmanycops')
AddEventHandler('esx_ownedcarthief:howmanycops', function()
  local xPlayers = ESX.GetPlayers()
  local cops = 0
	for i=1, #xPlayers, 1 do
	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			cops = cops + 1
		end
	end
TriggerClientEvent('esx_ownedcarthief:howmanycops2', source, cops)
end)

ESX.RegisterServerCallback('esx_ownedcarthief:isPlateTaken', function (source, cb, plate) --Ici on vérify si la plaque est dans la base de donnée
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
        ['@plate'] = plate
    }, function (result)
        cb(result[1] ~= nil, result[1].security)
    end)
end)

RegisterServerEvent('esx_ownedcarthief:buyitem')
AddEventHandler('esx_ownedcarthief:buyitem', function(item)
  local _item     = item
  local _source   = source
  local xPlayer   = ESX.GetPlayerFromId(_source)
  local limit     = xPlayer.getInventoryItem(_item).limit
  local delta     = 1
  local qtty      = xPlayer.getInventoryItem(_item).count
  local pricelist = Config.Prices
  local itemprice = nil
  
	for i=1, #pricelist, 1 do
	local itemname = (pricelist[i])
		if itemname.name == _item then
			itemprice = itemname.price
		end
	end
	
	if limit ~= -1 then
		delta = limit - qtty
	end

	if qtty < limit and xPlayer.getMoney() >= itemprice then
		xPlayer.removeMoney(itemprice)
		xPlayer.addInventoryItem(_item, delta)
	else
		TriggerClientEvent('esx:showNotification', _source, _U('max_item'))
	end
end)

ESX.RegisterUsableItem('hammerwirecutter', function(source) --Hammer high time to unlock but 100% call cops and alarm start
    local _source = source
	TriggerClientEvent('esx_ownedcarthief:stealcar', _source, "hammerwirecutter")
end)

ESX.RegisterUsableItem('unlockingtool', function(source) --unlockingtool Medium time to unlock and low chance to call cops
    local _source = source
	TriggerClientEvent('esx_ownedcarthief:stealcar', _source, "unlockingtool")
end)

ESX.RegisterUsableItem('jammer', function(source) --GPS Jammer cut the signal of call cops
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers    = ESX.GetPlayers()
	
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
	local _source = source
	local xPlayers    = ESX.GetPlayers()
	
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

ESX.RegisterUsableItem('alarm1', function(source) --In Build
    local _source = source
	TriggerClientEvent('esx_ownedcarthief:*******', _source, "alarm1")
end)

ESX.RegisterUsableItem('alarm2', function(source) --In Build
    local _source = source
	TriggerClientEvent('esx_ownedcarthief:*******', _source, "alarm2")
end)

ESX.RegisterUsableItem('alarm3', function(source) --In Build
    local _source = source
	TriggerClientEvent('esx_ownedcarthief:******', _source, "alarm3")
end)

RegisterServerEvent('esx_ownedcarthief:itemused')
AddEventHandler('esx_ownedcarthief:itemused', function(item)
	local _source  = source
	local itemused = item
	local xPlayer  = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem(itemused, 1)
end)
