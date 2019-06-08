sspec file

require 'spec_helper'
require 'rspec'
require 'beaker'


describe('gitprod::remote') do

 context 'with defaults for all parameters' do
    let (:config) {{}}
    set_encoding:'utf-8'
    it do
      expect {
       should copy
       }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

   context 'with default parameters from config' do
   let (:params)  {{ :class => 'gitprod::params' }}
  it { should contain_file('$envdir="/etc/puppetlabs/code/environments/$<-% environment %>/modules"').with(
     {
      'ensure' => 'present',
     }
       )
       }
      end
       end
