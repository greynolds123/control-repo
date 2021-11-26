# Facter.add("pe_razor_server_version") do
#   confine :osfamily => "Debian"
#   setcode do
#     # Use `pipefail` to retrieve the correct exit code.
#     Facter::Core::Execution.exec(<<-QUERY)
#       bash -o pipefail -c "dpkg-query -W --showformat='$\{Version}' pe-razor-server | cut -f1 -d'-'"
#       QUERY
#   end
# end

Facter.add('pe_razor_server_version') do
  confine osfamily: 'RedHat'
  setcode do
    # rpm command returns exit code 1 if not installed, which facter treats as nil
    Facter::Core::Execution.exec("rpm -q --qf '%{version}' pe-razor-server")
  end
end

# Facter.add("pe_razor_server_version") do
#   confine :operatingsystem => "SLES"
#   setcode do
#     Facter::Core::Execution.exec("rpm -q --qf '%{version}' pe-razor-server")
#   end
# end
