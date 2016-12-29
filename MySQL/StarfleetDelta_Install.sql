-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               10.0.28-MariaDB-2 - Debian unstable
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             9.4.0.5131
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for StarfleetDelta
DROP DATABASE IF EXISTS `StarfleetDelta`;
CREATE DATABASE IF NOT EXISTS `StarfleetDelta` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `StarfleetDelta`;

-- Dumping structure for table StarfleetDelta.accounts
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE IF NOT EXISTS `accounts` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) DEFAULT NULL,
  `UUID` char(36) NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000',
  `DivID` tinyint(3) unsigned NOT NULL DEFAULT '10',
  `RankID` tinyint(3) unsigned NOT NULL DEFAULT '13',
  `TitleID` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `DisplayName` varchar(64) DEFAULT NULL,
  `email` varchar(120) NOT NULL,
  `password` char(106) DEFAULT NULL COMMENT '128 char long sha512 hash',
  `active` tinyint(4) NOT NULL DEFAULT '1' COMMENT '0 inactive 1 active',
  `induction_date` date DEFAULT NULL,
  `dh` bit(1) NOT NULL DEFAULT b'0',
  `JoinDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'BUG: This field should be a Date however we will get ERROR 1607 Invalid value. Please Fix',
--  `promotiondate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `DOB` date NOT NULL DEFAULT '1990-01-07',
  `birth_place` varchar(64) NOT NULL DEFAULT 'Some Where',
  `height_metric` tinyint(3) unsigned NOT NULL DEFAULT '6',
  `weight_metric` tinyint(3) unsigned NOT NULL DEFAULT '6',
  `hair_color` varchar(3) NOT NULL DEFAULT 'blk',
  `species` varchar(10) NOT NULL DEFAULT 'Human',
  `gender` varchar(50) NOT NULL DEFAULT '1',
  `ethnic_origin` varchar(64) DEFAULT '1',
  `nationality` varchar(64) DEFAULT '1',
  `ident_marks` varchar(64) DEFAULT '1',
  `db_privlage_level` tinyint(3) unsigned NOT NULL DEFAULT '255' COMMENT 'Administration/viewing privlages',
  `cCode` varchar(32) DEFAULT NULL COMMENT 'Authentication codes',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UniqUUID` (`UUID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `uname_uniq` (`username`),
  KEY `FK_accounts_divisions` (`DivID`),
  KEY `FK_accounts_Rank` (`RankID`),
  KEY `FK_accounts_Titles` (`TitleID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Profile information for Staff and Students of StarfleetDelta.';

-- Dumping data for table StarfleetDelta.accounts: 0 rows
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;

-- Dumping structure for table StarfleetDelta.assets
DROP TABLE IF EXISTS `assets`;
CREATE TABLE IF NOT EXISTS `assets` (
  `aid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(36) DEFAULT NULL COMMENT 'Asset UUID number for inworld assets',
  `type` int(10) unsigned NOT NULL DEFAULT '1' COMMENT 'See Asset Type table for possible values',
  `name` varchar(50) NOT NULL COMMENT 'Human readable Name for asset',
  PRIMARY KEY (`aid`),
  UNIQUE KEY `Index 2` (`uuid`),
  KEY `FK_assets_asset_types` (`type`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Contains Asset UUIDs for Sounds and Images for the StarfleetDelta Classes';

-- Dumping data for table StarfleetDelta.assets: 0 rows
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
/*!40000 ALTER TABLE `assets` ENABLE KEYS */;

-- Dumping structure for table StarfleetDelta.asset_types
DROP TABLE IF EXISTS `asset_types`;
CREATE TABLE IF NOT EXISTS `asset_types` (
  `atid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`atid`),
  UNIQUE KEY `Index 2` (`type`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT='Asset Type Codes';

-- Dumping data for table StarfleetDelta.asset_types: 2 rows
/*!40000 ALTER TABLE `asset_types` DISABLE KEYS */;
INSERT INTO `asset_types` (`atid`, `type`) VALUES
	(2, 'Sound'),
	(1, 'Texture');
/*!40000 ALTER TABLE `asset_types` ENABLE KEYS */;

-- Dumping structure for function StarfleetDelta.ClockUpdate
DROP FUNCTION IF EXISTS `ClockUpdate`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `ClockUpdate`(
	`ACCOUNT_UUID` CHAR(36)











) RETURNS text CHARSET latin1
    DETERMINISTIC
BEGIN

DECLARE AccountID, ClockID INT(10);
SET ClockID = 0;
SET AccountID = 0;

SELECT a.ID INTO AccountID FROM accounts a WHERE a.UUID = ACCOUNT_UUID;
SELECT t.`id` INTO ClockID FROM `Time Clock` t WHERE t.`user_id` = AccountID ORDER BY t.`id` DESC LIMIT 1;

IF FOUND_ROWS( ) > 0
THEN
	IF ( SELECT t.`Time_Out` FROM `Time Clock` t WHERE t.`id` = ClockID )
	IS NULL
	THEN
		UPDATE `Time Clock` t SET t.`time_out` = UNIX_TIMESTAMP() WHERE t.`id` = ClockID;
		RETURN 'User Clocked Out';
	ELSE
		INSERT INTO `Time Clock` (`time_in`, `user_id`) VALUES (UNIX_TIMESTAMP(), AccountID);
		RETURN 'User Clocked In';
	END IF;
ELSE
	INSERT INTO `Time Clock` (`time_in`, `user_id`) VALUES (UNIX_TIMESTAMP(), AccountID);
	RETURN 'New Account Created';
END IF;

END//
DELIMITER ;

-- Dumping structure for table StarfleetDelta.committee
DROP TABLE IF EXISTS `committee`;
CREATE TABLE IF NOT EXISTS `committee` (
  `index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `aid` int(10) unsigned NOT NULL,
  PRIMARY KEY (`index`),
  UNIQUE KEY `FK_committee_accounts` (`aid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='List of all StarfleetDelta Committee members this table will be for class lookups. In the event a DH is offline a committee memeber can teach any class avalible';

-- Dumping data for table StarfleetDelta.committee: 0 rows
/*!40000 ALTER TABLE `committee` DISABLE KEYS */;
/*!40000 ALTER TABLE `committee` ENABLE KEYS */;

-- Dumping structure for table StarfleetDelta.Comms
DROP TABLE IF EXISTS `Comms`;
CREATE TABLE IF NOT EXISTS `Comms` (
  `comid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `accountid` int(10) unsigned NOT NULL,
  `ObjectUUID` char(36) NOT NULL,
  `url` varchar(255) NOT NULL,
  PRIMARY KEY (`comid`),
  UNIQUE KEY `Index 3` (`ObjectUUID`),
  UNIQUE KEY `Index 4` (`url`),
  KEY `FK_Comms_accounts` (`accountid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table StarfleetDelta.Comms: 0 rows
/*!40000 ALTER TABLE `Comms` DISABLE KEYS */;
/*!40000 ALTER TABLE `Comms` ENABLE KEYS */;

-- Dumping structure for procedure StarfleetDelta.CourseLine
DROP PROCEDURE IF EXISTS `CourseLine`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `CourseLine`(
	IN `CourseID` INT
,
	IN `LineNumber` INT
)
BEGIN

	SELECT IFNULL(c.`displayText`, CONCAT('ASSET|',CONCAT(aa.`type`,CONCAT(':',a.`uuid`)))) as `line`
	FROM `curriculum` c
		LEFT JOIN assets a
			ON  c.`asset_id` = a.`aid`
		LEFT JOIN asset_types aa
			ON a.`type`=aa.`atid`
		WHERE c.`classID` = CourseID AND c.lineNumber = LineNumber;

END//
DELIMITER ;

-- Dumping structure for table StarfleetDelta.courses
DROP TABLE IF EXISTS `courses`;
CREATE TABLE IF NOT EXISTS `courses` (
  `ClassID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DivID` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `AutherID` int(10) unsigned NOT NULL,
  `Class Name` tinytext NOT NULL,
  `Class Description` longtext NOT NULL,
  `Required Score` int(11) NOT NULL DEFAULT '80',
  PRIMARY KEY (`ClassID`),
  UNIQUE KEY `ClassName` (`Class Name`(100)),
  KEY `Divisions` (`DivID`),
  KEY `FK_courses_accounts` (`AutherID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='UFGQ Acedemic Courses';

-- Dumping data for table StarfleetDelta.courses: 0 rows
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;

-- Dumping structure for table StarfleetDelta.curriculum
DROP TABLE IF EXISTS `curriculum`;
CREATE TABLE IF NOT EXISTS `curriculum` (
  `index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `classID` int(10) unsigned NOT NULL DEFAULT '1',
  `asset_id` int(10) unsigned DEFAULT NULL,
  `lineNumber` int(10) unsigned NOT NULL DEFAULT '1',
  `displayText` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`index`),
  UNIQUE KEY `Line` (`asset_id`,`displayText`,`lineNumber`),
  KEY `FK_curriculum_courses` (`classID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Curriculum for all of UFGQ Classes.';

-- Dumping data for table StarfleetDelta.curriculum: 0 rows
/*!40000 ALTER TABLE `curriculum` DISABLE KEYS */;
/*!40000 ALTER TABLE `curriculum` ENABLE KEYS */;

-- Dumping structure for table StarfleetDelta.divisions
DROP TABLE IF EXISTS `divisions`;
CREATE TABLE IF NOT EXISTS `divisions` (
  `did` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `dname` varchar(50) NOT NULL DEFAULT '0',
  `alias` varchar(50) DEFAULT NULL,
  `FileNamePrefix` char(3) DEFAULT NULL,
  `colorX` int(10) unsigned NOT NULL DEFAULT '255',
  `colorY` int(10) unsigned NOT NULL DEFAULT '255',
  `ColorZ` int(10) unsigned NOT NULL DEFAULT '255',
  PRIMARY KEY (`did`),
  UNIQUE KEY `Index 3` (`dname`),
  UNIQUE KEY `Index 2` (`alias`),
  UNIQUE KEY `File name Prefix` (`FileNamePrefix`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=latin1 COMMENT='List of UFGQ Divisions';

-- Dumping data for table StarfleetDelta.divisions: 15 rows
/*!40000 ALTER TABLE `divisions` DISABLE KEYS */;
INSERT INTO `divisions` (`did`, `dname`, `alias`, `FileNamePrefix`, `colorX`, `colorY`, `ColorZ`) VALUES
	(1, 'Academy Staff', 'acdemy', 'ACM', 212, 0, 255),
	(2, 'Command', NULL, 'CMD', 255, 0, 0),
	(3, 'Diplomacy', NULL, 'DIP', 255, 0, 0),
	(4, 'Engineering', NULL, 'ENG', 255, 255, 0),
	(5, 'Operations', NULL, 'OPS', 0, 0, 0),
	(6, 'Science', NULL, 'SCI', 0, 29, 255),
	(7, 'Security', NULL, 'SEC', 203, 208, 242),
	(8, 'Academy Student', 'student', 'ACD', 0, 255, 0),
	(9, 'Medical', NULL, 'MED', 0, 0, 255),
	(10, 'Civilian', NULL, NULL, 255, 255, 255),
	(11, 'Department of Temporal Investigations', 'temporal', 'TMP', 0, 50, 0),
	(12, 'Information Technology Department', 'it', 'ITD', 0, 180, 180),
	(13, 'JAG', 'jag', 'JAG', 255, 255, 255),
	(14, 'Comms', NULL, 'COM', 255, 165, 0),
	(16, 'Contributors', NULL, NULL, 255, 255, 255);
/*!40000 ALTER TABLE `divisions` ENABLE KEYS */;

-- Dumping structure for table StarfleetDelta.exams
DROP TABLE IF EXISTS `exams`;
CREATE TABLE IF NOT EXISTS `exams` (
  `eid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(10) unsigned NOT NULL DEFAULT '0',
  `question_number` int(10) unsigned NOT NULL DEFAULT '1',
  `question` varchar(255) NOT NULL,
  `a` varchar(255) NOT NULL,
  `b` varchar(255) NOT NULL,
  `c` varchar(255) NOT NULL,
  `d` varchar(255) NOT NULL,
  `answer` char(1) NOT NULL,
  PRIMARY KEY (`eid`),
  UNIQUE KEY `Index 3` (`question_number`,`question`),
  KEY `FK__courses` (`course_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table StarfleetDelta.exams: 0 rows
/*!40000 ALTER TABLE `exams` DISABLE KEYS */;
/*!40000 ALTER TABLE `exams` ENABLE KEYS */;

-- Dumping structure for table StarfleetDelta.gradebook
DROP TABLE IF EXISTS `gradebook`;
CREATE TABLE IF NOT EXISTS `gradebook` (
  `entryIndex` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `StudentID` int(10) unsigned NOT NULL,
  `CourseID` int(10) unsigned NOT NULL,
  `Grade` int(10) unsigned NOT NULL,
  PRIMARY KEY (`entryIndex`),
  KEY `FK_gradebook_accounts` (`StudentID`),
  KEY `FK_gradebook_class_test` (`CourseID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Holds all the grades for each class in StarfleetDelta';

-- Dumping data for table StarfleetDelta.gradebook: 0 rows
/*!40000 ALTER TABLE `gradebook` DISABLE KEYS */;
/*!40000 ALTER TABLE `gradebook` ENABLE KEYS */;

-- Dumping structure for view StarfleetDelta.grades
DROP VIEW IF EXISTS `grades`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `grades` (
	`Name` VARCHAR(64) NULL COLLATE 'latin1_swedish_ci',
	`Class Name` TINYTEXT NOT NULL COLLATE 'latin1_swedish_ci',
	`Grade` INT(10) UNSIGNED NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for table StarfleetDelta.products
DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `pid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `version` float unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`pid`),
  UNIQUE KEY `pname` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='Product information for all of StarfleetDelta';

-- Dumping data for table StarfleetDelta.products: 0 rows
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
/*!40000 ALTER TABLE `products` ENABLE KEYS */;

-- Dumping structure for table StarfleetDelta.Rank
DROP TABLE IF EXISTS `Rank`;
CREATE TABLE IF NOT EXISTS `Rank` (
  `RankID` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `rname` varchar(50) DEFAULT '0',
  `RankLogo` varchar(7) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '★',
  PRIMARY KEY (`RankID`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=latin1 COMMENT='Rank table';

-- Dumping data for table StarfleetDelta.Rank: 18 rows
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
	(14, 'Cadet 1st Year', '▍'),
	(15, 'Cadet 2nd Year', '▍▍'),
	(16, 'Cadet 3rd Year', '▍▍▍'),
	(17, 'Cadet 4th Year', '▍▍▍▍'),
	(18, 'Chat Bot', '【 ☎ 】');
/*!40000 ALTER TABLE `Rank` ENABLE KEYS */;

-- Dumping structure for view StarfleetDelta.RankName
DROP VIEW IF EXISTS `RankName`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `RankName` (
	`RankLogo` VARCHAR(7) NOT NULL COLLATE 'utf8_unicode_ci',
	`rname` VARCHAR(50) NULL COLLATE 'latin1_swedish_ci',
	`name` VARCHAR(64) NULL COLLATE 'latin1_swedish_ci',
	`tag_name` VARCHAR(50) NULL COLLATE 'latin1_swedish_ci',
	`active` TINYINT(4) NOT NULL COMMENT '-1 inactive 0 cadet 1 active officer',
	`dname` VARCHAR(50) NOT NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;

-- Dumping structure for table StarfleetDelta.scores
DROP TABLE IF EXISTS `scores`;
CREATE TABLE IF NOT EXISTS `scores` (
  `sid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `StudentID` int(10) unsigned NOT NULL,
  `QuestionID` int(10) unsigned NOT NULL,
  `answer` char(1) NOT NULL,
  PRIMARY KEY (`sid`),
  UNIQUE KEY `Index 4` (`StudentID`,`QuestionID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Holds scoring information for taken exams';

-- Dumping data for table StarfleetDelta.scores: 0 rows
/*!40000 ALTER TABLE `scores` DISABLE KEYS */;
/*!40000 ALTER TABLE `scores` ENABLE KEYS */;

-- Dumping structure for table StarfleetDelta.Time_Clock
DROP TABLE IF EXISTS `Time_Clock`;
CREATE TABLE IF NOT EXISTS `Time_Clock` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL COMMENT 'User ID from accounts table',
  `time_in` int(10) unsigned NOT NULL,
  `time_out` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Cross refrences clock times with AV UUIDs';

-- Dumping data for table StarfleetDelta.Time_Clock: 0 rows
/*!40000 ALTER TABLE `Time_Clock` DISABLE KEYS */;
/*!40000 ALTER TABLE `Time_Clock` ENABLE KEYS */;

-- Dumping structure for table StarfleetDelta.Titles
DROP TABLE IF EXISTS `Titles`;
CREATE TABLE IF NOT EXISTS `Titles` (
  `tid` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=latin1 COMMENT='Common Group Tags';

-- Dumping data for table StarfleetDelta.Titles: 30 rows
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
	(9, 'Head of SDQ'),
	(10, 'Information Service Technician'),
	(11, 'Chief of Diplomacy'),
	(12, 'Chief of Medical'),
	(13, 'Academy Commandant'),
	(14, 'Vice Commander SDQ Committee'),
	(15, 'Academy Instructor'),
	(16, 'XO of Security'),
	(17, 'XO of Diplomacy'),
	(18, 'Commander in Chief SDQ Committee'),
	(20, 'Academy Student'),
	(21, 'XO of Engineering'),
	(22, 'Communications Bot'),
	(23, 'Discharged'),
	(24, 'Alternate Profile'),
	(25, 'Judge Advocate General'),
	(26, 'Group Management Bot'),
	(27, 'XO of JAG'),
	(28, 'Chief of Science'),
	(29, 'Security Officer'),
	(30, 'Beta Tester'),
	(31, 'Academic Contributor');
/*!40000 ALTER TABLE `Titles` ENABLE KEYS */;

-- Dumping structure for procedure StarfleetDelta.UpdateCommLink
DROP PROCEDURE IF EXISTS `UpdateCommLink`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateCommLink`(
	IN `OwnerUUID` CHAR(36),
	IN `ObjectUUID` CHAR(36)
,
	IN `URL` VARCHAR(255)
)
    DETERMINISTIC
BEGIN

	DECLARE AccountID INT(10);

	SELECT a.`ID` INTO AccountID FROM `accounts` a WHERE a.`UUID` = OwnerUUID;
	REPLACE INTO `Comms` (`accountid`, `url`, `ObjectUUID`) VALUES (AccountID, URL, ObjectUUID);

END//
DELIMITER ;

-- Dumping structure for table StarfleetDelta.versions
DROP TABLE IF EXISTS `versions`;
CREATE TABLE IF NOT EXISTS `versions` (
  `vid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ProdID` int(10) unsigned NOT NULL DEFAULT '0',
  `AccountID` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`vid`),
  KEY `FK_versions_products` (`ProdID`),
  KEY `FK_versions_accounts` (`AccountID`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT='Tracks accounts and product version information for the update system';

-- Dumping data for table StarfleetDelta.versions: 0 rows
/*!40000 ALTER TABLE `versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `versions` ENABLE KEYS */;

-- Dumping structure for view StarfleetDelta.grades
DROP VIEW IF EXISTS `grades`;
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `grades`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `grades` AS select ifnull(`a`.`DisplayName`,`a`.`username`) AS `Name`,`c`.`Class Name` AS `Class Name`,`g`.`Grade` AS `Grade` from (((`accounts` `a` join `gradebook` `g` on((`g`.`StudentID` = `a`.`ID`))) join `courses` `c` on((`c`.`ClassID` = `g`.`CourseID`))) join `divisions` `d` on((`c`.`DivID` = `d`.`did`))) order by `a`.`ID`;

-- Dumping structure for view StarfleetDelta.RankName
DROP VIEW IF EXISTS `RankName`;
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `RankName`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `RankName` AS select `r`.`RankLogo` AS `RankLogo`,`r`.`rname` AS `rname`,ifnull(`a`.`DisplayName`,`a`.`username`) AS `name`,`t`.`tag_name` AS `tag_name`,`a`.`active` AS `active`,`d`.`dname` AS `dname` from (((`accounts` `a` join `divisions` `d` on((`a`.`DivID` = `d`.`did`))) join `Rank` `r` on((`a`.`RankID` = `r`.`RankID`))) join `Titles` `t` on((`a`.`TitleID` = `t`.`tid`)));

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
