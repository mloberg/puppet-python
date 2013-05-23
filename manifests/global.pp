# Specify the global Python version
#
# Usage:
#
#   class { 'python::global': version => '2.7.3' }
#
class python::global($version = '2.7.3') {
  require python
  require join(['python', join(split($version, '\.'), '_')], '::')

  validate_re($version, '^\d+\.\d+(\.\d+)*$',
    'Version must be of the form N.N.(.N)')

  file { "${python::pyenv_root}/version":
    ensure  => present,
    owner   => $python::pyenv_user,
    mode    => '0644',
    content => "${version}\n",
  }
}
