source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? "#{ENV['PUPPET_VERSION']}" : ['>= 3.3']

gem 'puppetlabs_spec_helper',       :require => false
gem 'puppet-lint',                  :require => false
gem 'rake',                         :require => false
gem 'rspec-puppet',                 :require => false
gem 'beaker-rspec',                 :require => false
gem 'beaker-puppet_install_helper', :require => false
gem 'beaker_spec_helper',           :require => false
gem 'simplecov',                    :require => false

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
