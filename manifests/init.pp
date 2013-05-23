# Install Pyenv so Python versions can be installed
#
# Usage:
#
#   include python
#
class python(
  $pyenv_root    = $python::params::pyenv_root,
  $pyenv_user    = $python::params::pyenv_user,
  $pyenv_version = $python::params::pyenv_version
) inherits python::params {
  include python::rehash

  if $::osfamily == 'Darwin' {
    include boxen::config

    file { "${boxen::config::envdir}/pyenv.sh":
      source => 'puppet:///modules/python/pyenv.sh',
    }
  }

  repository { $pyenv_root:
    ensure => $pyenv_version,
    source => 'yyuu/pyenv',
    user   => $pyenv_user,
  }

  file { "${pyenv_root}/versions":
    ensure  => directory,
    owner   => $pyenv_user,
    require => Repository[$pyenv_root],
  }
}
