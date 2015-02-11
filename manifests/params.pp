# Config for Python module
#
class python::params {
  case $::osfamily {
    'Darwin': {
      include boxen::config

      $pyenv_root = "${boxen::config::home}/pyenv"
      $user       = $::boxen_user

      # Moved from versions.pp -> Provide sane defaults but Hiera can be used to override
      # See versions.pp for docs on how to override this data
      case $::macosx_productversion_major {
        /(10.9|10.10)/: {
          $os_env = {
            'CFLAGS'  => "-I${homebrew::config::installdir}/include -I/opt/X11/include -I${::xcrun_sdk_path}/usr/include",
            'LDFLAGS' => "-L${homebrew::config::installdir}/lib -L/opt/X11/lib",
          }
        }
        default: {
          $os_env = {
            'CFLAGS'  => "-I${homebrew::config::installdir}/include -I/opt/X11/include",
            'LDFLAGS' => "-L${homebrew::config::installdir}/lib -L/opt/X11/lib",
          }
        }
      }
    }
    default: {
      $pyenv_root = '/usr/local/share/pyenv'
      $user       = 'root'
      $os_env     = {}
    }
  }

  $pyenv_version = 'v20141012'

  $pyenv_plugins = {
    'pyenv-pip-rehash' => {
      'ensure' => 'v0.0.4',
      'source' => 'yyuu/pyenv-pip-rehash',
    }
  }
}
