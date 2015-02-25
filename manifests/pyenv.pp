# Manage python version with pyenv
#
# Usage:
#     include python::pyenv
#
# Normally internal use only; will automatically included by the `python` class
#
class python::pyenv(
  $ensure = $python::pyenv::ensure,
  $prefix = $python::pyenv::prefix,
  $user   = $python::pyenv::user,
) {
  require python

  repository { $prefix:
    ensure => $ensure,
    force  => true,
    source => 'yyuu/pyenv',
    user   => $user,
  }

  file { "${prefix}/versions":
    ensure  => symlink,
    force   => true,
    backup  => false,
    target  => '/opt/python',
    require => Repository[$prefix],
  }
}
