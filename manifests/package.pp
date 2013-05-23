# Install a Python package for a given version of Python
#
# Usage:
#
#   python::pacakge { 'virtualenv': python_version => }'2.7.3' }
#
define python::package(
  $python_version,
  $package = $title,
  $ensure = installed,
) {
  include python
  require join(['python', join(split($python_version, '\.'), '_')], '::')

  python_package { $name:
    ensure         => $ensure,
    package        => $package,
    python_version => $python_version,
    pyenv_root     => $python::pyenv_root,
    user           => $python::pyenv_user,
    provider       => pyenv
  }
}
