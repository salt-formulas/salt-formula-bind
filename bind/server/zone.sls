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
  - value: {{ salt['grains.get']('dnsserial', 1) + 1000 }}

bind_service_stop:
  service.dead:
  - name: {{ server.service }}

{%- for name, zone in server.zone.iteritems() %}
{%- if zone.get('type', 'master') == 'master' %}
{#- Slave zone files will be created by bind #}

bind_zone_{{ name }}_jnl:
  file.absent:
  - name: {{ server.zones_dir }}/db.{{ name }}.jnl
  - require:
    - service: bind_service_stop

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
  - defaults:
      zone_name: {{ name }}

{%- endif %}
{%- endfor %}

bind_service_start:
  service.running:
  - name: {{ server.service }}

{%- endif %}
