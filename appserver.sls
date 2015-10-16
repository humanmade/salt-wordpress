ntp:
  pkg:
    - installed
  service:
    - running

webroot:
  pkg.installed:
    - name: git
  ssh_known_hosts.present:
    - name: github.com
    - user: {{ grains['user'] }}
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48
  git.latest:
    - name: {{ grains['deployment_url'] }}
    - rev: {{ grains['deployment_rev'] }}
    - target: /srv/www/webroot
    - user: {{ grains['user'] }}
    - submodules: True
    - force: True
    - require:
      - file: /srv/www
      - file: /home/{{ grains['user'] }}/.ssh/id_rsa

/srv/www:
  file.directory:
    - user: {{ grains['user'] }}
    - group: {{ grains['user'] }}
    - mode: 755
    - makedirs: True

/var/cloudformation-vars.php:
  file.managed:
    - source: salt://config/cloudformation-vars.php
    - template: jinja

webroot-auto-pull:
  cron.{% if grains['deployment_autoupdating'] == True %}present{% else %}absent{% endif %}:
    - name: cd /srv/www/webroot ; git pull && git submodule foreach --recursive 'git fetch --tags' && git submodule update --init --recursive;
    - user: {{ grains['user'] }}
    - minute: '*/5'

system-cron-for-repo:
  cron.present:
    - identifier: app-cron
    - name: cd /srv/www/webroot ; test -f .system-cron && sh ./.system-cron 2>&1 >> /var/log/app-cron.log
    - user: {{ grains['user'] }}
    - minute: '*'
  file.managed:
    - name: /var/log/app-cron.log
    - user: {{ grains['user'] }}
    - group: {{ grains['user'] }}


# Job Server
jobserver:
  git.latest:
    - name: https://github.com/humanmade/Cavalcade-Runner.git
    - rev: master
    - target: /etc/cavalcade
    - user: root
    - force: True
  file.symlink:
    - name: /usr/bin/cavalcade
    - target: /etc/cavalcade/bin/cavalcade
  cmd.run:
    - name: initctl reload-configuration
    - unless: initctl list | grep cavalcade

jobserver-upstart:
  file.symlink:
    - name: /etc/init/cavalcade.conf
    - target: /etc/cavalcade/upstart.conf
  service.running:
    - name: cavalcade
