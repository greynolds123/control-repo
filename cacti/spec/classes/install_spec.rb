require 'spec_helper'

required_params = "database_root_pass => 'root_password', database_pass => 'cacti_password',"

describe 'cacti::install' do
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
        case os
        when "redhat-7-x86_64"
          it do
            is_expected.to contain_package('cacti').
              with({"ensure"=>"present"})
          end

        end
      end
    end
end
