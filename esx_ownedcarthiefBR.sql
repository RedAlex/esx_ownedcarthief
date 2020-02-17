USE `essentialmode`;

ALTER TABLE `owned_vehicles` ADD `security` int(1) NOT NULL DEFAULT '0' COMMENT 'Alarme no nível do sistema' AFTER `owner`;
ALTER TABLE `owned_vehicles` ADD `alarmactive` int(1) NOT NULL DEFAULT '0' COMMENT 'Status sistema de alarme' AFTER `security`;

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
	('hammerwirecutter', 'Kit para arrombamento basico', 1),
	('unlockingtool', 'Kit para arrombamento sofisticado (Ilegal)', 1),
	('jammer', 'Bloqueador de sinal (Ilegal)', 1),
	('alarminterface', "Interface do sistema de alarme", 1),
	('alarm1', "sistema básico de alarme com alto-falante", 1),
	('alarm2', "módulo de ligação de emergência", 1),
	('alarm3', "módulo de posicionamento contínuo GPS", 1)
;
