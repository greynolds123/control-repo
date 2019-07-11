require 'spec_helper'

describe 'is_domain_name' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params(1).and_return(false) }
  it { is_expected.to run.with_params([]).and_return(false) }
  it { is_expected.to run.with_params({}).and_return(false) }
  it { is_expected.to run.with_params('').and_return(false) }
  it { is_expected.to run.with_params('.').and_return(true) }
  it { is_expected.to run.with_params('com').and_return(true) }
  it { is_expected.to run.with_params('com.').and_return(true) }
  it { is_expected.to run.with_params('x.com').and_return(true) }
  it { is_expected.to run.with_params('x.com.').and_return(true) }
  it { is_expected.to run.with_params('foo.example.com').and_return(true) }
  it { is_expected.to run.with_params('foo.example.com.').and_return(true) }
  it { is_expected.to run.with_params('2foo.example.com').and_return(true) }
  it { is_expected.to run.with_params('2foo.example.com.').and_return(true) }
  it { is_expected.to run.with_params('www.2foo.example.com').and_return(true) }
  it { is_expected.to run.with_params('www.2foo.example.com.').and_return(true) }
<<<<<<< HEAD
  describe 'inputs with spaces' do
    it { is_expected.to run.with_params('invalid domain').and_return(false) }
  end
=======
  it { is_expected.to run.with_params(true).and_return(false) }

  describe 'inputs with spaces' do
    it { is_expected.to run.with_params('invalid domain').and_return(false) }
  end

>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  describe 'inputs with hyphens' do
    it { is_expected.to run.with_params('foo-bar.example.com').and_return(true) }
    it { is_expected.to run.with_params('foo-bar.example.com.').and_return(true) }
    it { is_expected.to run.with_params('www.foo-bar.example.com').and_return(true) }
    it { is_expected.to run.with_params('www.foo-bar.example.com.').and_return(true) }
    it { is_expected.to run.with_params('-foo.example.com').and_return(false) }
    it { is_expected.to run.with_params('-foo.example.com.').and_return(false) }
  end
<<<<<<< HEAD
  # Values obtained from Facter values will be frozen strings
  # in newer versions of Facter:
  it { is_expected.to run.with_params('www.example.com'.freeze).and_return(true) }
=======

  # Values obtained from Facter values will be frozen strings
  # in newer versions of Facter:
  it { is_expected.to run.with_params('www.example.com'.freeze).and_return(true) }

>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  describe 'top level domain must be alphabetic if there are multiple labels' do
    it { is_expected.to run.with_params('2com').and_return(true) }
    it { is_expected.to run.with_params('www.example.2com').and_return(false) }
  end
<<<<<<< HEAD
=======

>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  describe 'IP addresses are not domain names' do
    it { is_expected.to run.with_params('192.168.1.1').and_return(false) }
  end
end
