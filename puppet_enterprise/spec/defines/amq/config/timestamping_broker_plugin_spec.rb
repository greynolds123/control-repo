require 'spec_helper'

describe 'puppet_enterprise::amq::config::timestamping_broker_plugin', :type => :define do
  before(:each) do
    @title = 'timestamping broker plugin'
    @brokername = 'broker1.example'
    @augeas_title = "#{@brokername}: AMQ timeStampingBrokerPlugin: #{@title}"

    @params = {
      :brokername => @brokername,
    }

    @changes = [
      "set #attribute/futureOnly 'false'",
      "set #attribute/ttlCeiling '0'",
      "set #attribute/zeroExpirationOverride '0'",
    ]

  end

  let(:title) { @title }
  let(:broker_context) { "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='#{@brokername}']" }
  let(:plugin_context) { "#{broker_context}/plugins/timeStampingBrokerPlugin" }
  let(:params) { @params }

  it { should contain_augeas_with_changes(@augeas_title, @changes) }
  it { should contain_augeas(@augeas_title).with_notify('Service[pe-activemq]') }
  it { should contain_augeas(@augeas_title).with_require("Puppet_enterprise::Amq::Config::Broker[#{@brokername}]") }

  context 'invalid parameter' do
    context 'future_only' do
      before(:each) do
        @params.merge!({:future_only => 'this tots should raise an error, yo'})
      end

      it { should compile.and_raise_error(/is not a boolean/) }
    end

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

    context 'future_only=true' do
      before(:each) do
        @params.merge!({:future_only => true})
        @changes = "set #attribute/futureOnly 'true'"
      end

      it { should contain_augeas_with_changes(@augeas_title, @changes) }
    end

    context 'ttl_ceiling=1000' do
      before(:each) do
        @params.merge!({:ttl_ceiling => 1000})
        @changes = "set #attribute/ttlCeiling '1000'"
      end

      it { should contain_augeas_with_changes(@augeas_title, @changes) }
    end

    context 'zero_expiration_override=1000' do
      before(:each) do
        @params.merge!({:zero_expiration_override => 1000})
        @changes = "set #attribute/zeroExpirationOverride '1000'"
      end

      it { should contain_augeas_with_changes(@augeas_title, @changes) }
    end
  end
end
