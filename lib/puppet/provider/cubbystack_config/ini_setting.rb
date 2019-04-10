require 'facter'

Puppet::Type.type(:cubbystack_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def exists?
    immutable_string = Facter.value(:os_immutable) || '<_IMMUTABLE_>'
    if resource[:value][0].to_s[0..1] == '--'
      resource[:ensure] = :absent
    elsif resource[:value] == immutable_string or resource[:value] == [immutable_string]
      resource[:value] = value
      # when the value is undefined, we keep it that way.
      if value.nil? or (value.kind_of?(Array) and value[0].nil?)
        resource[:ensure] = :absent
      end
    end
    super
  end

  def section
    resource[:name].split(/\s*:\s*/, 2).last.split('/', 2).first
  end

  def setting
    resource[:name].split(/\s*:\s*/, 2).last.split('/', 2).last
  end

  def separator
    '='
  end

  def file_path
    resource[:name].split(/\s*:\s*/, 2).first
  end

  def path
    file_path
  end

  def value
    val = super
    if val.length > 1
      val
    elsif val.length == 1
      val[0]
    else
      nil
    end
  end
end
