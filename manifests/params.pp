# Default parameters
class mounthomedir::params {

  $ensure = 'present'
  $scripts_ensure = $ensure
  $default_homedirs_server_fqdn = 'foo.bar.example.co.uk'
  #If homedirs server is foo.bar.example.co.uk, use foo.
  #Server to use if all else fails.
  $fallback_homedirs_server = 'foo'

  $custom_mount_options = ['nobrl','serverino','_netdev']
  $opts = join($custom_mount_options, ",")

  $security_type = ['krb5','cruid=%(USERUID)']
  $sectype = join($security_type, ",")
  
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
        #'krb5-user',
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
        #'krb5-workstation',
      ]
    }
    /Default/: {
      fail('mounthomedir only supports Debian and RedHat OS families.')
    }
  }

}
