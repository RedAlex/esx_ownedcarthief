Config = {}

-- GENERAL SETTING
Config.SuccesChance  = 60   --How many % of chance to unlock a car. 0-100
Config.OnlyPlayerCar = true --Set false if you want to picklock work on npc car
Config.Locale        = 'fr'

-- POLICE
Config.PoliceNumberRequired = 0    --Set how many cops is need to try stole a car. 0-32
Config.AlertPolice          = true --Turn to false if you don't want cops is called on car alarm start for player car.
Config.CallCopsChance       = 60   --How many % of chance for the car alarm start AND call cops. 0-100
Config.BlipTime             = 40   --Set how many time a blip keep flash on map.


--SHOPS ZONES
Config.Zones = {

  {
	Name  = "PawnShop",
    Pos   = {x = -1451.63, y = -382.51 , z = 38.36 },
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = 1
  },
  {
	Name  = "PawnShop",
    Pos   = {x = 1708.82, y = 3774.66 , z = 34.49 },
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = 1
  },
  {
	Name  = "PawnShop",
    Pos   = {x = -230.73, y = 6351.28 , z = 32.20 },
    Size  = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = 1
  }
}

--ITEMS PRICES
Config.Prices = {
  {name = "hammerwirecutter", price = 100,},
  {name = "unlockingtool",    price = 200,},
  {name = "jammer",           price = 300}
}