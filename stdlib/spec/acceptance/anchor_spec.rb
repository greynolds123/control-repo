require 'spec_helper_acceptance'

<<<<<<< HEAD
describe 'anchor type', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'should effect proper chaining of resources' do
      pp = <<-EOS
=======
describe 'anchor type' do
  describe 'success' do
    pp = <<-DOC
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      class anchored {
        anchor { 'anchored::begin': }
        ~> anchor { 'anchored::end': }
      }

      class anchorrefresh {
        notify { 'first': }
        ~> class { 'anchored': }
        ~> anchor { 'final': }
      }

      include anchorrefresh
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Anchor\[final\]: Triggered 'refresh'/)
=======
    DOC
    it 'effects proper chaining of resources' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Anchor\[final\]: Triggered 'refresh'})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
end
