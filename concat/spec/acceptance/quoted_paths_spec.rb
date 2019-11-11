require 'spec_helper_acceptance'

describe 'quoted paths' do
<<<<<<< HEAD
  basedir = default.tmpdir('concat')

  before(:all) do
    pp = <<-EOS
      file { '#{basedir}':
        ensure => directory,
      }
      file { '#{basedir}/concat test':
        ensure => directory,
      }
    EOS
    apply_manifest(pp)
  end

  context 'path with blanks' do
    pp = <<-EOS
      concat { '#{basedir}/concat test/foo':
      }
      concat::fragment { '1':
        target  => '#{basedir}/concat test/foo',
        content => 'string1',
      }
      concat::fragment { '2':
        target  => '#{basedir}/concat test/foo',
        content => 'string2',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file("#{basedir}/concat test/foo") do
      it { should be_file }
      its(:content) { should match /string1string2/ }
=======
  before(:all) do
    @basedir = setup_test_directory
  end

  describe 'with path with blanks' do
    let(:pp) do
      <<-MANIFEST
        file { '#{@basedir}/concat test':
          ensure => directory,
        }
        concat { '#{@basedir}/concat test/foo':
        }
        concat::fragment { '1':
          target  => '#{@basedir}/concat test/foo',
          content => 'string1',
        }
        concat::fragment { '2':
          target  => '#{@basedir}/concat test/foo',
          content => 'string2',
        }
      MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      idempotent_apply(pp)
      expect(file("#{@basedir}/concat test/foo")).to be_file
      expect(file("#{@basedir}/concat test/foo").content).to match %r{string1string2}
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    end
  end
end
