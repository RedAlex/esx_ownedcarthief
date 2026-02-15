-- ============================================
-- FICHIER DE DÉFINITION DES ITEMS POUR OX_INVENTORY
-- ============================================
-- Ce fichier doit être ajouté dans ox_inventory/data/items.lua
-- ou utilisé comme référence pour créer les items manuellement
-- ============================================

return {
	['hammerwirecutter'] = {
		label = 'Hammer & wire cutter',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Basic tool for breaking into vehicles. High chance to trigger alarms.',
		client = {
			image = 'hammerwirecutter.png',
		}
	},

	['unlockingtool'] = {
		label = 'Burglary tools (Illegal)',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Advanced burglary tools. Better success rate with lower alarm trigger chance.',
		client = {
			image = 'unlockingtool.png',
		}
	},

	['jammer'] = {
		label = 'Signal jammer (Illegal)',
		weight = 500,
		stack = true,
		close = true,
		description = 'Cuts signal transmission to prevent alarm systems from calling police.',
		client = {
			image = 'jammer.png',
		}
	},

	['alarminterface'] = {
		label = 'Alarm system interface',
		weight = 200,
		stack = true,
		close = true,
		description = 'Interface for managing vehicle alarm systems. Used by police and mechanics.',
		client = {
			image = 'alarminterface.png',
		}
	},

	['alarm1'] = {
		label = 'Basic alarm system',
		weight = 1500,
		stack = true,
		close = true,
		description = 'Basic alarm system with loudspeaker. Emits audible alarm when triggered.',
		client = {
			image = 'alarm1.png',
		}
	},

	['alarm2'] = {
		label = 'Emergency liaison module',
		weight = 2000,
		stack = true,
		close = true,
		description = 'Advanced alarm that notifies police and sends vehicle position when triggered.',
		client = {
			image = 'alarm2.png',
		}
	},

	['alarm3'] = {
		label = 'GPS continuous positioning module',
		weight = 2500,
		stack = true,
		close = true,
		description = 'High-tech GPS alarm system with real-time tracking for police.',
		client = {
			image = 'alarm3.png',
		}
	},
}
