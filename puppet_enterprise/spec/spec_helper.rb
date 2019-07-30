require 'puppetlabs_spec_helper/module_spec_helper'
require 'matchers/yaml_matchers'
require 'matchers/relationship_matchers'
require 'matchers/augeas_matchers'

# With the upgrade to rspec-puppet 2, spec tests are failing on any classes that
# inherit from puppet_enterprise due to the required parameters. To work around
# the fact that the majority of our classes inherit from puppet_enterprise, use a
# documented-not documented feature of rspec-puppet called pre_condition.  If a
# pre_condition method is defined, it will take what is returned by the method
# and prepend it to the manifest used for catalogue compilation.
#
# For now the pre_condition is defined as a module and included globaly at
# the `spec_helper.rb` level to avoid duplicating the code in the majority
# of classses.
#
# More info:
# https://github.com/rodjek/rspec-puppet/blob/bd8e54e3ae144b57bfd9efca7a8d92a116fa406b/lib/rspec-puppet/support.rb#L92
module Helpers
  def pre_condition
<<-PRE_COND
class {'puppet_enterprise':
  certificate_authority_host   => 'ca.rspec',
  puppet_master_host           => 'master.rspec',
  console_host                 => 'console.rspec',
  puppetdb_host                => 'puppetdb.rspec',
  database_host                => 'database.rspec',
  mcollective_middleware_hosts => ['mco.rspec'],
  pcp_broker_host              => 'pcp_broker.rspec',
}
PRE_COND
  end
end

RSpec.configure do |c|
  c.hiera_config = 'spec/fixtures/hiera/hiera.yaml'
  c.include Helpers
  c.default_facts = {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :lsbmajdistrelease         => '6',
    :operatingsystemrelease    => '6',
    :is_pe                     => 'true',
    :pe_concat_basedir         => '/tmp/file',
    :platform_symlink_writable => true,
    :puppetversion             => '4.5.1',
    :memorysize                => '1.00 GB',
    :processorcount            => '1',
    :id                        => 'root',
    :gid                       => 'root',
    :path                      => '/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/usr/local/bin',
    :mountpoints               => { '/' => {}},
    :puppet_files_dir_present  => 'false',
  }
end
