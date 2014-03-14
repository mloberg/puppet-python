# Install a Python version via pyenv
#
# Usage:
#
#   python::version { '2.7.3': }
#

define python::version(
  $ensure  = 'installed',
  $env     = {},
  $version = $name,
) {
  require python

  case $version {
    /jython/: { require java }
    default: { }
  }

  case $::osfamily {
    'Darwin': {
      require xquartz
      include homebrew::config
      include boxen::config

      $os_env = {
        'CFLAGS'  => "-I${homebrew::config::installdir}/include -I/opt/X11/include",
        'LDFLAGS' => "-L${homebrew::config::installdir}/lib -L/opt/X11/lib",
      }
    }

    default: {
      $os_env = {}
    }
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
    }

    Exec["python-install-${version}"] {
      environment +> sort(join_keys_to_values($final_env, '='))
    }
  }
}
