ALTER TABLE `owned_vehicles` ADD `security` int(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system state' AFTER `owner`;

INSERT INTO `items` (name, label, `limit`) VALUES
	('hammerwirecutter', 'Marteau & coupe fil', 1),
	('unlockingtool', 'Outils de cambriolage', 1),
	('jammer', 'Brouilleur de Signal', 1),
	('alarm1', "System d'alarm de base", 1),
	('alarm2', "System d'alarm relier a la central", 1),
	('alarm3', "System d'alarm high tech avec GPS", 1)
;