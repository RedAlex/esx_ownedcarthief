ALTER TABLE `owned_vehicles` ADD `security` int(1) NOT NULL DEFAULT '0' COMMENT 'status sistema de alarme' AFTER `owner`;

INSERT INTO `items` (name, label, `limit`) VALUES
	('hammerwirecutter', 'Kit para arrombamento basico', 1),
	('unlockingtool', 'Kit para arrombamento sofisticado', 1),
	('jammer', 'Bloqueador de sinal', 1),
	('alarm1', 'Alarme basico', 1),
	('alarm2', 'Alarme com GPS barato', 1),
	('alarm3', 'Alarme com GPS premium', 1)
;