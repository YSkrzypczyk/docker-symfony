# Symfony Docker

Un environnement Docker embarquant la dernière version de <code>symfony/skeleton</code> dans un
environnement AMP avec génération automatique de certificat SSL et mise en production.

<u>Stack et environnement technique</u>
<ul>
    <li>Apache2</li>
    <li>Php 8.2</li>
    <li>Postgres</li>
    <li>Symfony / Doctrine</li>
    <li>Symfony Flex</li>
    <li>Https dev et prod</li>
    <li>Let's Encrypt</li>
    <li>Adminer env de Dev</li>
    <li>NodeJS / npm / WEBPACK ENCORE</li>
</ul>


<u>Pré-requis :</u>
<ul>
    <li><a href="https://git-scm.com/">Git</a></li>
    <li><a href="https://www.docker.com/">Docker</a></li>
</ul>


<u style="color: #925252"> !!! Les variables d'environnement !!!</u>
<p>
    Pour éditer les variables d'environnement de SYMFONY 
    il faut modifier <code>./server/.env</code> pour l'environnement
    de développement et <code>./server/.env.prod</code> pour
    l'environnement de production. Contrairement au fonctionnement
    classique de Symfony, les fichiers <code>.env.*</code> 
    ne se surchargent pas
</p>
<hr>

# En local

<h3>Génération d'une clé SSL en local </h3>
<pre>openssl req -x509 -new -out server/ssl/mycert.crt -keyout server/ssl/mycert.key -days 365 -newkey rsa:4096 -sha256 -nodes</pre>

<h3>Lancement du docker</h3>
<p>Build automatique de docker-compose.yml et docker-compose.override.yml<br>
Execution de <i>server/docker-entrypoint.dev.sh</i> :
<ul>
    <li>Installation de Symfony latest</li>
    <li>composer require</li>
    <ul>
        <li>--dev symfony/profiler-pack
        <li>symfony/orm-pack
        <li>--dev symfony/maker-bundle
        <li>symfony/apache-pack
        <li>twig/twig
        <li>symfony/webpack-encore-bundle
    </ul>
    <li>Migration si nécessaire</li>
    <li>npm run watch</li>
</ul>

Build avec des images neuves :
<code>docker compose build --no-cache</code><br>
Run des containers :
<code>docker compose up</code>

<h3>Accès</h3>
<p>
<a href="https://localhost">localhost</a><br>
<a href="http://localhost:8080/?pgsql=symfony_db&username=symfony&db=symfony">adminer</a>
</p>


<h3>Identifiants Database :</h3>
<ul>
	<li>host: database</li>
	<li>dbname: symfony_db
	<li>user: symfony
	<li>password: password
	<li>port: 5432

</ul>



<h3>Commandes Docker utiles :</h3>

Accès au container web : 
<code>docker exec -it symfony_web /bin/bash</code>


<hr>

# En production
<p>
Modifier le <code>site.fr</code> dans le fichier : <code>apache2/default-ssl-prod.conf</code>
</p>

<pre>SSLCertificateFile /var/www/html/server/ssl/etc/letsencrypt/live/<span style="color:#cc6464">site.fr</span>/cert.pem
SSLCertificateKeyFile /var/www/html/server/ssl/etc/letsencrypt/live/<span style="color:#cc6464">site.fr</span>/privkey.pem
SSLCertificateChainFile /var/www/html/server/ssl/etc/letsencrypt/live/<span style="color:#cc6464">site.fr</span>/fullchain.pem</pre>


<p>Commenter la ligne ci-dessous, Fichier : <code>server/docker-entrypoint.prod.sh</code></u>
<pre>#a2ensite default-ssl </pre>

<p>
    Build avec des images neuves en indiquant les docker-compose de prod :
</p>
<pre>
docker compose -f docker-compose.yml -f docker-compose.prod.yml up --build
</pre>

<p>Utilisation du Docker Hub pour la génération d'une clé SSH Letsencrypt en
modifiant le <code>site.fr</code> ainsi que  le <code>mail@domain.fr</code></p>
<pre>
docker run -it --rm \
-v $PWD/server/ssl/etc/letsencrypt:/etc/letsencrypt \
-v $PWD/server/ssl/lib/letsencrypt:/var/lib/letsencrypt \
-v $PWD/public:/data/letsencrypt \
-v $PWD/server/ssl/log/letsencrypt:/var/log/letsencrypt \
certbot/certbot \
certonly --webroot \
--email <span style="color:#cc6464">mail@domain.fr</span> --agree-tos --no-eff-email \
--webroot-path=/data/letsencrypt \
-d <span style="color:#cc6464">site.fr</span> -d <span style="color:#cc6464">www.site.fr</span>
</pre>

<p>
Activer le SSL en supprimant le commentaire de <code>a2ensite default-ssl </code> et redémarrer les containers :
</p>

<code>docker compose -f docker-compose.yml -f docker-compose.prod.yml up
</code>

# License
Docker Symfony is available under the MIT License.
# Credits
Created by Yves SKRZYPCZYK.