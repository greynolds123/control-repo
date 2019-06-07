require 'spec_helper'

describe 'puppet_enterprise::profile::console::proxy' do
  before :each do
    @localcacert = '/etc/puppetlabs/puppet/ssl/certs/ca.pem'

    @params = {
      'certname'                           => 'console_services.rspec',
      'trapperkeeper_proxy_listen_address' => '0.0.0.0',
      'trapperkeeper_proxy_listen_port'    => 1234,
      'ssl_listen_port'                    => 6789,
    }
  end

  let(:confdir) { '/etc/puppetlabs/nginx/conf.d' }
  let(:proxy_conf_file) { "#{confdir}/proxy.conf" }
  let(:cert_dir) { '/opt/puppetlabs/server/data/console-services/certs' }
  let(:console_host) { 'console.rspec' }
  let(:localcacert) { @localcacert }
  let(:params) { @params }
  let(:default_ssl_cert) { "#{cert_dir}/console_services.rspec.cert.pem" }
  let(:default_ssl_priv_key) { "#{cert_dir}/console_services.rspec.private_key.pem" }

  def should_have_directive(name, value)
    should contain_pe_nginx__directive(name).with_value(value)
  end

  context "using this class" do
    it { should contain_class('puppet_enterprise::profile::console::proxy::nginx_conf') }
  end

  context 'invalid parameters' do
    %w[ssl_verify_client ssl_prefer_server_ciphers].each do |param|
      before :each do
        @params[param] = 'this should tots fail'
      end

      it { should compile.and_raise_error(/does not match/) }
    end
  end

  context "when the parameters are valid" do
    it { should_have_directive('server_name', 'console.rspec') }
    it { should_have_directive('listen', '6789 ssl') }
    it { should_have_directive('ssl_certificate', default_ssl_cert) }
    it { should_have_directive('ssl_certificate_key', default_ssl_priv_key) }
    it { should_have_directive('proxy_pass', 'http://0.0.0.0:1234') }
    it { should_have_directive('proxy_redirect', 'http://0.0.0.0:1234 /') }
    it { should_have_directive('proxy_set_header x-forwarded-for', 'X-Forwarded-For $proxy_add_x_forwarded_for') }
    it { should_have_directive('proxy_read_timeout', '120')}
    it { should contain_file(proxy_conf_file).with(:ensure => "file", :owner => "root", :group => "root", :mode => "0644") }
  end

  context "custom proxy read timeout" do
    context "value is set to integer" do
      before :each do
        @params['proxy_read_timeout'] = 99
      end

      it { should_have_directive('proxy_read_timeout', '99')}
    end

    context "value is set to integer string" do
      before :each do
        @params['proxy_read_timeout'] = '99'
      end

      it { should_have_directive('proxy_read_timeout', '99')}
    end

    context "value is set to non-integer" do
      before :each do
        @params['proxy_read_timeout'] = 'infinite'
      end

      it { should compile.and_raise_error(/not an integer/) }
    end

    context "when no ssl_listen_address is given" do
      before :each do
        @params['ssl_listen_address'] = '1.2.3.4'
      end

      it { should_have_directive('listen', '1.2.3.4:6789 ssl') }
      it { should_have_directive('proxy_pass', 'http://0.0.0.0:1234') }
      it { should_have_directive('proxy_redirect', 'http://0.0.0.0:1234 /') }
      it { should contain_file(proxy_conf_file).with(:ensure => "file", :owner => "root", :group => "root", :mode => "0644") }
    end

    context "when 0.0.0.0 ssl_listen_address is given" do
      before :each do
        @params['ssl_listen_address'] = '0.0.0.0'
      end

      it { should_have_directive('listen', '6789 ssl') }
      it { should_have_directive('proxy_pass', 'http://0.0.0.0:1234') }
      it { should_have_directive('proxy_redirect', 'http://0.0.0.0:1234 /') }
      it { should contain_file(proxy_conf_file).with(:ensure => "file", :owner => "root", :group => "root", :mode => "0644") }
    end
  end

  context "custom ssl configurations" do
    context "when browser_ssl_cert and browser_ssl_private_key are set" do
      before :each do
        @params['browser_ssl_cert'] = '/some/path/to/a/browser.cert.pem'
        @params['browser_ssl_private_key'] = '/some/path/to/a/browser.private_key.pem'
      end

      it { should_have_directive('server_name', 'console.rspec') }
      it { should_have_directive('listen', '6789 ssl') }
      it { should_have_directive('ssl_certificate', '/some/path/to/a/browser.cert.pem') }
      it { should_have_directive('ssl_certificate_key', '/some/path/to/a/browser.private_key.pem') }
      it { should_have_directive('proxy_pass', 'http://0.0.0.0:1234') }
      it { should_have_directive('proxy_redirect', 'http://0.0.0.0:1234 /') }
      it { should contain_file(proxy_conf_file).with(:ensure => "file", :owner => "root", :group => "root", :mode => "0644") }
    end

    context "when only browser_ssl_cert is set" do
      before :each do
        @params['browser_ssl_cert'] = '/some/path/to/a/browser.cert.pem'
      end

      it { should compile.and_raise_error(/browser_ssl_private_key must also be set/) }
    end
    context "when only browser_ssl_private_key is set" do
      before :each do
        @params['browser_ssl_private_key'] = '/some/path/to/a/browser.private_key.pem'
      end

      it { should compile.and_raise_error(/browser_ssl_cert must also be set/) }
    end
  end
end
