
# Bind DNS service

bind:
  configured_zones:
    sub.domain.com:
      type: master
      notify: False
    1.168.192.in-addr.arpa:
      type: master
      notify: False

available_zones:
  sub.domain.org:
    file: db.sub.domain.org
    masters: "192.168.0.1;"