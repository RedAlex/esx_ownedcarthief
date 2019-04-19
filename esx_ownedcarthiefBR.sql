USE `essentialmode`;

ALTER TABLE `owned_vehicles` ADD `security` int(1) NOT NULL DEFAULT '0' COMMENT 'status sistema de alarme' AFTER `owner`;

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
	('hammerwirecutter', 'Kit para arrombamento basico', 1),
	('unlockingtool', 'Kit para arrombamento sofisticado (Ilegal)', 1),
	('jammer', 'Bloqueador de sinal (Ilegal)', 1),
	('alarminterface', "Interface do sistema de alarme", 1),
	('alarm1', 'Alarme basico', 1),
	('alarm2', 'Alarme com GPS barato', 1),
	('alarm3', 'Alarme com GPS premium', 1)
;
