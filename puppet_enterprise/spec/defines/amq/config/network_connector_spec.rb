require 'spec_helper'

describe 'puppet_enterprise::amq::config::network_connector', :type => :define do
  before(:each) do
    @title = 'broker-1-to-broker-2'
    @brokername = 'broker1.example'
    @augeas_title = "#{@brokername}: AMQ network connector: #{@title}"

    @params = {
      :brokername     => @brokername,
      :connector_name => 'broker-1-to-broker-2',
    }

    @changes = [
      "set #attribute/name '#{@params[:connector_name]}'",
      "set #attribute/uri 'static:(ssl://#{@brokername}:61616)'",
      "set #attribute/userName mcollective",
      "set #attribute/password ",
      "set #attribute/duplex true",
      "set #attribute/decreaseNetworkConsumerPriority true",
      "set #attribute/networkTTL 2",
      "set #attribute/dynamicOnly true",
      "set #attribute/conduitSubscriptions true",
    ]

    @excluded_collectives = ['europe.datacenter', 'asia.datacenter']
    @included_collectives = ['us.datacenter', 'brazil.datacenter']
  end

  let(:title) { @params[:connector_name] }
  let(:pre_condition) { 'include puppet_enterprise::params' }
  let(:params) { @params }

  it { should contain_augeas_with_changes(@augeas_title, @changes) }
  it { should contain_augeas(@augeas_title).with_notify('Service[pe-activemq]') }

  context 'invalid parameters' do
    context 'additional_attributes' do
      before(:each) do
        @params.merge!({:additional_attributes => 'this tots should raise an error, yo'})
      end

      it { should compile.and_raise_error(/is not a Hash/) }
    end
  end

  context 'excluded collectives' do
    context 'as an array' do
      before(:each) do
        @excluded_collectives.each do |excluded|
          @changes << "set excludedDestinations/queue[#attribute/physicalName=#{excluded}.>]/#attribute/physicalName #{excluded}.>"
          @changes << "set excludedDestinations/topic[#attribute/physicalName=#{excluded}.>]/#attribute/physicalName #{excluded}.>"
        end
        @params.merge!({ :excluded_collectives => @excluded_collectives })
      end

      it { should contain_augeas_with_changes(@augeas_title, @changes) }
    end

    context 'as a string' do
      before(:each) do
        @changes << "set excludedDestinations/queue[#attribute/physicalName=foo.>]/#attribute/physicalName foo.>"
        @changes << "set excludedDestinations/topic[#attribute/physicalName=foo.>]/#attribute/physicalName foo.>"
        @params.merge!({ :excluded_collectives => 'foo' })
      end

      it { should contain_augeas_with_changes(@augeas_title, @changes) }
    end

    context 'when a topic' do
      before(:each) do
        @title = 'broker-1-to-broker-2-topic'
        @augeas_title = "#{@brokername}: AMQ network connector: #{@title}"
        @params[:connector_name] = 'broker-1-to-broker-2-topic'

        @changes[0] = "set #attribute/name '#{@params[:connector_name]}'"
        @changes << "set excludedDestinations/queue/#attribute/physicalName >"
      end

      it { should contain_augeas_with_changes(@augeas_title, @changes) }
    end

    context 'when a queue' do
      before(:each) do
        @title = 'broker-1-to-broker-2-queue'
        @augeas_title = "#{@brokername}: AMQ network connector: #{@title}"
        @params[:connector_name] = 'broker-1-to-broker-2-queue'

        @changes[0] = "set #attribute/name '#{@params[:connector_name]}'"
        @changes << "set excludedDestinations/topic/#attribute/physicalName >"
      end

      it { should contain_augeas_with_changes(@augeas_title, @changes) }
    end
  end

  context 'included collectives' do
    context 'as an array' do
      before(:each) do
        @included_collectives.each do |included|
          @changes << "set dynamicallyIncludedDestinations/queue[#attribute/physicalName=#{included}.>]/#attribute/physicalName #{included}.>"
          @changes << "set dynamicallyIncludedDestinations/topic[#attribute/physicalName=#{included}.>]/#attribute/physicalName #{included}.>"
        end
        @params.merge!({ :included_collectives => @included_collectives })
      end

      it { should contain_augeas_with_changes(@augeas_title, @changes) }
    end

    context 'as a string' do
      before(:each) do
        @changes << "set dynamicallyIncludedDestinations/queue[#attribute/physicalName=bar.>]/#attribute/physicalName bar.>"
        @changes << "set dynamicallyIncludedDestinations/topic[#attribute/physicalName=bar.>]/#attribute/physicalName bar.>"
        @params.merge!({ :included_collectives => 'bar' })
      end

      it { should contain_augeas_with_changes(@augeas_title, @changes) }
    end
  end

  context 'excluded and included collectives' do
    before(:each) do
      @excluded_collectives.each do |excluded|
          @changes << "set excludedDestinations/queue[#attribute/physicalName=#{excluded}.>]/#attribute/physicalName #{excluded}.>"
          @changes << "set excludedDestinations/topic[#attribute/physicalName=#{excluded}.>]/#attribute/physicalName #{excluded}.>"
      end
      @included_collectives.each do |included|
          @changes << "set dynamicallyIncludedDestinations/queue[#attribute/physicalName=#{included}.>]/#attribute/physicalName #{included}.>"
          @changes << "set dynamicallyIncludedDestinations/topic[#attribute/physicalName=#{included}.>]/#attribute/physicalName #{included}.>"
      end
      @params.merge!({
        :included_collectives => @included_collectives,
        :excluded_collectives => @excluded_collectives,
      })
    end

    it { should contain_augeas_with_changes(@augeas_title, @changes) }
  end

  context 'additional attributes' do
    before(:each) do
      @params.merge!({
        :additional_attributes => {
          'messageTTL'             => 'asd',
          'bridgeTempDestinations' => false,
        }
      })
      @changes << 'set #attribute/messageTTL asd'
      @changes << 'set #attribute/bridgeTempDestinations false'
    end

    it { should contain_augeas_with_changes(@augeas_title, @changes) }
  end
end
