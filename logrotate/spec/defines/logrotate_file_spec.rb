require 'spec_helper'

describe 'logrotate::file', :type => :define do

  let(:title) { 'foo' }

  context "when log => '/var/log/foo.log', options => [ 'compress', 'rotate 7' ]" do
    let(:params) { { 'log' => '/var/log/foo.log', 'options' => [ 'compress', 'rotate 7' ] } }

    it { should contain_file('/etc/logrotate.d/foo') }
    it { should contain_file('/etc/logrotate.d/foo').with_content(/\/var\/log\/foo.log/) }
    it { should contain_file('/etc/logrotate.d/foo').with_content(/compress/) }
    it { should contain_file('/etc/logrotate.d/foo').with_content(/rotate 7/) }
  end

  context "when log => '/var/log/foo.log', options => [ 'compress', 'missingok' ], postrate => '/etc/init.d/foo restart'" do
    let(:params) { { 'log' => '/var/log/foo.log', 'options' => [ 'compress', 'missingok' ], 'postrotate' => '/etc/init.d/foo restart' } }

    it { should contain_file('/etc/logrotate.d/foo') }
    it { should contain_file('/etc/logrotate.d/foo').with_content(/\/var\/log\/foo.log/) }
    it { should contain_file('/etc/logrotate.d/foo').with_content(/compress/) }
    it { should contain_file('/etc/logrotate.d/foo').with_content(/missingok/) }
    it { should contain_file('/etc/logrotate.d/foo').with_content(/postrotate\n\s\s\/etc\/init.d\/foo\srestart\nendscript\n/) }
  end

  context "when log => 'blah', options => 'blah', ensure => 'absent'" do
    let(:params) { { 'log' => 'blah', 'options' => 'blah', 'ensure' => 'absent' } }

    it { should contain_file('/etc/logrotate.d/foo').with_ensure('absent') }
  end

  context "when setting template parameter" do
    let(:params) { { :log => '/var/log/foo.log', :template => "logrotate/spec.erb", :options => { 'opt_a' => 'value_a' } } }

    it 'should generate a valid template' do
      content = catalogue.resource('file', '/etc/logrotate.d/foo').send(:parameters)[:content]
      content.should match "template: logrotate/spec.erb"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', '/etc/logrotate.d/foo').send(:parameters)[:content]
      content.should match "value_a"
    end
  end

  context "when setting source parameter" do
    let(:params) { { :log => '/var/log/foo.log', :source => "puppet:///modules/logrotate/spec", :options => { 'opt_a' => 'value_a' } } }
    it { should contain_file('/etc/logrotate.d/foo').with_source('puppet:///modules/logrotate/spec') }
  end
end
