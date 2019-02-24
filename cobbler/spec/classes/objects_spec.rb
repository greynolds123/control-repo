#require 'spec_helper'
#
#describe('cobbler::objects') do
#
#  context 'with defaults for all parameters' do
#    let (:params) {{}}
#
#    it { should compile }
#  end
#
#  context 'with default parameters from init' do
#  let (:params) {
#    {
#      'distros'  => {
#        'testdistro1' => {
#          'ensure'                 => 'present',
#          'arch'                   => 'x86_64',
#          'path'                   => '/mnt',
#          'initrd'                => '/var/www/cobbler/ks_mirror/centos7-minimal-x86_64/images/pxeboot/initrd.img',
#          'kernel'                 => '/var/www/cobbler/ks_mirror/centos7-minimal-x86_64/images/pxeboot/vmlinuz',
#          'owners'                 => ['admin'],
#          'comment'                => 'CentOS7 Minimal Distribution',
#        }
#      },
#      'repos'    => {
#        'testrepo1' => {
#          'mirror' => 'http://path/to/repo'
#        },
#        'testrepo2' => {
#          'mirror'         => '/some/local/repo/',
#          'mirror_locally' => false,
#        }
#      },
#      'profiles' => {
#        'testprofile1' => {
#          'ensure' => 'present',
#          'distro' => 'testdistro1',
#          'repos'  => ['testrepo1', 'testrepo2'],
#    }
#      },
#      'systems'  => {
#        'testhost1' => {
#          'ensure'     => 'present',
#          'profile'    => 'testprofile1',
#          'interfaces' => {
#            'eth0'       => {
#              'ip_address' => '192.168.1.6',
#              'netmask'    => '255.255.255.0',
#              'if_gateway' => '192.168.1.1',
#            },
#            'eth1'       => {
#              'ip_address' => '192.168.100.10',
#              'netmask'    => '255.255.255.0',
#              'if_gateway' => '192.168.100.1',
#            },
#            'eth2'       => {
#              'ip_address' => '192.168.200.11',
#              'netmask'    => '255.255.255.0',
#              'if_gateway' => '192.168.200.1',
#            }
#          },
#          'hostname'   => 'testhost1',
#        }
#      },
#    }
#  }
#
#  it { should contain_cobbler_distro('testdistro1') }
#  it { should contain_cobbler_repo('testrepo1') }
#  it { should contain_cobbler_repo('testrepo2') }
#  it { should contain_cobbler_profile('testprofile1') }
#  it { should contain_cobbler_system('testsystem1') }
#
#  end
#end
