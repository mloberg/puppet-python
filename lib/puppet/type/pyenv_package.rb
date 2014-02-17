Puppet::Type.newtype(:pyenv_package) do
  @doc = "Install a Python package"

  ensurable

  newparam(:name, :namevar => true) do
    desc ""
  end

  newparam(:package) do
    desc "Name of the package to install"
  end

  newparam(:pyenv_version) do
    desc "The Python version to install under"
  end

  newparam(:version) do
    desc "The version of the package to install"
    defaultto '>=0'
  end

  newparam(:pyenv_root) do
    desc "The location of pyenv install"
  end

  autorequire(:exec) do
    "python-install-#{self[:pyenv_version]}"
  end
end
