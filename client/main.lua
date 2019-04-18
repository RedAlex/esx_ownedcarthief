local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX              = nil
local PlayerData = {}
local seconde    = 1000
local vehicle    = nil
local callcops   = 0
local carblips   = {}
local timer      = 0
local stolecheck = false
local vehunlock  = false
local vehplate   = nil
local alarm      = false
local SystemType = 0
local SellWait   = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

end)

Citizen.CreateThread(function()
local playerPed = PlayerPedId()
	while true do

		Citizen.Wait(5)
		if stolecheck then
			local coordx,coordy,coordz = table.unpack(GetEntityCoords(playerPed,true))
			Citizen.Wait(1 * seconde)
			local newx,newy,newz = table.unpack(GetEntityCoords(playerPed,true))
			if GetDistanceBetweenCoords(coordx,coordy,coordz, newx,newy,newz) > 2 then
				stolecheck = false
				timer      = 0
			end
		end
	end
end)

Citizen.CreateThread(function()
local playerPed = PlayerPedId()

	while true do

		Citizen.Wait(0)
		if timer > (20 * seconde) and stolecheck then
			Citizen.Wait(19 * seconde)
			if timer > (4 * seconde) and stolecheck then
				TaskPlayAnim(GetPlayerPed(-1), "gestures@m@standing@casual" ,"gesture_damn" ,8.0, -8.0, -1, 0, 0, false, false, false )
				Citizen.Wait(3 * seconde)
				TaskStartScenarioInPlace(playerPed, "prop_human_parking_meter", 0, true)
			end
		end
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx_ownedcarthief:911')
AddEventHandler('esx_ownedcarthief:911', function(gx, gy, gz, blipt)
local XBlipTime = blipt
	if PlayerData.job ~= nil then
	  if PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'fbi' then
		if Config.AlertPolice then
			local transG = 250
			local crimeBlip = AddBlipForCoord(gx, gy, gz)
			SetBlipSprite(crimeBlip , 161) -- Blips qui flash bleu
			SetBlipScale(crimeBlip , 2.0) -- Blips qui flash bleu
			SetBlipColour(crimeBlip, 3) -- Blips qui flash bleu
			PulseBlip(crimeBlip) -- Blips qui flash bleu
			while transG ~= 0 do
				Wait(Config.BlipTime * XBlipTime)
				transG = transG - 1
				if transG == 0 then
					SetBlipSprite(crimeBlip,  2)
					return
				end
			end
		   
		end
	  end
	end
end)

RegisterNetEvent('esx_ownedcarthief:useitemalarm')
AddEventHandler('esx_ownedcarthief:useitemalarm', function(data)
	local AlarmType = data
	local Vehicle   = ESX.Game.GetVehicleInDirection()
		if Vehicle ~= nil then
			local vehicleData = ESX.Game.GetVehicleProperties(Vehicle)
			TriggerServerEvent('esx_ownedcarthief:installalarm', vehicleData.plate, AlarmType)
		end
end)

RegisterNetEvent('esx_ownedcarthief:stealcar')
AddEventHandler('esx_ownedcarthief:stealcar', function(item)

    vehicle    = ESX.Game.GetVehicleInDirection()
    stolecheck = false
    timer      = 0
local playerPed       = PlayerPedId()
local coords          = GetEntityCoords(playerPed, true)
local vehicleData     = ESX.Game.GetVehicleProperties(vehicle)
local CheckOwnedPlate = false
local itemused        = item
	  vehplate        = vehicleData.plate

	ESX.UI.Menu.CloseAll()
	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) and vehicleData ~= nil then
		ESX.TriggerServerCallback('esx_ownedcarthief:isPlateTaken', function (isPlateTaken, alarmsystem)
			if isPlateTaken then
					TriggerServerEvent('esx_ownedcarthief:itemused', itemused)
					SystemType = alarmsystem
					if itemused == "hammerwirecutter" then
						timer = (60 * seconde)
						callcops = 1
						TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_HAMMERING", 0, true)
						Citizen.Wait(5 * seconde)
						TaskStartScenarioInPlace(playerPed, "prop_human_parking_meter", 0, true)
					elseif itemused == "unlockingtool" then
						timer = (30 * seconde)
						callcops = math.random(1,101)	
						TaskStartScenarioInPlace(playerPed, "prop_human_parking_meter", 0, true)
					end

					ShowTimer()

					Citizen.Wait(math.random(1,21) * seconde)
					if callcops <= Config.CallCopsChance and stolecheck then
						if alarmsystem > 0 then
							SetVehicleAlarm(vehicle, 1)
						else
							SetVehicleAlarm(vehicle, 0)
						end
						if alarmsystem >= 2 then
							TriggerServerEvent('esx_ownedcarthief:callcops', coords.x, coords.y, coords.z)
						end
						StartVehicleAlarm(vehicle)
						Citizen.Wait(1 * seconde)
						TaskPlayAnim(GetPlayerPed(-1), "gestures@m@standing@casual" ,"gesture_bring_it_on" ,8.0, -8.0, -1, 0, 0, false, false, false )
						Citizen.Wait(2.5 * seconde)
						TaskStartScenarioInPlace(playerPed, "prop_human_parking_meter", 0, true)
					end

			elseif not isPlateTaken and not Config.OnlyPlayerCar then
				TriggerServerEvent('esx_ownedcarthief:itemused', itemused)
				if itemused == "hammerwirecutter" then
					timer = (60 * seconde)
					callcops = 1
					TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_HAMMERING", 0, true)
					Citizen.Wait(5 * seconde)
					TaskStartScenarioInPlace(playerPed, "prop_human_parking_meter", 0, true)
				elseif itemused == "unlockingtool" then
					timer = (30 * seconde)
					callcops = math.random(1,101)	
					TaskStartScenarioInPlace(playerPed, "prop_human_parking_meter", 0, true)
				end

				ShowTimer()

				Citizen.Wait(math.random(1,21) * seconde)
				if callcops <= Config.CallCopsChance then
						if math.random(1,101) <= 81 then
							SetVehicleAlarm(vehicle, 1)
						else
							SetVehicleAlarm(vehicle, 0)
						end
						if math.random(1,101) <= 41 then
							TriggerServerEvent('esx_ownedcarthief:callcops', coords.x, coords.y, coords.z)			
						end
						StartVehicleAlarm(vehicle)
						Citizen.Wait(1 * seconde)
						TaskPlayAnim(GetPlayerPed(-1), "gestures@m@standing@casual" ,"gesture_bring_it_on" ,8.0, -8.0, -1, 0, 0, false, false, false )
						Citizen.Wait(2.5 * seconde)
						TaskStartScenarioInPlace(playerPed, "prop_human_parking_meter", 0, true)
				end
			elseif not isPlateTaken and Config.OnlyPlayerCar then
				ESX.ShowNotification(_U('not_work_with_npc'))
			end
		end, vehicleData.plate)
	end
end)

