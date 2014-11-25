# Install a Python version via pyenv
#
# Usage:
#
#   python::version { '2.7.3': }
#
# Hiera override for CFLAGS and LDFLAGS example:
#
#   python::version::os_env:
#       CFLAGS: -I/opt/X11/include -I/usr/include
#       LDFLAGS: -L/opt/X11/lib

define python::version(
  $ensure  = 'installed',
  $env     = {},
  $version = $name,
  $os_env  = $python::params::os_env,
) {
  require python

  notify { "OS_ENV Settings: ${os_env}": }

  case $version {
    /jython/: { require java }
    default: { }
  }

  case $::osfamily {
    'Darwin': {
      require xquartz
      include homebrew::config
      include boxen::config

    }
    default: { }
  }

  $dest = "${python::pyenv_root}/versions/${version}"

  if $ensure == 'absent' {
    file { $dest:
      ensure => absent,
      force  => true,
    }
  } else {
    $default_env = {
      'CC'         => '/usr/bin/cc',
      'PYENV_ROOT' => $python::pyenv_root,
    }

    $final_env = merge(merge($default_env, $os_env), $env)

    if has_key($final_env, 'CC') {
      case $final_env['CC'] {
        /gcc/: { require gcc }
        default: { }
      }
    }

    exec { "python-install-${version}":
      command  => "${python::pyenv_root}/bin/pyenv install ${version}",
      cwd      => "${python::pyenv_root}/versions",
      provider => 'shell',
      timeout  => 0,
      creates  => $dest,
      user     => $python::user,
      require  => Repository[$python::pyenv_root],
    }

    Exec["python-install-${version}"] {
      environment +> sort(join_keys_to_values($final_env, '='))
    }
  }
}
