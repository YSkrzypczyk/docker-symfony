#!/bin/sh
set -e

cd /var/www/html
composer update

if [ "$( find ./migrations -iname '*.php' -print -quit )" ]; then
			bin/console doctrine:migrations:migrate --no-interaction
fi

npm update && npm run build

#a2ensite default-ssl
service apache2 reload


/etc/init.d/apache2 start

php bin/console cache:clear

tail -f /var/log/apache2/error.log
