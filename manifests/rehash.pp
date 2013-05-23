# Add rehash exec hooks after python version install
class python::rehash {
  include python

  exec {
    [
      'pyenv rehash after python install',
      'pyenv rehash after python package install'
    ]:
      refreshonly => true,
      command     => "PYENV_ROOT=${python::pyenv_root} ${python::pyenv_root}/bin/pyenv rehash",
      provider    => shell
  }

  Python <| |> ~>
    Exec['pyenv rehash after python install'] ->
    Python_package <| |>
}
