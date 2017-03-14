{%- from "bind/map.jinja" import client with context %}
{%- if client.get('enabled', True) %}

bind_client_packages:
  pkg.installed:
  - pkgs: {{ client.pkgs }}

bind_rndc_config:
  file.managed:
  - name: {{ client.rndc_config }}
  - source: 'salt://bind/files/rndc.conf'
  - template: jinja
  - user: root
  - group: root
  - mode: 640
  - require:
    - pkg: bind_client_packages

{%- endif %}
