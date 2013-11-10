Puppet::Type.type(:cubbystack_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:ini_setting).provider(:ruby)
) do

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

end
