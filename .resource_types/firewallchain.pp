# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# This type provides the capability to manage rule chains for firewalls.
# 
# Currently this supports only iptables, ip6tables and ebtables on Linux. And
# provides support for setting the default policy on chains and tables that
# allow it.
# 
# **Autorequires:**
# If Puppet is managing the iptables, iptables-persistent, or iptables-services packages,
# and the provider is iptables_chain, the firewall resource will autorequire
# those packages to ensure that any required binaries are installed.
Puppet::Resource::ResourceType3.new(
  'firewallchain',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # This is the action to when the end of the chain is reached.
    # It can only be set on inbuilt chains (INPUT, FORWARD, OUTPUT,
    # PREROUTING, POSTROUTING) and can be one of:
    # 
    # * accept - the packet is accepted
    # * drop - the packet is dropped
    # * queue - the packet is passed userspace
    # * return - the packet is returned to calling (jump) queue
    #            or the default of inbuilt chains
    # 
    # Valid values are `accept`, `drop`, `queue`, `return`.
    Puppet::Resource::Param(Enum['accept', 'drop', 'queue', 'return'], 'policy')
  ],
  [
    # The canonical name of the chain.
    # 
    # For iptables the format must be {chain}:{table}:{protocol}.
    Puppet::Resource::Param(Any, 'name', true),

    # Purge unmanaged firewall rules in this chain
    # 
    # Valid values are `false`, `true`.
    Puppet::Resource::Param(Variant[Boolean, Enum['false', 'true']], 'purge'),

    # Regex to perform on firewall rules to exempt unmanaged rules from purging (when enabled).
    # This is matched against the output of `iptables-save`.
    # 
    # This can be a single regex, or an array of them.
    # To support flags, use the ruby inline flag mechanism.
    # Meaning a regex such as
    #   /foo/i
    # can be written as
    #   '(?i)foo' or '(?i:foo)'
    # 
    # Full example:
    # firewallchain { 'INPUT:filter:IPv4':
    #   purge => true,
    #   ignore => [
    #     '-j fail2ban-ssh', # ignore the fail2ban jump rule
    #     '--comment "[^"]*(?i:ignore)[^"]*"', # ignore any rules with "ignore" (case insensitive) in the comment in the rule
    #   ],
    # }
    Puppet::Resource::Param(Any, 'ignore'),

    # The specific backend to use for this `firewallchain`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # iptables_chain
    # : Iptables chain provider
    # 
    #   * Required binaries: `ebtables-save`, `ebtables`, `ip6tables-save`, `ip6tables`, `iptables-save`, `iptables`.
    #   * Default for `kernel` == `linux`.
    #   * Supported features: `iptables_chain`, `policy`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
