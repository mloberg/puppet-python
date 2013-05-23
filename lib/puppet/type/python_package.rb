Puppet::Type.newtype :python_package do
  ensurable do
    newvalue :installed, :event => :package_installed do
      provider.install
    end

    newvalue :uninstalled, :event => :package_removed do
      provider.uninstall
    end

    newvalue :latest, :event => :package_installed do
      provider.update
    end

    newvalue(/./) do
      current = provider.query[:ensure]

      begin
        provider.install
      rescue => e
        self.fail "Could not install: #{e}"
      end

      unless current == provider.query[:ensure]
        if current == :absent
          :module_installed
        else
          :module_changed
        end
      end
    end

    aliasvalue :present, :installed
    aliasvalue :absent,  :uninstalled

    defaultto :installed

    def retrieve
      provider.query[:ensure]
    end

    def insync?(is)
      @should.each { |should|
        case should
        when :present
          return true unless is == :absent
        when :absent
          return true if is == :absent
        when *Array(is)
          return true
        end
      }
      false
    end
  end

  newparam :name do
    isnamevar
  end

  newparam :package do
  end

  newparam :python_version do
  end

  newparam :pyenv_root do
  end

  newparam :user do
  end

  autorequire :python do
    [@parameters[:python_version].value]
  end

  autorequire :user do
    Array.new.tap do |a|
      if @parameters.include?(:user) && user = @parameters[:user].to_s
        a << user if catalog.resource(:user, user)
      end
    end
  end

  def exists?
    @provider.query[:ensure] != :absent
  end

  def initialize(*args)
    super
    self[:notify] = [ "Exec[pyenv rehash after python package install]" ]
  end
end
