# mounthomedir

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Parameters](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)

## Overview

Module to access and mount users homedir from a system using kerberos. Mounts to /home/$username.

Has the dependency on pam_mount. Provides settings for pam_mount.conf.xml

## Parameters

ensure
------

Defines if mounthomedir and its relevant packages are to be installed or removed.

Accepts: 'present', 'absent'
Default: 'present'

scripts_ensure
--------------

Defines if the doautomount and doautounmount scripts are to be installed or removed. Valid values are 'present' and 'absent'.

Accepts: 'present', 'absent'
Default: Value of $ensure

default_homedirs_server_fqdn
----------------------------

The fully qualified domain name of the server to search for home directories.
If $pam_mount_config is overwritten, this does nothing.

Accepts: String
Default: 'foo.bar.example.co.uk'

pam_mount_config
----------------

This module also configures pam_mount.conf.xml through the pam_mount module. 
The value of this parameter can be used to configure the pam_mount module.

Accepts: See pam_mount::config.
Default: Results in the following XML:
```<pam_mount>
<debug enable="0"/>
<path>/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin</path>
<cifsmount>doautomount %(USER) /home/$(USER) %(USERUID) %(USERGID)</cifsmount>
<volume fstype="cifs" server="$default_homedirs_server_fqdn" path="%(USER)" mountpoint=""/> 
</pam_mount>
```

ldap_base_dn
------------

Base domain name to search against in Active Directory.
Should be split into domain components as 'DC=bar,DC=example,DC=co,DC=uk'.

Accepts: String
Default: 'DC=bar,DC=example,DC=co,DC=uk'

ldap_uri
--------

List of servers as URIs to search with ldapsearch. 

Accepts: Array
Default: ['ldap://baz0.bar.example.co.uk','ldap://baz0.bar.example.co.uk','ldap://baz0.bar.example.co.uk']

fallback_homedirs_server
------------------------

The name of the server to fall back to if automatic searching fails.
This should take only the name of the server, not the fully qualified name.
For example, if your server is foo.bar.example.co.uk, then this parameter should
take the value 'foo'.

Accepts: String
Default: 'foo'

custom_mount_options
--------------------

Options used for mount.cifs -o. (eg: iocharset, rw, perm, etc.)

Accepts: Array
Default: ['nobrl','serverino','_netdev']
	
## Limitations

Tested on Ubuntu 14.04 64bit/32bit.

## Release Notes/Contributors/Etc 

0.1.0 - Initial Release
