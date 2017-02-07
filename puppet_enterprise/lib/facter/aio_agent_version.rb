require_relative '../shared/aio_build'

module AIOAgentVersionCustomFact
  def self.get_aio_agent_version
    agent_build = AIOAgentBuild.get_aio_build
    if agent_build
      agent_version = agent_build.match(/^(\d+\.\d+\.\d+(\.\d+){0,2})/)
      agent_version[0] if agent_version
    else
      nil
    end
  end


  def self.add_fact
    Facter.add("aio_agent_version") do
      setcode do
        AIOAgentVersionCustomFact.get_aio_agent_version
      end
    end
  end
end

AIOAgentVersionCustomFact.add_fact
