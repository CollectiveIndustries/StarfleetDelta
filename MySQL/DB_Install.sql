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
  `DivID` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `RankID` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `TitleID` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `username` varchar(64) DEFAULT NULL,
  `DisplayName` varchar(64) DEFAULT NULL,
  `password` char(128) DEFAULT NULL COMMENT '128 char long sha512 hash',
  `active` tinyint(4) NOT NULL DEFAULT '1' COMMENT '-1 inactive 0 cadet 1 active officer',
  `induction_date` date DEFAULT NULL,
  `dh` bit(1) NOT NULL DEFAULT b'0',
  `JoinDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `promotiondate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DOB` date NOT NULL,
  `birth_place` varchar(64) NOT NULL,
  `height_metric` tinyint(3) unsigned NOT NULL,
  `weight_metric` tinyint(3) unsigned NOT NULL,
  `hair_color` varchar(3) NOT NULL,
  `species` varchar(10) NOT NULL,
  `gender` varchar(50) NOT NULL DEFAULT '1',
  `ethnic_origin` varchar(64) DEFAULT '1',
  `nationality` varchar(64) DEFAULT '1',
  `ident_marks` varchar(64) DEFAULT '1',
  `db_privlage_level` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT 'Administration/viewing privlages',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UniqUUID` (`UUID`),
  UNIQUE KEY `uname_uniq` (`username`),
  KEY `FK_accounts_divisions` (`DivID`),
  KEY `FK_accounts_Rank` (`RankID`),
  KEY `FK_accounts_Titles` (`TitleID`),
  CONSTRAINT `FK_accounts_Rank` FOREIGN KEY (`RankID`) REFERENCES `Rank` (`RankID`),
  CONSTRAINT `FK_accounts_Titles` FOREIGN KEY (`TitleID`) REFERENCES `Titles` (`tid`),
  CONSTRAINT `FK_accounts_divisions` FOREIGN KEY (`DivID`) REFERENCES `divisions` (`did`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1 COMMENT='Profile information for Staff and Students of UFGQ.';

-- Dumping structure for table ufgq.divisions
DROP TABLE IF EXISTS `divisions`;
CREATE TABLE IF NOT EXISTS `divisions` (
  `did` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `dname` varchar(50) NOT NULL DEFAULT '0',
  `colorX` int(10) unsigned NOT NULL DEFAULT '255',
  `colorY` int(10) unsigned NOT NULL DEFAULT '255',
  `ColorZ` int(10) unsigned NOT NULL DEFAULT '255',
  PRIMARY KEY (`did`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

-- Dumping data for table ufgq.divisions: ~7 rows (approximately)
DELETE FROM `divisions`;
/*!40000 ALTER TABLE `divisions` DISABLE KEYS */;
INSERT INTO `divisions` (`did`, `dname`, `colorX`, `colorY`, `ColorZ`) VALUES
	(1, 'Academy', 212, 0, 255),
	(2, 'Command', 255, 0, 0),
	(3, 'Diplomacy', 255, 0, 0),
	(4, 'Engineering', 255, 255, 0),
	(5, 'Operations', 0, 0, 0),
	(6, 'Science', 0, 29, 255),
	(7, 'Security', 203, 208, 242);
/*!40000 ALTER TABLE `divisions` ENABLE KEYS */;

-- Dumping structure for table ufgq.Rank
DROP TABLE IF EXISTS `Rank`;
CREATE TABLE IF NOT EXISTS `Rank` (
  `RankID` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `rname` varchar(50) DEFAULT '0',
  PRIMARY KEY (`RankID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1 COMMENT='Rank table';

-- Dumping data for table ufgq.Rank: ~12 rows (approximately)
DELETE FROM `Rank`;
/*!40000 ALTER TABLE `Rank` DISABLE KEYS */;
INSERT INTO `Rank` (`RankID`, `rname`) VALUES
	(1, 'Ensign'),
	(2, 'Lt. Junior Grade (Lt. JG)'),
	(3, 'Lieutenant'),
	(4, 'Lt. Commander'),
	(5, 'Commander'),
	(6, 'Captain'),
	(7, 'Commodore'),
	(8, 'Rear Admiral'),
	(9, 'Vice Admiral'),
	(10, 'Admiral'),
	(11, 'Fleet Admiral'),
	(12, 'Super Duper Fleet Admiral'),
	(13, 'Civilian');
/*!40000 ALTER TABLE `Rank` ENABLE KEYS */;

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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1 COMMENT='Cross refrences clock times with AV UUIDs';

-- Dumping structure for table ufgq.Titles
DROP TABLE IF EXISTS `Titles`;
CREATE TABLE IF NOT EXISTS `Titles` (
  `tid` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1 COMMENT='Common Group Tags';

-- Dumping data for table ufgq.Titles: ~10 rows (approximately)
DELETE FROM `Titles`;
/*!40000 ALTER TABLE `Titles` DISABLE KEYS */;
INSERT INTO `Titles` (`tid`, `tag_name`) VALUES
	(1, 'OOC Observer'),
	(2, 'Executive Assistant to The Commander-In-Chief'),
	(3, 'Information Technology Specialist'),
	(4, 'Chief of Security'),
	(5, 'Chief of Engineering'),
	(6, 'Chief of Operations'),
	(7, 'Operations Officer'),
	(8, 'Diplomat in Training'),
	(9, 'Rank 15'),
	(10, 'Information Service technician'),
	(11, 'Chief of Diplomacy');
/*!40000 ALTER TABLE `Titles` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
