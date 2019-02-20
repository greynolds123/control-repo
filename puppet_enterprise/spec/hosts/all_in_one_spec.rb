require 'spec_helper'

describe 'all_in_one', :type => :host do
  before :each do
    Puppet::Parser::Functions.newfunction(:pe_compiling_server_aio_build, :type => :rvalue) do |args|
      nil
    end

    Puppet::Parser::Functions.newfunction(:puppetdb_query, :type => :rvalue, :arity => 1) do |args|
      []
    end

    @facter_facts = {
      'processors' => {"count"=>8, "speed"=>"2.5 GHz"},
    }
  end
  let(:pre_condition) {}
  let(:facts) { @facter_facts }

  it { should satisfy_all_relationships }
end
