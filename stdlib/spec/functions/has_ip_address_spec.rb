require 'spec_helper'

describe 'has_ip_address' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }

  context 'when on Linux Systems' do
    let(:facts) do
      {
        :interfaces => 'eth0,lo',
        :ipaddress => '10.0.0.1',
        :ipaddress_lo => '127.0.0.1',
        :ipaddress_eth0 => '10.0.0.1',
      }
    end

    it { is_expected.to run.with_params('127.0.0.1').and_return(true) }
    it { is_expected.to run.with_params('10.0.0.1').and_return(true) }
    it { is_expected.to run.with_params('8.8.8.8').and_return(false) }
<<<<<<< HEAD
=======
    it { is_expected.to run.with_params('invalid').and_return(false) }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end
end
