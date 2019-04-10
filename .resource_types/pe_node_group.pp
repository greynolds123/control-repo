# This file was automatically generated on 2019-03-02 14:49:17 -0800.
# Use the 'puppet generate types' command to regenerate this file.

# Type for managing node groups in PE's node classifier.
# 
# If no server, port or prefix parameter is specified, the type
# will first try to load the settings from classifier.yaml. If
# the file does not exist (in the event of a split install), the
# type will then fall back to using the agent's certname as the server.
# 
# The parent parameter can be specified as either the GUID, or name.
# 
# For more documentation, visit:
# https://docs.puppetlabs.com/pe/latest/nc_index.html
# 
# Example:
#   pe_node_group { 'PE Infrastructure':
#     parent  => '00000000-0000-4000-8000-000000000000',
#     refresh_classes => true,
#     classes => {
#       'puppet_enterprise' => {
#         'certificate_authority_host'   => 'ca.example.vm',
#         'puppet_master_host'           => 'master.example.vm',
#         'console_host'                 => 'console.example.vm',
#         'puppetdb_host'                => 'puppetdb.example.vm',
#         'database_host'                => 'puppetdb.example.vm',
#         'pcp_broker_host'              => 'master.example.vm',
#       }
#     },
#   }
# 
#   pe_node_group { 'PE Certificate Authority':
#     parent  => 'PE Infrastructure',
#     rule    => ['or', ['=', 'name', $::pe_install::ca_certname]],
#     classes => {
#       'puppet_enterprise::profile::certificate_authority' => {},
#     }
#   }
Puppet::Resource::ResourceType3.new(
  'pe_node_group',
  [
    # The basic property that the resource should be in.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # The ID of the group
    Puppet::Resource::Param(Any, 'id'),

    # The description of the node group
    Puppet::Resource::Param(Any, 'description'),

    # Whether this node group's environment should override those of other node
    # groups at classification-time.
    # 
    # This key is optional; if it's not provided, the default value of false will be used.
    Puppet::Resource::Param(Any, 'environment_trumps'),

    # The ID or name of the parent group
    Puppet::Resource::Param(Any, 'parent'),

    # Variables set this group's scope
    Puppet::Resource::Param(Any, 'variables'),

    # The condition that must be satisfied for a node to be classified
    # into this node group. The structure of this condition is described in
    # the "Rule Condition Grammar" section at:
    # https://docs.puppetlabs.com/pe/latest/nc_groups.html#rule-condition-grammar.
    Puppet::Resource::Param(Any, 'rule'),

    # An array of certnames that should be pinned to this node group
    Puppet::Resource::Param(Any, 'pinned'),

    # Environment for this group
    Puppet::Resource::Param(Any, 'environment'),

    # Classes applied to this group
    Puppet::Resource::Param(Any, 'classes')
  ],
  [
    # This is the common name for the node group
    Puppet::Resource::Param(Any, 'name', true),

    # Refresh classes before making call
    # 
    # Valid values are `true`, `false`, `yes`, `no`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false', 'yes', 'no']], 'refresh_classes'),

    # The url of the classifier server
    Puppet::Resource::Param(Any, 'server'),

    # The port of the classifier server
    Puppet::Resource::Param(Any, 'port'),

    # The prefix of the classifier server
    Puppet::Resource::Param(Any, 'prefix'),

    # Only add this class if it doesn't already exist in the classifier
    # 
    # Valid values are `true`, `false`, `yes`, `no`.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false', 'yes', 'no']], 'create_only'),

    # The specific backend to use for this `pe_node_group`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ruby
    # :
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
