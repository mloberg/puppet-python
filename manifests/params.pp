# Config for Python module
#
class python::params {
  include boxen::config

  $pyenv_user = $::boxen_user
  $pyenv_root = "${boxen::config::home}/pyenv"

  $pyenv_version = 'v0.2.0'
}
