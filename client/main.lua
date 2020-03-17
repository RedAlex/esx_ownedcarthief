ESX = nil
local PlayerData, carblips = {}, {}
local second, callCops, timer, systemType = 1000, 0, 0, 0
local vehicle, vehPlate = nil, nil
local alarm, sellWait, step1, stoleCheck, vehUnlock = false, false, false, false, false
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastZone, LastPart, LastPartNum

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
	while true do
		Citizen.Wait(5)
		if stoleCheck then
			local coordx,coordy,coordz = table.unpack(GetEntityCoords(PlayerPedId(),true))
			Citizen.Wait(1 * second)
			local newx,newy,newz = table.unpack(GetEntityCoords(PlayerPedId(),true))
			if GetDistanceBetweenCoords(coordx,coordy,coordz, newx,newy,newz) > 2 then
				stoleCheck = false
				timer = 0
			end
		end
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.Zones.Shops) do
		if v.OnMap then
			for i = 1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i])

				SetBlipSprite (blip, v.Sprite)
				SetBlipScale  (blip, v.Size)
				SetBlipColour (blip, v.Color)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(_U(v.Name))
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local letSleep, isInMarker, hasExited = true, false, false
		local currentZone, currentPart, currentPartNum

		for zone,shop in pairs(Config.Zones) do

			for k,v in ipairs(shop.PawnShop.Pos) do
				local distance = #(playerCoords - v)

				if distance < 100.0 then
					DrawMarker(1, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.5, 102, 0, 102, 100, false, false, 2, false, nil, nil, false)
					letSleep = false

					if distance < 1.5 then
						isInMarker, currentZone, currentPart, currentPartNum = true, zone, 'PawnShopActions', k
					end
				end
			end
			
			for k,v in ipairs(shop.BlackGarage.Pos) do
				local distance = #(playerCoords - v)

				if distance < 100.0 then
					DrawMarker(1, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3, 3, 0.5, 102, 0, 102, 100, false, false, 2, false, nil, nil, false)
					letSleep = false

					if distance < 3 then
						isInMarker, currentZone, currentPart, currentPartNum = true, zone, 'BlackGarageActions', k
					end
				end
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastZone ~= currentZone or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
			if
				(LastZone ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
				(LastZone ~= currentZone or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
			then
				TriggerEvent('esx_ownedcarthief:hasExitedMarker', LastZone, LastPart, LastPartNum)
				hasExited = true
			end

			HasAlreadyEnteredMarker, LastZone, LastPart, LastPartNum = true, currentZone, currentPart, currentPartNum

			TriggerEvent('esx_ownedcarthief:hasEnteredMarker', currentZone, currentPart, currentPartNum)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_ownedcarthief:hasExitedMarker', LastZone, LastPart, LastPartNum)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('esx_ownedcarthief:hasEnteredMarker', function(hospital, part, partNum)
	if part == 'PawnShopActions' then
		OpenPawnshopMenu()
	elseif part == 'BlackGarageActions' then
		OpenBlackGarageMenu()
	end
end)

AddEventHandler('esx_ownedcarthief:hasExitedMarker', function(hospital, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

Citizen.CreateThread(function()
	local alarmTime = 0
	local step2 = false

	while true do
		Citizen.Wait(1 * second)
		if systemType == 3 and vehUnlock and GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
			local veh         = GetVehiclePedIsIn(PlayerPedId(), false)
			local vehicleData = ESX.Game.GetVehicleProperties(veh)
			local coords      = GetEntityCoords(veh)
			if step1 and veh ~= nil and vehPlate == vehicleData.plate and GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
				TriggerServerEvent('esx_ownedcarthief:alarmgps', true, true,coords.x, coords.y, coords.z)
				SetVehicleAlarm(vehicle, true)
				StartVehicleAlarm(vehicle)
				step1, step2, alarm = false, true, true
			end
			if step2 and vehicle ~= nil and alarm and vehPlate == vehicleData.plate then
				alarmTime = (alarmTime + 2)
				if alarmTime >= 10 then
					SetVehicleAlarm(vehicle, true)
					StartVehicleAlarm(vehicle)
					alarmTime = 0
				end
				TriggerServerEvent('esx_ownedcarthief:alarmgps', true, false, coords.x, coords.y, coords.z)
				Citizen.Wait(1 * second)
			else
				Citizen.Wait(1 * second)
				alarmTime   = 0
			end
		elseif systemType == 2 and vehUnlock and GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
			if vehicle ~= nil and alarm and vehPlate == vehicleData.plate then
				alarmTime = (alarmTime + 2)
				if alarmTime >= 10 then
					SetVehicleAlarm(vehicle, true)
					StartVehicleAlarm(vehicle)
					alarmTime = 0
				end
				Citizen.Wait(1 * second)
			else
				Citizen.Wait(1 * second)
				alarmTime   = 0
			end
		end
		
	end
end)

Citizen.CreateThread(function()
local hornCount = 0
local warn = false
local lastvehicle = 0

	while true do
		Citizen.Wait(1 * second)
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		if veh ~= 0 and veh ~= lastvehicle and GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
			systemType, step1, step2, vehUnlock, warn = 0, false, false, false, false
			vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			lastvehicle = vehicle
			local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
			vehPlate = vehicleData.plate
			ESX.TriggerServerCallback('esx_ownedcarthief:isPlateTaken', function (isPlateTaken, canInteract ,alarmSystem, alarmactive)
				if isPlateTaken then
					if not canInteract then
						systemType = alarmSystem
						warn = alarmactive
					end
				end
			end, vehicleData.plate)
		end
		if warn then
			if hornCount < 9 and warn then
				StartVehicleHorn(vehicle, 0, "HELDDOWN", false)
				Citizen.Wait(100)
				if hornCount >= 3 then
					StartVehicleHorn(vehicle, 0, "HELDDOWN", false)
					Citizen.Wait(100)
					if hornCount >= 6 then
						StartVehicleHorn(vehicle, 0, "HELDDOWN", false)
						Citizen.Wait(100)
					end
				end
				hornCount = hornCount + 1
			elseif hornCount >= 9 and warn then
				step1, vehUnlock, warn = true, true, false
				CallCops(100, true, false)
			end
		end
		if hornCount > 0 and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
			hornCount = 0
		end
		if veh == 0 and lastvehicle ~= 0 then
			lastvehicle = 0
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

	if PlayerData ~= {} then
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

RegisterNetEvent('esx_ownedcarthief:stealcar')
AddEventHandler('esx_ownedcarthief:stealcar', function(item)
	vehicle, stoleCheck, timer = ESX.Game.GetVehicleInDirection(), false, 0
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true)
	local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
	local itemUsed = item
	vehPlate = vehicleData.plate

	ESX.UI.Menu.CloseAll()
	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) and vehicleData ~= nil then
		ESX.TriggerServerCallback('esx_ownedcarthief:isPlateTaken', function (isPlateTaken, canInteract ,alarmSystem, alarmactive)
			systemType = alarmSystem or 0
			if isPlateTaken then
				StartCarSteal(itemUsed, true, vehicleData, false)
			elseif not isPlateTaken and not Config.OnlyPlayerCar then
				StartCarSteal(itemUsed, false, vehicleData, true)
			elseif not isPlateTaken and Config.OnlyPlayerCar then
				ESX.ShowNotification(_U('not_work_with_npc'))
			end
		end, vehicleData.plate)
	end
end)


RegisterNetEvent('esx_ownedcarthief:alarminterfacemenu')
AddEventHandler('esx_ownedcarthief:alarminterfacemenu', function()
	local playerPed = PlayerPedId()
	local veh = GetVehiclePedIsIn(playerPed, false)
	if veh ~= 0 then
		local vehicleData = ESX.Game.GetVehicleProperties(veh)
		ESX.UI.Menu.CloseAll()

		local elements = {}

		ESX.TriggerServerCallback('esx_ownedcarthief:isPlateTaken', function (isPlateTaken, canInteract, security, alarmactive)
		local _alarmactive = ""
			if alarmactive == 1 then
				_alarmactive = _U('active')
			else
				_alarmactive = _U('disable')
			end
			elements = {
				{label = _U('alarmstatus', _alarmactive), value = ""},
				{label = _U('activatesystem'),  value = 'activatesystem'},
				{label = _U('disablesystem'),  value = 'disablesystem'},
				{label = _U('cutalarm'),  value = 'cutalarm'}
			}
			if PlayerData.job.name == 'mechanic' then
				table.insert(elements, {label = _U('alarm1install'), value = 'basealarm'})
				table.insert(elements, {label = _U('alarm2install'), value = 'modgps'})
				table.insert(elements, {label = _U('alarm3install'), value = 'satcon'})
			end

			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'interfacemenu',
			{
				title    = _U('interfacemenu'),
				align    = 'left',
				elements = elements,
			}, function(data, menu)
				if data.current.value == "activatesystem" then
					menu.close()
					TriggerServerEvent("esx_ownedcarthief:togglealarm", vehicleData.plate, 1)
				elseif data.current.value == "disablesystem" then
					menu.close()
					TriggerServerEvent("esx_ownedcarthief:togglealarm", vehicleData.plate, 0)
				elseif data.current.value == "cutalarm" and canInteract then
					menu.close()
					TriggerServerEvent('esx_ownedcarthief:alarmgps', false)
				elseif data.current.value == "basealarm" then
					TriggerServerEvent('esx_ownedcarthief:installalarm', vehicleData.plate, 1)
				elseif data.current.value == "modgps" then
					TriggerServerEvent('esx_ownedcarthief:installalarm', vehicleData.plate, 2)
				elseif data.current.value == "satcon" then
					TriggerServerEvent('esx_ownedcarthief:installalarm', vehicleData.plate, 3)
				end
			end, function(data, menu)
				ESX.UI.Menu.CloseAll()
			end)
		end, vehicleData.plate)
	else
		ESX.ShowNotification(_U('needtobesit'))
	end
end)

RegisterNetEvent('esx_ownedcarthief:GPSBlip')
AddEventHandler('esx_ownedcarthief:GPSBlip', function(id, data)
	local AlarmStatus = data
	local PID  = id
	local veh  = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(PID)), false)
	if AlarmStatus then
		createBlip(veh)
		alarm = true
	else
		removeBlip(veh)
		SetVehicleAlarm(veh, false)
		StartVehicleAlarm(veh)
		alarm, systemType, step2, vehUnlock = false, 0 ,false, false
	end

