# Specify the global Python version
#
# Usage:
#
#   class { 'python::global': version => '2.7.3' }
#

class python::global(
  $version = '2.7.10',
) {
  require python

  if is_array($version) {
    $version_list = $version
  } else {
    $version_list = split($version, '[, ]+')
  }
  $version_list_without_system = delete($version_list, 'system')
  if count($version_list_without_system) > 0 {
    ensure_resource('python::version', $version_list_without_system)
    $require = Python::Version[$version_list_without_system]
  } else {
    $require = undef
  }

  file { "${python::pyenv::prefix}/version":
    ensure  => present,
    owner   => $python::user,
    mode    => '0644',
    content => join($version_list, "\n"),
    require => $require,
  }
}
