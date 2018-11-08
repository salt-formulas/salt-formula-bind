{%- from "bind/map.jinja" import client with context %}
{%- for rec_name, record in data.data.get('net_info', {}).iteritems() %}
{%- for name in record.get('names', []) if '.' in name %}
{%- set hostname, domain = name.split('.',1) %}

bind_node_register_{{ name }}_{{ loop.index }}:
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
