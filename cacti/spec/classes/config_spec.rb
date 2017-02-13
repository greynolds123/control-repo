require 'spec_helper'

required_params = "database_root_pass => 'root_password', database_pass => 'cacti_password',"

describe 'cacti::config' do
  on_supported_os({
    :hardwaremodels => ['x86_64'],
    :supported_os   => [
      {
        "operatingsystem" => "RedHat",
        "operatingsystemrelease" => [
          "7",
        ]
      }
    ],
  }).each do |os, facts|
      context "on #{os}" do
        let(:pre_condition) { "class {'cacti': #{required_params}}" }
        let(:facts) do
          facts
        end
        let(:params) do
          {
          }
        end
        it do
          is_expected.to contain_file('/etc/cacti/db.php').
            with({"ensure"=>"present",
                  "content"=>/.*\$database_type\s=\s\"mysql\";\s\$database_default\s=\s\"cacti\";\s\$database_hostname\s=\s\"localhost\";\s\$database_username\s=\s\"cacti\";\s\$database_password\s=\s\"cacti_password\";\s*\$database_port\s=\s\"3306\";\s\$database_ssl\s=\sfalse;.*/m,
                  "mode"=>"0640",
                  "owner"=>"cacti",
                  "group"=>"apache"})
        end
        it do
          is_expected.to contain_augeas('cacti_perms').
            with({"incl"=>"/etc/httpd/conf.d/cacti.conf",
                  "lens"=>"Httpd.lns",
                  "context"=>"/files/etc/httpd/conf.d/cacti.conf"})
        end
        it do
          is_expected.to contain_cron__job('cacti').
            with({"minute"=>"*/5",
                  "command"=>"/usr/bin/php /usr/share/cacti/poller.php > /dev/null 2>&1",
                  "user"=>"cacti"})
        end
      end
    end
end
