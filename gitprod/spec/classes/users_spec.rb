sspec file

require 'spec_helper'
require 'rspec'
require 'beaker'


describe('gitprod::users') do

 context 'with defaults for all parameters' do
    let (:users) {{}}
    set_encoding:'utf-8'
    it do
      expect {
       should copy
       }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

   context 'with default parameters from config' do
   let (:params)  {{ :class => 'gitprod::users' }}
  it { should contain_file('/home/git').with(
  {
    'ensure'  => 'directory',
    'user'    => 'git',
    'group'   => 'git',
    'seltype' => 'admin',
    'uid'     => '1111',
    'group'   => '1111',
    'require' => 'Group[group]',
  }
  )
  }
 end
  end
