-- AUTO-GENERATED FILE.

-- This file is an auto-generated file by Ballerina persistence layer for model.
-- Please verify the generated scripts and execute them against the target DB server.
DROP TABLE IF EXISTS `UserConfiguration`;

CREATE TABLE `UserConfiguration` (
	`location` VARCHAR(191) NOT NULL,
	`weatherCondition` VARCHAR(191) NOT NULL,
	`contactNumber` VARCHAR(191) NOT NULL,
	`lat` DECIMAL(65,30) NOT NULL,
	`lon` DECIMAL(65,30) NOT NULL,
	PRIMARY KEY(`location`,`weatherCondition`,`contactNumber`)
);
