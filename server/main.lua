ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local copscalled = false

  RegisterServerEvent('esx_ownedcarthief:callcops')
  AddEventHandler('esx_ownedcarthief:callcops', function(gx, gy, gz)
	  
	local xPlayers = ESX.GetPlayers()	  
		for i=1, #xPlayers, 1 do
			local xPlayer1 = ESX.GetPlayerFromId(xPlayers[i])		
			if xPlayer1.job.name == 'police' or xPlayer1.job.name == 'sheriff' then
			  TriggerClientEvent('esx:showNotification', xPlayers[i], _U('911')("Central : Une alarme de véhicule a été activer a ces coordonnés."))
			  TriggerClientEvent('esx_ownedcarthief:911', xPlayers[i], gx, gy, gz)
			end
		end
end)

RegisterServerEvent('esx_ownedcarthief:alarmgps')
AddEventHandler('esx_ownedcarthief:alarmgps', function(source)
	local _source = source
	print("AlarmGPS")
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'fbi' then
			TriggerClientEvent('esx_ownedcarthief:addBlip', xPlayers[i], _source)
		end
	end

end)

RegisterServerEvent('esx_ownedcarthief:howmanycops')
AddEventHandler('esx_ownedcarthief:howmanycops', function()
  local xPlayers = ESX.GetPlayers()
  local cops = 0
	for i=1, #xPlayers, 1 do
	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' then
			cops = cops + 1
		end
	end
TriggerClientEvent('esx_ownedcarthief:howmanycops2', source, cops)
end)

ESX.RegisterServerCallback('esx_ownedcarthief:isPlateTaken', function (source, cb, plate) --Ici on vérify si la plaque est dans la base de donnée
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
        ['@plate'] = plate
    }, function (result)
        cb(result[1] ~= nil)
    end)
end)

ESX.RegisterServerCallback('esx_ownedcarthief:alarminstall', function (source, cb, plate) --Ici on vérify quel system est installer sur le véhicule
	
	 MySQL.Async.fetchScalar('SELECT security FROM owned_vehicles WHERE  @plate = plate',
    {
        ['@plate'] = plate
    }, function(security)
		cb(security)
	print(security)
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
    xPlayer.removeInventoryItem('jammer', 1)
    TriggerClientEvent('esx:showNotification', _source, "In Build")
end)

RegisterServerEvent('esx_ownedcarthief:itemused')
AddEventHandler('esx_ownedcarthief:itemused', function(item)
	local _source  = source
	local itemused = item
	local xPlayer  = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem(itemused, 1)
end)
