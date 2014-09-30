
# Bind DNS service

## Sample pillars

    bind:
      server:
        enabled: true
        zone:
          sub.domain.com:
            type: master
            notify: false
            records:
            - name: @
              type: A
              ttl: 7200
              value: 192.168.0.5
          1.168.192.in-addr.arpa:
            type: master
            notify: false

## Read more

* https://github.com/theforeman/puppet-dns
* https://help.ubuntu.com/community/BIND9ServerHowto