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
			  TriggerClientEvent('esx:showNotification', xPlayers[i], ("Central : Une alarme de véhicule a été activer a ces coordonnés."))
			  TriggerClientEvent('esx_ownedcarthief:911', xPlayers[i], gx, gy, gz)
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
