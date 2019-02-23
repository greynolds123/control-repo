require 'spec_helper'
 
describe 'logrotate', :type => :class do

  context "when called with default parameters" do

    it { should create_class('logrotate') }
    
    it { should create_package('logrotate') }
    
    it { should create_file('/etc/logrotate.d').with_ensure('directory') }
    
    it { should create_file('/etc/logrotate.conf').with(
      'ensure' => 'file',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0444'
    )}

  end

  context "when setting template parameter" do
    let(:params) { {:template => "logrotate/spec.erb", :options => { 'opt_a' => 'value_a' } } }

    it 'should generate a valid template' do
      content = catalogue.resource('file', '/etc/logrotate.conf').send(:parameters)[:content]
      content.should match "template: logrotate/spec.erb"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', '/etc/logrotate.conf').send(:parameters)[:content]
      content.should match "value_a"
    end
  end

  context "when setting source parameter" do
    let(:params) { {:source => "puppet:///modules/logrotate/spec"} }
    it { should contain_file('/etc/logrotate.conf').with_source('puppet:///modules/logrotate/spec') }
  end
end

