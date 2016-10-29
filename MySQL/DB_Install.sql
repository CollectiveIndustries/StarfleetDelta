-- --------------------------------------------------------
-- Host:                         192.168.1.186
-- Server version:               5.6.30-1 - (Debian)
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             9.3.0.5112
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for ufgq
DROP DATABASE IF EXISTS `ufgq`;
CREATE DATABASE IF NOT EXISTS `ufgq` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `ufgq`;

-- Dumping structure for table ufgq.accounts
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE IF NOT EXISTS `accounts` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UUID` char(36) NOT NULL,
  `username` varchar(64) DEFAULT NULL,
  `DisplayName` varchar(64) DEFAULT NULL,
  `password` char(128) DEFAULT NULL COMMENT '128 char long sha512 hash',
  `active` tinyint(4) NOT NULL DEFAULT '1' COMMENT '-1 inactive 0 cadet 1 active officer',
  `induction_date` date DEFAULT NULL,
  `rank` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `division` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `dh` bit(1) NOT NULL DEFAULT b'0',
  `JoinDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `promotiondate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DOB` date NOT NULL,
  `birth_place` varchar(64) NOT NULL,
  `height_metric` tinyint(3) unsigned NOT NULL,
  `weight_metric` tinyint(3) unsigned NOT NULL,
  `hair_color` varchar(3) NOT NULL,
  `species` varchar(3) NOT NULL,
  `gender` bit(1) NOT NULL DEFAULT b'1',
  `ethnic_origin` varchar(64) DEFAULT '1',
  `nationality` varchar(64) DEFAULT '1',
  `ident_marks` varchar(64) DEFAULT '1',
  `db_privlage_level` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT 'Administration/viewing privlages',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UniqUUID` (`UUID`),
  UNIQUE KEY `uname_uniq` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1 COMMENT='Profile information for Staff and Students of UFGQ.';

-- Data exporting was unselected.
-- Dumping structure for table ufgq.Time Clock
DROP TABLE IF EXISTS `Time Clock`;
CREATE TABLE IF NOT EXISTS `Time Clock` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL COMMENT 'User ID from accounts table',
  `time_in` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `time_out` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1 COMMENT='Cross refrences clock times with AV UUIDs';

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
