require_relative '../shared/pe_server_version'

# This only works on server nodes.  It relies on the presence of the file
# /opt/puppetlabs/server/pe_version file which is placed by the
# pe-puppet-enterprise-release package.
module PEServerVersionCustomFact
  def self.add_fact
    Facter.add("pe_server_version") do
      setcode do
        PEServerVersion.get_pe_server_version
      end
    end
  end
end

PEServerVersionCustomFact.add_fact
