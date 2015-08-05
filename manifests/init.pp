# == Class: mounthomedir
#
# Mount the user's home directory. 
#
class mounthomedir (
  $ensure                   = $mounthomedir::params::ensure,
  $homedir_packages         = $mounthomedir::params::homedir_packages,
  $ldap_base_dn             = $mounthomedir::params::ldap_base_dn,
  $ldap_uri                 = $mounthomedir::params::ldap_uri,
  $fallback_homedirs_server = $mounthomedir::params::fallback_homedirs_server,
) inherits mounthomedir::params {

  validate_re($ensure, '^(present|absent)$',"${ensure} is not allowed for the 'ensure' parameter. Allowed values are 'present' and 'absent'.")

  validate_array($homedir_packages,)

  anchor { 'mounthomedir::begin': } ->
  class { '::mounthomedir::install': } ->
  anchor { 'mounthomedir::end': }
}

