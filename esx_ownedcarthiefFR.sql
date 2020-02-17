USE `essentialmode`;

ALTER TABLE `owned_vehicles` ADD `security` int(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system level' AFTER `owner`;
ALTER TABLE `owned_vehicles` ADD `alarmactive` int(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system state' AFTER `security`;

CREATE TABLE `pawnshop_vehicles` (
	`owner` varchar(30) DEFAULT NULL,
	`security` int(1) NOT NULL DEFAULT '0' COMMENT 'Alarm system state',
	`plate` varchar(12) NOT NULL,
	`vehicle` longtext,
	`price` int(15) NOT NULL,
	`expiration` int(15) NOT NULL,

	PRIMARY KEY (`plate`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `items` (name, label, weight) VALUES
	('hammerwirecutter', 'Marteau & coupe fil', 1),
	('unlockingtool', 'Outils de cambriolage (Illégal)', 1),
	('jammer', 'Brouilleur de Signal (Illégal)', 1),
	('alarminterface', "Interface de système d'alarm", 1),
	('alarm1', "système d'alarme de base avec haut-parleur", 1),
	('alarm2', "module de liaison avec les urgences", 1),
	('alarm3', "module de positionnement continu GPS", 1)
;
