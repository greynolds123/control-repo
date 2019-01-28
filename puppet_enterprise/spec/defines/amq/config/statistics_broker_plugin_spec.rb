require 'spec_helper'

describe 'puppet_enterprise::amq::config::statistics_broker_plugin', :type => :define do
  before(:each) do
    @title = 'statisticsBrokerPlugin'
    @brokername = 'broker1.example'
    @augeas_title = "#{@brokername}: AMQ statisticsBrokerPlugin: #{@title}"

    @params = {
      :brokername         => @brokername,
    }

    @changes = []

  end

  let(:title) { @title }
  let(:broker_context) { "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='#{@brokername}']" }
  let(:plugin_context) { "#{broker_context}/plugins/statisticsBrokerPlugin" }
  let(:params) { @params }

  it { should contain_augeas(@augeas_title).with_notify('Service[pe-activemq]') }
  it { should contain_augeas(@augeas_title).with_require("Puppet_enterprise::Amq::Config::Broker[#{@brokername}]") }

  context 'invalid parameter' do
    context 'plugin_ensure' do
      before(:each) do
        @params.merge!({:plugin_ensure => 'this tots should raise an error, yo'})
      end

      it { should compile.and_raise_error(/does not match/) }
    end
  end

  context 'with paramater' do
    %w[absent false].each do |param|
      context "plugin_ensure=#{param}" do
        before(:each) do
          @params.merge!({ :plugin_ensure => param })
          @changes = "rm #{plugin_context}"
        end

        it { should contain_augeas_with_changes(@augeas_title, @changes) }
      end
    end

    context "plugin_ensure=present" do
      before(:each) do
        @params.merge!({ :plugin_ensure => 'present' })
        @changes = "set #{plugin_context} ''"
      end

      it { should contain_augeas_with_changes(@augeas_title, @changes) }
    end
  end
end
