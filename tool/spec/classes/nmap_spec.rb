require 'spec_helper'

describe('tool::config') do
  let(:facts) {
context 'with defaults for all parameters'  do
    let (:install) {{}}
    set_encoding:'utf-8'
 end
    it do
      it { should_contain_packages('nmap') }
      it { should_contain_ensure('nmap')   }
      it { should_contain_mode('0655')      }
      it { should_contain_version('latest')}.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
latest = Puppet::Util::Execution.execute(
      '"yum" ; "yum -y install nmap"') }
    end
