# == Fact: pe_concat_basedir
#
# A custom fact that sets the default location for fragments
#
# "${::vardir}/pe_concat/"
#
Facter.add("pe_concat_basedir") do
  setcode do
    File.join(Puppet[:vardir],"pe_concat")
  end
end
