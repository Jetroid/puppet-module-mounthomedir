# == Class: mounthomedir
#
# Mount the user's home directory. 
#
class mounthomedir (
  $ensure                       = $mounthomedir::params::ensure,
  $scripts_ensure               = $mounthomedir::params::scripts_ensure,
  $default_homedirs_server_fqdn = $mounthomedir::params::default_homedirs_server_fqdn,
  $homedir_packages             = $mounthomedir::params::homedir_packages,
  $ldap_base_dn                 = $mounthomedir::params::ldap_base_dn,
  $ldap_uri                     = $mounthomedir::params::ldap_uri,
  $fallback_homedirs_server     = $mounthomedir::params::fallback_homedirs_server,
  $custom_mount_options         = $mounthomedir::params::custom_mount_options,
) inherits mounthomedir::params {

  validate_re($ensure, '^(present|absent)$',"${ensure} is not allowed for the 'ensure' parameter. Allowed values are 'present' and 'absent'.")

  validate_array($homedir_packages,$custom_mount_options, $pam_mount_config, $ldap_uri)

  validate_string($default_homedirs_server_fqdn,$fallback_homedirs_server, $ldap_base_dn)

  anchor { 'mounthomedir::begin': } ->
  class { '::mounthomedir::install': } ->
  anchor { 'mounthomedir::end': }
}

