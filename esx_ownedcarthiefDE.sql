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
	('hammerwirecutter', 'Hammer- und Drahtschneider', 1),
	('unlockingtool', 'Einbruchswerkzeuge (Illegal)', 1),
	('jammer', 'Signalstörer (illegal)', 1),
	('alarminterface', "Schnittstelle für Alarmsysteme", 1),
	('alarm1', 'Alarmsystem Basic', 1),
	('alarm2', 'Zentralüberwachtes Alarmsystem', 1),
	('alarm3', 'High-Tech-Alarmsystem mit GPS-Ortung', 1)
;
