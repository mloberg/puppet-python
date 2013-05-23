# Python Puppet Module for Boxen

[![Build Status](https://travis-ci.org/mloberg/puppet-python.png?branch=master)](https://travis-ci.org/mloberg/puppet-python)

Install Python versions using [pyenv](https://github.com/yyuu/pyenv). Module based off of [puppet-nodejs](https://github.com/boxen/puppet-nodejs).

## Usage

```puppet
include python::2_7_3
include python::3_3_0

# Install any arbitrary Python version
python { '2.6.8': }

# Install a Python package
python::package { 'virtualenv':
  python_version => '2.7.3',
}

# Set the global version of Python
class { 'python::global': version => '2.7.3' }

# Set version of Python within a specific directory
python::local { '/path/to/directory': version => '3.3.0' }
```

## Required Puppet Modules

* `boxen`
* `repository`
* `stdlib`

## Development

Write code. Run `script/cibuild` to test it. Check the `script`
directory for other useful tools.
