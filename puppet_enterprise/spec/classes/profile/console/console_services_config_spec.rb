require 'spec_helper'

describe 'puppet_enterprise::profile::console::console_services_config' do
  before :all do
    @facter_facts = {
      'osfamily'          => 'Debian',
      'operatingsystem'   => 'Debian',
      'lsbmajdistrelease' => '6',
      'puppetversion'     => '3.6.2 (Puppet Enterprise 3.3.0)',
      'pe_server_version' => '4.0.0',
      'is_pe'             => 'true',
      'fqdn'              => 'console.rspec',
      'clientcert'        => 'awesomecert',
      'pe_concat_basedir' => '/tmp/file',
    }

    @params = {
      'certname' => 'console_services.rspec',
      'classifier_url_prefix' => '/classifier-api'
    }
  end

  let(:facts)    { @facter_facts }
  let(:params)   { @params }
  let(:confdir)  { '/etc/puppetlabs/console-services' }
  let(:cert_dir) { '/opt/puppetlabs/server/data/console-services/certs' }
  let(:hiera_config) { nil }

  context "when the parameters are valid" do
    it { should contain_pe_hocon_setting('global.logging-config').with_value('/etc/puppetlabs/console-services/logback.xml') }
    it { should contain_pe_hocon_setting('global.login-path').with_value('/auth/login') }
    it { should contain_file("#{confdir}/bootstrap.cfg") }
    it { should contain_pe_concat("#{confdir}/bootstrap.cfg") }
  end

  context "when configuring jetty SSL" do
    it { should contain_pe_hocon_setting('webserver.console.access-log-config').with_value('/etc/puppetlabs/console-services/request-logging.xml') }
    it { should contain_pe_hocon_setting('webserver.console.host').with_value('127.0.0.1') }
    it { should contain_pe_hocon_setting('webserver.console.port').with_value('4430') }
    it { should contain_pe_hocon_setting('webserver.console.ssl-host').with_value('0.0.0.0') }
    it { should contain_pe_hocon_setting('webserver.console.ssl-cert').with_value("#{cert_dir}/console_services.rspec.cert.pem") }
    it { should contain_pe_hocon_setting('webserver.console.ssl-key').with_value("#{cert_dir}/console_services.rspec.private_key.pem") }
    it { should contain_pe_hocon_setting('webserver.console.ssl-ca-cert').with_value('/etc/puppetlabs/puppet/ssl/certs/ca.pem') }
    it { should contain_pe_hocon_setting('webserver.console.ssl-port').with_value('4431') }
    it { should contain_pe_hocon_setting('webserver.console.client-auth').with_value('none') }
    it { should contain_pe_hocon_setting('webserver.console.max-threads').with_ensure('absent') }
    it { should contain_pe_hocon_setting('webserver.console.request-header-max-size').with_value('65536') }
    it { should contain_pe_hocon_setting('webserver.api.access-log-config').with_value('/etc/puppetlabs/console-services/request-logging.xml') }
    it { should contain_pe_hocon_setting('webserver.api.host').with_value('127.0.0.1') }
    it { should contain_pe_hocon_setting('webserver.api.port').with_value('4432') }
    it { should contain_pe_hocon_setting('webserver.api.ssl-host').with_value('0.0.0.0') }
    it { should contain_pe_hocon_setting('webserver.api.ssl-cert').with_value("#{cert_dir}/console_services.rspec.cert.pem") }
    it { should contain_pe_hocon_setting('webserver.api.ssl-key').with_value("#{cert_dir}/console_services.rspec.private_key.pem") }
    it { should contain_pe_hocon_setting('webserver.api.ssl-ca-cert').with_value('/etc/puppetlabs/puppet/ssl/certs/ca.pem') }
    it { should contain_pe_hocon_setting('webserver.api.ssl-port').with_value('4433') }
    it { should contain_pe_hocon_setting('webserver.api.client-auth').with_value('want') }
    it { should contain_pe_hocon_setting('webserver.api.max-threads').with_ensure('absent') }

    it do
      should contain_pe_hocon_setting('web-router-service."puppetlabs.activity.services/activity-service"').with_value(
        { "route" => '/activity-api',
          "server" => 'api',}
      )
    end
    it do
      should contain_pe_hocon_setting(
        'web-router-service."puppetlabs.activity.services/activity-service"'
      ).with_setting('web-router-service."puppetlabs.activity.services/activity-service"')
    end

    it do
      should contain_pe_hocon_setting('web-router-service."puppetlabs.rbac.services.http.api/rbac-http-api-service"').with_value(
        { "route" => '/rbac-api',
          "server" => 'api',}
      )
    end
    it do
      should contain_pe_hocon_setting(
        'web-router-service."puppetlabs.rbac.services.http.api/rbac-http-api-service"'
      ).with_setting('web-router-service."puppetlabs.rbac.services.http.api/rbac-http-api-service"')
    end

    it do
      should contain_pe_hocon_setting('web-router-service."puppetlabs.pe-console-ui.service/pe-console-ui-service".pe-console-app').with_value(
        { "route" => '/',
          "server" => 'console',}
      )
    end
    it do
      should contain_pe_hocon_setting(
        'web-router-service."puppetlabs.pe-console-ui.service/pe-console-ui-service".pe-console-app'
      ).with_setting('web-router-service."puppetlabs.pe-console-ui.service/pe-console-ui-service".pe-console-app')
    end

    it do
      should contain_pe_hocon_setting('web-router-service."puppetlabs.pe-console-auth-ui.service/pe-console-auth-ui-service".authn-app').with_value(
        { "route" => '/auth',
          "server" => 'console',}
      )
    end
    it do
      should contain_pe_hocon_setting(
        'web-router-service."puppetlabs.pe-console-auth-ui.service/pe-console-auth-ui-service".authn-app'
      ).with_setting('web-router-service."puppetlabs.pe-console-auth-ui.service/pe-console-auth-ui-service".authn-app')
    end

    it do
      should contain_pe_hocon_setting('web-router-service."puppetlabs.classifier.main/classifier-service"').with_value(
        { "route" => '/classifier-api',
          "server" => 'api',}
      )
    end
    it do
      should contain_pe_hocon_setting(
        'web-router-service."puppetlabs.classifier.main/classifier-service"'
      ).with_setting('web-router-service."puppetlabs.classifier.main/classifier-service"')
    end

    it do
      should contain_pe_hocon_setting('web-router-service."puppetlabs.trapperkeeper.services.status.status-service/status-service"').with_value(
        { "route" => '/status',
          "server" => 'api',}
      )
    end
    it do
      should contain_pe_hocon_setting(
        'web-router-service."puppetlabs.trapperkeeper.services.status.status-service/status-service"'
      ).with_setting('web-router-service."puppetlabs.trapperkeeper.services.status.status-service/status-service"')
    end

    context "when status proxy is enabled" do
      before(:each) do
        @params['status_proxy_enabled'] = true
        @params['status_proxy_port'] = 5000
      end

      it do
        should contain_pe_hocon_setting(
          'web-router-service."puppetlabs.trapperkeeper.services.status.status-proxy-service/status-proxy-service"'
        ).with_setting('web-router-service."puppetlabs.trapperkeeper.services.status.status-proxy-service/status-proxy-service"')
      end

      it do
        should contain_pe_hocon_setting('web-router-service."puppetlabs.trapperkeeper.services.status.status-proxy-service/status-proxy-service"').with_value(
          { "route" => '/status',
            "server" => 'status-proxy',}
        )
      end
    end

    context "when status proxy is disabled" do
      before(:each) do
        @params['status_proxy_enabled'] = false
        @params['status_proxy_port'] = 5000
      end

      it do
        should contain_pe_hocon_setting(
          'web-router-service."puppetlabs.trapperkeeper.services.status.status-proxy-service/status-proxy-service"'
        ).with_setting('web-router-service."puppetlabs.trapperkeeper.services.status.status-proxy-service/status-proxy-service"').with_ensure(:absent)
      end

      it do
        should contain_pe_hocon_setting('web-router-service."puppetlabs.trapperkeeper.services.status.status-proxy-service/status-proxy-service"').with_value(
          { "route" => '/status',
            "server" => 'status-proxy',}
        ).with_ensure(:absent)
      end
    end

    context "removal of deprecated web-router-service" do
      it do
        should contain_pe_hocon_setting('web-router-service.remove-rbac-ui-service')
          .with_ensure('absent')
          .with_setting('web-router-service."puppetlabs.rbac-ui.service/rbac-ui-service"')
      end

      it do
        should contain_pe_hocon_setting('web-router-service.remove-helpers-service')
          .with_ensure('absent')
          .with_setting('web-router-service."puppetlabs.proxy.services.proxy/helpers-service"')
      end

      it do
        should contain_pe_hocon_setting('web-router-service.remove-classifier-ui-service')
          .with_ensure('absent')
          .with_setting('web-router-service."puppetlabs.classifier-ui.service/classifier-ui-service"')
      end
    end
  end

  context "when specifying jetty max-threads" do
    before :each do
      @params['tk_jetty_max_threads_api'] = 12
      @params['tk_jetty_max_threads_console'] = 34
    end
    it { should contain_pe_hocon_setting('webserver.api.max-threads').with_value('12') }
    it { should contain_pe_hocon_setting('webserver.console.max-threads').with_value('34') }
  end

  context "when specifying jetty request-header-max-size" do
    before :each do
      @params['tk_jetty_request_header_max_size'] = 42
    end
    it { should contain_pe_hocon_setting('webserver.console.request-header-max-size').with_value('42') }
  end

  context "when specifying an RBAC URL prefix" do
    before :each do
      @params['rbac_url_prefix'] = '/prefix'
    end
    it { should contain_pe_hocon_setting('web-router-service."puppetlabs.rbac.services.http.api/rbac-http-api-service"').with_value(
      { "route" => '/prefix',
        "server" => 'api',})}
  end
end
