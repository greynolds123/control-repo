require 'spec_helper_acceptance'

describe 'warnings' do
<<<<<<< HEAD
  basedir = default.tmpdir('concat')

  shared_examples 'has_warning' do |pp, w|
    it 'applies the manifest twice with a stderr regex' do
      expect(apply_manifest(pp, :catch_failures => true).stderr).to match(/#{Regexp.escape(w)}/m)
      expect(apply_manifest(pp, :catch_changes => true).stderr).to match(/#{Regexp.escape(w)}/m)
    end
  end

  context 'concat force parameter deprecation' do
    pp = <<-EOS
      concat { '#{basedir}/file':
        force => false,
      }
      concat::fragment { 'foo':
        target  => '#{basedir}/file',
        content => 'bar',
      }
    EOS
    w = 'The $force parameter to concat is deprecated and has no effect.'

    it_behaves_like 'has_warning', pp, w
  end

  context 'concat::fragment ensure parameter deprecation' do
    context 'target file exists' do
    pp = <<-EOS
      concat { '#{basedir}/file':
      }
      concat::fragment { 'foo':
        target  => '#{basedir}/file',
        ensure  => false,
        content => 'bar',
      }
    EOS
    w = 'The $ensure parameter to concat::fragment is deprecated and has no effect.'

    it_behaves_like 'has_warning', pp, w
    end
  end

  context 'concat::fragment target not found' do
    context 'target not found' do
    pp = <<-EOS
      concat { 'file':
        path => '#{basedir}/file',
      }
      concat::fragment { 'foo':
        target  => '#{basedir}/bar',
        content => 'bar',
      }
    EOS
    w = 'not found in the catalog'

    it_behaves_like 'has_warning', pp, w
=======
  before(:all) do
    @basedir = setup_test_directory
  end

  context 'when concat::fragment target not found' do
    let(:pp) do
      <<-MANIFEST
      concat { 'file':
        path => '#{@basedir}/file',
      }
      concat::fragment { 'foo':
        target  => '#{@basedir}/bar',
        content => 'bar',
      }
    MANIFEST
    end

    it 'applies manifests, check stderr' do
      expect(apply_manifest(pp, expect_failures: true).stderr).to match 'not found in the catalog'
      expect(apply_manifest(pp, expect_failures: true).stderr).to match 'not found in the catalog'
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    end
  end
end