end)


function removeBlip(data)
	local existingBlip = data

	for k, existingBlip in pairs(carblips) do
		RemoveBlip(existingBlip)
	end
end

function SellStolenCar()
local playerPed   = PlayerPedId()
local veh         = GetVehiclePedIsIn(playerPed, false)
local vehicleData = ESX.Game.GetVehicleProperties(veh)

	if GetPedInVehicleSeat(veh, -1) == playerPed and not sellWait then
		sellWait = true
		ESX.TriggerServerCallback('esx_ownedcarthief:GetVehPrice', function (ownedcar, vehicles)
			ESX.ShowNotification(_U('checkvehicle'))
			Citizen.CreateThread(function()
				Citizen.Wait(1000)
				if ownedcar then
					local found = false
					for i=1, #vehicles, 1 do
						local vehicle = vehicles[i]

						if vehicleData.model == GetHashKey(vehicle.model) then
							price = math.floor(vehicle.price / 100 * Config.ResellPercentage) 
							ESX.Game.DeleteVehicle(veh)
							TriggerServerEvent('esx_ownedcarthief:VehSold', true, price, vehicleData.plate)
							sellWait = false
							found = true
							break
						end
					end
					if not found then
						ESX.ShowNotification(_U('wedontbuythis'))
					end
				elseif not Config.OnlyPlayerCar and not ownedcar then
					price = Config.NpcCarPrice
					ESX.Game.DeleteVehicle(veh)
					TriggerServerEvent('esx_ownedcarthief:VehSold', false, price, vehicleData.plate)
					sellWait = false
				elseif Config.OnlyPlayerCar and not ownedcar then
					ESX.ShowNotification(_U('not_work_with_npc'))
					sellWait = false
				end

			end)
		end, vehicleData.plate)
	end
