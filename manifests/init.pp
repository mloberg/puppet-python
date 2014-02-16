# Install Pyenv so Python versions can be installed
#
# Usage:
#
#   include python
#
class python(
  $pyenv_plugins    = {},
  $pyenv_version    = $python::params::pyenv_version,
  $pyenv_root       = $python::params::pyenv_root,
  $user             = $python::params::user,
) inherits python::params {

  if $::osfamily == 'Darwin' {
    include boxen::config

    package { 'readline':
      ensure => latest,
    }

    file { "${boxen::config::envdir}/pyenv.sh":
      ensure => absent,
    }

    boxen::env_script { 'pyenv':
      source   => 'puppet:///modules/python/pyenv.sh',
      priority => 'higher'
    }
  }

  repository { $pyenv_root:
    ensure => $pyenv_version,
    source => 'yyuu/pyenv',
    user   => $user,
  }

  file {
    [
      "${pyenv_root}/pyenv.d",
      "${pyenv_root}/pyenv.d/install",
      "${pyenv_root}/shims",
      "${pyenv_root}/versions",
    ]:
      ensure  => directory,
      require => Repository[$pyenv_root],
  }

  $_real_pyenv_plugins = merge($python::params::pyenv_plugins, $pyenv_plugins)
  create_resources('python::plugin', $_real_pyenv_plugins)

  Repository[$pyenv_root] ->
    File <| tag == 'python_plugin_config' |> ->
    Python::Plugin <| |> ->
    Python::Version <| |>
}
