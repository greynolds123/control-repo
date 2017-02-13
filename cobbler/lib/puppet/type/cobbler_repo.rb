require 'pathname'

Puppet::Type.newtype(:cobbler_repo) do
  desc "Puppet type for cobbler repo object"

  ensurable

  # Parameters
  newparam(:name, :namevar => true) do
    desc "A string identifying the repo"
    munge do |value|
      value.downcase
    end
    def insync?(is)
      is.downcase == should.downcase
    end
  end

  newparam(:reposync) do
    desc "Run reposync upon repo creation"
    defaultto :false
    newvalues(:true, :false)
  end

  # Properties
  newproperty(:mirror) do
    desc "The addresss of the yum mirror"
    validate do |value|
      unless Pathname.new(value).absolute? || value =~ /^(rsync|http(s)?|ftp|rhn):\/\/.*$/
        raise ArgumentError, "%s is not a valid directory or remote location." % value
      end
    end
  end

  newproperty(:arch) do
    desc "Specifies what architecture the repository should use"
    newvalues(:i386, :x86_64, :ia64, :ppc, :ppc64, :s390, :arm, :src)
    defaultto(:x86_64)
  end

  newproperty(:breed) do
    newvalues(:rsync, :rhn, :wget, :yum, :apt, :wget)
    defaultto(:rsync)
  end

  newproperty(:rpmlist, :array_matching => :all) do
    desc "List of package names part of a repo"
    defaultto([])

    def insync?(is)
      is.sort == should.sort
    end
  end

  newproperty(:mirror_locally, :boolean => true) do
    desc "Specifies that this yum repo is to be referenced directly via kickstarts or mirrored locally on the cobbler server"
    newvalues(:true, :false)
    defaultto(:false)
  end

end
