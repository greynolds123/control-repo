module AIOAgentBuild
  def self.get_aio_build
    osfamily = Facter.value(:osfamily)
    case osfamily
    when /windows/
      puppet_dir = Facter.value(:env_windows_installdir)
      agent_version_file = "#{puppet_dir}/VERSION"
    else
      agent_version_file = '/opt/puppetlabs/puppet/VERSION'
    end

    if File.readable? agent_version_file and !File.zero? agent_version_file
      agent_version = File.open(agent_version_file, 'r').gets.chomp
      return agent_version
    else
      nil
    end
  end
end
