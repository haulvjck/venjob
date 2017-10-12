CREATE TABLE `cities` (
	`id` INT(256) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(128) NOT NULL,
	`created_at` DATETIME NOT NULL,
	`updated_at` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `industries` (
	`id` INT(256) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(256) NOT NULL,
	`created_at` DATETIME NOT NULL,
	`updated_at` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `companies` (
	`id` INT(256) NOT NULL AUTO_INCREMENT,
	`company_id` VARCHAR(128) NOT NULL,
	`name` VARCHAR(128) NOT NULL,
	`introductions` TEXT NOT NULL,
	`location_id` INT NOT NULL,
	`created_at` DATETIME NOT NULL,
	`updated_at` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `locations` (
	`id` INT(256) NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(128) NOT NULL,
	`country` VARCHAR(128) NOT NULL,
	`industry_id` INT(256) NOT NULL,
	`city_id` INT(256) NOT NULL,
	`district` VARCHAR(128) NOT NULL,
	`address` VARCHAR(128) NOT NULL,
	`created_at` DATETIME NOT NULL,
	`updated_at` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `jobs` (
	`id` INT(256) NOT NULL AUTO_INCREMENT,
	`title` VARCHAR(128) NOT NULL,
	`name` TEXT NOT NULL,
	`short_title` VARCHAR(200) NOT NULL,
	`short_desc` VARCHAR(200) NOT NULL,
	`full_desc` TEXT NOT NULL,
	`location_id` INT(256) NOT NULL,
	`company_id` INT(256) NOT NULL,
	`salary` VARCHAR(128) NOT NULL,
	`benefit` TEXT NOT NULL,
	`created_at` DATETIME NOT NULL,
	`updated_at` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `users` (
	`id` INT(256) NOT NULL AUTO_INCREMENT,
	`full_name` VARCHAR(200) NOT NULL,
	`encrypted_password` VARCHAR(128) NOT NULL,
	`reset_password_token` VARCHAR(128) NOT NULL,
	`reset_password_sent_at` VARCHAR(128) NOT NULL,
	`remember_created_at` DATETIME NOT NULL,
	`sign_in_count` INT(256) NOT NULL,
	`current_sign_in_at` DATETIME NOT NULL,
	`last_sign_in_at` VARCHAR(128) NOT NULL,
	`current_sign_in_ip` VARCHAR(128) NOT NULL,
	`last_sign_in_ip` VARCHAR(128) NOT NULL,
	`email` VARCHAR(128) NOT NULL,
	`role` VARCHAR(128) NOT NULL,
	`cv_path` VARCHAR(128) NOT NULL,
	`created_at` DATETIME NOT NULL,
	`updated_at` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `users_jobs` (
	`id` INT(256) NOT NULL AUTO_INCREMENT,
	`user_id` INT(256) NOT NULL,
	`job_id` INT(256) NOT NULL,
	`user_job_relative_type` VARCHAR(128) NOT NULL,
	`created_at` DATETIME NOT NULL,
	`updated_at` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);


ALTER TABLE `companies` ADD CONSTRAINT `company_fk0` FOREIGN KEY (`location_id`) REFERENCES `locations`(`id`);

ALTER TABLE `locations` ADD CONSTRAINT `location_fk0` FOREIGN KEY (`industry_id`) REFERENCES `industries`(`id`);

ALTER TABLE `locations` ADD CONSTRAINT `location_fk1` FOREIGN KEY (`city_id`) REFERENCES `cities`(`id`);

ALTER TABLE `jobs` ADD CONSTRAINT `job_fk0` FOREIGN KEY (`location_id`) REFERENCES `locations`(`id`);

ALTER TABLE `jobs` ADD CONSTRAINT `job_fk1` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`);

ALTER TABLE `users_jobs` ADD CONSTRAINT `user_job_fk0` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`);

ALTER TABLE `users_jobs` ADD CONSTRAINT `user_job_fk1` FOREIGN KEY (`job_id`) REFERENCES `jobs`(`id`);

