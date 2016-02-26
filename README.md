
# Bind DNS service

## Sample pillars

    bind:
      server:
        enabled: true
        zone:
          sub.domain.com:
            type: master
            records:
            - name: @
              type: A
              ttl: 7200
              value: 192.168.0.5
          1.168.192.in-addr.arpa:
            type: master
            notify: false
          slave.domain.com:
            type: slave
            notify: true
            masters:
              - dns01.domain.com
              - dns02.domain.com
        dnssec:
          enabled: true
        # Don't hide version
        version: true
        # Allow recursion, better don't on public dns servers
        recursion:
          hosts:
            - localhost

## Read more

* https://github.com/theforeman/puppet-dns
* https://help.ubuntu.com/community/BIND9ServerHowto
