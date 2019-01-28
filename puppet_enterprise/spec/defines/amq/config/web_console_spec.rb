require 'spec_helper'

describe 'puppet_enterprise::amq::config::web_console', :type => :define do
  before(:each) do
    @title        = 'webconsole'
    @augeas_title = "AMQ webConsole: #{@title}"
    @console_config_file = 'foo.xml'
    @params = {
      :console_config_file => @console_config_file,
    }

    @changes      = "set #attribute/resource '#{@console_config_file}'"
  end

  let(:title) { @title }
  let(:console_context) { "/files/etc/puppetlabs/activemq/activemq.xml/beans/import[#attribute/resource='#{@console_config_file}']" }
  let(:params) { @params }

  it { should contain_augeas_with_changes(@augeas_title, @changes) }
  it { should contain_augeas(@augeas_title).with_notify('Service[pe-activemq]') }

  context 'invalid parameter' do
    context 'console_ensure' do
      before(:each) do
        @params.merge!({:console_ensure => 'this tots should raise an error, yo'})
      end

      it { should compile.and_raise_error(/does not match/) }
    end
  end

  context 'with paramater' do
    %w[absent false].each do |param|
      context "console_ensure=#{param}" do
        before(:each) do
          @params.merge!({ :console_ensure => param })
          @changes = "rm #{console_context}"
        end

        it { should contain_augeas_with_changes(@augeas_title, @changes) }
      end
    end
  end
end
