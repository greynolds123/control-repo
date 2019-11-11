require 'spec_helper_acceptance'

<<<<<<< HEAD
describe 'concat warn =>' do
  basedir = default.tmpdir('concat')
  context 'true should enable default warning message' do
    pp = <<-EOS
      concat { '#{basedir}/file':
=======
describe 'concat warn_header =>' do
  before(:all) do
    @basedir = setup_test_directory
  end

  describe 'applies the manifest twice with no stderr' do
    let(:pp) do
      <<-MANIFEST
      concat { '#{@basedir}/file':
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
        warn  => true,
      }

      concat::fragment { '1':
<<<<<<< HEAD
        target  => '#{basedir}/file',
=======
        target  => '#{@basedir}/file',
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
        content => '1',
        order   => '01',
      }

      concat::fragment { '2':
<<<<<<< HEAD
        target  => '#{basedir}/file',
        content => '2',
        order   => '02',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file("#{basedir}/file") do
      it { should be_file }
      its(:content) {
        should match /# This file is managed by Puppet\. DO NOT EDIT\./
        should match /1/
        should match /2/
      }
    end
  end
  context 'false should not enable default warning message' do
    pp = <<-EOS
      concat { '#{basedir}/file':
        warn  => false,
      }

      concat::fragment { '1':
        target  => '#{basedir}/file',
=======
        target  => '#{@basedir}/file',
        content => '2',
        order   => '02',
      }

      concat { '#{@basedir}/file2':
        warn  => false,
      }

      concat::fragment { 'file2_1':
        target  => '#{@basedir}/file2',
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
        content => '1',
        order   => '01',
      }

<<<<<<< HEAD
      concat::fragment { '2':
        target  => '#{basedir}/file',
        content => '2',
        order   => '02',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file("#{basedir}/file") do
      it { should be_file }
      its(:content) {
        should_not match /# This file is managed by Puppet\. DO NOT EDIT\./
        should match /1/
        should match /2/
      }
    end
  end
  context '# foo should overide default warning message' do
    pp = <<-EOS
      concat { '#{basedir}/file':
        warn  => "# foo\n",
      }

      concat::fragment { '1':
        target  => '#{basedir}/file',
=======
      concat::fragment { 'file2_2':
        target  => '#{@basedir}/file2',
        content => '2',
        order   => '02',
      }

      concat { '#{@basedir}/file3':
        warn  => "# foo\n",
      }

      concat::fragment { 'file3_1':
        target  => '#{@basedir}/file3',
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
        content => '1',
        order   => '01',
      }

<<<<<<< HEAD
      concat::fragment { '2':
        target  => '#{basedir}/file',
        content => '2',
        order   => '02',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file("#{basedir}/file") do
      it { should be_file }
      its(:content) {
        should match /# foo/
        should match /1/
        should match /2/
      }
=======
      concat::fragment { 'file3_2':
        target  => '#{@basedir}/file3',
        content => '2',
        order   => '02',
      }

    MANIFEST
    end

    it 'when true should enable default warning message' do
      idempotent_apply(pp)
      expect(file("#{@basedir}/file")).to be_file
      expect(file("#{@basedir}/file").content).to match %r{# This file is managed by Puppet\. DO NOT EDIT\.}
      expect(file("#{@basedir}/file").content).to match %r{1}
      expect(file("#{@basedir}/file").content).to match %r{2}
    end

    it 'when false should not enable default warning message' do
      expect(file("#{@basedir}/file2")).to be_file
      expect(file("#{@basedir}/file2").content).not_to match %r{# This file is managed by Puppet\. DO NOT EDIT\.}
      expect(file("#{@basedir}/file2").content).to match %r{1}
      expect(file("#{@basedir}/file2").content).to match %r{2}
    end

    it 'when foo should overide default warning message' do
      expect(file("#{@basedir}/file3")).to be_file
      expect(file("#{@basedir}/file3").content).to match %r{# foo}
      expect(file("#{@basedir}/file3").content).to match %r{1}
      expect(file("#{@basedir}/file3").content).to match %r{2}
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    end
  end
end
