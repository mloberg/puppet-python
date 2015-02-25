# Make sure a specific version of Python is used in a directory
#
# Usage:
#
#   python::local { '/path/to/directory': version => '3.3.0' }
#

define python::local(
  $version = undef,
  $ensure  = present,
) {
  include python

  case $version {
    'system', undef: { $require = undef }

    default: {
      ensure_resource('python::version', $version)
      $require = Python::Version[$version]
    }

  }

  file { "${name}/.pyenv-version":
    ensure => absent
  } -> file { "${name}/.python-version":
    ensure  => $ensure,
    content => "${version}\n",
    replace => true,
    require => $require
  }
}
