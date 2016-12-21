-- MySQL dump 10.13  Distrib 5.6.30, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: StarfleetDelta
-- ------------------------------------------------------
-- Server version	5.6.30-1-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Rank`
--

DROP TABLE IF EXISTS `Rank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Rank` (
  `RankID` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `rname` varchar(50) DEFAULT '0',
  `RankLogo` varchar(7) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '★',
  PRIMARY KEY (`RankID`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=latin1 COMMENT='Rank table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Rank`
--

LOCK TABLES `Rank` WRITE;
/*!40000 ALTER TABLE `Rank` DISABLE KEYS */;
INSERT INTO `Rank` VALUES (1,'Ensign','●'),(2,'Lt. Junior Grade (Lt. JG)','○●'),(3,'Lieutenant','●●'),(4,'Lt. Commander','○●●'),(5,'Commander','●●●'),(6,'Captain','●●●●'),(7,'Commodore','▪'),(8,'Rear Admiral','▪▪'),(9,'Vice Admiral','▪▪▪'),(10,'Admiral','▪▪▪▪'),(11,'Fleet Admiral','▪▪▪▪▪'),(12,'Super Fleet Admiral','⓯'),(13,'Civilian','═══════'),(15,'Cadet 1st Year','▍'),(16,'Cadet 2nd Year','▍▍'),(17,'Cadet 3rd Year','▍▍▍'),(18,'Cadet 4th Year','▍▍▍▍'),(19,'Chat Bot','【 ☎ 】');
/*!40000 ALTER TABLE `Rank` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Time Clock`
--

DROP TABLE IF EXISTS `Time Clock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Time Clock` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL COMMENT 'User ID from accounts table',
  `time_in` int(10) unsigned NOT NULL,
  `time_out` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COMMENT='Cross refrences clock times with AV UUIDs';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Titles`
--

DROP TABLE IF EXISTS `Titles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Titles` (
  `tid` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=latin1 COMMENT='Common Group Tags';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Titles`
--

LOCK TABLES `Titles` WRITE;
/*!40000 ALTER TABLE `Titles` DISABLE KEYS */;
INSERT INTO `Titles` VALUES (1,'Please IM I.T Staff for Title updates'),(2,'Executive Assistant to The Commander-In-Chief'),(3,'Information Technology Specialist'),(4,'Chief of Security'),(5,'Chief of Engineering'),(6,'Chief of Operations'),(7,'Operations Officer'),(8,'Diplomat in Training'),(9,'Head of UFGQ'),(10,'Information Service Technician'),(11,'Chief of Diplomacy'),(12,'Chief of Medical'),(13,'Academy Commandant'),(14,'Vice Commander UFGQ Committee'),(15,'Academy Instructor'),(17,'XO of Diplomacy'),(18,'Commander in Chief UFGQ Committee'),(20,'Academy Student'),(21,'XO of Engineering'),(22,'Communications Bot'),(23,'Discharged'),(24,'Alternate Profile'),(25,'Judge Advocate General'),(26,'Group Management Bot'),(27,'XO of JAG'),(28,'Chief of Science'),(29,'Security Officer');
/*!40000 ALTER TABLE `Titles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) DEFAULT NULL,
  `UUID` char(36) NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000',
  `DivID` tinyint(3) unsigned NOT NULL DEFAULT '10',
  `RankID` tinyint(3) unsigned NOT NULL DEFAULT '13',
  `TitleID` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `DisplayName` varchar(64) DEFAULT NULL,
  `email` varchar(120) NOT NULL,
  `password` char(106) DEFAULT NULL COMMENT '128 char long sha512 hash',
  `active` tinyint(4) NOT NULL DEFAULT '1' COMMENT '-1 inactive 0 cadet 1 active officer',
  `induction_date` date DEFAULT NULL,
  `dh` bit(1) NOT NULL DEFAULT b'0',
  `JoinDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'BUG: This field should be a Date however we will get ERROR 1607 Invalid value. Please Fix',
  `promotiondate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
  `db_privlage_level` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT 'Administration/viewing privlages',
  `cCode` varchar(32) DEFAULT NULL COMMENT 'Authentication codesr',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UniqUUID` (`UUID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `uname_uniq` (`username`),
  KEY `FK_accounts_divisions` (`DivID`),
  KEY `FK_accounts_Rank` (`RankID`),
  KEY `FK_accounts_Titles` (`TitleID`),
  CONSTRAINT `FK_accounts_Rank` FOREIGN KEY (`RankID`) REFERENCES `Rank` (`RankID`),
  CONSTRAINT `FK_accounts_Titles` FOREIGN KEY (`TitleID`) REFERENCES `Titles` (`tid`),
  CONSTRAINT `FK_accounts_divisions` FOREIGN KEY (`DivID`) REFERENCES `divisions` (`did`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=latin1 COMMENT='Profile information for Staff and Students of Starfleet Delta.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asset_types`
--

DROP TABLE IF EXISTS `asset_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `asset_types` (
  `atid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`atid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COMMENT='Asset Type Codes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asset_types`
--

LOCK TABLES `asset_types` WRITE;
/*!40000 ALTER TABLE `asset_types` DISABLE KEYS */;
INSERT INTO `asset_types` VALUES (1,'Texture'),(2,'Sound'),(3,'Animation');
/*!40000 ALTER TABLE `asset_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assets`
--

DROP TABLE IF EXISTS `assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assets` (
  `aid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(36) COMMENT 'Asset UUID nmber for inworld assets',
  `type` int(10) unsigned NOT NULL DEFAULT '1' COMMENT 'See Asset Type table for possible values',
  `name` varchar(50) NOT NULL COMMENT 'Human readable Name for asset',
  PRIMARY KEY (`aid`),
  UNIQUE KEY `Index 2` (`uuid`),
  KEY `FK_assets_asset_types` (`type`),
  CONSTRAINT `FK_assets_asset_types` FOREIGN KEY (`type`) REFERENCES `asset_types` (`atid`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1 COMMENT='Contains ASSet UUIDs for Sounds Animations and Images for the Starfleet Delta Classes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clue`
--

DROP TABLE IF EXISTS `clue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clue` (
  `index` int(11) NOT NULL,
  `uuid` char(36) NOT NULL,
  `examine` varchar(255) NOT NULL,
  `tricorder` varchar(255) NOT NULL,
  PRIMARY KEY (`index`),
  UNIQUE KEY `Index 2` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Clue table for Kodos and his tricorder';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clue`
--

LOCK TABLES `clue` WRITE;
/*!40000 ALTER TABLE `clue` DISABLE KEYS */;
/*!40000 ALTER TABLE `clue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `committee`
--

DROP TABLE IF EXISTS `committee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `committee` (
  `index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `aid` int(10) unsigned NOT NULL,
  PRIMARY KEY (`index`),
  UNIQUE KEY `FK_committee_accounts` (`aid`),
  CONSTRAINT `FK_committee_accounts` FOREIGN KEY (`aid`) REFERENCES `accounts` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1 COMMENT='List of all Starfleet Delta Committee members this table will be for class lookups. in the event a DH is offline a committee memeber can teach any class avalible';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courses` (
  `ClassID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `DivID` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Class Name` tinytext NOT NULL,
  `Class Description` longtext NOT NULL,
  `Required Score` int(11) NOT NULL DEFAULT '80',
  PRIMARY KEY (`ClassID`),
  UNIQUE KEY `ClassName` (`Class Name`(100)),
  KEY `Divisions` (`DivID`),
  CONSTRAINT `Divisions` FOREIGN KEY (`DivID`) REFERENCES `divisions` (`did`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=latin1 COMMENT='Starfleet Delta Acedemic Courses';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `curriculum`
--

DROP TABLE IF EXISTS `curriculum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `curriculum` (
  `index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `classID` int(10) unsigned NOT NULL DEFAULT '1',
  `asset_id` int(10) unsigned DEFAULT NULL,
  `lineNumber` int(10) unsigned NOT NULL DEFAULT '1',
  `displayText` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`index`),
  KEY `FK__assets` (`asset_id`),
  KEY `FK_curriculum_courses` (`classID`),
  CONSTRAINT `FK__assets` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`aid`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `FK_curriculum_courses` FOREIGN KEY (`classID`) REFERENCES `courses` (`ClassID`)
) ENGINE=InnoDB AUTO_INCREMENT=199 DEFAULT CHARSET=latin1 COMMENT='Curriculum for all of Starfleet Delta Classes.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `divisions`
--

DROP TABLE IF EXISTS `divisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `divisions` (
  `did` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `dname` varchar(50) NOT NULL DEFAULT '0',
  `colorX` int(10) unsigned NOT NULL DEFAULT '255',
  `colorY` int(10) unsigned NOT NULL DEFAULT '255',
  `ColorZ` int(10) unsigned NOT NULL DEFAULT '255',
  PRIMARY KEY (`did`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1 COMMENT='List of Starfleet Delta Divisions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `divisions`
--

LOCK TABLES `divisions` WRITE;
/*!40000 ALTER TABLE `divisions` DISABLE KEYS */;
INSERT INTO `divisions` VALUES (1,'Academy Staff',212,0,255),(2,'Command',255,0,0),(3,'Diplomacy',255,0,0),(4,'Engineering',255,255,0),(5,'Operations',0,0,0),(6,'Science',0,29,255),(7,'Security',203,208,242),(8,'Academy Student',0,255,0),(9,'Medical',0,0,255),(10,'Civilian',255,255,255),(11,'Department of Temporal Investigations',0,50,0),(12,'Information Technology Department',0,180,180),(13,'JAG',255,255,255),(14,'Screwing Around ',255,255,255);
/*!40000 ALTER TABLE `divisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gradebook`
--

DROP TABLE IF EXISTS `gradebook`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gradebook` (
  `entryIndex` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `StudentID` int(10) unsigned NOT NULL,
  `CourseID` int(10) unsigned NOT NULL,
  `Grade` int(10) unsigned NOT NULL,
  PRIMARY KEY (`entryIndex`),
  KEY `FK_gradebook_accounts` (`StudentID`),
  KEY `FK_gradebook_class_test` (`CourseID`),
  CONSTRAINT `FK_gradebook_accounts` FOREIGN KEY (`StudentID`) REFERENCES `accounts` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `FK_gradebook_courses` FOREIGN KEY (`CourseID`) REFERENCES `courses` (`ClassID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=latin1 COMMENT='Holds all the grades for each class in Starfleet Delta';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `pid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `version` float unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`pid`),
  UNIQUE KEY `pname` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='Product information for all of Starfleet Delta';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Titler',3.1);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `versions`
--

DROP TABLE IF EXISTS `versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `versions` (
  `vid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ProdID` int(10) unsigned NOT NULL DEFAULT '0',
  `AccountID` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`vid`),
  KEY `FK_versions_products` (`ProdID`),
  KEY `FK_versions_accounts` (`AccountID`),
  CONSTRAINT `FK_versions_accounts` FOREIGN KEY (`AccountID`) REFERENCES `accounts` (`ID`),
  CONSTRAINT `FK_versions_products` FOREIGN KEY (`ProdID`) REFERENCES `products` (`pid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT='Tracks accounts and product version information for the update system';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `virtual_domains`
--

DROP TABLE IF EXISTS `virtual_domains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `virtual_domains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `virtual_domains`
--

LOCK TABLES `virtual_domains` WRITE;
/*!40000 ALTER TABLE `virtual_domains` DISABLE KEYS */;
INSERT INTO `virtual_domains` VALUES (1,'starfleetdelta.com');
/*!40000 ALTER TABLE `virtual_domains` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-12-05 10:38:56
