send_register_event:
  event.send:
  - name: dns/node/register
  - with_grains:
    - dns_records
