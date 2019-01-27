<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'deprecation function' do

  if fact('operatingsystem') == 'windows'
    test_file = 'C:/deprecation'
    else
    test_file = "/tmp/deprecation"
  end
=======
require 'spec_helper_acceptance'

describe 'deprecation function' do
  test_file = if fact('operatingsystem') == 'windows'
                'C:/deprecation'
              else
                '/tmp/deprecation'
              end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

  # It seems that Windows needs everything to be on one line when using puppet apply -e, otherwise the manifests would be in an easier format
  add_file_manifest = "\"deprecation('key', 'message') file { '#{test_file}': ensure => present, content => 'test', }\""
  remove_file_manifest = "file { '#{test_file}': ensure => absent }"

  before :all do
    apply_manifest(remove_file_manifest)
  end

<<<<<<< HEAD
  context 'with --strict=error', if: get_puppet_version =~ /^4/ do
    before :all do
      @result = on(default, puppet('apply', '--strict=error', '-e', add_file_manifest), acceptable_exit_codes: (0...256))
    end
=======
  context 'with --strict=error', :if => return_puppet_version =~ %r{^4} do
    let(:result) { on(default, puppet('apply', '--strict=error', '-e', add_file_manifest), :acceptable_exit_codes => (0...256)) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    after :all do
      apply_manifest(remove_file_manifest)
    end

<<<<<<< HEAD
    it "should return an error" do
      expect(@result.exit_code).to eq(1)
    end

    it "should show the error message" do
      expect(@result.stderr).to match(/deprecation. key. message/)
    end

    describe file("#{test_file}") do
=======
    it 'returns an error' do
      expect(result.exit_code).to eq(1)
    end

    it 'shows the error message' do
      expect(result.stderr).to match(%r{deprecation. key. message})
    end

    describe file(test_file.to_s) do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      it { is_expected.not_to be_file }
    end
  end

<<<<<<< HEAD
  context 'with --strict=warning', if: get_puppet_version =~ /^4/ do
    before :all do
      @result = on(default, puppet('apply', '--strict=warning', '-e', add_file_manifest), acceptable_exit_codes: (0...256))
    end
=======
  context 'with --strict=warning', :if => return_puppet_version =~ %r{^4} do
    let(:result) { on(default, puppet('apply', '--strict=warning', '-e', add_file_manifest), :acceptable_exit_codes => (0...256)) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    after :all do
      apply_manifest(remove_file_manifest)
    end

<<<<<<< HEAD
    it "should not return an error" do
      expect(@result.exit_code).to eq(0)
    end

    it "should show the error message" do
      expect(@result.stderr).to match(/Warning: message/)
    end

    describe file("#{test_file}") do
=======
    it 'does not return an error' do
      expect(result.exit_code).to eq(0)
    end

    it 'shows the error message' do
      expect(result.stderr).to match(%r{Warning: message})
    end

    describe file(test_file.to_s) do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      it { is_expected.to be_file }
    end
  end

<<<<<<< HEAD
  context 'with --strict=off', if: get_puppet_version =~ /^4/ do
    before :all do
      @result = on(default, puppet('apply', '--strict=off', '-e', add_file_manifest), acceptable_exit_codes: (0...256))
    end
=======
  context 'with --strict=off', :if => return_puppet_version =~ %r{^4} do
    let(:result) { on(default, puppet('apply', '--strict=off', '-e', add_file_manifest), :acceptable_exit_codes => (0...256)) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    after :all do
      apply_manifest(remove_file_manifest)
    end

<<<<<<< HEAD
    it "should not return an error" do
      expect(@result.exit_code).to eq(0)
    end

    it "should not show the error message" do
      expect(@result.stderr).not_to match(/Warning: message/)
    end

    describe file("#{test_file}") do
      it { is_expected.to be_file }
    end
  end
=======
    it 'does not return an error' do
      expect(result.exit_code).to eq(0)
    end

    it 'does not show the error message' do
      expect(result.stderr).not_to match(%r{Warning: message})
    end

    describe file(test_file.to_s) do
      it { is_expected.to be_file }
    end
  end

  context 'puppet 3 test', :if => return_puppet_version =~ %r{^3} do
    let(:result) { on(default, puppet('apply', '--parser=future', '-e', add_file_manifest), :acceptable_exit_codes => (0...256)) }

    after :all do
      apply_manifest(remove_file_manifest)
    end

    it 'returns a deprecation error' do
      expect(result.stderr).to match(%r{Warning: message})
    end
    it 'passes without error' do
      expect(result.exit_code).to eq(0)
    end
  end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
end
