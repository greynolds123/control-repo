require 'spec_helper'

describe 'puppet_enterprise::amq::config::simple_authentication_user', :type => :define do
  before(:each) do
    @title        = 'simple_auth_user-mcollective'
    @brokername   = 'broker1.example'
    @augeas_title = "#{@brokername}: AMQ simpleAuthentication user: #{@title}"

    @params = {
      :groups     => 'admins,devs',
      :password   => 'superSecret',
      :username   => 'foo',
      :brokername => @brokername,
    }

    @changes = [
      "set #attribute/groups '#{@params[:groups]}'",
      "set #attribute/password '#{@params[:password]}'",
      "set #attribute/username '#{@params[:username]}'",
    ]

  end

  let(:title) { @title }
  let(:broker_context) { "/files/etc/puppetlabs/activemq/activemq.xml/beans/broker[#attribute/brokerName='#{@brokername}']" }
  let(:user_context) { "#{broker_context}/plugins/simpleAuthenticationPlugin/users/authenticationUser[#attribute/username='#{@params[:username]}']" }
  let(:params) { @params }

  it { should contain_augeas_with_changes(@augeas_title, @changes) }
  it { should contain_augeas(@augeas_title).with_notify('Service[pe-activemq]') }
  it { should contain_augeas(@augeas_title).with_require("Puppet_enterprise::Amq::Config::Broker[#{@brokername}]") }

  context 'invalid parameter' do
    context 'user_ensure' do
      before(:each) do
        @params.merge!({:user_ensure => 'this tots should raise an error, yo'})
      end

      it { should compile.and_raise_error(/does not match/) }
    end
  end

  context 'with paramater' do
    %w[absent false].each do |param|
      context "user_ensure=#{param}" do
        before(:each) do
          @params.merge!({ :user_ensure => param })
          @changes = "rm #{user_context}"
        end

        it { should contain_augeas_with_changes(@augeas_title, @changes) }
      end
    end
  end
end
