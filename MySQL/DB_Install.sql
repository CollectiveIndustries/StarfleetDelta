-- --------------------------------------------------------
-- Host:                         ci-main2.no-ip.org
-- Server version:               5.6.27-2 - (Debian)
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             9.3.0.5112
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for academy
DROP DATABASE IF EXISTS `academy`;
CREATE DATABASE IF NOT EXISTS `academy` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `academy`;

-- Dumping structure for table academy.accounts
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE IF NOT EXISTS `accounts` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(64) DEFAULT NULL,
  `password` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'BUG: needs to have an md5sum has on passwords',
  `active` tinyint(4) NOT NULL DEFAULT '0' COMMENT '-1 inactive 0 cadet 1 active officer',
  `rank` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `promotiondate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `db_privlage_level` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Administration/viewing privlages',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Profile information for Staff and Students of UFGQ.';

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
