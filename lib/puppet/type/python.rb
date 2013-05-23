Puppet::Type.newtype :python do
  ensurable do
    newvalue :present do
      provider.create
    end

    newvalue :absent do
      provider.destroy
    end

    defaultto :present
  end

  newparam :version do
    isnamevar

    validate do |value|
      unless value =~ /\A\d+\.\d+\.\d+\z/
        raise Puppet::Error, "Version must be like N.N.N, not #{value}"
      end
    end
  end

  newparam :user do
  end

  newparam :pyenv_root do
  end

  autorequire :repository do
    [@parameters[:pyenv_root].value]
  end

  autorequire :user do
    Array.new.tap do |a|
      if @parameters.include?(:user) && user = @parameters[:user].to_s
        a << user if catalog.resource(:user, user)
      end
    end
  end

  def initialize(*args)
    super
    self[:notify] = [ "Exec[pyenv rehash after python install]" ]
  end
end
