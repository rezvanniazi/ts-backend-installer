-- SQL to sync LOCAL database to match PRODUCTION
-- Generated: 2025-11-09T07:45:43.248Z
-- WARNING: Review this file carefully before executing!

SET FOREIGN_KEY_CHECKS=0;

-- Create table from production
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

-- Sync table: AudioBots
ALTER TABLE `AudioBots` MODIFY COLUMN `created` datetime NOT NULL;
ALTER TABLE `AudioBots` DROP COLUMN `bot_server_port`;

-- Sync table: BotPackages

-- Sync table: CompanyLists
ALTER TABLE `CompanyLists` MODIFY COLUMN `domain_ip` varchar(45) NOT NULL DEFAULT '0.0.0.0';

-- Sync table: ManagerBotPanels

-- Sync table: MusicBotPanels

-- Sync table: Permissions

-- Sync table: Radios

-- Sync table: RanksystemSettings
ALTER TABLE `RanksystemSettings` ADD COLUMN `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY;
ALTER TABLE `RanksystemSettings` DROP COLUMN `da_url`;
ALTER TABLE `RanksystemSettings` DROP COLUMN `da_username`;
ALTER TABLE `RanksystemSettings` DROP COLUMN `da_password`;

-- Sync table: Ranksystems
ALTER TABLE `Ranksystems` ADD COLUMN `created` datetime NOT NULL DEFAULT current_timestamp();
ALTER TABLE `Ranksystems` ADD COLUMN `author` varchar(45) NOT NULL;
ALTER TABLE `Ranksystems` ADD COLUMN `state` varchar(45) NOT NULL DEFAULT 'active';
ALTER TABLE `Ranksystems` ADD COLUMN `status` varchar(45) NOT NULL DEFAULT 'offline';
ALTER TABLE `Ranksystems` ADD COLUMN `information` text DEFAULT NULL;

-- Sync table: RefreshTokens

-- Sync table: ServerPackages

-- Sync table: Servers
ALTER TABLE `Servers` MODIFY COLUMN `info` varchar(255) DEFAULT NULL;
ALTER TABLE `Servers` MODIFY COLUMN `package_name` varchar(45) DEFAULT NULL;


-- Sync table: UsedPorts

-- Sync table: Users
ALTER TABLE `Users` MODIFY COLUMN `password` blob NOT NULL;
ALTER TABLE `Users` MODIFY COLUMN `created` datetime NOT NULL;
ALTER TABLE `Users` MODIFY COLUMN `balance` int(11) NOT NULL DEFAULT 0;
ALTER TABLE `Users` MODIFY COLUMN `company_name` varchar(45) DEFAULT NULL;

SET FOREIGN_KEY_CHECKS=1;