end

function OpenPawnshopMenu2()
	local elements = {}
		elements = {
			{label = Config.Items.AlarmInterface.price.."$ - ".._U('alarminterface'),  value = Config.Items.AlarmInterface},
			{label = Config.Items.HammerWireCutter.price.."$ - ".._U('hammerwirecutter'), value = Config.Items.HammerWireCutter}
		}
	if PlayerData.job.name ~= 'police' then
		table.insert(elements, {label = Config.Items.Jammer.price.."$ - ".._U('jammer'), value = Config.Items.Jammer})
		table.insert(elements, {label = Config.Items.UnlockingTool.price.."$ - ".._U('unlockingtool'), value = Config.Items.UnlockingTool})
	end
	if PlayerData.job.name == 'mechanic' then
		table.insert(elements, {label = Config.Items.Alarm1.price.."$ - ".._U('alarm1'), value = Config.Items.Alarm1})
		table.insert(elements, {label = Config.Items.Alarm2.price.."$ - ".._U('alarm2'), value = Config.Items.Alarm2})
		table.insert(elements, {label = Config.Items.Alarm3.price.."$ - ".._U('alarm3'), value = Config.Items.Alarm3})
	end
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'pawnshop2',
	{
		title    = _U('pawnshop_menu_title'),
		align    = 'left',
		elements = elements,
	}, function(data, menu)
		TriggerServerEvent('esx_ownedcarthief:buyitem', data.current.value)
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
			VehPrice           = math.floor(vehicle.price / Config.ResellPercentage * Config.RebuyPercentage)
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

