require 'spec_helper'
describe 'kubernetes::repos', :type => :class do

  
  context 'with osfamily => Ubuntu' do
    let(:facts) do
      {
        :operatingsystem => 'Ubuntu',
        :osfamily => 'Debian',
        :os               => {
          :name    => 'Ubuntu',
          :release => {
            :full => '16.04',
          },
        },
      }
    end

    let(:params) { { 'container_runtime' => 'docker' } }

    it { should contain_apt__source('kubernetes').with(
      :ensure   => 'present',
      :location => 'http://apt.kubernetes.io',
      :repos    => 'main',
      :release  => 'kubernetes-xenial',
      :key      => { 'id' => '54A647F9048D5688D7DA2ABE6A030B21BA07F4FB', 'source' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg' }
    ) }

    it { should contain_apt__source('docker').with(
      :ensure   => 'present',
      :location => 'https://apt.dockerproject.org/repo',
      :repos    => 'main',
      :release  => 'ubuntu-xenial',
      :key      => { 'id' => '58118E89F3A912897C070ADBF76221572C52609D', 'source' => 'https://apt.dockerproject.org/gpg' }
    ) }

  end

  context 'with osfamily => RedHat and manage_epel => true' do
    let(:facts) do
      {
        :operatingsystem => 'RedHat',
        :osfamily => 'RedHat',
        :operatingsystemrelease => '7.0',
      }
    end

    let(:params) { { 'container_runtime' => 'docker' } }

    it { should contain_yumrepo('docker') }
    it { should contain_yumrepo('kubernetes') }
  end
end
