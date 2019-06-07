require 'spec_helper'

required_params = "database_root_pass => 'root_password', database_pass => 'cacti_password',"
services = [ 'httpd', 'snmpd' ]

describe 'cacti::service' do
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
        context "managed_services => #{services}" do
          let(:pre_condition) { "class {'cacti': managed_services => #{services}, #{required_params}}" }
          let(:facts) do
            facts
          end
          let(:params) do
            {
            }
          end
          services.each do |service|
            it do
              is_expected.to contain_service(service).
                with({"ensure"    =>"running",
                      "enable"    =>"true",
                      "hasstatus" =>"true",
                      "hasrestart"=>"true"})
            end
          end
        end
        context "managed_services => []" do
          let(:pre_condition) { "class {'cacti': managed_services => [], #{required_params}}" }
          let(:facts) do
            facts
          end
          let(:params) do
            {
            }
          end
          services.each do |service|
            it do
              is_expected.not_to contain_service(service).
                with({"ensure"    =>"running",
                      "enable"    =>"true",
                      "hasstatus" =>"true",
                      "hasrestart"=>"true"})
            end
          end
        end
      end
    end
end
