Config = Config or {}

-- SHOPS ZONES
Config.Zones = {
	Shops = {
		PawnShop = {
			Name  = "pawnshop_menu_title",
			OnMap = true,		-- if set true PawnShop will be show on map
			Pos = {
				vector3(-1451.63, -382.51, 37.34),
				vector3(1708.82, 3774.66, 34.49),
				vector3(-230.73, 6351.28, 32.20)
				},
			Size = 1.5,
			Color = 26,
			Sprite = 52
		},
		BlackGarage = {
			Name  = "black_menu_title",
			OnMap = false,		-- if set true BlackGarage will be show on map
			Pos = {
				vector3(1218.43, -3230.96, 4.16),
				vector3(2352.38, 3133.29, 47.71)
				},
			Size  = 1.5,
			Color = 40,
			Sprite  = 229
		}
	}
}
