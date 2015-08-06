# Default parameters
class mounthomedir::params {

  $ensure = 'present'
  $scripts_ensure = $ensure
  $pam_mount_config = [
      ['debug', {'enable' =>  '"0"'}],
      [path, '"/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"'],
      # Custom mount/unmount scripts; these automatically find the user's 
      # home filestore location etc.
      ['cifsmount','doautomount %(USER) %(MNTPT) %(USERUID) %(USERGID)'],
      ['umount','"doautounmount %(MNTPT)"'],
      # Always cifs mount home directories; use server in $default_homedirs_server_fqdn (eg: foo.bar.example.co.uk) by default.
      ['volume', {
        'fstype'     => '"cifs"',
        'server'     => "\"${default_homedirs_server_fqdn}\"",
        'path'       => '"%(USER)"',
        'mountpoint' => '"~"',}
      ]
      # Note for Future People from Space: do not set sgrp
      # to Domain Users in the volume tag. It'll get cached
      # with only the previous people it's seen in that group,
      # and people won't be able to mount homedirs.
    ]
  
  # Packages needed for samba-mounted home directories.
  case $osfamily {
    /Debian/: {
      $homedir_packages = [
        'cifs-utils',
        'libgssapi-krb5-2',
        'samba-common-bin',
        'keyutils',
        'libsasl2-modules-gssapi-mit',
        'ldap-utils',
        'krb5-user',
      ]
    }
    /RedHat/: {
      $homedir_packages = [
        'cifs-utils',
        #'libgssapi-krb5-2',
        'samba-common',
        'keyutils',
        #'libsasl2-modules-gssapi-mit',
        'openldap-clients',
        'krb5-workstation',
      ]
    }
    /Default/: {
      fail('mounthomedir only supports Debian and RedHat OS families.')
    }
  }

  $ldap_base_dn = 'DC=bar,DC=example,DC=co,DC=uk'

  $ldap_uri = ['dc=bar','dc=example','dc=co','dc=uk']

  #If homedirs server is foo.bar.example.co.uk, use foo.
  #Server to use if all else fails.
  $fallback_homedirs_server = 'foo'

  $default_homedirs_server_fqdn = 'foo.bar.example.co.uk'

  $custom_mount_options = ['nobrl','serverino','_netdev']

}
