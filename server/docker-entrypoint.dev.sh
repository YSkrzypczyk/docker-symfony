#!/bin/sh
set -e

cd /var/www/html
if [ ! -f composer.json ]; then
		rm -Rf tmp/
		composer create-project "symfony/skeleton" tmp --no-interaction --no-install
		cd tmp
    composer require --dev symfony/profiler-pack
		composer require symfony/orm-pack
    composer require --dev symfony/maker-bundle
    composer require symfony/apache-pack
    composer require twig/twig
    composer require symfony/webpack-encore-bundle
    composer require symfony/dotenv
		cp -Rpn . ..
		cd -
		rm -Rf tmp/
fi

composer update

if [ "$( find ./migrations -iname '*.php' -print -quit )" ]; then
			bin/console doctrine:migrations:migrate --no-interaction
fi

a2ensite default-ssl

/etc/init.d/apache2 start

php bin/console cache:clear

npm update && npm run watch
