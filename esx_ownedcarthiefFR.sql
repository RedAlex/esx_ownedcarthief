USE `essentialmode`;

ALTER TABLE `owned_vehicles` ADD `security` int(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system state' AFTER `owner`;

CREATE TABLE `pawnshop_vehicles` (
	`owner` varchar(30) DEFAULT NULL,
	`security` int(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system state',
	`plate` varchar(12) NOT NULL,
	`vehicle` longtext,
	`price` int(15) NOT NULL,
	`expiration` int(15) NOT NULL,

	PRIMARY KEY (`plate`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `items` (name, label, `limit`) VALUES
	('hammerwirecutter', 'Marteau & coupe fil', 1),
	('unlockingtool', 'Outils de cambriolage (Illégal)', 1),
	('jammer', 'Brouilleur de Signal (Illégal)', 1),
	('alarminterface', "Interface de système d'alarm", 1),
	('alarm1', "système d'alarm de base", 1),
	('alarm2', "système d'alarm relier a la central", 1),
	('alarm3', "système d'alarm high tech avec GPS", 1)
;
