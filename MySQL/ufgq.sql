-- MySQL dump 10.13  Distrib 5.6.30, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ufgq
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
-- Dumping data for table `Time Clock`
--

LOCK TABLES `Time Clock` WRITE;
/*!40000 ALTER TABLE `Time Clock` DISABLE KEYS */;
INSERT INTO `Time Clock` VALUES (1,16,1480916627,1480917669),(2,16,1480917688,1480918115),(3,16,1480919165,1480919183),(4,16,1480919191,NULL),(5,2,1480921016,1480921029);
/*!40000 ALTER TABLE `Time Clock` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=latin1 COMMENT='Profile information for Staff and Students of UFGQ.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (2,'AdmiralMorketh Sorex','81c65d80-2e5c-42e2-b6f2-0e541368ca1a',12,6,3,'Morketh Sorex','AdmiralMorkethSorex@ufgq.co','$6$aa9b357b9ed2bdb4$zq4YU2zQlDBe.pxcXyhU9fRYBlT681sML5NjKvHMYPN4wIzW/1TIGrW4NU26ZyHaxXO5QmdtdneCzMNZfgCXp.',1,NULL,'','2016-10-27 06:00:00','2016-10-27 06:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,'123qwe'),(3,'maryannlin Resident','b57a87f9-bb4b-4871-8b35-f23e0ee2eed7',3,1,17,'Chibi Sorex','maryannlinResident@ufgq.co',NULL,1,'2016-10-29','\0','2016-10-27 06:00:00','2016-10-27 06:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,NULL),(4,'Evo Torrance','c3209b01-62f2-4097-ab11-6e371507ac8d',2,5,2,'Evo Torrance','EvoTorrance@ufgq.co','$6$ffba9970f988a304$cY7SDxLG5a4e3AvvYYOy5MAaCnlI75sfidoPcFRKRMZRf2bC4GHA91fOLILPaLNwj4Lp9YXVP6/9xSw.ZZZit.',1,'2009-10-21','\0','2016-10-28 06:00:00','2012-03-31 06:00:00','1989-12-19','Kamloops, BC, Canada',2,54,'Bro','Trill','1','1','1','1',3,NULL),(5,'Dyveke Biberman','819ce81a-78a2-41c0-910a-904225601571',5,3,7,'Dyv3ke','DyvekeBiberman@ufgq.co',NULL,1,NULL,'\0','2016-10-28 06:00:00','2016-10-28 06:00:00','0000-00-00','',0,0,'','','Female / Gynoid','Savannah Clans / Nanite Systems','1','Tawny and cream color markings on skin. Small square metallic bo',1,NULL),(6,'jayster Shinn','7c0fff81-73c3-420c-9cf6-e9ff7181aaa8',7,2,4,'Jayster Shinn','jaysterShinn@ufgq.co',NULL,1,NULL,'\0','2016-10-29 06:00:00','2016-10-29 06:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,NULL),(7,'Kodos Macarthur','d6110a36-8531-4831-a581-3715c8f4a1b2',4,6,5,NULL,'KodosMacarthur@ufgq.co','$6$690fa94d5dc3947f$7HntonQ/j6RDq9WlyHhJU/WvO9uDaeacwzUFxRdgynfMnXMnBQeLXlknzIxlwb.HzfPQ.4LifRPPxqTz0BlmS0',1,NULL,'','2016-10-30 06:00:00','2016-10-30 06:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,'A2Z123'),(8,'James Stark','83dea12f-f2f4-41df-8a6d-2a983f13968e',3,7,11,'James Stark','JamesStark@ufgq.co',NULL,1,NULL,'','2016-10-30 06:00:00','2016-10-30 06:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,NULL),(12,'Severene Resident','ecb06f5a-bd51-47aa-8c29-343fd5d4225f',8,15,20,'Severene Stonewall','SevereneResident@ufgq.co','$6$ce1b35c18261d0b8$qhwIA9UHUXZvHNmmfo1ldxWYJua77Cs4tyEzUPJZPdF3lAgoVAXeclsO/999J.e1tyD/yfSDP80P2JGN4N3Eo1',1,NULL,'\0','2016-10-30 06:00:00','2016-10-30 06:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,NULL),(15,'AdmiralScripts Alcove','d43322ce-0a69-4a9d-b914-e4e277e897b3',10,13,24,'Morketh Sorex','AdmiralScriptsAlcove@ufgq.co',NULL,1,NULL,'\0','2016-10-30 06:00:00','2016-10-30 06:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,NULL),(16,'Samuel Hornbridge','cd7a3c7a-d3b5-4cb2-a2f3-b2b25db140df',9,3,12,'Raven McQuiston','SamuelHornbridge@ufgq.co',NULL,1,NULL,'','2016-10-30 06:00:00','2016-10-30 06:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,'Raven11Alpha'),(17,'Data Spectre','ef4cae58-3736-4fe7-a9d0-245eebbce7b9',2,11,18,'Data Spectre','DataSpectre@ufgq.co',NULL,1,NULL,'\0','2016-10-30 06:00:00','2016-10-30 06:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,NULL),(18,'Renari Ishtari','b639164f-7649-4b68-947f-f78d24582a3b',1,5,13,'Renari Mitsuki','RenariIshtari@ufgq.co',NULL,1,NULL,'\0','2016-10-30 06:00:00','2016-10-30 06:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,NULL),(19,'pnthrpink1 Resident','17b68ed9-5b37-4261-aa41-ad87c1152fd6',2,11,18,'Lucine Dax','pnthrpink1Resident@ufgq.co',NULL,1,NULL,'','2016-10-30 06:00:00','2016-10-30 06:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,NULL),(20,'astrocat2016 Resident','a628547c-891e-4c75-a2c5-312c6552f60f',10,13,23,'astrocat2016 Resident','astrocat2016Resident@ufgq.co',NULL,0,NULL,'\0','2016-10-30 06:00:00','2016-10-30 06:00:00','0000-00-00','',0,0,'','','1','1','1','1',0,NULL),(21,'Cd Duffield','9509ca0e-de31-4155-b1a2-4e1cccfb098c',2,11,18,'Charlie Duffield','CdDuffield@ufgq.co',NULL,1,NULL,'\0','2016-10-31 06:00:00','2016-10-31 06:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,NULL),(22,'Amikuva Resident','e9fedc44-b869-4c89-80ed-d9288e59c4ab',8,15,20,'Amikuva','AmikuvaResident@ufgq.co',NULL,1,NULL,'\0','2016-10-31 06:00:00','2016-10-31 06:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,NULL),(23,'AresCheetah Resident','81b5743b-f55b-49a3-8381-b11031b5b221',8,16,20,'Violet Omega','AresCheetahResident@ufgq.co',NULL,1,NULL,'\0','2016-11-01 06:00:00','2016-11-01 06:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,NULL),(24,'Ant Demonia','b6960f27-245d-4e2e-b375-91f105ba67c7',4,6,21,'Demonia','AntDemonia@ufgq.co',NULL,1,NULL,'\0','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,NULL),(25,'ChatBot','988da074-b939-7e40-0f57-b2e7fde450c9',4,19,22,'Akira Kayosa','ChatBot@ufgq.co',NULL,1,NULL,'\0','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,NULL),(26,'Kinney Bellic','f5603618-8aa9-4e3e-b783-f95158972927',2,9,14,'Kent','KinneyBellic@ufgq.co',NULL,1,NULL,'\0','2016-11-06 01:15:22','0000-00-00 00:00:00','0000-00-00','',0,0,'','','1','1','1','1',1,NULL),(28,'ufgqbot Resident','b1aef1d5-db18-4bee-a957-8343b0e2c9ae',2,1,26,'Boothby','ufgqbotResident@ufgq.co',NULL,1,NULL,'\0','2016-11-17 03:49:21','2016-11-17 03:49:21','1990-01-07','Some Where',6,6,'blk','Human','1','1','1','1',1,NULL),(30,'Lianna Beaumont','143ea4af-98a4-4d6d-99b1-184d2ca489f3',13,7,25,'Gaia Scipiona-Tai','LiannaBeaumont@ufgq.co',NULL,1,NULL,'','2016-11-17 04:25:33','2016-11-17 04:25:33','1990-01-07','Some Where',6,6,'blk','Human','1','1','1','1',1,NULL),(31,'Leo Ravenheart','baafa723-c2ac-4947-a3a2-5d65880435ed',13,4,27,'Leo Ravenheart-Torres','LeoRavenheart@ufgq.co',NULL,1,NULL,'\0','2016-11-22 21:35:24','2016-11-22 21:35:24','1990-01-07','Some Where',6,6,'blk','Human','1','1','1','1',1,NULL),(32,'Evo Stormcrow','980157fb-bc36-49cb-87f4-0a6e1da2d841',10,13,1,NULL,'EvoStormcrow@ufgq.co',NULL,1,NULL,'\0','2016-11-24 02:02:08','2016-11-24 02:02:08','1990-01-07','Some Where',6,6,'blk','Human','1','1','1','1',1,NULL),(33,'silverfoxfollet Resident','d5a7c618-0f9b-4312-b14a-9083cbdf490e',6,2,28,'Silver Follet','silverfoxfolletResident@ufgq.co',NULL,1,NULL,'','2016-11-24 02:07:46','2016-11-24 02:07:46','1990-01-07','Some Where',6,6,'blk','Human','1','1','1','1',1,NULL),(34,'Admiral Morketh','14f066f7-8a5d-401e-9847-8377651815b5',12,6,3,'Morketh Collective Grid','AdmiralMorketh@ufgq.co',NULL,1,NULL,'\0','2016-11-24 20:44:27','2016-11-24 20:44:27','1990-01-07','Some Where',6,6,'blk','Human','1','1','1','1',1,'123qwe'),(36,'Angel1 Avon','18819661-e974-470a-969d-5b8876f1547c',7,4,29,'Angel Macarthur','Angel1Avon@ufgq.co',NULL,1,NULL,'\0','2016-12-04 19:02:07','2016-12-04 19:02:07','1990-01-07','Some Where',6,6,'blk','Human','1','1','1','1',1,NULL);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1 COMMENT='Contains ASSet UUIDs for Sounds Animations and Images for the UFGQ Classes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
INSERT INTO `assets` VALUES (1,'88eb59ea-f555-827e-35f8-e37368886c4c',2,'TEST'),(3,'581a69d3-37ea-3d17-766f-68cacafb8636',2,''),(4,'23ce93f6-5e92-9e63-4fc7-8cf3f27f9c35',1,''),(5,'dbf25465-c454-2c20-6bbd-ee68ffb09180',1,''),(6,'9a775dcc-98f8-7d91-f23e-4d558875d4fb',1,''),(7,'c4c8cbbb-0ae3-ec97-bd1c-3a348a7afdd7',1,''),(8,'0d3f67fb-3d81-2ebd-0754-b9c1ca7df739',1,''),(9,'65d7d002-6530-bf4e-4954-43959be9c78c',1,''),(10,'2c9c6e9c-1628-0218-6f63-cb1987828f8d',1,''),(11,'817027c0-462b-14c7-3c63-d373673e4796',1,''),(12,'0db0a0b0-92e8-ddd4-d369-0add3a98af78',1,''),(14,'4b03276c-0a83-8e0e-42df-9edd7473db6f',2,'DROID');
/*!40000 ALTER TABLE `assets` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1 COMMENT='List of all UFGQ Committee members this table will be for class lookups. in the event a DH is offline a committee memeber can teach any class avalible';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `committee`
--

LOCK TABLES `committee` WRITE;
/*!40000 ALTER TABLE `committee` DISABLE KEYS */;
INSERT INTO `committee` VALUES (9,4),(7,17),(5,19),(6,21);
/*!40000 ALTER TABLE `committee` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=latin1 COMMENT='UFGQ Acedemic Courses';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` VALUES (1,8,'ACD-100','Intro to UFGQ',80),(2,8,'ACD-101','Regulations and Protocals',80),(3,8,'BRP-100','Bridge RP Evaluation',80),(4,8,'ACD-102','UFGQ History',80),(5,8,'ACD-104','Bridge Stations Overview',80),(6,8,'REC-100','Transfer Request',100),(7,8,'BRP-200','Bridge Role Play 2',80),(8,8,'ACD-103','Gama Quadrant',80),(9,8,'BRP-300','Bridge Role Play 3',80),(10,8,'DIV-100','Division Introduction',80),(11,8,'DIV-101','Meeting with Department Head',100),(12,8,'ACD-105','Meeting with the Commendant',100),(13,8,'REC-101','Medical Records',100),(14,8,'REC-102','Service Records',100),(16,8,'ELE-100','Elective Class',80),(17,8,'PRJ-100','Senior Project',80),(18,1,'ACM-100','Intro to UFGQ Academy',80),(19,1,'ACM-101','Instructor Training',80),(20,1,'ACM-102','Ships Named Enterprise',80),(21,1,'ACM-103','Civilian Etiquette',80),(22,2,'CMD-100','Intro to UFGQ Leadership',80),(23,2,'CMD-101','Interpersonal Communications',80),(24,3,'DIP-100','Intro to UFGQ Diplomacy',80),(25,3,'DIP-101','Intro to Bajor',80),(26,3,'DIP-102','Intro to Caitians',80),(27,3,'DIP-104','Romulan Star Empire',80),(28,3,'DIP-105','Intro to the Borg',80),(29,3,'DIP-106','Intro to Klingon',80),(30,3,'DIP-107','Intro to Tril',80),(31,3,'DIP-108','Intro to Andorians',80),(32,3,'DIP-109','The UFP Protocol for First Contact',80),(33,3,'DIP-110','The Mauqis',80),(34,4,'ENG-100','Intro to Engineering',80),(35,4,'ENG-101','History and Science of Warp Drive',80),(36,4,'ENG-102','The Impulse Drive System',80),(37,4,'ENG-103','Warp Drive Basics',80),(38,4,'ENG-L01','Introduction Building Lab',80),(39,13,'JAG-100','Intro to JAG',80),(40,13,'JAG-101','Intro to IG',80),(41,13,'JAG-102','Prime Directive',80),(42,13,'JAG-201','Federation Charter',80),(43,13,'JAG-202','UFGQ Charter',80),(44,13,'JAG-203','General Orders',80),(45,9,'MED-101','History of Nursing',80),(47,9,'MED-102','Famous Doctors of Starfleet',80),(48,9,'MED-103','Intro to Xenobiology',80),(49,9,'MED-200','Medical Ethics',80),(50,9,'MED-201','Anatomy',80),(51,9,'MED-202','Psychology',80),(52,9,'MED-L01','Medical Tools Lab',80),(53,5,'OPS-100','Intro to Operations',80),(54,5,'OPS-101','Basic Flight',80),(55,5,'OPS-102','Intro to Flight Ops',80),(56,5,'OPS-103','Personal Shuttle Basics Training',80),(57,5,'OPS-104','Bridge Stations - Ops Officers',80),(58,6,'SCI-100','Intro to Science',80),(59,6,'SCI-101','Chemistry',80),(60,6,'SCI-102','Temporal Mechanics',80),(61,6,'SCI-103','Physics',80),(62,6,'SCI-201','Science Divison',80),(63,7,'SEC-100','Intro to Security',80),(64,7,'SEC-101','Hazard Team Pt. 1 - History',80),(65,7,'SEC-102','Hazard Team Pt. 2 - Weapons',80),(66,7,'SEC-103','Hazard Team Pt. 3 - Alien Species',80),(67,7,'SEC-104','Starship Combat',80),(68,7,'SEC-201','Sim Security',80),(69,9,'MED-100','Intro to UFGQ Medical',80),(70,3,'DIP-103','Introduction to Ferangi',80),(99,4,'ENG-999','Test Class',80);
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=199 DEFAULT CHARSET=latin1 COMMENT='Curriculum for all of UFGQ Classes.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curriculum`
--

LOCK TABLES `curriculum` WRITE;
/*!40000 ALTER TABLE `curriculum` DISABLE KEYS */;
INSERT INTO `curriculum` VALUES (1,1,NULL,1,'*Dims the lights and smiles at each cadet*'),(2,1,NULL,2,'<LIGHTS_OFF>'),(3,1,3,3,NULL),(5,1,NULL,4,'Greetings and welcome to the United Federation Gamma Quadrant Starfleet Academy!'),(6,1,NULL,6,'My name is <INSTRUCTOR_NAME> and I will be your instructor for today\'s class.'),(7,1,NULL,7,'Please hold all questions until the end of the lecture, at which time, I will be glad to answer any that you may have.'),(8,1,NULL,8,'There will be an exam at the conclusion of the lecture.'),(9,1,NULL,9,'You may use your class notes, but please refrain from any talking during the exam.'),(10,1,NULL,10,'If you have any questions at that time, please IM the instructor.'),(11,1,NULL,11,'Welcome to UFGQ Academy'),(12,1,NULL,12,'Our class today is ACD-100 / Introduction to UFGQ'),(13,1,NULL,13,'*Takes a deep breath and proceeds*'),(14,1,NULL,14,'The primary goal of this class is to explain what you need to know about the inner workings the United Federation of Planets: Gamma Quadrant -Starfleet (UFGQ) \r\nso that you can function as a contributing member of our group. \r\n'),(15,1,NULL,16,'UFGQ was founded and set up by Dayna Bedrosian, Horatio Easterwood, Xavier Tairov, Serenajoy Holder, Azrael Emmons, Yurei Kubo and Kayden Joles.'),(16,1,NULL,17,'All, at one point or another, were active members of other Star Trek groups here in SL who decided to venture out on our own and form UFGQ. '),(17,1,NULL,18,'UFGQ is made up of a group of people with a similar vision that was Roddenberry\'s dream... '),(18,1,NULL,19,'We strive to keep the dream alive, live it to the fullest and share it with the world. '),(19,1,NULL,20,'We are, in essence, a group that shares the passion of Star Trek,\r\nand to share that passion we meet in different metaverse locations such as Second Life to live out Gene Roddenberry\'s dream.  \r\n'),(20,1,NULL,21,'This group utilizes the technology and resources from the Star Trek universe in the 25th century, specifically the year 2416.'),(21,1,NULL,22,'UFGQ\'s goal is to strive to keep Roddenberry\'s dream alive here in SL.'),(22,1,NULL,23,'To that end, we see ourselves as the Federation presence in the Gamma Quadrant - exploring new worlds and making new friends. '),(23,1,NULL,24,'Smiles with pride, making eye contact with each person in the room*'),(24,1,NULL,26,'UFGQ is not only Starfleet, but also the Federation.'),(25,1,NULL,27,'We welcome all civilians into the Federation and offer many jobs that work in coordination with Starfleet.'),(26,1,NULL,28,'As we grow, we will look forward to new ideas for expanding our civilian roles within UFGQ.'),(27,1,NULL,29,'UFGQ: Starfleet has a chain of command that starts with Cadets reporting to the Academy Commandant'),(28,1,NULL,30,'The Officers report to their Division heads and the Division heads report to the Admirals. '),(29,1,NULL,31,'The Admirals make up the  United Federation Gamma Quadrant Committee.'),(30,1,NULL,32,'The group is as much yours as it is ours. '),(31,1,NULL,33,'You help shape and steer the direction of the group.'),(32,1,NULL,34,'Every member has a voice no matter what level you are.  '),(33,1,NULL,35,'Your voice and opinions are important to us. '),(34,1,NULL,36,'The first step in starting your journey with UFGQ is choosing if you want to join the civilian populous or join UFGQ: Starfleet.   	'),(35,1,NULL,37,'Both positions (civilian and Starfleet) are valuable to the success and happiness of our group.'),(36,1,NULL,38,'UFGQ: Starfleet Option'),(37,1,NULL,39,'Your first step towards becoming a Starfleet Officer is to take classes and graduate from our Academy.'),(38,1,NULL,40,'A list of required classes will be made available to you through your instructors and is posted in the academy lobby.'),(39,1,NULL,41,'You have 2 paths you may choose to become an officer.'),(40,1,NULL,42,'Path 1 is the Junior Officer program:  '),(41,1,NULL,43,'Once you have completed your time at the basic (4 week) Academy and have graduated, you will become a commissioned officer with the rank of Ensign.'),(42,1,NULL,44,'Path 2 is the Senior Officer program:'),(43,1,NULL,45,'Along this path you will complete the basic Academy and become a Graduate Student with the rank of Acting Ensign.'),(44,1,NULL,46,'You will then complete an additional (6 weeks) of classes and training, at the conclusion of which you will have earned a graduate degree and achieve rank of a full Lieutenant.'),(45,1,NULL,47,'UFGQ is run on a 24-hour clock, using SLT/PST as our standard local time. '),(46,1,NULL,48,'Stardates are laid out as follows:'),(47,1,NULL,49,'Y= Year M= Month D= Day T=Time. '),(48,1,NULL,50,'Dates should be written: YYMMDD.TT'),(49,1,NULL,51,'For example: November 24, 2016 at 7pm, would like written like this: 161124.19'),(50,1,NULL,52,'UFGQ Divisions:'),(51,1,NULL,53,'We have a variety of divisions for you to join. '),(52,1,NULL,54,'Once you have chosen your division, you will then have another decision to make.  '),(53,1,NULL,55,'You will have to decide if you wish to join a ship or be a part of Headquarters.'),(54,1,NULL,56,'Even if you are part of Headquarters, you will still be able to take part on a ship RP. '),(55,1,NULL,57,'Our division colors are out of the norm, which we feel is an advantage that\r\nwill separate UFGQ from other Star Trek groups. \r\n'),(56,1,NULL,58,'We take great pride in that. '),(57,1,NULL,59,'We feel that in order to grow and prosper you need to think outside of the box.'),(58,1,NULL,61,'Our Divisions are as follows:'),(59,1,NULL,62,'Academy: Violet'),(60,1,NULL,63,'Command: Red'),(61,1,NULL,64,'Engineering: Yellow'),(62,1,NULL,65,'Operations: Black'),(63,1,NULL,66,'Medical Science: Blue'),(64,1,NULL,67,'Security: Gray'),(65,1,NULL,68,'An Academy Cadet would wear green'),(66,1,NULL,69,'Some of you may ask about things like Diplomatic, Communications, JAG, along with other specialties.'),(67,1,NULL,70,'Those are all included under the divisions. As we expand we may find the need to split and make independent divisions.'),(68,1,NULL,71,'Officers should wear the color of the uniform that is coordinated with your division and rank in the group. '),(69,1,NULL,72,'You are also required to wear a tilter that will help identify your Rank and Division'),(70,1,NULL,73,'Your tilter should be the color of your Division.'),(71,1,NULL,74,'Then you will list your rank and department. '),(72,1,NULL,75,'For example: If you were an Ensign in Medical and part of Emergency Medicine, your tilter would be blue and red: Ensign | Emergency Medicine.'),(73,1,NULL,76,'You will also wear the correct Group Tag for your Division.'),(74,1,NULL,77,'By now, you should have picked up your uniform on the supply deck.'),(75,1,NULL,78,'Freshmen cadets wear green uniforms. '),(76,1,NULL,79,'You will be required to wear your green cadet uniform and equipment at all times while on the sim.'),(77,1,NULL,80,'For ceremonies and formal occasions such as weddings, promotion ceremonies and graduation ceremonies, you will be required to wear a Dress Uniform.'),(78,1,NULL,81,'We will always let you know beforehand which type of uniform to wear. '),(79,1,NULL,82,'All Academy cadets and Starfleet officers MUST be in correct uniform while on sim. '),(80,1,NULL,83,'As a Cadet you will be assigned to the Academy group.'),(81,1,NULL,84,'Upon Graduation you will then be added to the Main UFGQ group and the Divisional group you will be entering. '),(82,1,NULL,85,'You may be asked to join other groups as your duties expand.'),(83,1,NULL,86,'You can change divisions if you wish.'),(84,1,NULL,87,'To change to a different division, fill out a Divisional Transfer Form.'),(85,1,NULL,88,'Ask the Academy Commandant for this from.'),(86,1,NULL,89,'The time that you spend as a cadet with UFGQ Starfleet All cadets are expected to complete their initial Academy stay in a timely manner. '),(87,1,NULL,90,'The basic academy is based on a 4 week term, with each week being one year of scholastic achievement. '),(88,1,NULL,91,'Classes are to begin within the first week of being accepted into the academy and a maximum of 8 weeks will be allotted to complete them. '),(89,1,NULL,92,'A cadet IS NOT to take more than 2 classes per day or 6 per week, without pre approval from the admiralty.'),(90,1,NULL,93,'Any unapproved LOA more than 2 consecutive weeks could result in expulsion from the academy and will require you to start over should you choose to return                                                            '),(92,1,4,5,NULL),(93,1,5,15,NULL),(94,1,6,25,NULL),(95,1,7,60,NULL),(96,1,8,94,NULL),(97,1,NULL,95,'FIRST SEMESTER - FRESHMAN CADET'),(98,1,NULL,96,'Once your application has been processed you will go to the Supply Deck and pick up your Green Cadet Uniform, and Combadge..'),(99,1,NULL,97,'You will activate your Group Tag to indicate your Freshman Cadet status (your CO should set this up for you).'),(100,1,NULL,98,'Requirements:'),(101,1,NULL,99,'1. Introduce yourself to the group: Write a background history about yourself and take a cadet photo. This will be posted in the welcome center, so that the group can get to know you. This is mandatory and must be done within one week of joining the group'),(102,1,NULL,100,'2. Passed Intro to UFGQ'),(103,1,NULL,101,'3. Passed UFGQ Regulations & Protocols'),(104,1,NULL,102,'4. Passed History of UFGQ'),(105,1,NULL,103,'5. Bridge RP/Evaluation - Here your roleplay experience will be evaluated.'),(106,1,NULL,104,'6. Weekly Reporting - Every Friday, you will submit a report to the Academy Commandant. List all of the classes and RP’s you have attended. '),(107,1,NULL,105,'Also list any other activities you have participated in. '),(108,1,NULL,106,'Keep a copy of this report, you will add to it each week.'),(109,1,NULL,107,'A drop box is located on the Academy lobby.'),(110,1,NULL,108,'You can find a copy of the form in you Welcome to UFGQ: SF Academy folder or in the Academy lobby.'),(111,1,NULL,109,'You may send reports in early if you finish classes before Friday of a given week, but you will not be able to move on to the next level until the next  week.'),(112,1,9,110,NULL),(113,1,NULL,111,'SECOND SEMESTER - SOPHOMORE CADET'),(114,1,NULL,112,'After your CO has processed your Weekly Report and has determined that you are ready to move on to the next semester.  '),(115,1,NULL,113,'Congratulations you made it! The real fun is just about to begin!'),(116,1,NULL,114,'Requirements:'),(117,1,NULL,115,'1. Attended  a RP'),(118,1,NULL,116,'2. Passed Bridge Stations 101'),(119,1,NULL,117,'3. Passed Gamma Quadrant'),(120,1,NULL,118,'4. Take one alien species class from the diplomatic classes'),(121,1,NULL,119,'5. Filled out Cadet Transfer for Division of choice you can find the form in the Welcome to UFGQ: SF Academy folder or you can find a copy in the academy lobby.'),(122,1,NULL,120,'Send the Transfer Request to the academy Commandant promptly.'),(123,1,NULL,121,'6. Weekly Reporting - Again, this week, you will submit in your Weekly Report to the Academy Commandant Friday.  '),(124,1,NULL,122,'You will use the same report you turned in the previous week but you will add your activities for this week.'),(125,1,10,123,NULL),(126,1,NULL,124,'THIRD SEMESTER - JUNIOR CADET'),(127,1,NULL,125,'After your CO has processed your Weekly Report and has determined that you are ready to move on to the next semester.'),(128,1,NULL,126,'You are halfway through.'),(129,1,NULL,127,'Requirements:'),(130,1,NULL,128,'1. Take a second  alien species class from the diplomatic classes'),(131,1,NULL,129,'2. Take Intro to Division of choice.'),(132,1,NULL,130,'3. Additional class in your division'),(133,1,NULL,131,'4. Attended a RP'),(134,1,NULL,132,'5. Meet with the CO of the division you will be entering. You will discuss topics like what your duties will be in the division and possible ideas for your Sr. Project.'),(135,1,NULL,133,'6. Meet with the Academy Commandant to finalize what your Sr. Project will be.\r\nIt is a good idea at this point to visit the Division you have chosen and get to know some of the Officers working there.\r\n'),(136,1,NULL,134,'7. Again, this week, you will send in your Weekly Report to the Academy Commandant Friday.  You will use the same report you turned in the previous weeks but you will add your activities for this week.'),(137,1,11,135,NULL),(138,1,NULL,136,'FOURTH SEMESTER - SENIOR CADET'),(139,1,NULL,137,'The Sr officer program will be study at your own pace.'),(140,1,NULL,138,'The officer must complete additional 20 activities, these may include:'),(141,1,NULL,139,'Taking classes (must take at least 10 additional classes)'),(142,1,NULL,140,'Writing classes for the academy.'),(143,1,NULL,141,'Building something for the group.'),(144,1,NULL,142,'You will not have to submit a report every week but you must keep track of your activities on the same weekly reporting form you have been using, and submit the report when you have completed them.'),(145,1,NULL,143,'At the next scheduled graduation you then will graduate the Sr. Officer program as a Full Lieutenant.'),(146,1,NULL,144,'DOCTORATE PROGRAM:'),(147,1,NULL,145,'For those really ambitious officers that would like to continue and take all the basic level classes the academy has to offer. '),(148,1,NULL,146,' At the graduation following completion you will graduate as a Doctor of Starfleet Education Sciences.'),(149,1,NULL,147,'There will be no rank increase for this program..'),(150,1,NULL,148,'A list of the current classes that are available is posted in the Welcome Center and Academy lobby'),(151,1,NULL,149,'After 3 months’ Time in Grade (TiG) as an Ensign you will become ELIGIBLE for promotion it is NOT AUTOMATIC.'),(152,1,NULL,150,'When your TiG is up your service record will be reviewed by your division CO and then submitted to the admiralty to be further reviewed and only on their approval will you advance in rank. '),(153,1,NULL,151,'Participation in the group is required for advancement. If you are not regularly interacting with the group, you could be considered AWOL and would affect your TiG. If you know you will be gone for some time submit a LOA to personal.'),(154,1,12,152,NULL),(155,1,NULL,153,'The Officer Rank Structure is as follows:'),(156,1,NULL,154,'Ensign'),(157,1,NULL,155,'Lt. Junior Grade (Lt. JG)'),(158,1,NULL,156,'Lieutenant'),(159,1,NULL,157,'Lt. Commander'),(160,1,NULL,158,'Commander'),(161,1,NULL,159,'Captain'),(162,1,NULL,160,'Commodore'),(163,1,NULL,161,'Rear Admiral'),(164,1,NULL,162,'Vice Admiral'),(165,1,NULL,163,'Admiral'),(166,1,NULL,164,'Fleet Admiral'),(167,1,NULL,165,'Civilians at UFGQ:'),(168,1,NULL,166,'As a civilian you can RP with our group: '),(169,1,NULL,167,'We have few requirements for civilians at UFGQ.'),(170,1,NULL,168,'You must have write an introduction of yourself for the group. '),(171,1,NULL,169,'t needs to include your character\'s name, race, and age. '),(172,1,NULL,170,'Have a plausible backstory for why you are here that fits into the Star Trek universe. '),(173,1,NULL,171,'Also include your Role Play experience beginner, moderate or advanced.'),(174,1,NULL,172,'Civilians must take the following classes.'),(175,1,NULL,173,'ACD-100 / Intro to UFGQ'),(176,1,NULL,174,'ACD-102 / History of UFGQ'),(177,1,NULL,175,'ACM-103 / Civilian Etiquette Course'),(178,1,NULL,176,'You can RP as your character or in a variety of rolls, you can work with the Civilian Director on jobs you can do.'),(179,1,NULL,177,'Civilian members normally do not participate in the bridge RP’s, you might as a guest on board or in a specific role for that RP (guest villain). This is at the discretion of the ship captain for each RP.'),(180,1,NULL,178,'Or you can complete the academy\'s first year courses and then you can be classified as a ship\'s Civilian Crewman and then you can participate in bridge RP’s in that role.'),(181,1,NULL,179,'Civilians are free to take most of the academy classes. Log the classes you take on a Weekly Report to keep track of them, but it is not necessary to turn it in. If you later decide to become an officer you will get credit for the classes you have taken.'),(182,1,NULL,180,'This concludes our lecture for today.'),(183,1,4,181,NULL),(184,1,NULL,182,'<LIGHTS_ON>'),(185,1,NULL,183,'Are there any questions?'),(186,1,NULL,184,'*Looks around the room*'),(187,1,NULL,185,'You may now start your test by activating the computer terminal in front of you.'),(188,1,NULL,186,'You will need to score 80% or better to pass this exam.'),(189,1,NULL,187,'If you do happen to fail the class you can request a written exam from the Academy Commandant.'),(190,1,NULL,188,'If you would like a copy of this class for further reference you can request  one from the Academy Commandant.'),(191,1,NULL,189,'All students will need to record the grade given on their weekly report. Instructors will record the grade in the gradebook.'),(192,1,NULL,190,'Good luck'),(193,99,NULL,1,'This is a Test of the Engineering classes by <INSTRUCTOR_NAME>'),(194,99,12,3,NULL),(195,99,14,5,NULL),(196,99,NULL,4,'Testing Sound DROID in 10 seconds'),(197,99,NULL,2,'<LIGHTS_OFF>'),(198,99,NULL,6,'<LIGHTS_ON>');
/*!40000 ALTER TABLE `curriculum` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1 COMMENT='List of UFGQ Divisions';
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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=latin1 COMMENT='Holds all the grades for each class in UFGQ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gradebook`
--

LOCK TABLES `gradebook` WRITE;
/*!40000 ALTER TABLE `gradebook` DISABLE KEYS */;
INSERT INTO `gradebook` VALUES (1,'2016-11-03 11:12:34',7,1,90),(2,'2016-11-03 11:14:23',23,1,80),(3,'2016-11-03 11:15:21',16,22,100),(4,'2016-11-03 14:22:42',16,23,100),(5,'2016-11-03 14:23:22',16,50,90),(6,'2016-11-03 16:27:29',19,1,100),(7,'2016-11-03 16:27:57',19,2,100),(8,'2016-11-03 16:28:14',19,3,100),(9,'2016-11-03 16:28:30',19,4,80),(10,'2016-11-03 16:28:55',19,5,100),(11,'2016-11-03 16:29:41',19,8,90),(12,'2016-11-03 16:29:53',19,5,0),(14,'2016-11-06 12:18:49',23,2,100),(15,'2016-11-06 12:18:49',23,4,90),(16,'2016-11-06 12:19:53',23,8,90),(17,'2016-11-06 12:21:34',23,6,100),(18,'2016-11-06 16:16:05',16,1,90),(19,'2016-11-06 16:16:09',16,2,90),(20,'2016-11-06 16:16:21',16,4,100),(21,'2016-11-06 16:24:37',16,8,80),(22,'2016-11-06 16:24:55',16,5,90),(23,'2016-11-06 16:25:08',16,18,100),(24,'2016-11-06 16:25:38',16,19,80),(25,'2016-11-06 16:25:54',16,22,100),(26,'2016-11-06 16:26:23',16,23,90),(27,'2016-11-06 16:26:34',16,45,80),(28,'2016-11-06 16:27:57',16,47,80),(30,'2016-11-06 16:28:13',16,48,80),(31,'2016-11-06 16:30:58',16,69,80),(32,'2016-11-06 16:32:29',16,49,100),(33,'2016-11-06 19:44:43',3,1,80),(34,'2016-11-06 19:45:21',3,2,100),(35,'2016-11-06 19:46:12',3,4,100),(36,'2016-11-06 19:46:28',3,8,90),(37,'2016-11-06 19:46:59',3,5,100),(38,'2016-11-06 19:47:11',3,18,90),(39,'2016-11-06 19:48:22',3,19,100),(40,'2016-11-06 19:48:31',3,22,90),(41,'2016-11-06 19:49:45',3,23,90),(42,'2016-11-06 19:49:57',3,25,90),(43,'2016-11-06 19:51:58',3,26,100),(44,'2016-11-06 19:52:10',3,27,90),(45,'2016-11-06 19:53:44',3,70,100),(46,'2016-11-06 19:54:22',3,28,90),(47,'2016-11-06 19:54:46',3,29,100),(48,'2016-11-06 19:54:59',3,30,80),(49,'2016-11-06 19:55:16',3,31,0),(50,'2016-11-06 19:55:32',3,11,100),(51,'2016-11-27 16:09:41',33,41,100),(52,'2016-11-29 17:48:00',33,18,100);
/*!40000 ALTER TABLE `gradebook` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='Product information for all of UFGQ';
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
-- Dumping data for table `versions`
--

LOCK TABLES `versions` WRITE;
/*!40000 ALTER TABLE `versions` DISABLE KEYS */;
INSERT INTO `versions` VALUES (1,1,2),(2,1,7);
/*!40000 ALTER TABLE `versions` ENABLE KEYS */;
UNLOCK TABLES;

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
INSERT INTO `virtual_domains` VALUES (1,'ufgq.co');
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
