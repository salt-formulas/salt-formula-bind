{% from "bind/map.jinja" import server with context %}

bind_packages:
  pkg.installed:
    - pkgs: {{ server.pkgs|json }}

named_directory:
  file.directory:
    - name: {{ map.named_directory }}
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: 775
    - makedirs: True
    - require:
      - pkg: bind

{% if grains.os_family == 'RedHat' %}
bind_config:
  file.managed:
    - name: {{ map.config }}
    - source: 'salt://bind/files/redhat/named.conf'
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '640') }}
    - require:
      - pkg: bind
    - watch_in:
      - service: bind

bind_local_config:
  file.managed:
    - name: {{ map.local_config }}
    - source: 'salt://bind/files/redhat/named.conf.local'
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - require:
      - pkg: bind
    - watch_in:
      - service: named
{% endif %}

{% if grains['os_family'] == 'Debian' %}
bind_config:
  file:
    - managed
    - name: {{ map.config }}
    - source: 'salt://bind/files/debian/named.conf'
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - require:
      - pkg: bind
    - watch_in:
      - service: bind

bind_local_config:
  file:
    - managed
    - name: {{ map.local_config }}
    - source: 'salt://bind/files/debian/named.conf.local'
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - require:
      - pkg: bind
    - watch_in:
      - service: bind

bind_options_config:
  file:
    - managed
    - name: {{ map.options_config }}
    - source: 'salt://bind/files/debian/named.conf.options'
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - require:
      - pkg: bind
    - watch_in:
      - service: bind

bind_default_zones:
  file:
    - managed
    - name: {{ map.default_zones_config }}
    - source: 'salt://bind/files/debian/named.conf.default-zones'
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - require:
      - pkg: bind
    - watch_in:
      - service: bind

/var/log/bind9:
  file:
    - directory
    - user: root
    - group: bind
    - mode: 775
    - template: jinja


/etc/logrotate.d/bind9:
  file:
    - managed
    - source: salt://bind/files/debian/logrotate_bind
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