function ShowTimer()

	Citizen.CreateThread(function()
		while timer > 0 do
			Citizen.Wait(5)

			raw_seconds = timer/1000
			raw_minutes = raw_seconds/60
			minutes = stringsplit(raw_minutes, ".")[1]
			seconds = stringsplit(raw_seconds-(minutes*60), ".")[1]

			SetTextFont(7)
			SetTextProportional(0)
			SetTextScale(0.0, 0.5)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()

			local text = _U('please_wait', minutes, seconds)

			SetTextCentre(true)
			BeginTextCommandDisplayText("STRING")
			AddTextComponentSubstringPlayerName(text)
			EndTextCommandDisplayText(0.5, 0.8)

			timer = timer - 20
			stolecheck = true
		end
		
		while timer == 0 and stolecheck do
			        stolecheck = false
			local 	vehicle2   = ESX.Game.GetVehicleInDirection()
			local   playerPed  = PlayerPedId()
			local   succes     = math.random(1,101)

			ClearPedTasksImmediately(playerPed)
			if vehicle == vehicle2 then
				if succes <= Config.SuccesChance then
					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					if callcops <= Config.CallCopsChance then
						vehunlock = true
					end
					ESX.ShowNotification(_U('vehicle_unlocked'))
				else
					ESX.ShowNotification(_U('vehicle_notunlocked'))
				end
			end
		end
	end)
