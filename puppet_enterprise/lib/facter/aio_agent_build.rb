require_relative '../shared/aio_build'

module AIOAgentBuildCustomFact
  def self.add_fact
    Facter.add("aio_agent_build") do
      setcode do
        AIOAgentBuild.get_aio_build
      end
    end
  end
end

AIOAgentBuildCustomFact.add_fact
