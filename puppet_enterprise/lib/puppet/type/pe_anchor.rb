# Namespaced anchor function from puppetlabs-stdlib
# # https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/lib/puppet/type/anchor.rb

Puppet::Type.newtype(:pe_anchor) do
  desc <<-'ENDOFDESC'
  A simple resource type intended to be used as an pe_anchor in a composite class.

  In Puppet 2.6, when a class declares another class, the resources in the
  interior class are not contained by the exterior class. This interacts badly
  with the pattern of composing complex modules from smaller classes, as it
  makes it impossible for end users to specify order relationships between the
  exterior class and other modules.

  The pe_anchor type lets you work around this. By sandwiching any interior
  classes between two no-op resources that _are_ contained by the exterior
  class, you can ensure that all resources in the module are contained.

      class ntp {
        # These classes will have the correct order relationship with each
        # other. However, without pe_anchors, they won't have any order
        # relationship to Class['ntp'].
        class { 'ntp::package': }
        -> class { 'ntp::config': }
        -> class { 'ntp::service': }

        # These two resources "pe_anchor" the composed classes within the ntp
        # class.
        pe_anchor { 'ntp::begin': } -> Class['ntp::package']
        Class['ntp::service']    -> pe_anchor { 'ntp::end': }
      }

  This allows the end user of the ntp module to establish require and before
  relationships with Class['ntp']:

      class { 'ntp': } -> class { 'foo': }
      class { 'foo': } -> class { 'ntp': }

  ENDOFDESC

  newparam :name do
    desc "The name of the pe_anchor resource."
  end

  def refresh
    # We don't do anything with them, but we need this to
    #   show that we are "refresh aware" and not break the
    #   chain of propagation.
  end
end
