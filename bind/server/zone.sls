{%- from "bind/map.jinja" import server with context %}
{%- if server.enabled %}

zones_directory:
  file.directory:
  - name: {{ server.zones_dir }}
  - user: root
  - group: {{ server.group }}
  - mode: 775
  - makedirs: True

dnsserial_increment:
  grains.present:
  - name: dnsserial
  - value: {{ salt['grains.get']('dnsserial', 1) + 1000 }}

{%- for name, zone in server.zone.iteritems() %}
{%- if zone.get('type', 'master') == 'master' %}
{#- Slave zone files will be created by bind #}

{%- if salt['file.file_exists'](server.zones_dir + '/db.' + name + '.jnl') %}
bind_zone_{{ name }}_sync:
  cmd.run:
  - name: rndc sync -clean {{ name }}
{%- endif %}

bind_zone_{{ name }}:
  file.managed:
  - name: {{ server.zones_dir }}/db.{{ name }}
  - replace: False
  - source: 'salt://bind/files/db.zone'
  - template: jinja
  - user: root
  - group: {{ server.group }}
  - mode: 640
  - require:
    - file: zones_directory
  - defaults:
      zone_name: {{ name }}
  - watch_in:
      service: bind_service_reload

{%- endif %}
{%- endfor %}

bind_service_reload:
  service.running:
  - name: {{ server.service }}
  - reload: True
{%- endif %}
