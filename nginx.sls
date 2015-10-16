nginx:
  pkg:
    - installed
  service.running:
    - require:
      - pkg: nginx
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/sites-enabled/default

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://config/nginx.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/etc/nginx/sites-enabled/default:
  file.managed:
    {% if grains['role'] == 'webserver' %}
    - source: salt://config/nginx-vhost-webserver.conf
    {% elif grains['role'] == 'appserver' %}
    - source: salt://config/nginx-vhost-appserver.conf
    {% elif grains['role'] == 'glotpressserver' %}
    - source: salt://config/nginx-vhost-appserver.conf
    {% elif grains['project'] == 'proxy' %}
    - source: salt://config/nginx-vhost-hm-stack.conf
    {% endif %}
    - user: root
    - group: root
    - mode: 644
    - template: jinja

{% if grains['role'] == 'webserver' %}
/srv/www:
  file.directory:
    - user: {{ grains['user'] }}
    - group: {{ grains['user'] }}
    - mode: 755
    - makedirs: True

/srv/www/default:
  file.directory:
    - user: {{ grains['user'] }}
    - group: {{ grains['user'] }}
    - mode: 755
    - makedirs: True

/srv/www/default/index.php:
  file.managed:
    - user: {{ grains['user'] }}
    - group: {{ grains['user'] }}
    - mode: 644
    - contents: "not found"
{% endif %}