end

function stringsplit(inputstr, sep)
  if sep == nil then
      sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      t[i] = str
      i = i + 1
  end
  return t
end

function OpenPawnshopMenu()
	ESX.UI.Menu.CloseAll()

	local cantsellcar = false
	local playerPed   = PlayerPedId()
	local veh         = GetVehiclePedIsIn(playerPed, false)

	local menuelements = {
		{label = _U('pawnshop_buyitem'), value = 'pawnshop_buyitem'},
		{label = _U('pawnshop_rebuy'),   value = 'pawnshop_rebuy'}

	}

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'pawnshop',
	{
		title    = _U('pawnshop_menu_title'),
		align    = 'left',
		elements = menuelements,
	}, function(data, menu)
			menu.close()
			local zone = Config.Zones
			for i=1, #zone, 1 do
				if (isNear(zone[i].Pos)) and data.current.value == 'pawnshop_rebuy' then
					OpenPawnshopMenu3()
				elseif (isNear(zone[i].Pos)) and data.current.value == 'pawnshop_buyitem' then
					OpenPawnshopMenu2()
				end
			end
	end, function(data, menu)
		menu.close()
	 end
	
	)
end

function OpenBlackGarageMenu()
	ESX.UI.Menu.CloseAll()

	local cantsellcar = false
	local playerPed   = PlayerPedId()
	local veh         = GetVehiclePedIsIn(playerPed, false)

	for i=1, #Config.PawnShopBLJob, 1 do
		local BLJob = Config.PawnShopBLJob[i]
		if PlayerData.job.name == BLJob.JobName then
			cantsellcar = true
		end
	end
	
	if not cantsellcar and GetPedInVehicleSeat(veh, -1) == playerPed then
		local menuelements = {{label = _U('blackgarage_resell'),  value = 'blackgarage_resell'}}

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'blackgarage',
		{
			title    = _U('black_menu_title'),
			align    = 'left',
			elements = menuelements,
		}, function(data, menu)
				menu.close()
				local zone = Config.Zones
				for i=1, #zone, 1 do
					if (isNear(zone[i].Pos)) and data.current.value == 'blackgarage_resell' then
						SellStolenCar()
					end
				end
		end, function(data, menu)
			menu.close()
		 end)
	end
end

function SellStolenCar()
local playerPed   = PlayerPedId()
local veh         = GetVehiclePedIsIn(playerPed, false)
local vehicleData = ESX.Game.GetVehicleProperties(veh)

	if GetPedInVehicleSeat(veh, -1) == playerPed and not SellWait then
		SellWait = true
		ESX.TriggerServerCallback('esx_ownedcarthief:GetVehPrice', function (ownedcar, vehicles)
			ESX.ShowNotification(_U('checkvehicle'))
			Citizen.CreateThread(function()
				if ownedcar then
					for i=1, #vehicles, 1 do
						Citizen.Wait(1)
						local vehicle = vehicles[i]

						if vehicleData.model == GetHashKey(vehicle.model) then
							price = math.floor(vehicle.price / 100 * Config.ResellPercentage) 
							ESX.Game.DeleteVehicle(veh)
							TriggerServerEvent('esx_ownedcarthief:VehSold', true, price, vehicleData.plate)
							SellWait = false
							break
						end
					end
				elseif not Config.OnlyPlayerCar and not ownedcar then
					price = Config.NpcCarPrice
					ESX.Game.DeleteVehicle(veh)
					TriggerServerEvent('esx_ownedcarthief:VehSold', false, price, vehicleData.plate)
					SellWait = false
				elseif Config.OnlyPlayerCar and not ownedcar then
					ESX.ShowNotification(_U('not_work_with_npc'))
					SellWait = false
				end

			end)
		end, vehicleData.plate)
	end
