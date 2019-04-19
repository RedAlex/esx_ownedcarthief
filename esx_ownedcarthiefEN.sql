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
	('hammerwirecutter', 'Hammer & wire cutter', 1),
	('unlockingtool', 'Burglary tools (Illegal)', 1),
	('jammer', 'Signal jammer (Illegal)', 1),
	('alarminterface', "Alarm system interface", 1),
	('alarm1', 'Basic alarm system', 1),
	('alarm2', 'System of alarm to connect to the central', 1),
	('alarm3', 'High tech alarm system with GPS', 1)
;
