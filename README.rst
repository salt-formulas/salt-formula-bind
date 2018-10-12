
============
Bind formula
============

BIND is open source software that enables you to publish your Domain Name System (DNS) information on the Internet, and to resolve DNS queries for your users. The name BIND stands for “Berkeley Internet Name Domain”, because the software originated in the early 1980s at the University of California at Berkeley.

Sample pillars
==============

Server
------

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
        control:
          local:
            enabled: true
            bind:
              address: 127.0.0.1
              port: 953
            allow:
              - 127.0.0.1
            keys:
              - xyz
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
            auto_records: true
            # Allow autoload of host records from salt mine.
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

You can use following command to generate key:

.. code-block:: bash

    dnssec-keygen -a HMAC-SHA512 -b 512 -n HOST -r /dev/urandom mykey

Client
------

.. code-block:: yaml

    bind:
      client:
        enabled: true
        option:
          default:
            server: localhost
            port: 953
            key: keyname
        key:
          keyname:
            secret: xyz
            algorithm: hmac-sha512
        server:
          8.8.8.8:
            keys:
              - keyname

Read more
=========

* https://github.com/theforeman/puppet-dns
* https://help.ubuntu.com/community/BIND9ServerHowto
* https://www.isc.org/downloads/bind/

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-bind/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-bind

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
