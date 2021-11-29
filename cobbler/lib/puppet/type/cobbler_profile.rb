require 'pathname'

Puppet::Type.newtype(:cobbler_profile) do
  desc "Puppet type for cobbler profile object"

  ensurable

  # Parameters
  newparam(:name, :namevar => true) do
    desc "A string identifying the profile"
    munge do |value|
      value.downcase
    end
    def insync?(is)
      is.downcase == should.downcase
    end
  end

  newproperty(:kickstart) do
    desc "Path to kickstart template"
    validate do |value|
      if value
        unless Pathname.new(value).absolute? 
          raise ArgumentError, "%s is not a valid path" % value
        end
      end
    end
  end
  autorequire(:file) do
    self[:kickstart] if self[:kickstart] and Pathname.new(self[:kickstart]).absolute?
  end

  # Properties
  newproperty(:distro) do
    desc "Distribution (Parent distribution)"
    validate do |value|
      raise ArgumentError, "%s is not valid value for distro" % value  unless value
    end
  end
  autorequire(:cobbler_distro) do
    self[:distro] if self[:distro]
  end

  newproperty(:dhcp_tag) do
    desc 'DHCP tags for multiple networks usage'
    defaultto('default')
  end

  newproperty(:repos, :array_matching => :all) do
    defaultto([])
    desc "Repos to auto-assign to this profile"
  end
  autorequire(:cobbler_repo) do
    self[:repos] if self[:repos]
  end

  newproperty(:kopts) do
    desc "Kernel Options"
    defaultto({})
    validate do |value|
      unless value.is_a? Hash
        raise ArgumentError, "Kopts parameter accepts only Hash"
      end
    end
  end

  newproperty(:kopts_post) do
    desc "Governs kernel options on the installed OS"
    defaultto({})
    validate do |value|
      unless value.is_a? Hash
        raise ArgumentError, "Kopts_post parameter accepts only Hash"
      end
    end
  end

  newproperty(:ksmeta) do
    desc "Sets variables available for use in templates"
    defaultto({})
    validate do |value|
      unless value.is_a? Hash
        raise ArgumentError, "ksmeta parameter accepts only a Hash"
      end
    end
    def change_to_s(currentvalue, newvalue)
      result = []
      newvalue.each do |var_name,value|
        if (not currentvalue.has_key?(var_name)) or currentvalue[var_name] != value
          if var_name =~ /^.*(password|secret|key).*$/
            new_value = "[new password redacted]"
            old_value = "[old password redacted]"
          else
            new_value = value
            old_value = currentvalue[var_name]
          end
          result = result << "#{var_name}: #{old_value} -> #{new_value}"
        end
      end
      return result.join(', ')
    end

    def is_to_s(currentvalue)
      result = []
      currentvalue.each do |var_name,value|
        if var_name =~ /^.*(password|secret|key).*$/
          old_value = "[old password redacted]"
        else
          old_value = value
        end
          result = result << "#{var_name} => #{old_value}"
      end
      return result.join(', ')
    end

    def should_to_s(newvalue)
      result = []
      newvalue.each do |var_name,value|
        if var_name =~ /^.*(password|secret|key).*$/
          new_value = "[new password redacted]"
        else
          new_value = value
        end
          result = result << "#{var_name} => #{new_value}"
      end
      return result.join(', ')
    end

  end

  newproperty(:virt_cpus) do
    desc "How many virtual CPUs should koan give the virtual machine"
    validate do |value|
      unless value.is_a? Integer
        raise ArgumentError, "Virt_cpus parameter accepts only integer value"
      end
    end
  end

  newproperty(:virt_ram) do
    desc "How many megabytes of RAM to consume"
    validate do |value|
      unless value.is_a? Integer
        raise ArgumentError, "Virt_ram parameter accepts only integer value"
      end
    end
  end

  newproperty(:virt_type) do
    desc "Virtualization technology to use"
    newvalues(
      :xenpv,
      :xenfv,
      :qemu,
      :kvm,
      :vmware,
      :openvz
    )
  end

  validate do
    raise ArgumentError, "Distro must be defined for profile" if self[:ensure] == :present and self[:distro].nil?
  end

end
