Puppet::Type.newtype(:pyenv_package) do
  @doc = ""

  ensurable

  newparam(:name, :namevar => true) do
    desc ""
  end

  newparam(:package) do
    desc ""
  end

  newparam(:pyenv_version) do
    desc ""
  end

  newparam(:version) do
    desc ""
  end

  newparam(:pyenv_root) do
    desc ""
  end

  autorequire(:exec) do
    "python-install-#{self[:pyenv_version]}"
  end
end
