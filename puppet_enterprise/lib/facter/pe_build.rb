require_relative '../shared/pe_build'

module PEBuildCustomFact
  def self.add_fact
    Facter.add("pe_build") do
      setcode do
        PEBuild.get_pe_build
      end
    end
  end
end

PEBuildCustomFact.add_fact
