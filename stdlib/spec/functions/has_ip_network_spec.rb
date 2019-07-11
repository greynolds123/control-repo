require 'spec_helper'

describe 'has_ip_network' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }

  context 'when on Linux Systems' do
    let(:facts) do
      {
        :interfaces => 'eth0,lo',
        :network_lo => '127.0.0.0',
        :network_eth0 => '10.0.0.0',
      }
    end

    it { is_expected.to run.with_params('127.0.0.0').and_return(true) }
    it { is_expected.to run.with_params('10.0.0.0').and_return(true) }
    it { is_expected.to run.with_params('8.8.8.0').and_return(false) }
<<<<<<< HEAD
=======
    it { is_expected.to run.with_params('invalid').and_return(false) }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  end
end
