require 'spec_helper'

describe 'puppet_enterprise::amq::config::destination_policy_entry', :type => :define do
  before(:each) do
    @title = 'authorization-topic=mcollective.>'
    @brokername = 'broker1.example'
    @augeas_title = "#{@brokername}: AMQ destinationPolicyEntry: #{@title}"

    @params = {
      :destination_type   => 'topic',
      :target_destination => '>',
      :brokername         => @brokername,
    }

    @changes = [
      "set #attribute/producerFlowControl 'true'",
      "set #attribute/gcInactiveDestinations 'false'",
    ]

  end

  let(:title) { @title }
  let(:broker_context) { "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='#{@brokername}']" }
  let(:entry_context) { "#{broker_context}/destinationPolicy/policyMap/policyEntries/policyEntry[#attribute/#{@params[:destination_type]}='#{@params[:target_destination]}']" }
  let(:params) { @params }

  it { should contain_augeas_with_changes(@augeas_title, @changes) }
  it { should contain_augeas(@augeas_title).with_notify('Service[pe-activemq]') }
  it { should contain_augeas(@augeas_title).with_require("Puppet_enterprise::Amq::Config::Broker[#{@brokername}]") }

  context 'invalid parameter' do
    %w[destination_type entry_ensure inactive_timout_before_gc memory_limit].each do |param|
      context "#{param}" do
        before(:each) do
          @params.merge!({param.to_sym => 'this tots should raise an error, yo'})
        end

        it { should compile.and_raise_error(/expects a.* got String/) }
      end
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

    context "memory_limit=5mb" do
      before(:each) do
        @params.merge!({ :memory_limit => '5mb' })
        @changes << "set #attribute/memoryLimit '5mb'"
      end

      it { should contain_augeas_with_changes(@augeas_title, @changes) }
    end

    context "inactive_timout_before_gc=5" do
      before(:each) do
        @params.merge!({ :inactive_timout_before_gc => 5 })
        @changes << "set #attribute/inactiveTimoutBeforeGC '5'"
      end

      it { should contain_augeas_with_changes(@augeas_title, @changes) }
    end

    context 'additional attributes' do
      before(:each) do
        @params.merge!({
          :additional_attributes => {
            'advisoryWhenFull' => 'true',
          }
        })
        @changes << 'set #attribute/advisoryWhenFull true'
      end

      it { should contain_augeas_with_changes(@augeas_title, @changes) }
    end
  end
end
