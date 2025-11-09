/*M!999999\- enable the sandbox mode */ 

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;
DROP TABLE IF EXISTS `AudioBots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `AudioBots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `bot_server_ip` varchar(45) NOT NULL,
  `bot_default_channel_name` varchar(255) DEFAULT NULL,
  `bot_channel_commander_is_on` tinyint(1) DEFAULT 0,
  `bot_owner` varchar(45) NOT NULL,
  `information` text DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `expires` date DEFAULT NULL,
  `package_name` varchar(45) NOT NULL,
  `type` varchar(45) NOT NULL DEFAULT 'normal',
  `template_name` varchar(45) NOT NULL,
  `state` varchar(45) NOT NULL DEFAULT 'active',
  `playing` varchar(45) DEFAULT NULL,
  `status` varchar(45) NOT NULL DEFAULT 'offline',
  `panel_id` int(11) NOT NULL,
  `autorenew` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `BotPackages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `BotPackages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `package_name` varchar(45) NOT NULL,
  `package_days` int(20) DEFAULT NULL,
  `package_amount` int(20) NOT NULL,
  `package_description` varchar(45) NOT NULL,
  `package_for_admin` tinyint(1) DEFAULT 0,
  `package_bot_type` varchar(45) NOT NULL DEFAULT 'normal',
  PRIMARY KEY (`id`),
  UNIQUE KEY `package_name` (`package_name`),
  UNIQUE KEY `package_name_2` (`package_name`),
  UNIQUE KEY `package_name_3` (`package_name`),
  UNIQUE KEY `package_name_4` (`package_name`),
  UNIQUE KEY `package_name_5` (`package_name`),
  UNIQUE KEY `package_name_6` (`package_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `CompanyLists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `CompanyLists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `domain_name` varchar(45) NOT NULL,
  `domain_zone_id` varchar(45) NOT NULL,
  `cloudf_token` varchar(45) NOT NULL,
  `domain_ip` varchar(45) NOT NULL DEFAULT '0.0.0.0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `name_2` (`name`),
  UNIQUE KEY `name_3` (`name`),
  UNIQUE KEY `name_4` (`name`),
  UNIQUE KEY `name_5` (`name`),
  UNIQUE KEY `name_6` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ManagerBotPanels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ManagerBotPanels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `host` varchar(45) NOT NULL,
  `token` varchar(255) NOT NULL,
  `max_bot` int(11) NOT NULL,
  `in_use_count` int(11) NOT NULL DEFAULT 0,
  `status` varchar(45) NOT NULL DEFAULT 'offline',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `MusicBotPanels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `MusicBotPanels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `host` varchar(45) NOT NULL,
  `token` varchar(255) NOT NULL,
  `max_bot` int(11) NOT NULL,
  `in_use_count` int(11) NOT NULL DEFAULT 0,
  `panel_type` varchar(45) NOT NULL DEFAULT 'normal',
  `status` varchar(45) NOT NULL DEFAULT 'offline',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  `desc` varchar(255) NOT NULL,
  `multi` tinyint(1) NOT NULL DEFAULT 0,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Radios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Radios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `url` varchar(255) NOT NULL,
  `information` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `RanksystemSettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `RanksystemSettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `price` int(11) NOT NULL DEFAULT 10000,
  `backend_url` varchar(45) NOT NULL,
  `backend_token` varchar(45) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Ranksystems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ranksystems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `template_name` varchar(45) NOT NULL,
  `expires` date DEFAULT NULL,
  `autorenew` tinyint(1) NOT NULL DEFAULT 0,
  `username` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `author` varchar(45) NOT NULL,
  `state` varchar(45) NOT NULL DEFAULT 'active',
  `status` varchar(45) NOT NULL DEFAULT 'offline',
  `information` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `RefreshTokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `RefreshTokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `revoked` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_hash` (`token_hash`),
  UNIQUE KEY `refresh_tokens_token_hash` (`token_hash`),
  UNIQUE KEY `token_hash_2` (`token_hash`),
  UNIQUE KEY `token_hash_3` (`token_hash`),
  UNIQUE KEY `token_hash_4` (`token_hash`),
  UNIQUE KEY `token_hash_5` (`token_hash`),
  UNIQUE KEY `token_hash_6` (`token_hash`),
  KEY `refresh_tokens_user_id` (`user_id`),
  KEY `refresh_tokens_expires_at` (`expires_at`),
  KEY `refresh_tokens_revoked` (`revoked`),
  CONSTRAINT `RefreshTokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ServerPackages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ServerPackages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `package_name` varchar(45) NOT NULL,
  `package_slots` int(20) NOT NULL,
  `package_days` int(20) DEFAULT NULL,
  `package_amount` int(20) NOT NULL,
  `package_description` varchar(45) NOT NULL,
  `package_for_admin` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `package_name` (`package_name`),
  UNIQUE KEY `package_name_2` (`package_name`),
  UNIQUE KEY `package_name_3` (`package_name`),
  UNIQUE KEY `package_name_4` (`package_name`),
  UNIQUE KEY `package_name_5` (`package_name`),
  UNIQUE KEY `package_name_6` (`package_name`),
  KEY `server_packages_package_amount` (`package_amount`),
  KEY `server_packages_package_for_admin` (`package_for_admin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Servers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(45) NOT NULL DEFAULT 'active',
  `server_port` int(11) NOT NULL,
  `query_port` int(11) NOT NULL,
  `file_port` int(11) NOT NULL,
  `query_password` varchar(45) NOT NULL,
  `author` varchar(45) NOT NULL,
  `slots` int(11) NOT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `expires` date DEFAULT NULL,
  `version` varchar(10) NOT NULL,
  `info` varchar(255) DEFAULT NULL,
  `package_name` varchar(45) DEFAULT NULL,
  `subdomain_record_id` varchar(45) DEFAULT NULL,
  `subdomain_name` varchar(45) DEFAULT NULL,
  `autorenew` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `servers_server_port_query_port_file_port` (`server_port`,`query_port`,`file_port`),
  KEY `servers_state` (`state`),
  KEY `servers_author` (`author`),
  KEY `servers_expires` (`expires`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tokens` (
  `id` varchar(45) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expires_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `Tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `TsManagerBots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `TsManagerBots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `template_name` varchar(45) NOT NULL,
  `expires` date DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `author` varchar(45) NOT NULL,
  `information` varchar(255) DEFAULT NULL,
  `state` varchar(45) NOT NULL DEFAULT 'active',
  `status` varchar(45) NOT NULL DEFAULT 'online',
  `panel_id` int(11) NOT NULL,
  `conn` longtext NOT NULL,
  `channels` longtext NOT NULL,
  `permissions` longtext NOT NULL,
  `autorenew` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`template_name`),
  UNIQUE KEY `template_name` (`template_name`),
  UNIQUE KEY `template_name_2` (`template_name`),
  UNIQUE KEY `template_name_3` (`template_name`),
  UNIQUE KEY `template_name_4` (`template_name`),
  UNIQUE KEY `template_name_5` (`template_name`),
  KEY `ts_manager_bots_state` (`state`),
  KEY `ts_manager_bots_status` (`status`),
  KEY `ts_manager_bots_panel_id` (`panel_id`),
  KEY `ts_manager_bots_expires` (`expires`),
  KEY `ts_manager_bots_author` (`author`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `UsedPorts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `UsedPorts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `port` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `used_ports_port` (`port`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `password` blob NOT NULL,
  `scope` varchar(45) NOT NULL,
  `status` varchar(45) NOT NULL DEFAULT 'active',
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `info` varchar(55) DEFAULT NULL,
  `balance` int(11) NOT NULL DEFAULT 0,
  `company_name` varchar(45) DEFAULT NULL,
  `global_command` text DEFAULT NULL,
  `can_use_bot` tinyint(1) NOT NULL DEFAULT 0,
  `can_use_manager_bots` tinyint(1) NOT NULL DEFAULT 0,
  `can_use_servers` tinyint(1) NOT NULL DEFAULT 0,
  `can_use_ranksystems` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `users_username` (`username`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `username_2` (`username`),
  UNIQUE KEY `username_3` (`username`),
  UNIQUE KEY `username_4` (`username`),
  UNIQUE KEY `username_5` (`username`),
  KEY `users_status` (`status`),
  KEY `users_scope` (`scope`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

