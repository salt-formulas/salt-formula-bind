
# Bind DNS service

## Sample pillars

    bind:
      server:
        enabled: true
        zone:
          sub.domain.com:
            type: master
            notify: False
          1.168.192.in-addr.arpa:
            type: master
            notify: False

## Read more

* https://help.ubuntu.com/community/BIND9ServerHowto