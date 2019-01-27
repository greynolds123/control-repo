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
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
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
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
end
