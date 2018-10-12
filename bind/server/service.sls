{%- from "bind/map.jinja" import server with context %}
{%- if server.enabled %}

bind_packages:
  pkg.installed:
  - pkgs: {{ server.pkgs }}

named_directory:
  file.directory:
  - name: {{ server.named_dir }}
  - user: root
  - group: {{ server.group }}
  - mode: 775
  - makedirs: True
  - require:
    - pkg: bind_packages

bind_config:
  file.managed:
  - name: {{ server.config }}
  - source: 'salt://bind/files/named.conf.{{ grains.os_family }}'
  - template: jinja
  - user: root
  - group: {{ server.group }}
  - mode: 640
  - require:
    - pkg: bind_packages
  - watch_in:
    - service: bind_service

{%- if grains['os_family'] == 'Debian' %}

bind_config_local:
  file.managed:
  - name: {{ server.config_local }}
  - source: 'salt://bind/files/named.conf.local'
  - template: jinja
  - user: root
  - group: {{ server.group }}
  - mode: 644
  - require:
    - pkg: bind_packages
  - watch_in:
    - service: bind_service

bind_config_options:
  file.managed:
  - name: {{ server.config_options }}
  - source: 'salt://bind/files/named.conf.options'
  - template: jinja
  - user: root
  - group: {{ server.group }}
  - mode: 644
  - require:
    - pkg: bind_packages
  - watch_in:
    - service: bind_service

{%- endif %}

bind_service:
  service.running:
  - name: {{ server.service }}
  - enable: true
  - reload: true
  - require:
    - pkg: bind_packages

bind_service_reload:
  file.managed:
  - name: /etc/systemd/system/bind9.service.d/reload.conf
  - source: 'salt://bind/files/reload.conf'
  - user: root
  - group: root
  - mode: 644
  - makedirs: True
  module.run:
  - name: service.systemctl_reload
  - onchanges:
    - file: bind_service_reload

{%- endif %}
