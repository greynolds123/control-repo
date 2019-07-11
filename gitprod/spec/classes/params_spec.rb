spec file

require 'spec_helper'
require 'rspec'
require 'beaker'


describe('gitprod::params') do

 context 'with defaults for all parameters' do
    let (:params) {{}}
    set_encoding:'utf-8'
    it do
      expect {
       should copy
       }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

   context 'with default parameters from config' do
   let (:params)  {{ :class => 'gitprod::params' }}
   it { should contain_file('/etc/puppetlabs/code/environments/$<-% environment %>/modules').with(
  {

   'ensure'  => 'directory',
   'seltype' => 'system',
   'seluser' => 'puppet',
   'user'    => 'pe-puppet',
   'group'   => 'pe-puppet'
    }
      )
   }
   end
  end
