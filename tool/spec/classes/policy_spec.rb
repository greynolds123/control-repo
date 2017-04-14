require 'spec_helper'

   describe('tool::config') do
  let(:facts) {
    {
context 'with defaults for all parameters' do
    let (:policy) {{}}
    set_encoding: utf-8
    it do

    it { should_contain_packages('puppetlabs-policy_engine') }
      it { should_contain_ensure('latest')   }
       }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end
 end

latest = Puppet::Util::Execution.execute(
      "puppet" ; "puppet module install puppetlabs-policy_engine/",
    )

