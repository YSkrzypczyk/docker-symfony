#!/bin/sh
set -e

cd /var/www/html
composer update

if [ "$( find ./migrations -iname '*.php' -print -quit )" ]; then
			bin/console doctrine:migrations:migrate --no-interaction
fi

npm update && npm run build

chown -R www-data:www-data /var/www/html/public

#a2ensite default-ssl

/etc/init.d/apache2 start

php bin/console cache:clear

tail -f /var/log/apache2/error.log
