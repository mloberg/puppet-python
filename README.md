# Python Puppet Module for Boxen

[![Build Status](https://travis-ci.org/mloberg/puppet-python.png?branch=master)](https://travis-ci.org/mloberg/puppet-python)

Install Python versions using [pyenv](https://github.com/yyuu/pyenv). Module based off of [puppet-ruby](https://github.com/boxen/puppet-ruby) and [puppet-nodejs](https://github.com/boxen/puppet-nodejs).

## Usage

```puppet
# Install Python versions
python::version { '2.7.10': }
python::version { '3.5.0': }

# Set the global version of Python
class { 'python::global':
  version => '2.7.7'
}

# ensure a certain python version is used in a dir
python::local { '/path/to/some/project':
  version => '3.4.1'
}

# Install the latest version of virtualenv
$version = '3.4.1'
python::package { "virtualenv for ${version}":
  package => 'virtualenv',
  python  => $version,
}
# Install Django 1.6.x
python::package { "django for 2.7.7":
  package => 'django',
  python  => '2.7.7',
  version => '>=1.6,<1.7',
}

# Installing a pyenv plugin
python::plugin { 'pyenv-virtualenvwrapper':
  ensure => 'v20140122',
  source => 'yyuu/pyenv-virtualenvwrapper',
}

# Running a package script
# pyenv-installed gems cannot be run in the boxen installation environment which uses the system
# python. The environment must be cleared (env -i) so an installed python (and packages) can be used in a new shell.
exec { "env -i bash -c 'source /opt/boxen/env.sh && PYENV_VERSION=${version} virtualenv venv'":
  provider => 'shell',
  cwd => "~/src/project",
  require => Python::Package["virtualenv for ${version}"],
}
```

## Required Puppet Modules

* `boxen >= 3.2.0`
* `repository >= 2.1`
* `xquartz`
* `gcc`
* `stdlib`
* `java` (jython)

## Development

Write code. Run `script/cibuild` to test it. Check the `script`
directory for other useful tools.
