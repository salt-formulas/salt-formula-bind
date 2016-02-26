bind:
  server:
    enabled: true
    forwarders:
      - 8.8.4.4
      - 8.8.8.8
    zone:
      master.domain.com:
        type: master
        records:
        - name: "@"
          type: A
          ttl: 7200
          value: 192.168.0.5
        - name: sub
          type: CNAME
          ttl: 1800
          value: test.domain.com.
      1.168.192.in-addr.arpa:
        type: master
      slave.domain.com:
        type: slave
        notify: true
        masters:
          # Masters must be specified by IP address
          - 8.8.8.8
          - 8.8.4.4
    dnssec:
      enabled: true
      validation: true
    # Don't hide version
    version: true
    # Allow recursion
    recursion:
      hosts:
        - localhost
