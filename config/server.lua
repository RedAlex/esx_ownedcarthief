Config = Config or {}

-- GENERAL SETTING
Config.SuccesChance  = 60   -- How many % of chance to unlock a car. (0-100)
Config.OnlyPlayerCar = true -- Set false if you want to picklock work on npc car (true-false)

-- POLICE
Config.PoliceNumberRequired = 0    -- Set how many cops is need to try stole a car. (0-64)
Config.AlertPolice          = true -- Turn to false if you don't want cops is called on car alarm start for player car. (true-false)
Config.CallCopsChance       = 60   -- How many % of chance for the car alarm start AND call cops. (0-100)
Config.BlipTime             = 40   -- Set how many time a blip keep flash on map. (1-200)

-- PAWNSHOP SETTING
Config.SellCarBlackMoney = false -- Set this to true if you want player recive blackmoney instead of money (true-false)
Config.WaitTime          = 15    -- Set how many time in minutes before another vehicle can be sell to the pawnshop (0-9999...)
Config.ExpireVehicle     = 7     -- Set how many days the player have to buy back ther vehicle before all can buy it
Config.ResellPercentage  = 10    -- Percent of original car price player get from selling car (1-100)
Config.RebuyPercentage   = 15    -- Percent of original car price player need to buy back the car (1-100)
Config.NpcCarPrice       = 100   -- Set the sell price for npc car (1-9999...)
Config.PawnShopBLJob     = {	 -- Here you can add job can't sell car at PawnShop
	{ JobName  = "police", },
	{ JobName  = "mechanic", },
	{ JobName  = "ambulance", }
}

-- ITEMS PRICES
Config.Items = {
  HammerWireCutter = {name = "hammerwirecutter", price = 100},
  UnlockingTool = {name = "unlockingtool", price = 1000},
  Jammer = {name = "jammer", price = 10000},
  Alarm1 = {name = "alarm1", price = 10000},
  Alarm2 = {name = "alarm2", price = 20000},
  Alarm3 = {name = "alarm3", price = 30000},
  AlarmInterface = {name = "alarminterface", price = 100}
}
