# Default parameters
class mounthomedir::params {

  $ensure = 'present'
  
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

  $ldap_base_dn = 'DC=bar,DC=example,DC=co,DC=uk'

  $ldap_uri = ['dc=bar','dc=example','dc=co','dc=uk']

  #If homedirs server is foo.bar.example.co.uk, use foo. 
  $fallback_homedirs_server = 'foo' 

}
