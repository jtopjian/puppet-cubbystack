Puppet::Type.newtype(:cubbystack_config) do

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The filename: section/setting name to manage.'
    newvalues(/\S+: \S+\/\S+/)
  end

  newproperty(:value, :array_matching => :all) do
    desc 'The value of the setting to be defined. If the value starts with
      "--" then ensure will be set to absent.'

    def insync?(is)
      return true if @should.empty?

      if @should.is_a? Array
        if not is.is_a? Array
          if @should.length > 1
            return false
          end

          return true if @should[0] == is
        end
      end

      if @should.is_a? Array and is.is_a? Array
        return (
          is & @should == is or
          is & @should.map(&:to_s) == is
        )
      end

      return false
    end

    munge do |value|
      value = value.to_s.strip
      value.capitalize! if value =~ /^(true|false)$/i
      value
    end
  end

  newparam(:secret, :boolean => true) do
    desc 'Whether to hide the value from Puppet logs. Defaults to `false`.'

    newvalues(:true, :false)

    defaultto false
  end

  newparam(:ensure_absent_val) do
    desc 'A value that is specified as the value property will behave as if ensure => absent was specified'
    nil
  end


end
