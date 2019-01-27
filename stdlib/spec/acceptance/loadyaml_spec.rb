<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
=======
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
require 'spec_helper_acceptance'

tmpdir = default.tmpdir('stdlib')

<<<<<<< HEAD
describe 'loadyaml function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'loadyamls array of values' do
      shell("echo '---
      aaa: 1
      bbb: 2
      ccc: 3
      ddd: 4' > #{tmpdir}/testyaml.yaml")
      pp = <<-EOS
      $o = loadyaml('#{tmpdir}/testyaml.yaml')
=======
describe 'loadyaml function' do
  describe 'success' do
    shell("echo '---
      aaa: 1
      bbb: 2
      ccc: 3
      ddd: 4' > #{tmpdir}/test1yaml.yaml")
    pp1 = <<-DOC
      $o = loadyaml('#{tmpdir}/test1yaml.yaml')
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      notice(inline_template('loadyaml[aaa] is <%= @o["aaa"].inspect %>'))
      notice(inline_template('loadyaml[bbb] is <%= @o["bbb"].inspect %>'))
      notice(inline_template('loadyaml[ccc] is <%= @o["ccc"].inspect %>'))
      notice(inline_template('loadyaml[ddd] is <%= @o["ddd"].inspect %>'))
<<<<<<< HEAD
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/loadyaml\[aaa\] is 1/)
        expect(r.stdout).to match(/loadyaml\[bbb\] is 2/)
        expect(r.stdout).to match(/loadyaml\[ccc\] is 3/)
        expect(r.stdout).to match(/loadyaml\[ddd\] is 4/)
      end
    end

    it 'returns the default value if there is no file to load' do
      pp = <<-EOS
      $o = loadyaml('#{tmpdir}/no-file.yaml', {'default' => 'value'})
      notice(inline_template('loadyaml[default] is <%= @o["default"].inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/loadyaml\[default\] is "value"/)
      end
    end

    it 'returns the default value if the file was parsed with an error' do
      shell("echo '!' > #{tmpdir}/testyaml.yaml")
      pp = <<-EOS
      $o = loadyaml('#{tmpdir}/testyaml.yaml', {'default' => 'value'})
      notice(inline_template('loadyaml[default] is <%= @o["default"].inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/loadyaml\[default\] is "value"/)
=======
    DOC
    regex_array = [%r{loadyaml\[aaa\] is 1}, %r{loadyaml\[bbb\] is 2}, %r{loadyaml\[ccc\] is 3}, %r{loadyaml\[ddd\] is 4}]
    it 'loadyamls array of values' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        regex_array.each do |i|
          expect(r.stdout).to match(i)
        end
      end
    end

    pp2 = <<-DOC
      $o = loadyaml('#{tmpdir}/no-file.yaml', {'default' => 'value'})
      notice(inline_template('loadyaml[default] is <%= @o["default"].inspect %>'))
    DOC
    it 'returns the default value if there is no file to load' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{loadyaml\[default\] is "value"})
      end
    end

    shell("echo '!' > #{tmpdir}/test2yaml.yaml")
    pp3 = <<-DOC
      $o = loadyaml('#{tmpdir}/test2yaml.yaml', {'default' => 'value'})
      notice(inline_template('loadyaml[default] is <%= @o["default"].inspect %>'))
    DOC
    it 'returns the default value if the file was parsed with an error' do
      apply_manifest(pp3, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{loadyaml\[default\] is "value"})
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
  describe 'failure' do
    it 'fails with no arguments'
  end
end
