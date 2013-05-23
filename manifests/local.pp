# Make sure a specific version of Python is used in a directory
#
# Usage:
#
#   python::local { '/path/to/directory': version => '3.3.0' }
#
define python::local(
  $version = undef,
  $path    = $title,
  $ensure  = present
) {
  validate_re($ensure, '^(present|absent)$',
    'Ensure must be one of present or absent')

  if $ensure == present {
    validate_re($version, '^\d+\.\d+(\.\d+)*$',
      'Version must be of the form N.N.(.N)')

    require join(['python', join(split($version, '\.'), '_')], '::')
  }

  validate_absolute_path($path)

  file { "${path}/.python-version":
    ensure  => $ensure,
    content => "${version}\n",
    replace => true,
  }
}
