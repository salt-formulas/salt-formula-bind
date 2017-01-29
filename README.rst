
============
Bind formula
============

BIND is open source software that enables you to publish your Domain Name System (DNS) information on the Internet, and to resolve DNS queries for your users. The name BIND stands for “Berkeley Internet Name Domain”, because the software originated in the early 1980s at the University of California at Berkeley.

Sample pillars
==============

.. code-block:: yaml

    bind:
      server:
        enabled: true
        key:
          keyname:
            secret: xyz
            algorithm: hmac-sha512
        server:
          8.8.8.8:
            keys:
              - keyname
        zone:
          sub.domain.com:
            ttl: 86400
            root: "hostmaster@domain.com"
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
              # Masters must be specified by IP address
              - 8.8.8.8
              - 8.8.4.4
        dnssec:
          enabled: true
        # Don't hide version
        version: true
        # Allow recursion, better don't on public dns servers
        recursion:
          hosts:
            - localhost

Read more
=========

* https://github.com/theforeman/puppet-dns
* https://help.ubuntu.com/community/BIND9ServerHowto
* https://www.isc.org/downloads/bind/
