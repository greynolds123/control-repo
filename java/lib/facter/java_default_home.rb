# Fact: java_default_home
#
# Purpose: get absolute path of java system home
#
# Resolution:
<<<<<<< HEAD
#   Uses `readlink` to resolve the path of `/usr/bin/java` then returns subsubdir
#
# Caveats:
#   Requires readlink
=======
#   Find the real java binary, and return the subsubdir
#
# Caveats:
#   java binary has to be found in $PATH
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
#
# Notes:
#   None
Facter.add(:java_default_home) do
<<<<<<< HEAD
  confine :kernel => 'Linux'
  setcode do
    if Facter::Util::Resolution.which('readlink')
      java_bin = Facter::Util::Resolution.exec('readlink -e /usr/bin/java').strip
      java_default_home = File.dirname(File.dirname(File.dirname(java_bin)))
    end
  end
=======
  confine kernel: ['Linux', 'OpenBSD']
  java_default_home = nil
  setcode do
    java_bin = Facter::Util::Resolution.which('java').to_s.strip
    if java_bin.empty?
      nil
    else
      java_path = File.realpath(java_bin)
      java_default_home = if java_path =~ %r{/jre/}
                            File.dirname(File.dirname(File.dirname(java_path)))
                          else
                            File.dirname(File.dirname(java_path))
                          end
    end
  end
  java_default_home
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
end
