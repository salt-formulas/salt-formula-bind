{%- from "bind/map.jinja" import server with context %}
{%- if server.enabled %}

bind_packages:
  pkg.installed:
  - pkgs: {{ server.pkgs }}

named_directory:
  file.directory:
  - name: {{ server.named_dir }}
  - user: {{ server.user }}
  - group: {{ server.group }}
  - mode: 775
  - makedirs: True
  - require:
    - pkg: bind

{%- if grains.os_family == 'RedHat' %}

bind_config:
  file.managed:
  - name: {{ server.config }}
  - source: 'salt://bind/files/named.conf.RedHat'
  - template: jinja
  - user: {{ server.user }}
  - group: {{ server.group }}
  - mode: 640
  - require:
    - pkg: bind_packages
  - watch_in:
    - service: bind_service

bind_local_config:
  file.managed:
    - name: {{ server.local_config }}
    - source: 'salt://bind/files/redhat/named.conf.local'
    - template: jinja
    - user: {{ server.user }}
    - group: {{ server.group }}
    - mode: 644
    - require:
      - pkg: bind_packages
    - watch_in:
      - service: bind_service

{%- endif %}

{%- if grains['os_family'] == 'Debian' %}

bind_config:
  file.managed:
  - name: {{ server.config }}
  - source: 'salt://bind/files/debian/named.conf.Debian'
  - template: jinja
  - user: {{ server.user }}
  - group: {{ server.group }}
  - mode: 644
  - require:
    - pkg: bind_packages
  - watch_in:
    - service: bind_service

bind_local_config:
  file.managed:
  - name: {{ server.local_config }}
  - source: 'salt://bind/files/debian/named.conf.local'
  - template: jinja
  - user: {{ server.user }}
  - group: {{ server.group }}
  - mode: 644
  - require:
    - pkg: bind_packages
  - watch_in:
    - service: bind_service

bind_options_config:
  file.managed:
  - name: {{ server.options_config }}
  - source: 'salt://bind/files/debian/named.conf.options'
  - template: jinja
  - user: {{ server.user }}
  - group: {{ server.group }}
  - mode: 644
  - require:
    - pkg: bind_packages
  - watch_in:
    - service: bind_service

bind_default_zones:
  file.managed:
  - name: {{ server.default_zones_config }}
  - source: 'salt://bind/files/debian/named.conf.default-zones'
  - template: jinja
  - user: {{ server.user }}
  - group: {{ server.group }}
  - mode: 644
  - require:
    - pkg: bind_packages
  - watch_in:
    - service: bind_service

/var/log/bind9:
  file.directory:
  - user: {{ server.user }}
  - group: {{ server.group }}
  - mode: 775
  - template: jinja

/etc/logrotate.d/bind9:
  file.managed:
  - source: salt://bind/files/logrotate
  - user: root
  - group: root

{%- endif %}

bind_service:
  service.running:
  - name: {{ server.service }}
  - enable: true
  - reload: true
  - require:
    - pkg: bind_packages

setup_rndc:
  cmd.run:
  - name: /usr/sbin/rndc-confgen -r /dev/urandom -a -c {{ server.rndc_key }}
  - require:
    - pkg: bind_packages

{{ server.rndc_key }}:
  file.managed:
  - user: root
  - mode: 0640
  - require:
    - cmd: setup_rndc

{%- endif %}