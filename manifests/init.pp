# == Class: mounthomedir
#
# Mount the user's home directory. 
#
class mounthomedir{

	# Defaults for the file resource type.
	File {
		ensure  => present,
		owner   => root,
		group   => root,
	}

	# Packages needed for samba-mounted homedirs
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

	# Automounted home directories
	package{$homedir_packages:
		ensure => present,
	} ->
	Class['pam_mount']
	  ->
	file{ '/usr/local/bin/doautomount':
		mode    => 755,
		source  => "puppet:///modules/mounthomedir/doautomount",
	} ->
	file{ '/usr/local/bin/doautounmount':
		mode    => 755,
		source  => "puppet:///modules/mounthomedir/doautounmount",
	}
}

