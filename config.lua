Config = {}

-- GENERAL SETTING
Config.SuccesChance  = 60   --How many % of chance to unlock a car. (0-100)
Config.OnlyPlayerCar = true --Set false if you want to picklock work on npc car (true-false)
Config.Locale        = 'fr' --Set lang (fr-en-br)

-- POLICE
Config.PoliceNumberRequired = 0    --Set how many cops is need to try stole a car. (0-64)
Config.AlertPolice          = true --Turn to false if you don't want cops is called on car alarm start for player car. (true-false)
Config.CallCopsChance       = 60   --How many % of chance for the car alarm start AND call cops. (0-100)
Config.BlipTime             = 40   --Set how many time a blip keep flash on map. (1-200)

-- PAWNSHOP SETTING
Config.SellCarBlackMoney = false --Set this to true if you want player recive blackmoney instead of money (true-false)
Config.WaitTime          = 5     --Set how many time in minutes before another vehicle can be sell to the pawnshop (0-9999...)
Config.ExpireVehicle     = 7     --Set how many days the player have to buy back ther vehicle before all can buy it
Config.ResellPercentage  = 10    --Percent of original car price player get from selling car (1-100)
Config.RebuyPercentage   = 15    --Percent of original car price player need to buy back the car (1-100)
Config.NpcCarPrice       = 100   --Set the sell price for npc car (1-9999...)
Config.PawnShopBLJob     = {	 --Here you can add job can't sell car at PawnShop
	{ JobName  = "police", },
	{ JobName  = "mechanic", },	--new name of job esx_org/esx_mecahnicjob!
	{ JobName  = "ambulance", }
}

--ITEMS PRICES
Config.Prices = {
  {name = "hammerwirecutter", price = 100},
  {name = "unlockingtool",    price = 1000},
  {name = "jammer",           price = 10000},
  {name = "alarm1",           price = 10000},
  {name = "alarm2",           price = 20000},
  {name = "alarm3",           price = 30000},
  {name = "alarminterface",   price = 100}
}

--SHOPS ZONES
Config.Zones = {

  {
	Name  = "PawnShop",
	OnMap = true,		--if set true PawnShop will be show on map
    Pos   = {x = -1451.63, y = -382.51 , z = 38.36 },
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = 1
  },
  {
	Name  = "PawnShop",
	OnMap = true,		--if set true PawnShop will be show on map
    Pos   = {x = 1708.82, y = 3774.66 , z = 34.49 },
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = 1
  },
  {
	Name  = "PawnShop",
	OnMap = true,		--if set true PawnShop will be show on map
    Pos   = {x = -230.73, y = 6351.28 , z = 32.20 },
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = 1
  },
  {
	Name  = "BlackGarage",
	OnMap = false,		--if set true BlackGarage will be show on map
    Pos   = {x = 1218.43, y = -3230.96 , z = 4.16 },
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = 1
  },
  {
	Name  = "BlackGarage",
	OnMap = false,		--if set true BlackGarage will be show on map
    Pos   = {x = 2352.38, y = 3133.29 , z = 47.71 },
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = 1
  }
}
