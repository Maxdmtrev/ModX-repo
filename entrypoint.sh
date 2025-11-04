#!/bin/bash
set -e

# Запуск MariaDB
service mysql start

# Настройки базы
DB_NAME="modx"
DB_USER="modxuser"
DB_PASS="modxpass"

CONFIG_FILE="/var/www/html/core/config/config.inc.php"

# Если конфиг не существует – создаем базу, юзера и конфиг
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Настройка MODX..."

  mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;"
  mysql -uroot -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
  mysql -uroot -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
  
  if [ -f /var/www/html/setup.sql ]; then
    mysql -u$DB_USER -p$DB_PASS $DB_NAME < /var/www/html/setup.sql
  fi

  cat > "$CONFIG_FILE" <<EOL
<?php
define('MODX_CORE_PATH', '/var/www/html/core/');
define('MODX_CONNECTORS_PATH', '/var/www/html/connectors/');
define('MODX_MANAGER_PATH', '/var/www/html/manager/');
define('MODX_BASE_PATH', '/var/www/html/');

define('MODX_SITE_URL', 'http://localhost/');

define('database_type', 'mysql');
define('database_server', 'localhost');
define('database_user', '$DB_USER');
define('database_password', '$DB_PASS');
define('database_connection_charset', 'utf8');
define('database_name', '$DB_NAME');
define('table_prefix', 'modx_');
define('database_dsn', 'mysql:host=localhost;dbname=$DB_NAME;charset=utf8');
define('database_options', array());
define('driver_options', array());
EOL
  echo "Конфигурация создана"
fi

exec apache2-foreground