end

function OpenPawnshopMenu2()
	ESX.UI.Menu.CloseAll()

	local elements = {}
	if PlayerData.job.name ~= 'police' then
		elements = {
			{label = _U('hammerwirecutter', Config.Prices[1].price), value = 'hammerwirecutter'},
			{label = _U('jammer', Config.Prices[3].price), value = 'jammer'},
			{label = _U('unlockingtool', Config.Prices[2].price), value = 'unlockingtool'}
		}
	end
	if PlayerData.job.name == 'police' then
		elements = {
			{label = _U('alarminterface', Config.Prices[7].price),  value = 'alarminterface'}
		}
	end
	if PlayerData.job.name == 'mechanic' then
		table.insert(elements, {label = _U('alarm1', Config.Prices[4].price), value = 'alarm1'})
		table.insert(elements, {label = _U('alarm2', Config.Prices[5].price), value = 'alarm2'})
		table.insert(elements, {label = _U('alarm3', Config.Prices[6].price), value = 'alarm3'})
	end
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'pawnshop2',
	{
		title    = _U('pawnshop_menu_title'),
		align    = 'left',
		elements = elements,
	}, function(data, menu)
	  	local zone = Config.Zones
		for i=1, #zone, 1 do
			if (isNear(zone[i].Pos)) then
				TriggerServerEvent('esx_ownedcarthief:buyitem', data.current.value)
			end
		end
	end, function(data, menu)
		ESX.UI.Menu.CloseAll()
	end
	)
end

function OpenPawnshopMenu3()
	local elements = {}
	local VehPrice = nil

	ESX.TriggerServerCallback('esx_ownedcarthief:getpawnshopvehicle', function(vehicles)

		for i=1, #vehicles, 1 do
			local vehicle      = vehicles[i].vehicle
			local VehDecode    = json.decode(vehicle.vehicle)
			local VehModel     = VehDecode.model
    		local VehicleName  = GetDisplayNameFromVehicleModel(VehModel)
			      VehPrice     = math.floor(vehicle.price / Config.ResellPercentage * Config.RebuyPercentage)
    		local labelvehicle = (VehicleName .." ".. VehPrice .."$")

			table.insert(elements, {label = labelvehicle, value = vehicle})
			
		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'pawnshop3',
		{
			title    = _U('pawnshop_menu_title'),
			align    = 'left',
			elements = elements,
		},
		function(data, menu)
			if (data.current.value) then
				menu.close()
				local veh = data.current.value
				TriggerServerEvent('esx_ownedcarthief:VehBuy', veh)
			end
		end, function(data, menu)
			ESX.UI.Menu.CloseAll()
		end
	)	
	end)
end

function Info(text, loop)
			SetTextComponentFormat("STRING")
			AddTextComponentString(text)
			DisplayHelpTextFromStringLabel(0, loop, 1, 0)
end

function isNear(tabl)
local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),tabl.x,tabl.y,tabl.z, true)

if(distance<3) then
	return true
	end
		return false
end

function createBlip(id)
	local veh  = id
	local blip = GetBlipFromEntity(veh)

	if not DoesBlipExist(blip) then -- Add blip and create head display on player
		blip = AddBlipForEntity(veh)
		SetBlipSprite(blip, 161)
		ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
		SetBlipRotation(blip, math.ceil(GetEntityHeading(veh))) -- update rotation
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('stolen_car'))
		EndTextCommandSetBlipName(blip)
		SetBlipScale(blip, 1.5) -- set scale
		SetBlipAsShortRange(blip, true)
		
		table.insert(carblips, blip) -- add blip to array so we can remove it later
	end
