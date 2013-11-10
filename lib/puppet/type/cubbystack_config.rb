Puppet::Type.newtype(:cubbystack_config) do

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The filename: section/setting name to manage.'
    newvalues(/\S+: \S+\/\S+/)
  end

  newproperty(:value) do
    desc 'The value of the setting to be defined. If the value starts with
      "--" then ensure will be set to absent.'
    validate do |value|
      @resource[:ensure] = :absent if value.to_s[0..1] == '--'
    end
    munge do |value|
      value = value.to_s.strip
      value.capitalize! if value =~ /^(true|false)$/i
      value
    end
  end

end
