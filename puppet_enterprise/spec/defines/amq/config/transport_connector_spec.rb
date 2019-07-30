require 'spec_helper'

describe 'puppet_enterprise::amq::config::transport_connector', :type => :define do
  before(:each) do
    @title        = 'ssl'
    @brokername   = 'broker1.example'
    @augeas_title = "#{@brokername}: AMQ transportConnector: #{@title}"

    @params = {
      :brokername     => @brokername,
      :transport_name => 'openwire',
      :transport_uri  => 'ssl://0.0.0.0:61616',
    }

    @changes = [
      "set #attribute/name '#{@params[:transport_name]}'",
      "set #attribute/uri '#{@params[:transport_uri]}'",
    ]

  end

  let(:title) { @title }
  let(:broker_context) { "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='#{@brokername}']" }
  let(:connector_context) { "#{broker_context}/transportConnectors/transportConnector[#attribute/name='#{@params[:transport_name]}']" }
  let(:params) { @params }

  it { should contain_augeas_with_changes(@augeas_title, @changes) }
  it { should contain_augeas(@augeas_title).with_notify('Service[pe-activemq]') }
  it { should contain_augeas(@augeas_title).with_require("Puppet_enterprise::Amq::Config::Broker[#{@brokername}]") }

  context 'invalid parameter' do
    context 'additional_attributes' do
      before(:each) do
        @params.merge!({:additional_attributes => 'this tots should raise an error, yo'})
      end

      it { should compile.and_raise_error(/is not a Hash/) }
    end

    context 'connector_ensure' do
      before(:each) do
        @params.merge!({:connector_ensure => 'this tots should raise an error, yo'})
      end

      it { should compile.and_raise_error(/does not match/) }
    end
  end

  context 'with paramater' do
    %w[absent false].each do |param|
      context "destination_type=#{param}" do
        before(:each) do
          @params.merge!({ :connector_ensure => param })
          @changes = "rm #{connector_context}"
        end

        it { should contain_augeas_with_changes(@augeas_title, @changes) }
      end
    end
  end

  context 'additional attributes' do
    before(:each) do
      @params.merge!({
        :additional_attributes => {
          'updateClusterFilter'     => 'asd',
          'rebalanceClusterClients' => false,
        }
      })
      @changes << 'set #attribute/updateClusterFilter asd'
      @changes << 'set #attribute/rebalanceClusterClients false'
    end

    it { should contain_augeas_with_changes(@augeas_title, @changes) }
  end

  context 'transport options' do
    before(:each) do
      @params.merge!({
        :transport_options => {
          'transport.enabledProtocols' => 'TLSv1,TLSv1.1,TLSv1.2',
          'someOption' => 'withParams',
        }
      })
      @changes = "set #attribute/uri 'ssl://0.0.0.0:61616?transport.enabledProtocols=TLSv1,TLSv1.1,TLSv1.2&amp;someOption=withParams'"
    end

    it { should contain_augeas_with_changes(@augeas_title, @changes) }
  end
end
