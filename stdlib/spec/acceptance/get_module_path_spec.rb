<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'get_module_path function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'get_module_paths dne' do
      pp = <<-EOS
=======
require 'spec_helper_acceptance'

describe 'get_module_path function' do
  describe 'success' do
    pp = <<-DOC
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      $a = $::is_pe ? {
        'true'  => '/etc/puppetlabs/puppet/modules/dne',
        'false' => '/etc/puppet/modules/dne',
      }
      $o = get_module_path('dne')
      if $o == $a {
        notify { 'output correct': }
      } else {
        notify { "failed; module path is '$o'": }
      }
<<<<<<< HEAD
      EOS

=======
    DOC
    it 'get_module_paths dne' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      apply_manifest(pp, :expect_failures => true)
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-numbers'
  end
end
