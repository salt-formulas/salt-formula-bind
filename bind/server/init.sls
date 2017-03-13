include:
- bind.server.service
{%- if pillar.bind.server.zone is defined %}
- bind.server.zone
{%- endif %}