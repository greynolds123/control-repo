require 'spec_helper_acceptance'

describe 'concat ensure_newline parameter' do
<<<<<<< HEAD
  basedir = default.tmpdir('concat')
  context '=> false' do
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
        ensure_newline => false,
      }
      concat::fragment { '1':
        target  => '#{basedir}/file',
        content => '1',
      }
      concat::fragment { '2':
        target  => '#{basedir}/file',
        content => '2',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file("#{basedir}/file") do
      it { should be_file }
      its(:content) { should match '12' }
    end
  end

  context '=> true' do
    pp = <<-EOS
      concat { '#{basedir}/file':
        ensure_newline => true,
      }
      concat::fragment { '1':
        target  => '#{basedir}/file',
        content => '1',
      }
      concat::fragment { '2':
        target  => '#{basedir}/file',
        content => '2',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file("#{basedir}/file") do
      it { should be_file }
      its(:content) {
        should match /1\n2\n/
      }
=======
  before(:all) do
    @basedir = setup_test_directory
  end
  describe 'when false' do
    let(:pp) do
      <<-MANIFEST
      concat { '#{@basedir}/file':
        ensure_newline => false,
      }
      concat::fragment { '1':
        target  => '#{@basedir}/file',
        content => '1',
      }
      concat::fragment { '2':
        target  => '#{@basedir}/file',
        content => '2',
      }
    MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      idempotent_apply(pp)
      expect(file("#{@basedir}/file")).to be_file
      expect(file("#{@basedir}/file").content).to match '12'
    end
  end

  describe 'when true' do
    let(:pp) do
      <<-MANIFEST
      concat { '#{@basedir}/file':
        ensure_newline => true,
      }
      concat::fragment { '1':
        target  => '#{@basedir}/file',
        content => '1',
      }
      concat::fragment { '2':
        target  => '#{@basedir}/file',
        content => '2',
      }
    MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      idempotent_apply(pp)
      expect(file("#{@basedir}/file")).to be_file
      expect(file("#{@basedir}/file").content).to match %r{1\r?\n2\r?\n}
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    end
  end
end
