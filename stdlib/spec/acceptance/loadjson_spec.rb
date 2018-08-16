<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
=======
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
require 'spec_helper_acceptance'

tmpdir = default.tmpdir('stdlib')

<<<<<<< HEAD
describe 'loadjson function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'loadjsons array of values' do
      shell("echo '{\"aaa\":1,\"bbb\":2,\"ccc\":3,\"ddd\":4}' > #{tmpdir}/testjson.json")
      pp = <<-EOS
      $o = loadjson('#{tmpdir}/testjson.json')
=======
describe 'loadjson function' do
  describe 'success' do
    shell("echo '{\"aaa\":1,\"bbb\":2,\"ccc\":3,\"ddd\":4}' > #{tmpdir}/test1json.json")
    pp1 = <<-DOC
      $o = loadjson('#{tmpdir}/test1json.json')
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      notice(inline_template('loadjson[aaa] is <%= @o["aaa"].inspect %>'))
      notice(inline_template('loadjson[bbb] is <%= @o["bbb"].inspect %>'))
      notice(inline_template('loadjson[ccc] is <%= @o["ccc"].inspect %>'))
      notice(inline_template('loadjson[ddd] is <%= @o["ddd"].inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/loadjson\[aaa\] is 1/)
        expect(r.stdout).to match(/loadjson\[bbb\] is 2/)
        expect(r.stdout).to match(/loadjson\[ccc\] is 3/)
        expect(r.stdout).to match(/loadjson\[ddd\] is 4/)
      end
    end

    it 'returns the default value if there is no file to load' do
      pp = <<-EOS
      $o = loadjson('#{tmpdir}/no-file.json', {'default' => 'value'})
      notice(inline_template('loadjson[default] is <%= @o["default"].inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/loadjson\[default\] is "value"/)
      end
    end

    it 'returns the default value if the file was parsed with an error' do
      shell("echo '!' > #{tmpdir}/testjson.json")
      pp = <<-EOS
      $o = loadjson('#{tmpdir}/testjson.json', {'default' => 'value'})
      notice(inline_template('loadjson[default] is <%= @o["default"].inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/loadjson\[default\] is "value"/)
=======
    DOC
    regex_array = [%r{loadjson\[aaa\] is 1}, %r{loadjson\[bbb\] is 2}, %r{loadjson\[ccc\] is 3}, %r{loadjson\[ddd\] is 4}]
    it 'loadjsons array of values' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        regex_array.each do |i|
          expect(r.stdout).to match(i)
        end
      end
    end

    pp2 = <<-DOC
      $o = loadjson('#{tmpdir}/no-file.json', {'default' => 'value'})
      notice(inline_template('loadjson[default] is <%= @o["default"].inspect %>'))
    DOC
    it 'returns the default value if there is no file to load' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{loadjson\[default\] is "value"})
      end
    end

    shell("echo '!' > #{tmpdir}/test2json.json")
    pp3 = <<-DOC
      $o = loadjson('#{tmpdir}/test2json.json', {'default' => 'value'})
      notice(inline_template('loadjson[default] is <%= @o["default"].inspect %>'))
    DOC
    it 'returns the default value if the file was parsed with an error' do
      apply_manifest(pp3, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{loadjson\[default\] is "value"})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end
  describe 'failure' do
    it 'fails with no arguments'
  end
end
