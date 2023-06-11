CREATE TABLE IF NOT EXISTS `houses` (
    `id` INT AUTO_INCREMENT,
    `owner` VARCHAR(255) NOT NULL,
    `rented` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
);