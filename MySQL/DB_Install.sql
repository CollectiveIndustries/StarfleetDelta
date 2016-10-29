-- MySQL dump 10.13  Distrib 5.6.30, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ufgq
-- ------------------------------------------------------
-- Server version	5.6.30-1

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

--- Dumping database structure for ufgq
DROP DATABASE IF EXISTS `ufgq`;
CREATE DATABASE IF NOT EXISTS `ufgq` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `ufgq`;

--
-- Table structure for table `Time Clock`
--

DROP TABLE IF EXISTS `Time Clock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Time Clock` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL COMMENT 'User ID from accounts table',
  `time_in` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `time_out` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `accounts` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Cross refrences clock times with AV UUIDs';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UUID` char(36) NOT NULL,
  `username` varchar(64) DEFAULT NULL,
  `password` char(128) DEFAULT NULL COMMENT '128 char long sha512 hash',
  `active` tinyint(4) NOT NULL DEFAULT '0' COMMENT '-1 inactive 0 cadet 1 active officer',
  `rank` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `JoinDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `promotiondate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `db_privlage_level` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT 'Administration/viewing privlages',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UniqUUID` (`UUID`),
  UNIQUE KEY `uname_uniq` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Profile information for Staff and Students of UFGQ.';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-10-28 14:49:06
