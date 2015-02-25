# Install a Python package for a given version of Python
#
# Usage:
#
#   python::package { 'virtualenv==1.11.2 for 2.7.6':
#     package => 'virtualenv'
#     python  => '2.7.6',
#     version => '==1.11.2',
#   }
#

define python::package(
    $package,
    $python,
    $ensure = 'present',
    $version = '>= 0',
) {
  require python

  pyenv_package { $name:
    ensure         => $ensure,
    package        => $package,
    version        => $version,
    pyenv_version  => $python,
    pyenv_root     => $python::pyenv::prefix,
    provider       => pip,
  }
}
