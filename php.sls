# PHP5 modules and configuration
php_stack:
  pkg.installed:
    - name: php5-fpm
  service.running:
    - name: php5-fpm
    - require:
      - pkg: php5-fpm
      - pkg: php5-gd
      - pkg: php5-mysql
      - pkg: php5-memcache
      - pkg: php5-mcrypt
      - file: /etc/php5/fpm/conf.d/20-mcrypt.ini
      - file: /etc/php5/fpm/php.ini
      - file: /etc/php5/fpm/pool.d/www.conf
      - pkg: php5-curl
      - pkg: php5-cli
      - pkg: php-apc
      - pkg: php5-json
      - pkg: mysql-client
    - watch:
      - file: /etc/php5/fpm/php.ini
      - file: /etc/php5/fpm/pool.d/www.conf

php_json:
  pkg.installed:
    - name: php5-json

php_gd:
  pkg.installed:
    - name: php5-gd

php_mysql:
  pkg.installed:
    - name: php5-mysql

php_memcache:
  pkg.installed:
    - name: php5-memcache

php_mcrypt:
  pkg.installed:
    - name: php5-mcrypt

/etc/php5/fpm/conf.d/20-mcrypt.ini:
  file.symlink:
    - target: ../../mods-available/mcrypt.ini
    - require:
      - pkg: php5-mcrypt

/etc/php5/cli/conf.d/20-mcrypt.ini:
  file.symlink:
    - target: ../../mods-available/mcrypt.ini
    - require:
      - pkg: php5-mcrypt

php_curl:
  pkg.installed:
    - name: php5-curl

php_imagick:
  pkg.installed:
    - name: php5-imagick

# php5-imagick also requires imagemagick
imagemagick:
  pkg.installed

php_cli:
  pkg.installed:
    - name: php5-cli

php_apc:
  pkg.installed:
    - name: php-apc

mysql_client:
  pkg.installed:
    - name: mysql-client

libssh2-1-dev:
  pkg.installed:
    - name: libssh2-1-dev

libssh2-php:
  pkg.installed:
    - name: libssh2-php

# Configuration files for php5-fpm

/etc/php5/fpm/php.ini:
  file.managed:
    - source: salt://config/php5-fpm/php.ini
    - user: root
    - group: root
    - mode: 644

/etc/php5/fpm/pool.d/www.conf:
  file.managed:
    - source: salt://config/php5-fpm/www.conf
    - user: root
    - group: root
    - mode: 644

/var/log/php.log:
  file.managed:
    - user: www-data
    - group: www-data
    - mode: 644

wp_cli:
  cmd.run:
    - name: curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/bin/wp ; chmod +x /usr/bin/wp
    - unless: which wp
    - require:
      - pkg: php5-cli
      - pkg: php5-json
  file.managed:
    - name: /home/{{ grains['user'] }}/.wp-cli/config.yml
    - makedirs: True
    - user: {{ grains['user'] }}
    - group: {{ grains['user'] }}
    - contents: |
        path: /srv/www/webroot/wordpress
