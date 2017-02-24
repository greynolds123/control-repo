require 'pathname'
require 'ipaddr'

Puppet::Type.newtype(:cobbler_system) do
  desc "Puppet type for cobbler system object"

  ensurable

  # Parameters
  newparam(:name, :namevar => true) do
    desc "A string identifying the system"
    munge do |value|
      value.downcase
    end
    def insync?(is)
      is.downcase == should.downcase
    end
  end

  newproperty(:interfaces) do
    desc "Interfaces for the system"
    defaultto({})
    validate do |value|
      unless value.is_a? Hash
        raise ArgumentError, "interfaces parameter is not a hash"
      end
      # Validating interfaces parameters
      value.each do |interface, params|
        params.each do |param, val|
        case param
        when 'ip_address','if_gateway', 'netmask'
          unless IPAddr.new(val)
            raise ArgumentError, "%s is not a valid IP address" % val
          end
        when 'mac_address'
          unless /^[a-f0-9]{1,2}(:[a-f0-9]{1,2}){5}$/i.match(val) or val == :random
            raise ArgumentError, "%s is not a valid MAC address" % val
          end
        end
        end
      end
    end

    def insync?(is)
      should.each do |interface, params|
        # Return false if interface is not found on the server
        unless is.has_key? interface
          return false
        end
        # Check interface parameters
        params.each do |param, value|
          unless is[interface][param] == value
            return false
          end
        end
      end
      true
    end

    def change_to_s(currentvalue, newvalue)
      result = []
      newvalue.each do |var_name,value|
        if value.is_a? Hash
          result = result << "#{var_name}: #{change_to_s(currentvalue[var_name], value)}"
        else
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
      end
      return result.join(', ')
    end
  end

  newproperty(:profile) do
    desc "Parent profile"
    validate do |value|
      raise ArgumentError, "Profile must be specified"  if value.nil?
    end
  end
  autorequire(:cobbler_profile) do
    self[:profile]
  end

  newproperty(:redhat_management_key) do
    desc "Red Hat authorization key to use to register system"
  end

  newproperty(:redhat_management_server) do
    desc "The RHN Satellite or Spacewalk server to use for registration"
  end

  newproperty(:server) do
    desc "Server Override"
  end

  newproperty(:hostname) do
    desc "System hostname"
  end

  newproperty(:netboot_enabled, :boolean => true) do
    desc "Netboot Enabled (PXE (re)install this machine at next boot?)"
    newvalues(:true, :false)
  end

  validate do
    raise ArgumentError, "Profile is required for system object" if self[:profile].nil? and self[:ensure] == :present
  end

end
