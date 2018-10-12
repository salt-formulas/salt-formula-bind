{%- from "bind/map.jinja" import server with context %}
{%- if server.enabled %}

zones_directory:
  file.directory:
  - name: {{ server.zones_dir }}
  - user: root
  - group: {{ server.group }}
  - mode: 775
  - makedirs: True
  - require:
    - file: named_directory

dnsserial_increment:
  grains.present:
  - name: dnsserial
  - value: {{ salt['grains.get']('dnsserial', 1) + 1 }}

{%- for name, zone in server.zone.iteritems() %}
{%- if zone.get('type', 'master') == 'master' %}
{# Slave zone files will be created by bind #}

bind_zone_{{ name }}:
  file.managed:
  - name: {{ server.zones_dir }}/db.{{ name }}
  - source: 'salt://bind/files/db.zone'
  - template: jinja
  - user: root
  - group: {{ server.group }}
  - mode: 640
  - require:
    - file: zones_directory
  - watch_in:
    - service: bind_service
  - defaults:
      zone_name: {{ name }}

{%- endif %}
{%- endfor %}

{%- endif %}
