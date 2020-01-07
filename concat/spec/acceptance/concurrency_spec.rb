require 'spec_helper_acceptance'

<<<<<<< HEAD
describe 'with file recursive purge' do
  basedir = default.tmpdir('concat')
  context 'should still create concat file' do
    pp = <<-EOS
      file { '#{basedir}/bar':
        ensure => directory,
        purge  => true,
        recurse => true,
      }

      concat { "foobar":
        ensure => 'present',
        path   => '#{basedir}/bar/foobar',
      }

      concat::fragment { 'foo':
        target => 'foobar',
        content => 'foo',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file("#{basedir}/bar/foobar") do
      it { should be_file }
      its(:content) {
        should match 'foo'
      }
    end
  end
end

=======
describe 'concurrency, with file recursive purge' do
  before(:all) do
    @basedir = setup_test_directory
  end

  describe 'when run should still create concat file' do
    let(:pp) do
      <<-MANIFEST
        file { '#{@basedir}/bar':
          ensure => directory,
          purge  => true,
          recurse => true,
        }

        concat { "foobar":
          ensure => 'present',
          path   => '#{@basedir}/bar/foobar',
        }

        concat::fragment { 'foo':
          target => 'foobar',
          content => 'foo',
        }
      MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      idempotent_apply(pp)
      expect(file("#{@basedir}/bar/foobar")).to be_file
      expect(file("#{@basedir}/bar/foobar").content).to match 'foo'
    end
  end
end
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
