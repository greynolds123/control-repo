# This file was automatically generated on 2017-02-13 04:11:50 -0800.
# Use the 'puppet generate types' command to regenerate this file.

# A simple resource type intended to be used as an pe_anchor in a composite class.
# 
# In Puppet 2.6, when a class declares another class, the resources in the
# interior class are not contained by the exterior class. This interacts badly
# with the pattern of composing complex modules from smaller classes, as it
# makes it impossible for end users to specify order relationships between the
# exterior class and other modules.
# 
# The pe_anchor type lets you work around this. By sandwiching any interior
# classes between two no-op resources that _are_ contained by the exterior
# class, you can ensure that all resources in the module are contained.
# 
#     class ntp {
#       # These classes will have the correct order relationship with each
#       # other. However, without pe_anchors, they won't have any order
#       # relationship to Class['ntp'].
#       class { 'ntp::package': }
#       -> class { 'ntp::config': }
#       -> class { 'ntp::service': }
# 
#       # These two resources "pe_anchor" the composed classes within the ntp
#       # class.
#       pe_anchor { 'ntp::begin': } -> Class['ntp::package']
#       Class['ntp::service']    -> pe_anchor { 'ntp::end': }
#     }
# 
# This allows the end user of the ntp module to establish require and before
# relationships with Class['ntp']:
# 
#     class { 'ntp': } -> class { 'mcollective': }
#     class { 'mcollective': } -> class { 'ntp': }
Puppet::Resource::ResourceType3.new(
  'pe_anchor',
  [

  ],
  [
    # The name of the pe_anchor resource.
    Puppet::Resource::Param(Any, 'name')
  ],
  {
    /(.*)/ => ['name']
  },
  true,
  false)