function StartCarSteal(itemUsed, vehOwned, vehicleData, npcVeh)
	TriggerServerEvent('esx_ownedcarthief:itemused', itemUsed.name)
		callCops = math.random(1, itemUsed.warnCopsChance)
		if itemUsed.name == "hammerwirecutter" then
			TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_HAMMERING", 0, true)
			Citizen.Wait(5 * second)
			CarStealInProgress(itemUsed.warnCopsChance, itemUsed.sucessChance, npcVeh)
		else
			CarStealInProgress(itemUsed.warnCopsChance, itemUsed.sucessChance, npcVeh)
		end
end

function CarStealInProgress(warnCopsChance, sucessChance, npcVeh)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed, true)
	local succes = false
	timer = 30 * second
	vehUnlock, stoleCheck = false, true

	ShowTimer()
	TaskStartScenarioInPlace(playerPed, "prop_human_parking_meter", 0, true)
	CallCops(warnCopsChance, false, npcVeh)

	Citizen.CreateThread(function()
		while not vehUnlock and stoleCheck do
			Citizen.Wait(100)
			if timer <= 0 and not succes then
				local vehicle2 = ESX.Game.GetVehicleInDirection()
				succes = math.random(sucessChance, 101)
				if vehicle == vehicle2 then 
					if succes >= Config.SuccesChance then
						CallCops(warnCopsChance, true, npcVeh)
						SetVehicleDoorsLocked(vehicle, 1)
						SetVehicleDoorsLockedForAllPlayers(vehicle, false)
						vehUnlock, step1 = true, true
						if systemType >= 1 or math.random(1,101) <= 81 and npcVeh then
							SetVehicleAlarm(vehicle, true)
							StartVehicleAlarm(vehicle)
						end
						ESX.ShowNotification(_U('vehicle_unlocked'))
						ClearPedTasksImmediately(playerPed)
					else
						ESX.ShowNotification(_U('vehicle_notunlocked'))
						CallCops(warnCopsChance, false, npcVeh)
						timer = 30 * second
						ShowTimer()
						succes = false
					end
				end
			end
		end
	end)
end

function CallCops(warnCopsChance, unlocked, npcVeh)
	local playerPed = PlayerPedId()
	local percent = math.random(1, 100)
	if percent <= warnCopsChance or percent <= Config.CallCopsChance then
		local coords = GetEntityCoords(playerPed, true)
		
		if math.random(1,101) <= 81 and npcVeh or systemType >= 2 then
			SetVehicleAlarm(vehicle, true)
			StartVehicleAlarm(vehicle)
			alarm = true
			TriggerServerEvent('esx_ownedcarthief:callcops', coords.x, coords.y, coords.z)
		elseif math.random(1,101) <= 81 and npcVeh or systemType == 1 then
			SetVehicleAlarm(vehicle, true)
			StartVehicleAlarm(vehicle)
		end
		StartVehicleAlarm(vehicle)
		if not unlocked then
			Citizen.Wait(1 * second)
			TaskPlayAnim(playerPed, "gestures@m@standing@casual" ,"gesture_bring_it_on" ,8.0, -8.0, -1, 0, 0, false, false, false)
			Citizen.Wait(2.8 * second)
			TaskStartScenarioInPlace(playerPed, "prop_human_parking_meter", 0, true)
		end
	end
end

function ShowTimer()
	Citizen.CreateThread(function()
		while timer > 0 do
			Citizen.Wait(5)

			local raw_seconds = timer/1000
			local raw_minutes = raw_seconds/60
			local minutes = stringsplit(raw_minutes, ".")[1]
			local seconds = stringsplit(raw_seconds-(minutes*60), ".")[1]

			SetTextFont(7)
			SetTextProportional(0)
			SetTextScale(0.0, 0.5)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()

			local text = _U('please_wait', seconds)

			SetTextCentre(true)
			BeginTextCommandDisplayText("STRING")
			AddTextComponentSubstringPlayerName(text)
			EndTextCommandDisplayText(0.5, 0.8)

			timer = timer - 15
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
			if data.current.value == 'pawnshop_rebuy' then
				OpenPawnshopMenu3()
			elseif data.current.value == 'pawnshop_buyitem' then
				OpenPawnshopMenu2()
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
			if data.current.value == 'blackgarage_resell' then
				SellStolenCar()
			end
		end, function(data, menu)
			menu.close()
		 end)
	end
end
