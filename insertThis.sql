
CREATE TABLE IF NOT EXISTS `roda_blips` (
  `identifier` varchar(250) DEFAULT NULL,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `z` float DEFAULT NULL,
  `name` varchar(250) DEFAULT NULL,
  `sprite` int(11) DEFAULT NULL,
  `color` int(11) DEFAULT NULL,
  `blipid` int(11) NOT NULL AUTO_INCREMENT,
  `universal` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`blipid`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;
