class mounthomedir::install (
  $ensure                       = $mounthomedir::ensure,
  $scripts_ensure               = $mounthomedir::scripts_ensure,
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
    config => [
      ['debug', {'enable' =>  '0'}],
      [path, '/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin'],
      # Custom mount/unmount scripts; these automatically find the user's 
      # home filestore location etc.
      ['cifsmount','doautomount %(USER) /home/%(USER) %(USERUID) %(USERGID)'],
      #Alternate:
      #['cifsmount',"mount -t cifs //${fallback_homedirs_server}/%(USER) /home/%(USER) -o ${opts},sec=${sectype}"],
      ['umount','doautounmount /home/%(USER)'],
      #Alternate:
      #['umount','umount /home/%(USER)']
      # Always cifs mount home directories; use server in $default_homedirs_server_fqdn (eg: foo.bar.example.co.uk) by default.
      ['volume', {
        'fstype'     => 'cifs',
        'server'     => "${default_homedirs_server_fqdn}",
        'path'       => '%(USER)',
        'mountpoint' => '',}
      ],
      ['msg-authpw','Please enter your password:'],
      ['msg-sessionpw','Please enter your password:'],
      # Note for Future People from Space: do not set sgrp
      # to Domain Users in the volume tag. It'll get cached
      # with only the previous people it's seen in that group,
      # and people won't be able to mount homedirs.
    ]
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
