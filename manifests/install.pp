class mounthomedir::install (
  $ensure                   = $mounthomedir::ensure,
  $homedir_packages         = $mounthomedir::homedir_packages,
  $ldap_base_dn             = $mounthomedir::ldap_base_dn,
  $ldap_uri                 = $mounthomedir::ldap_uri,
  $fallback_homedirs_server = $mounthomedir::fallback_homedirs_server,
) {

  # Defaults for the file resource type.
  File {
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => "755",
  }

  # Automounted home directories
  package{$homedir_packages:
    ensure => present,
  }

  file{ '/usr/local/bin/doautomount':
    content => template('mounthomedir/doautomount.erb'),
    require Class['pam_mount'],
  }

  file{ '/usr/local/bin/doautounmount':
    source  => "puppet:///modules/mounthomedir/doautounmount",
    require Class['pam_mount'],
  }
}
