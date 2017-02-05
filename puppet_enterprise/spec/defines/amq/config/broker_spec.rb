require 'spec_helper'

describe 'puppet_enterprise::amq::config::broker', :type => :define do
  before(:each) do
    @title = 'broker'
    @brokername = 'broker1.example'
    @augeas_title = "#{@brokername}: AMQ broker: #{@title}"

    @params = {
      :brokername         => @brokername,
    }

    @changes = [
      "set #attribute/brokerName '#{@brokername}'",
      "set #attribute/xmlns 'http://activemq.apache.org/schema/core'",
    ]

  end

  let(:title) { @title }
  let(:broker_context) { "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='#{@brokername}']" }
  let(:params) { @params }

  it { should contain_augeas_with_changes(@augeas_title, @changes) }
  it { should contain_augeas(@augeas_title).with_notify('Service[pe-activemq]') }

  context 'invalid parameter' do
    %w[additional_attributes use_jmx persistent].each do |param|
      context "#{param}" do
        before(:each) do
          @params.merge!({param.to_sym => 'this tots should raise an error, yo'})
        end

        it { should compile.and_raise_error(/is not a/) }
      end
    end
  end

  context 'with paramater' do
    %w[absent false].each do |param|
      context "broker_ensure=#{param}" do
        before(:each) do
          @params.merge!({ :broker_ensure => param })
          @changes = "rm #{broker_context}"
        end

        it { should contain_augeas_with_changes(@augeas_title, @changes) }
      end
    end

    context "data_directory=5mb" do
      before(:each) do
        @params.merge!({ :data_directory => '/etc/puppetlabs/fake/path' })
        @changes << "set #attribute/dataDirectory '/etc/puppetlabs/fake/path'"
      end

      it { should contain_augeas_with_changes(@augeas_title, @changes) }
    end

    context "persistent=true" do
      before(:each) do
        @params.merge!({ :persistent => true })
        @changes << "set #attribute/persistent 'true'"
      end

      it { should contain_augeas_with_changes(@augeas_title, @changes) }
    end

    context "use_jmx=false" do
      before(:each) do
        @params.merge!({ :use_jmx => false })
        @changes << "set #attribute/useJmx 'false'"
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
