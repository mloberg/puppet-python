require "puppet/util/execution"

Puppet::Type.type(:python).provide :pyenv do
  include Puppet::Util::Execution

  optional_commands :pyenv => "pyenv"

  def create
    command = [
      "#{root}/bin/pyenv",
      "install",
      @resource[:version]
    ]

    Puppet.notice("Compiling Python #{@resource[:version]}")

    execute command, command_opts
  end

  def destroy
    command = [
      "#{root}/bin/pyenv",
      "uninstall",
      @resource[:version]
    ]

    execute command, command_opts
  end

  def exists?
    File.directory? "#{root}/versions/#{@resource[:version]}"
  end

  def command_opts
    {
      :combine            => true,
      :custom_environment => {
        "PYENV_ROOT" => root
      },
      :failonfail         => true,
      :uid                => Facter[:boxen_user].value
    }
  end

  def root
    @root ||= @resource[:pyenv_root]
  end
end