end

RegisterNetEvent('esx_ownedcarthief:GPSBlip')
AddEventHandler('esx_ownedcarthief:GPSBlip', function(id, data)
	local AlarmStatus = data
	local PID  = id
	local veh  = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(PID)), false)
	local veh2 = ESX.Game.GetVehicleInDirection()
	if AlarmStatus then
		createBlip(veh)
		alarm = true
	else
		removeBlip(veh)
		removeBlip(veh2)
		alarm     = false
		vehunlock = false
	end

end)

Citizen.CreateThread(function()
	local playerPed   = PlayerPedId()
	local alarmtime   = 0
	while true do
		Citizen.Wait(1 * seconde)
		if SystemType == 3 and (vehunlock or alarm) then
			local veh         = GetVehiclePedIsIn(playerPed, false)
			local vehicleData = ESX.Game.GetVehicleProperties(veh)
			local coords      = GetEntityCoords(veh)
			if vehunlock and veh ~= nil and vehplate == vehicleData.plate and GetPedInVehicleSeat(veh, -1) == playerPed then
				local coords    = GetEntityCoords(veh)
				TriggerServerEvent('esx_ownedcarthief:alarmgps', true, true,coords.x, coords.y, coords.z)
				SetVehicleAlarm(vehicle, 1)
				StartVehicleAlarm(vehicle)
				vehunlock = false
				alarm     = true
			elseif not vehunlock and vehicle ~= nil and alarm and vehplate == vehicleData.plate then
				alarmtime = (alarmtime + 2)
				if alarmtime >= 10 then
					SetVehicleAlarm(vehicle, 1)
					StartVehicleAlarm(vehicle)
					alarmtime = 0
				end
				TriggerServerEvent('esx_ownedcarthief:alarmgps', true, false, coords.x, coords.y, coords.z)
				Citizen.Wait(1 * seconde)
			else
				Citizen.Wait(1 * seconde)
				alarmtime   = 0
			end
		end
	end

end)

RegisterNetEvent('esx_ownedcarthief:removeBlip')
AddEventHandler('esx_ownedcarthief:removeBlip', function()
	TriggerServerEvent('esx_ownedcarthief:alarmgps', false ,false)
end)

function removeBlip(data)
	local existingBlip = data

	for k, existingBlip in pairs(carblips) do
		RemoveBlip(existingBlip)
	end
end

Citizen.CreateThread(function()
local zone = Config.Zones
	for i=1, #zone, 1 do
		if zone[i].OnMap then
			local blip = AddBlipForCoord(zone[i].Pos.x, zone[i].Pos.y, zone[i].z)
			SetBlipSprite (blip, 488)
			SetBlipDisplay(blip, 4)
			SetBlipColour (blip, 1)
			SetBlipScale  (blip, 1.2)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('pawn_shop_blip'))
			EndTextCommandSetBlipName(blip)
		end
	end
		while true do
		Citizen.Wait(0)
			for i=1, #zone, 1 do
				DrawMarker(1,zone[i].Pos.x,zone[i].Pos.y,zone[i].Pos.z-1,0,0,0,0,0,0,5.001,5.0001,0.5001,255,0,0,200,0,0,0,0)
			
			
				if(isNear(zone[i].Pos)) and (zone[i].Name) == "PawnShop" then
					Info(_U('pawn_shop_menu'))
					if(IsControlJustPressed(1, 38)) then
						OpenPawnshopMenu()
					end
				elseif(isNear(zone[i].Pos)) and (zone[i].Name) == "BlackGarage" then
					Info(_U('black_garage_menu'))
					if(IsControlJustPressed(1, 38)) then
						OpenBlackGarageMenu()
					end
				end
			end
			
		end
end)

