require 'spec_helper'

describe 'puppet_enterprise::amq::config::authorization_plugin_entry', :type => :define do
  before(:each) do
    @title = 'authorization-topic=mcollective.>'
    @brokername = 'broker1.example'
    @augeas_title = "#{@brokername}: AMQ authorizationPlugin entry: #{@title}"

    @params = {
      :admin              => 'super_admin',
      :destination_type   => 'topic',
      :read               => 'user1',
      :target_destination => 'mcollective.>',
      :write              => 'user2',
      :brokername         => @brokername,
    }

    @changes = [
      "set #attribute/admin '#{@params[:admin]}'",
      "set #attribute/read '#{@params[:read]}'",
      "set #attribute/write '#{@params[:write]}'",
    ]

  end

  let(:title) { @title }
  let(:broker_context) { "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='#{@brokername}']" }
  let(:entry_context) { "#{broker_context}/plugins/authorizationPlugin/map/authorizationMap/authorizationEntries/authorizationEntry[#attribute/#{@params[:destination_type]}='#{@params[:target_destination]}']" }
  let(:params) { @params }

  it { should contain_augeas_with_changes(@augeas_title, @changes) }
  it { should contain_augeas(@augeas_title).with_notify('Service[pe-activemq]') }
  it { should contain_augeas(@augeas_title).with_require("Puppet_enterprise::Amq::Config::Broker[#{@brokername}]") }

  context 'invalid parameter' do
    context 'destination_type' do
      before(:each) do
        @params.merge!({:destination_type => 'this tots should raise an error, yo'})
      end

      it { should compile.and_raise_error(/does not match/) }
    end

    context 'entry_ensure' do
      before(:each) do
        @params.merge!({:entry_ensure => 'this tots should raise an error, yo'})
      end

      it { should compile.and_raise_error(/does not match/) }
    end
  end

  context 'with paramater' do
    %w[absent false].each do |param|
      context "entry_ensure=#{param}" do
        before(:each) do
          @params.merge!({ :entry_ensure => param })
          @changes = "rm #{entry_context}"
        end

        it { should contain_augeas_with_changes(@augeas_title, @changes) }
      end
    end

    %w[queue topic tempQueue tempTopic].each do |type|
      context "destination_type=#{type}" do
        before(:each) do
          @params.merge!({ :destination_type => type })
          @changes << "set #attribute/#{type} '#{@params[:target_destination]}'"
        end

        it { should contain_augeas_with_changes(@augeas_title, @changes) }
      end
    end
  end
end
