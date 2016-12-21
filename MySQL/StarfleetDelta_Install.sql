-- --------------------------------------------------------
-- Host:                         192.168.1.140
-- Server version:               5.7.16-0ubuntu0.16.04.1 - (Ubuntu)
-- Server OS:                    Linux
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
  `JoinDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'BUG: This field should be a Date however we will get ERROR 1607 Invalid value. Please Fix',
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Profile information for Staff and Students of UFGQ.';

-- Dumping data for table ufgq.accounts: ~0 rows (approximately)
DELETE FROM `accounts`;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;

-- Dumping structure for table ufgq.courses
DROP TABLE IF EXISTS `courses`;
CREATE TABLE IF NOT EXISTS `courses` (
  `ClassID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DivID` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Class Name` tinytext NOT NULL,
  `Class Description` longtext NOT NULL,
  `Required Score` int(11) NOT NULL DEFAULT '80',
  PRIMARY KEY (`ClassID`),
  UNIQUE KEY `ClassName` (`Class Name`(100)),
  KEY `Divisions` (`DivID`),
  CONSTRAINT `Divisions` FOREIGN KEY (`DivID`) REFERENCES `divisions` (`did`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=latin1 COMMENT='UFGQ Acedemic Courses';

-- Dumping data for table ufgq.courses: ~66 rows (approximately)
DELETE FROM `courses`;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` (`ClassID`, `DivID`, `Class Name`, `Class Description`, `Required Score`) VALUES
	(1, 8, 'ACD-100', 'Intro to UFGQ', 80),
	(2, 8, 'ACD-101', 'Regulations and Protocals', 80),
	(3, 8, 'BRP-100', 'Bridge RP Evaluation', 80),
	(4, 8, 'ACD-102', 'UFGQ History', 80),
	(5, 8, 'ACD-104', 'Bridge Stations Overview', 80),
	(6, 8, 'STR-100', 'Transfer Request', 100),
	(7, 8, 'BRP-200', 'Bridge Role Play 2', 80),
	(8, 8, 'ACD-103', 'Gama Quadrant', 80),
	(9, 8, 'BRP-300', 'Bridge Role Play 3', 80),
	(10, 8, 'DIV-100', 'Division Introduction', 80),
	(11, 8, 'DIV-101', 'Meeting with Department Head', 100),
	(12, 8, 'ACD-105', 'Meeting with the Commendant', 100),
	(13, 8, 'REC-100', 'Medical Records', 100),
	(14, 8, 'REC-101', 'Service Records', 100),
	(16, 8, 'ELE-100', 'Elective Class', 80),
	(17, 8, 'PRJ-100', 'Senior Project', 80),
	(18, 1, 'ACM-100', 'Intro to UFGQ Academy', 80),
	(19, 1, 'ACM-101', 'Instructor Training', 80),
	(20, 1, 'ACM-102', 'Ships Named Enterprise', 80),
	(21, 1, 'ACM-103', 'Civilian Etiquette', 80),
	(22, 2, 'CMD-100', 'Intro to UFGQ Leadership', 80),
	(23, 2, 'CMD-101', 'Interpersonal Communications', 80),
	(24, 3, 'DIP-100', 'Intro to UFGQ Diplomacy', 80),
	(25, 3, 'DIP-101', 'Intro to Bajor', 80),
	(26, 3, 'DIP-102', 'Intro to Caitians', 80),
	(27, 3, 'DIP-104', 'Romulan Star Empire', 80),
	(28, 3, 'DIP-105', 'Intro to the Borg', 80),
	(29, 3, 'DIP-106', 'Intro to Klingon', 80),
	(30, 3, 'DIP-107', 'Intro to Tril', 80),
	(31, 3, 'DIP-108', 'Intro to Andorians', 80),
	(32, 3, 'DIP-109', 'The UFP Protocol for First Contact', 80),
	(33, 3, 'DIP-110', 'The Mauqis', 80),
	(34, 4, 'ENG-100', 'Intro to Engineering', 80),
	(35, 4, 'ENG-101', 'History and Science of Warp Drive', 80),
	(36, 4, 'ENG-102', 'The Impulse Drive System', 80),
	(37, 4, 'ENG-103', 'Warp Drive Basics', 80),
	(38, 4, 'ENG-L01', 'Introduction Building Lab', 80),
	(39, 13, 'JAG-100', 'Intro to JAG', 80),
	(40, 13, 'JAG-101', 'Intro to IG', 80),
	(41, 13, 'JAG-102', 'Prime Directive', 80),
	(42, 13, 'JAG-201', 'Federation Charter', 80),
	(43, 13, 'JAG-202', 'UFGQ Charter', 80),
	(44, 13, 'JAG-203', 'General Orders', 80),
	(45, 9, 'MED-100', 'History of Nursing', 80),
	(47, 9, 'MED-101', 'Famous Doctors of Starfleet', 80),
	(48, 9, 'MED-103', 'Intro to Xenobiology', 80),
	(49, 9, 'MED-200', 'Medical Ethics', 80),
	(50, 9, 'MED-201', 'Anatomy', 80),
	(51, 9, 'MED-202', 'Psychology', 80),
	(52, 9, 'MED-L01', 'Medical Tools Lab', 80),
	(53, 5, 'OPS-100', 'Intro to Operations', 80),
	(54, 5, 'OPS-101', 'Basic Flight', 80),
	(55, 5, 'OPS-102', 'Intro to Flight Ops', 80),
	(56, 5, 'OPS-103', 'Personal Shuttle Basics Training', 80),
	(57, 5, 'OPS-104', 'Bridge Stations - Ops Officers', 80),
	(58, 6, 'SCI-100', 'Intro to Science', 80),
	(59, 6, 'SCI-101', 'Chemistry', 80),
	(60, 6, 'SCI-102', 'Temporal Mechanics', 80),
	(61, 6, 'SCI-103', 'Physics', 80),
	(62, 6, 'SCI-201', 'Science Divison', 80),
	(63, 7, 'SEC-100', 'Intro to Security', 80),
	(64, 7, 'SEC-101', 'Hazard Team Pt. 1 - History', 80),
	(65, 7, 'SEC-102', 'Hazard Team Pt. 2 - Weapons', 80),
	(66, 7, 'SEC-103', 'Hazard Team Pt. 3 - Alien Species', 80),
	(67, 7, 'Sec-104', 'Starship Combat', 80),
	(68, 7, 'SEC-201', 'Sim Security', 80);
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;

-- Dumping structure for table ufgq.divisions
DROP TABLE IF EXISTS `divisions`;
CREATE TABLE IF NOT EXISTS `divisions` (
  `did` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `dname` varchar(50) NOT NULL DEFAULT '0',
  `colorX` int(10) unsigned NOT NULL DEFAULT '255',
  `colorY` int(10) unsigned NOT NULL DEFAULT '255',
  `ColorZ` int(10) unsigned NOT NULL DEFAULT '255',
  PRIMARY KEY (`did`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

-- Dumping data for table ufgq.divisions: ~13 rows (approximately)
DELETE FROM `divisions`;
/*!40000 ALTER TABLE `divisions` DISABLE KEYS */;
INSERT INTO `divisions` (`did`, `dname`, `colorX`, `colorY`, `ColorZ`) VALUES
	(1, 'Academy Staff', 212, 0, 255),
	(2, 'Command', 255, 0, 0),
	(3, 'Diplomacy', 255, 0, 0),
	(4, 'Engineering', 255, 255, 0),
	(5, 'Operations', 0, 0, 0),
	(6, 'Science', 0, 29, 255),
	(7, 'Security', 203, 208, 242),
	(8, 'Student', 0, 255, 0),
	(9, 'Medical', 0, 0, 255),
	(10, 'Civilian', 255, 255, 255),
	(11, 'Department of Temporal Investigations', 0, 50, 0),
	(12, 'Information Technology Department', 0, 180, 180),
	(13, 'JAG', 255, 255, 255);
/*!40000 ALTER TABLE `divisions` ENABLE KEYS */;

-- Dumping structure for table ufgq.gradebook
DROP TABLE IF EXISTS `gradebook`;
CREATE TABLE IF NOT EXISTS `gradebook` (
  `entryIndex` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `StudentID` int(10) unsigned NOT NULL,
  `CourseID` int(10) unsigned NOT NULL,
  `Grade` int(10) unsigned NOT NULL,
  PRIMARY KEY (`entryIndex`),
  KEY `FK_gradebook_accounts` (`StudentID`),
  KEY `FK_gradebook_class_test` (`CourseID`),
  CONSTRAINT `FK_gradebook_accounts` FOREIGN KEY (`StudentID`) REFERENCES `accounts` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `FK_gradebook_courses` FOREIGN KEY (`CourseID`) REFERENCES `courses` (`ClassID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Holds all the grades for each class in UFGQ';

-- Dumping data for table ufgq.gradebook: ~0 rows (approximately)
DELETE FROM `gradebook`;
/*!40000 ALTER TABLE `gradebook` DISABLE KEYS */;
/*!40000 ALTER TABLE `gradebook` ENABLE KEYS */;

-- Dumping structure for table ufgq.Rank
DROP TABLE IF EXISTS `Rank`;
CREATE TABLE IF NOT EXISTS `Rank` (
  `RankID` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `rname` varchar(50) DEFAULT '0',
  `RankLogo` varchar(7) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '★',
  PRIMARY KEY (`RankID`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1 COMMENT='Rank table';

-- Dumping data for table ufgq.Rank: ~18 rows (approximately)
DELETE FROM `Rank`;
/*!40000 ALTER TABLE `Rank` DISABLE KEYS */;
INSERT INTO `Rank` (`RankID`, `rname`, `RankLogo`) VALUES
	(1, 'Ensign', '●'),
	(2, 'Lt. Junior Grade (Lt. JG)', '○●'),
	(3, 'Lieutenant', '●●'),
	(4, 'Lt. Commander', '○●●'),
	(5, 'Commander', '●●●'),
	(6, 'Captain', '●●●●'),
	(7, 'Commodore', '▪'),
	(8, 'Rear Admiral', '▪▪'),
	(9, 'Vice Admiral', '▪▪▪'),
	(10, 'Admiral', '▪▪▪▪'),
	(11, 'Fleet Admiral', '▪▪▪▪▪'),
	(12, 'Super Fleet Admiral', '⓯'),
	(13, 'Civilian', '═══════'),
	(15, 'Cadet 1st Year', '▍'),
	(16, 'Cadet 2nd Year', '▍▍'),
	(17, 'Cadet 3rd Year', '▍▍▍'),
	(18, 'Cadet 4th Year', '▍▍▍▍'),
	(19, 'Chat Bot', '【 ☎ 】');
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cross refrences clock times with AV UUIDs';

-- Dumping data for table ufgq.Time Clock: ~0 rows (approximately)
DELETE FROM `Time Clock`;
/*!40000 ALTER TABLE `Time Clock` DISABLE KEYS */;
/*!40000 ALTER TABLE `Time Clock` ENABLE KEYS */;

-- Dumping structure for table ufgq.Titles
DROP TABLE IF EXISTS `Titles`;
CREATE TABLE IF NOT EXISTS `Titles` (
  `tid` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1 COMMENT='Common Group Tags';

-- Dumping data for table ufgq.Titles: ~20 rows (approximately)
DELETE FROM `Titles`;
/*!40000 ALTER TABLE `Titles` DISABLE KEYS */;
INSERT INTO `Titles` (`tid`, `tag_name`) VALUES
	(1, 'Please IM I.T Staff for Title updates'),
	(2, 'Executive Assistant to The Commander-In-Chief'),
	(3, 'Information Technology Specialist'),
	(4, 'Chief of Security'),
	(5, 'Chief of Engineering'),
	(6, 'Chief of Operations'),
	(7, 'Operations Officer'),
	(8, 'Diplomat in Training'),
	(9, 'Head of UFGQ'),
	(10, 'Information Service Technician'),
	(11, 'Chief of Diplomacy'),
	(12, 'Chief of Medical'),
	(13, 'Academy Commandant'),
	(14, ' '),
	(15, 'Academy Instructor'),
	(17, 'XO of Diplomacy'),
	(18, 'Comittee Member'),
	(20, 'Academy Student'),
	(21, 'XO of Engineering'),
	(22, 'Comunications Bot');
/*!40000 ALTER TABLE `Titles` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
