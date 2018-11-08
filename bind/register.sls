send_dns_register_event:
  event.send:
  - name: dns/node/register
  - net_info: {{ pillar.linux.network.get('host', {}) }}
