Remote Assistance
=================

A common problem when requesting remote assistance is to get access to the user machine.
Usually the user machine is behind a NAT or a firewall which blocks incoming connections,
and it a problem for the non-technical user to setup port forwarding and firewall rules.
Remote access is available for user support. It is handy whenever you need for instance to access your ntopng behind a firewall and you do not want to setup a VPN. As n2n relies on the concept of supernode, ntop has setup on your behalf a public supernode for avoid you doing that. However we encourage you to setup your private supernode and configure it in ntopng preferences, so that you can have a fully private remote access infrastructure.

.. warning::
   Enabling the remote assistance you enable people to connect to your ntopng host by providing them the right credentials. The ntop team has no access to your ntopng instance unless you provide them credentials.

   
In order to ease remote assistance, ntopng integrates n2n_ and provides a web console
to enable remote access. This console is available only for distributions where the n2n package
is available. Please refer to http://packages.ntop.org for more information about the n2n package.


.. warning::
  ntopng assumes that certains script files are placed in certain locations, as installed by the ntopng prebuild package.
  This means that, if ntopng is compiled from source, special care must be taken to place these files at the correct locations
  in order to make remote assistance available.

The console can be accessed from the `Remote Assistance` menu entry:

.. figure:: img/remote_assistance_menu.png
  :align: center
  :alt: Remote Assistance Menu Entry

When the remote assistance is enabled, the machine running ntopng will take part
to a dedicated virtual network. You can download the connection script from the user interface so
your Linux (with little changes it can also run on other platforms such as Windows and OSX) with the n2n package installed can
can take part to the machine virtual network to provide remote assistance **bypassing NAT and firewalls**.
The script can be run from the terminal as follows:

.. code:: bash

    chmod +x n2n_assistance.sh
    ./n2n_assistance.sh

.. warning::

  The connection script contains connection credentials so it must be sent only to trusted peers

.. figure:: img/remote_assistance_settings.png
  :align: center
  :alt: Remote Assistance Settings

By enabling the remote assistance and providing the connection script to the ntop support
team, the user can receive remote assistance. When remote assistance is enabled, the ntopng instance will be available at IP address 192.168.166.1

If the `Temporary Admin Access` flag is checked, you enable a temporary access as admin (this to avoid disclosing the admin credentials to third parties). If this option is not enabled, the regular admin (or any other user) password has to be provided to the remote end for connection.

.. warning::

   - ntop is not responsible for any damage, security violation or vulnerability caused by enabling remote assistance
   - It is the user responsability to ensure that the network security policies allow virtual networks creation
   - Enabling remote assistance you grant access to the host where ntopng is running (i.e. it is an encrypted VPN) so the remote host is also accessible (i.e. you can SSH to it for instance) and not just the ntopng web interface.

Remote Assistance Status
------------------------

As long as the remote assistance is active, an icon will be displayed in the footer:

.. figure:: img/remote_assistance_footer.png
  :align: center
  :alt: Remote Assistance Status

By clicking on it, it's possible to check the service status and log.

.. figure:: img/remote_assistance_status.png
  :align: center
  :alt: Remote Assistance Status

The remote assistance service will stay active even when ntopng is stopped. This
must be manually disabled from the ntopng GUI in the Settings panel,  when remote assistance is concluded.

Security Considerations
-----------------------

Here are some consideration about the remote assistance security:

- All the traffic is end-to-end encrypted to prevent MITM (Man In The Middle) attacks
- The remote assistance is automatically disabled after 24 hours
- Traffic forwarding via the virtual network interface (i.e. the remote host where ntopng is running will not route traffic via n2n) is disabled to increase security





.. _n2n: https://github.com/ntop/n2n
