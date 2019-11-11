require 'spec_helper_acceptance'

<<<<<<< HEAD
describe 'concat validate_cmd parameter', :unless => (fact('kernel') != 'Linux') do
  basedir = default.tmpdir('concat')
  context '=> "/usr/bin/test -e %"' do
    before(:all) do
      pp = <<-EOS
        file { '#{basedir}':
          ensure => directory
        }
      EOS

      apply_manifest(pp)
    end
    pp = <<-EOS
      concat { '#{basedir}/file':
        validate_cmd => '/usr/bin/test -e %',
      }
      concat::fragment { 'content':
        target  => '#{basedir}/file',
        content => 'content',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file("#{basedir}/file") do
      it { should be_file }
      it { should contain 'content' }
=======
describe 'validation, concat validate_cmd parameter', if: ['debian', 'redhat', 'ubuntu'].include?(os[:family]) do
  before(:all) do
    @basedir = setup_test_directory
  end

  context 'with "/usr/bin/test -e %"' do
    let(:pp) do
      <<-MANIFEST
      concat { '#{@basedir}/file':
        validate_cmd => '/usr/bin/test -e %',
      }
      concat::fragment { 'content':
        target  => '#{@basedir}/file',
        content => 'content',
      }
      MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      idempotent_apply(pp)
      expect(file("#{@basedir}/file")).to be_file
      expect(file("#{@basedir}/file").content).to contain 'content'
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    end
  end
end
