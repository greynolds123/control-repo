require 'spec_helper'

required_params = "database_root_pass => 'root_password', database_pass => 'cacti_password',"

describe 'cacti::mysql' do
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
          is_expected.to contain_class("mysql::server").
            with({"root_password"=>"root_password",
                  "remove_default_accounts"=>true})
        end
        it do
          is_expected.to contain_mysql__db('cacti').
            with({"user"=>"cacti",
                  "password"=>"cacti_password",
                  "host"=>"localhost",
                  "grant"=>["ALL"],
                  "sql"=>"/usr/share/doc/cacti-0.8.8b/cacti.sql"})
        end
      end
    end
end
