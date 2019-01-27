# Fact: is_pe, pe_version, pe_major_version, pe_minor_version, pe_patch_version
#
# Purpose: Return various facts about the PE state of the system
#
# Resolution: Uses a regex match against puppetversion to determine whether the
#   machine has Puppet Enterprise installed, and what version (overall, major,
#   minor, patch) is installed.
#
# Caveats:
#
<<<<<<< HEAD
Facter.add("pe_version") do
  setcode do
    puppet_ver = Facter.value("puppetversion")
    if puppet_ver != nil
      pe_ver = puppet_ver.match(/Puppet Enterprise (\d+\.\d+\.\d+)/)
=======
Facter.add('pe_version') do
  setcode do
    puppet_ver = Facter.value('puppetversion')
    if !puppet_ver.nil?
      pe_ver = puppet_ver.match(%r{Puppet Enterprise (\d+\.\d+\.\d+)})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      pe_ver[1] if pe_ver
    else
      nil
    end
  end
end

<<<<<<< HEAD
Facter.add("is_pe") do
  setcode do
    if Facter.value(:pe_version).to_s.empty? then
=======
Facter.add('is_pe') do
  setcode do
    if Facter.value(:pe_version).to_s.empty?
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      false
    else
      true
    end
  end
end

<<<<<<< HEAD
Facter.add("pe_major_version") do
  confine :is_pe => true
  setcode do
    if pe_version = Facter.value(:pe_version)
=======
Facter.add('pe_major_version') do
  confine :is_pe => true
  setcode do
    pe_version = Facter.value(:pe_version)
    if pe_version
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      pe_version.to_s.split('.')[0]
    end
  end
end

<<<<<<< HEAD
Facter.add("pe_minor_version") do
  confine :is_pe => true
  setcode do
    if pe_version = Facter.value(:pe_version)
=======
Facter.add('pe_minor_version') do
  confine :is_pe => true
  setcode do
    pe_version = Facter.value(:pe_version)
    if pe_version
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      pe_version.to_s.split('.')[1]
    end
  end
end

<<<<<<< HEAD
Facter.add("pe_patch_version") do
  confine :is_pe => true
  setcode do
    if pe_version = Facter.value(:pe_version)
=======
Facter.add('pe_patch_version') do
  confine :is_pe => true
  setcode do
    pe_version = Facter.value(:pe_version)
    if pe_version
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      pe_version.to_s.split('.')[2]
    end
  end
end
