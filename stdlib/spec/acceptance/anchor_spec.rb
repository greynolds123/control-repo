require 'spec_helper_acceptance'

describe 'anchor type' do
<<<<<<< HEAD
  describe 'success' do
    pp = <<-DOC
=======
  let(:pp) do
    <<-MANIFEST
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
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
    DOC
    it 'effects proper chaining of resources' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Anchor\[final\]: Triggered 'refresh'})
      end
=======
    MANIFEST
  end

  it 'applies manifest, anchors resources in correct order' do
    apply_manifest(pp) do |r|
      expect(r.stdout).to match(%r{Anchor\[final\]: Triggered 'refresh'})
>>>>>>> 3e0569df506721e4616112328527bfb8431b063a
    end
  end
end
