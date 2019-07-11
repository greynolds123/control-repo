require 'spec_helper'

describe 'kubernetes::kubeadm_init', :type => :define do
<<<<<<< HEAD
=======
  let(:pre_condition) { 'include kubernetes' }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  let(:title) { 'kubeadm init' }
  let(:facts) do
    {
      :kernel           => 'Linux',
      :os               => {
        :family => "Debian",
        :name    => 'Ubuntu',
        :release => {
          :full => '16.04',
        },
        :distro => {
          :codename => "xenial",
        },
      },
    }
  end

  context 'with apiserver_advertise_address => 10.0.0.1' do
    let(:params) do
      {
        'config' => '/etc/kubernetes/config.yaml',
        'node_name' => 'kube-master',
        'path' => [ '/bin','/usr/bin','/sbin'],
        'env' => [ 'KUBECONFIG=/etc/kubernetes/admin.conf'],
      }
    end
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_exec('kubeadm init').with_command("kubeadm init --config '/etc/kubernetes/config.yaml'")}
<<<<<<< HEAD
=======
    it { is_expected.to contain_kubernetes__wait_for_default_sa('default')}
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  end
end