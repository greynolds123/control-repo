# A facter fact to determine the root home directory.
# This varies on PE supported platforms and may be
# reconfigured by the end user.
<<<<<<< HEAD

module Facter::Util::RootHome
  class << self
  def get_root_home
    root_ent = Facter::Util::Resolution.exec("getent passwd root")
    # The home directory is the sixth element in the passwd entry
    # If the platform doesn't have getent, root_ent will be nil and we should
    # return it straight away.
    root_ent && root_ent.split(":")[5]
=======
module Facter::Util::RootHome
  class << self
  def returnt_root_home
    root_ent = Facter::Util::Resolution.exec('getent passwd root')
    # The home directory is the sixth element in the passwd entry
    # If the platform doesn't have getent, root_ent will be nil and we should
    # return it straight away.
    root_ent && root_ent.split(':')[5]
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end
  end
end

Facter.add(:root_home) do
<<<<<<< HEAD
  setcode { Facter::Util::RootHome.get_root_home }
=======
  setcode { Facter::Util::RootHome.returnt_root_home }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
end

Facter.add(:root_home) do
  confine :kernel => :darwin
  setcode do
<<<<<<< HEAD
    str = Facter::Util::Resolution.exec("dscacheutil -q user -a name root")
    hash = {}
    str.split("\n").each do |pair|
      key,value = pair.split(/:/)
=======
    str = Facter::Util::Resolution.exec('dscacheutil -q user -a name root')
    hash = {}
    str.split("\n").each do |pair|
      key, value = pair.split(%r{:})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      hash[key] = value
    end
    hash['dir'].strip
  end
end

Facter.add(:root_home) do
  confine :kernel => :aix
  root_home = nil
  setcode do
<<<<<<< HEAD
    str = Facter::Util::Resolution.exec("lsuser -c -a home root")
    str && str.split("\n").each do |line|
      next if line =~ /^#/
      root_home = line.split(/:/)[1]
=======
    str = Facter::Util::Resolution.exec('lsuser -c -a home root')
    str && str.split("\n").each do |line|
      next if line =~ %r{^#}
      root_home = line.split(%r{:})[1]
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end
    root_home
  end
end
