require "puppet/util/execution"

Puppet::Type.type(:python_package).provide :pyenv do
  include Puppet::Util::Execution

  def packagelist options = {}
    unless File.directory? @resource[:pyenv_root]
      self.fail "PYENV_ROOT does not exist"
    end

    command = [ pip, "freeze" ]

    begin
      packages = execute(command, command_opts)
      Array.new.tap do |a|
        unless packages.nil?
          packages.split("\n").each do |package|
            match = /(\w*)==(.*)$/.match(package)
            a << {
              :package => match[1],
              :ensure  => match[2],
            }
          end
        end
      end.compact
    rescue Puppet::ExecutionFailure => e
      raise Puppet::Error, "Could not list python packages: #{e}"
    end
  end

  def install
    command = [ pip, "install" ]

    if @resource[:ensure].is_a? Symbol
      command << @resource[:package]
    else
      command << "#{@resource[:package]}#{resource[:ensure]}"
    end

    execute command, command_opts
  end

  def update
    command = [ pip, "install", "--upgrade" ]
    execute command, command_opts
  end

  def query
    packagelist(:justme => @resource[:package]).detect { |r|
      r[:package] == @resource[:package]
    } || {:ensure => :absent}
  end

  def uninstall
    command = [ pip, "uninstall", @resource[:package] ]
    execute command, command_opts
  end

  def command_opts
    {
      :combine            => true,
      :custom_environment => {
        "PYENV_ROOT"      => @resource[:pyenv_root],
        "PYENV_VERSION"   => @resource[:python_version]
      },
      :failonfail         => true,
      :uid                => @resource[:user]
    }
  end

  def pip
    "#{@resource[:pyenv_root]}/shims/pip"
  end
end
