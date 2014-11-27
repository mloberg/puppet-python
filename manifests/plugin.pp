# Define: python::plugin
# Parameters:
# $ensure, $source
#
# Usage:
#
#   python::plugin { 'pyenv-version':
#     ensure => 'v20140110.1',
#     source => 'yyuu/pyenv-virtualenv'
#   }
#

define python::plugin (
    $ensure,
    $source,
) {
  require python

  repository { "${python::pyenv::prefix}/plugins/${name}":
    ensure  => $ensure,
    force   => true,
    source  => $source,
    user    => $python::pyenv::user,
  }
}
