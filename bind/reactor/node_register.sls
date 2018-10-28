{%- from "bind/map.jinja" import client with context %}
{%- for record in data.data.grains.get('dns_records', []) %}
{%- for name in record.get('names', []) if '.' in name %}
{%- set hostname, domain = name.split('.',1) %}

bind_node_register_{{ name }}:
  local.ddns.add_host:
  - tgt: bind:server:zone:{{ domain }}:type:master
  - tgt_type: pillar
  - args:
    - zone: {{ domain }}
    - name: {{ hostname }}
    - ttl: {{ client.get('ddns_ttl', 300) }}
    - ip: {{ record.get('address', '127.0.0.127') }}

{%- endfor %}
{%- endfor %}
