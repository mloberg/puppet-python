# Config for Python module
#
class python::params {
  case $::osfamily {
    'Darwin': {
      include boxen::config

      $pyenv_root = "${boxen::config::home}/pyenv"
      $user       = $::boxen_user
    }

    default: {
      $pyenv_root = '/usr/local/share/pyenv'
      $user       = 'root'
    }
  }

  $pyenv_version = 'v0.4.0-20140211'

  $pyenv_plugins = {
    'pyenv-pip-rehash' => {
      'ensure' => 'v0.0.3',
      'source' => 'yyuu/pyenv-pip-rehash',
    }
  }
}
