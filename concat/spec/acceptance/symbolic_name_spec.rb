require 'spec_helper_acceptance'

describe 'symbolic name' do
<<<<<<< HEAD
  basedir = default.tmpdir('concat')
  pp = <<-EOS
    concat { 'not_abs_path':
      path => '#{basedir}/file',
    }

    concat::fragment { '1':
      target  => 'not_abs_path',
      content => '1',
      order   => '01',
    }

    concat::fragment { '2':
      target  => 'not_abs_path',
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
      should match '1'
      should match '2'
    }
=======
  before(:all) do
    @basedir = setup_test_directory
  end

  let(:pp) do
    <<-MANIFEST
      concat { 'not_abs_path':
        path => '#{@basedir}/file',
      }

      concat::fragment { '1':
        target  => 'not_abs_path',
        content => '1',
        order   => '01',
      }

      concat::fragment { '2':
        target  => 'not_abs_path',
        content => '2',
        order   => '02',
      }
    MANIFEST
  end

  it 'applies the manifest twice with no stderr' do
    idempotent_apply(pp)
    expect(file("#{@basedir}/file")).to be_file
    expect(file("#{@basedir}/file").content).to match '1'
    expect(file("#{@basedir}/file").content).to match '2'
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end
end
