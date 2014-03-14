require 'puppet/util/execution'

Puppet::Type.type(:pyenv_package).provide(:pip) do
  include Puppet::Util::Execution
  desc ""

  def path
    [
      "#{@resource[:pyenv_root]}/bin",
      "#{@resource[:pyenv_root]}/plugins/python-build/bin",
      "#{@resource[:pyenv_root]}/shims",
      "#{Facter[:boxen_home].value}/homebrew/bin",
      "$PATH"
    ].join(':')
  end

  def pyenv_package(command)
    full_command = [
      "sudo -u #{Facter[:boxen_user].value}",
      "PATH=#{path}",
      "PYENV_VERSION=#{@resource[:pyenv_version]}",
      "PYENV_ROOT=#{@resource[:pyenv_root]}",
      "#{@resource[:pyenv_root]}/shims/pip #{command}"
    ].join(" ")

    output = `#{full_command}`
    [output, $?]
  end

  def create
    pyenv_package "install '#{@resource[:package]}#{@resource[:version]}'"
  end

  def destroy
    pyenv_package "uninstall -y -q #{@resource[:package]}"
  end

  def exists?
    packagelist, status = pyenv_package "freeze"
    packages = Array.new.tap do |a|
      unless packagelist.nil?
        packagelist.split("\n").each do |package|
          match = /([a-zA-Z0-9_-]*)==(.*)$/.match(package)
          a << {
            :package => match[1].downcase(),
            :version => match[2],
          }
        end
      end
    end.compact

    package = packages.detect { |r| r[:package] == @resource[:package] }

    return false if package.nil?

    version = Gem::Version.new(package[:version])
    @resource[:version].split(',').each do |req|
      if req =~ /^==/
        if Gem::Requirement.new(req.sub(/^==/, '')).satisfied_by?(version)
          return true
        end
      elsif not Gem::Requirement.new(req).satisfied_by?(version)
        return false
      end
    end
    return true
  end
end
