# Install a Python version via pyenv
#
# Usage:
#
#   python::version { '2.7.3' }
#
define python::version(
  $ensure  = present,
  $version = $title,
) {
  require python

  python { $version:
    ensure     => $ensure,
    pyenv_root => $python::pyenv_root,
    user       => $python::pyenv_user,
  }
}
