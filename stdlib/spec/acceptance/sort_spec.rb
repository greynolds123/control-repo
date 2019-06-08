require 'spec_helper_acceptance'

<<<<<<< HEAD
describe 'sort function' do
=======
describe 'sort function', :if => Puppet::Util::Package.versioncmp(return_puppet_version, '6.0.0') < 0 do
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
  describe 'success' do
    pp1 = <<-DOC
      $a = ["the","public","art","galleries"]
      # Anagram: Large picture halls, I bet
      $o = sort($a)
      notice(inline_template('sort is <%= @o.inspect %>'))
    DOC
    it 'sorts arrays' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{sort is \["art", "galleries", "public", "the"\]})
      end
    end

    pp2 = <<-DOC
      $a = "blowzy night-frumps vex'd jack q"
      $o = sort($a)
      notice(inline_template('sort is <%= @o.inspect %>'))
    DOC
    it 'sorts strings' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{sort is "    '-abcdefghijklmnopqrstuvwxyz"})
      end
    end
  end
  describe 'failure' do
    it 'handles no arguments'
    it 'handles non strings or arrays'
  end
end
