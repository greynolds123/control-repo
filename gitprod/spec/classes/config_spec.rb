spec file

require 'spec_helper'
require 'rspec'
require 'beaker'


describe('gitprod::config') do
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
   let (:params)  {{ :class => 'gitprod::config' }}
  it { should contain_file('$::envidr').with(
   {

    'ensure'   => 'directory',
    'owner'    => 'puppet',
    'group'    => 'puppet',
    'seltype'  => 'admin'}
   )

  it { should_contain_subscribe_to('git::params').with(

    'subcribe' => ['git::params'])
   }
   }
   end
  end
