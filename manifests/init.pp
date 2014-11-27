# Install Pyenv so Python versions can be installed
#
# Usage:
#
#   include python
#
class python(
  $prefix   = $python::prefix,
  $user     = $python::user,
) {
  if $::osfamily == 'Darwin' {
    include boxen::config
  }

  include python::pyenv

  if $::osfamily == 'Darwin' {
    boxen::env_script { 'pyenv':
      content  => template('python/pyenv.sh.erb'),
      priority => 'higher'
    }
  }

  file { '/opt/python':
    ensure => directory,
    owner  => $user,
  }

  Class['python::pyenv'] ->
    Python::Version <| |> ->
    Python::Plugin <| |>
}
