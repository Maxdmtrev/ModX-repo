CREATE TABLE IF NOT EXISTS `modx_site_content` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pagetitle` varchar(255) NOT NULL,
  `content` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
