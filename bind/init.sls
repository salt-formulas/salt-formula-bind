
include:
{%- if pillar.bind.server is defined %}
- bind.server
{%- endif %}
{%- if pillar.bind.client is defined %}
- bind.client
{%- endif %}
