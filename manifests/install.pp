class mounthomedir::install (
  $ensure                       = $mounthomedir::ensure,
  $scripts_ensure               = $mounthomedir::scripts_ensure,
  $pam_mount_config             = $mounthomedir::pam_mount_config,
  $homedir_packages             = $mounthomedir::homedir_packages,
  $ldap_base_dn                 = $mounthomedir::ldap_base_dn,
  $ldap_uri                     = $mounthomedir::ldap_uri,
  $fallback_homedirs_server     = $mounthomedir::fallback_homedirs_server,
  $default_homedirs_server_fqdn = $mounthomedir::default_homedirs_server_fqdn,
  $custom_mount_options         = $mounthomedir::custom_mount_options,
) {

  # Defaults for the two scripts.
  File {
    ensure  => $scripts_ensure,
    owner   => root,
    group   => root,
    mode    => "755",
  }

  # Automounted home directories
  package{$homedir_packages:
    ensure => $ensure,
  }

  class { 'pam_mount':
    ensure => $ensure,
    config => $pam_mount_config,
  }

  file{ '/usr/local/bin/doautomount':
    content => template('mounthomedir/doautomount.erb'),
    require => Class[pam_mount]
  }

  file{ '/usr/local/bin/doautounmount':
    source  => "puppet:///modules/mounthomedir/doautounmount",
    require => Class[pam_mount]
  }
}
