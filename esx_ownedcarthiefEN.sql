ALTER TABLE `owned_vehicles` ADD `security` int(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system state' AFTER `owner`;

INSERT INTO `items` (name, label, `limit`) VALUES
	('hammerwirecutter', 'Hammer & wire cutter', 1),
	('unlockingtool', 'Burglary tools', 1),
	('jammer', 'Signal jammer', 1),
	('alarm1', 'Basic alarm system', 1),
	('alarm2', 'System of alarm to connect to the central', 1),
	('alarm3', 'High tech alarm system with GPS', 1)
;