require 'spec_helper_acceptance'

describe 'concat::fragment replace' do
<<<<<<< HEAD
  basedir = default.tmpdir('concat')

  context 'should create fragment files' do
    before(:all) do
      pp = <<-EOS
        file { '#{basedir}':
          ensure => directory,
        }
      EOS
      apply_manifest(pp)
    end

    pp1 = <<-EOS
      concat { '#{basedir}/foo': }

      concat::fragment { '1':
        target  => '#{basedir}/foo',
        content => 'caller has replace unset run 1',
      }
    EOS
    pp2 = <<-EOS
      concat { '#{basedir}/foo': }

      concat::fragment { '1':
        target  => '#{basedir}/foo',
        content => 'caller has replace unset run 2',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp1, :catch_failures => true)
      apply_manifest(pp1, :catch_changes => true)
      apply_manifest(pp2, :catch_failures => true)
      apply_manifest(pp2, :catch_changes => true)
    end

    describe file("#{basedir}/foo") do
      it { should be_file }
      its(:content) {
        should_not match 'caller has replace unset run 1'
        should match 'caller has replace unset run 2'
      }
    end
  end # should create fragment files

  context 'should replace its own fragment files when caller has File { replace=>true } set' do
    before(:all) do
      pp = <<-EOS
        file { '#{basedir}':
          ensure => directory,
        }
      EOS
      apply_manifest(pp)
    end

    pp1 = <<-EOS
      File { replace=>true }
      concat { '#{basedir}/foo': }

      concat::fragment { '1':
        target  => '#{basedir}/foo',
        content => 'caller has replace true set run 1',
      }
    EOS
    pp2 = <<-EOS
      File { replace=>true }
      concat { '#{basedir}/foo': }

      concat::fragment { '1':
        target  => '#{basedir}/foo',
        content => 'caller has replace true set run 2',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp1, :catch_failures => true)
      apply_manifest(pp1, :catch_changes => true)
      apply_manifest(pp2, :catch_failures => true)
      apply_manifest(pp2, :catch_changes => true)
    end

    describe file("#{basedir}/foo") do
      it { should be_file }
      its(:content) {
        should_not match 'caller has replace true set run 1'
        should match 'caller has replace true set run 2'
      }
    end
  end # should replace its own fragment files when caller has File(replace=>true) set

  context 'should replace its own fragment files even when caller has File { replace=>false } set' do
    before(:all) do
      pp = <<-EOS
        file { '#{basedir}':
          ensure => directory,
        }
      EOS
      apply_manifest(pp)
    end

    pp1 = <<-EOS
      File { replace=>false }
      concat { '#{basedir}/foo': }

      concat::fragment { '1':
        target  => '#{basedir}/foo',
        content => 'caller has replace false set run 1',
      }
    EOS
    pp2 = <<-EOS
      File { replace=>false }
      concat { '#{basedir}/foo': }

      concat::fragment { '1':
        target  => '#{basedir}/foo',
        content => 'caller has replace false set run 2',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp1, :catch_failures => true)
      apply_manifest(pp1, :catch_changes => true)
      apply_manifest(pp2, :catch_failures => true)
      apply_manifest(pp2, :catch_changes => true)
    end

    describe file("#{basedir}/foo") do
      it { should be_file }
      its(:content) {
        should_not match 'caller has replace false set run 1'
        should match 'caller has replace false set run 2'
      }
    end
  end # should replace its own fragment files even when caller has File(replace=>false) set

=======
  before(:all) do
    @basedir = setup_test_directory
  end

  describe 'when run should create fragment files' do
    let(:pp1) do
      <<-MANIFEST
      concat { '#{@basedir}/foo': }
      concat::fragment { '1':
        target  => '#{@basedir}/foo',
        content => 'caller has replace unset run 1',
      }
    MANIFEST
    end
    let(:pp2) do
      <<-MANIFEST
      concat { '#{@basedir}/foo': }
      concat::fragment { '1':
        target  => '#{@basedir}/foo',
        content => 'caller has replace unset run 2',
      }
    MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      idempotent_apply(pp1)
      idempotent_apply(pp2)
      expect(file("#{@basedir}/foo")).to be_file
      expect(file("#{@basedir}/foo").content).not_to match 'caller has replace unset run 1'
      expect(file("#{@basedir}/foo").content).to match 'caller has replace unset run 2'
    end
  end
  # should create fragment files

  describe 'when run should replace its own fragment files when caller has File { replace=>true } set' do
    let(:pp1) do
      <<-MANIFEST
      File { replace=>true }
      concat { '#{@basedir}/foo': }
      concat::fragment { '1':
        target  => '#{@basedir}/foo',
        content => 'caller has replace true set run 1',
      }
    MANIFEST
    end
    let(:pp2) do
      <<-MANIFEST
      File { replace=>true }
      concat { '#{@basedir}/foo': }
      concat::fragment { '1':
        target  => '#{@basedir}/foo',
        content => 'caller has replace true set run 2',
      }
    MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      idempotent_apply(pp1)
      idempotent_apply(pp2)
      expect(file("#{@basedir}/foo")).to be_file
      expect(file("#{@basedir}/foo").content).not_to match 'caller has replace true set run 1'
      expect(file("#{@basedir}/foo").content).to match 'caller has replace true set run 2'
    end
  end
  # should replace its own fragment files when caller has File(replace=>true) set

  describe 'when run should replace its own fragment files even when caller has File { replace=>false } set' do
    let(:pp1) do
      <<-MANIFEST
      File { replace=>false }
      concat { '#{@basedir}/foo': }
      concat::fragment { '1':
        target  => '#{@basedir}/foo',
        content => 'caller has replace false set run 1',
      }
    MANIFEST
    end
    let(:pp2) do
      <<-MANIFEST
      File { replace=>false }
      concat { '#{@basedir}/foo': }
      concat::fragment { '1':
        target  => '#{@basedir}/foo',
        content => 'caller has replace false set run 2',
      }
    MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      idempotent_apply(pp1)
      idempotent_apply(pp2)
      expect(file("#{@basedir}/foo")).to be_file
      expect(file("#{@basedir}/foo").content).not_to match 'caller has replace false set run 1'
      expect(file("#{@basedir}/foo").content).to match 'caller has replace false set run 2'
    end
  end
  # should replace its own fragment files even when caller has File(replace=>false) set
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
end
