<<<<<<< HEAD
# encoding: utf-8

Puppet::Type.newtype(:tacacs) do
  @doc = 'Enable or disable tacacs functionality'

  apply_to_all

  newparam(:name, namevar: true) do
    desc 'Resource name, not used to manage the device'

    validate do |value|
      if value.is_a? String then super(value)
      else fail "value #{value.inspect} is invalid, must be a String."
      end
    end
  end

  newproperty(:enable) do
    desc 'Enable or disable tacacs functionality [true|false]'
    newvalues(:true, :false)
  end
=======
require_relative '../../puppet_x/puppetlabs/netdev_stdlib/check'
if PuppetX::NetdevStdlib::Check.use_old_netdev_type
  Puppet::Type.newtype(:tacacs) do
    @doc = 'Enable or disable TACACS functionality'

    apply_to_all

    newparam(:name, namevar: true) do
      desc 'Resource name, not used to manage the device'

      validate do |value|
        if value.is_a? String then super(value)
        else raise "value #{value.inspect} is invalid, must be a String."
        end
      end
    end

    newproperty(:enable) do
      desc 'Enable or disable TACACS functionality [true|false]'
      newvalues(:true, :false)
    end
  end
else
  require 'puppet/resource_api'

  Puppet::ResourceApi.register_type(
    name: 'tacacs',
    docs: 'Enable or disable TACACS functionality',
    features: ['canonicalize','simple_get_filter'] + ( Puppet::Util::NetworkDevice.current.nil? ? [] : ['remote_resource'] ),
    attributes: {
      name: {
        type:      'String',
        desc:      'Resource name, not used to manage the device',
        behaviour: :namevar,
        default:   'default'
      },
      enable: {
        type:      'Boolean',
        desc:      'Enable or disable TACACS functionality [true|false]'
      }
    }
  )
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
end
