# Fact: java_libjvm_path
#
# Purpose: get path to libjvm.so
#
# Resolution:
#   Lists file in java default home and searches for the file
#
# Caveats:
#   Needs to list files recursively. Returns the first match
#
# Notes:
#   None
Facter.add(:java_libjvm_path) do
<<<<<<< HEAD
  confine :kernel => "Linux"
=======
  confine kernel: ['Linux', 'OpenBSD']
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
  setcode do
    java_default_home = Facter.value(:java_default_home)
    java_libjvm_file = Dir.glob("#{java_default_home}/jre/lib/**/libjvm.so")
    if java_libjvm_file.nil? || java_libjvm_file.empty?
      nil
    else
      File.dirname(java_libjvm_file[0])
    end
  end
end
<<<<<<< HEAD

=======
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
