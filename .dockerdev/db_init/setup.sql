CREATE DATABASE IF NOT EXISTS `blight_development`;
CREATE DATABASE IF NOT EXISTS `blight_test`;
GRANT ALL ON `blight_development`.* TO `blight`@'%';
GRANT ALL ON `blight_test`.* TO `blight`@'%';
