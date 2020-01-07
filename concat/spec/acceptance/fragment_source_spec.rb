require 'spec_helper_acceptance'

<<<<<<< HEAD
case fact('osfamily')
  when 'AIX'
    username = 'root'
    groupname = 'system'
  when 'Darwin'
    username = 'root'
    groupname = 'wheel'
  when 'windows'
    username = 'Administrator'
    groupname = 'Administrators'
  else
    username = 'root'
    groupname = 'root'
end

describe 'concat::fragment source' do
  basedir = default.tmpdir('concat')
  context 'should read file fragments from local system' do
    pp = <<-EOS
      file { '#{basedir}/file1':
        content => "file1 contents\n"
      }
      file { '#{basedir}/file2':
        content => "file2 contents\n"
      }
      concat { '#{basedir}/foo': }

      concat::fragment { '1':
        target  => '#{basedir}/foo',
        source  => '#{basedir}/file1',
        require => File['#{basedir}/file1'],
      }
      concat::fragment { '2':
        target  => '#{basedir}/foo',
        content => 'string1 contents',
      }
      concat::fragment { '3':
        target  => '#{basedir}/foo',
        source  => '#{basedir}/file2',
        require => File['#{basedir}/file2'],
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file("#{basedir}/foo") do
      it { should be_file }
      its(:content) {
        should match 'file1 contents'
        should match 'string1 contents'
        should match 'file2 contents'
      }
    end
  end # should read file fragments from local system

  context 'should create files containing first match only.' do
    pp = <<-EOS
      file { '#{basedir}/file1':
        content => "file1 contents\n"
      }
      file { '#{basedir}/file2':
        content => "file2 contents\n"
      }
      concat { '#{basedir}/result_file1':
        owner   => '#{username}',
        group   => '#{groupname}',
        mode    => '0644',
      }
      concat { '#{basedir}/result_file2':
        owner   => '#{username}',
        group   => '#{groupname}',
        mode    => '0644',
      }
      concat { '#{basedir}/result_file3':
        owner   => '#{username}',
        group   => '#{groupname}',
        mode    => '0644',
      }

      concat::fragment { '1':
        target  => '#{basedir}/result_file1',
        source  => [ '#{basedir}/file1', '#{basedir}/file2' ],
        require => [ File['#{basedir}/file1'], File['#{basedir}/file2'] ],
        order   => '01',
      }
      concat::fragment { '2':
        target  => '#{basedir}/result_file2',
        source  => [ '#{basedir}/file2', '#{basedir}/file1' ],
        require => [ File['#{basedir}/file1'], File['#{basedir}/file2'] ],
        order   => '01',
      }
      concat::fragment { '3':
        target  => '#{basedir}/result_file3',
        source  => [ '#{basedir}/file1', '#{basedir}/file2' ],
        require => [ File['#{basedir}/file1'], File['#{basedir}/file2'] ],
        order   => '01',
      }
    EOS

    it 'applies the manifest twice with no stderr' do
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
    describe file("#{basedir}/result_file1") do
      it { should be_file }
      its(:content) {
        should match 'file1 contents'
        should_not match 'file2 contents'
      }
    end
    describe file("#{basedir}/result_file2") do
      it { should be_file }
      its(:content) {
        should match 'file2 contents'
        should_not match 'file1 contents'
      }
    end
    describe file("#{basedir}/result_file3") do
      it { should be_file }
      its(:content) {
        should match 'file1 contents'
        should_not match 'file2 contents'
      }
    end
  end

  context 'should fail if no match on source.' do
    pp = <<-EOS
      concat { '#{basedir}/fail_no_source':
        owner   => '#{username}',
        group   => '#{groupname}',
        mode    => '0644',
      }

      concat::fragment { '1':
        target  => '#{basedir}/fail_no_source',
        source => [ '#{basedir}/nofilehere', '#{basedir}/nothereeither' ],
        order   => '01',
      }
    EOS

    it 'applies the manifest with resource failures' do
      expect(apply_manifest(pp, :catch_failures => true).stderr).to match(/Failed to generate additional resources using 'eval_generate'/)
    end
    describe file("#{basedir}/fail_no_source") do
      #FIXME: Serverspec::Type::File doesn't support exists? for some reason. so... hack.
      it { should_not be_directory }
    end
  end
end

=======
case os[:family]
when 'aix'
  username = 'root'
  groupname = 'system'
when 'darwin'
  username = 'root'
  groupname = 'wheel'
when 'windows'
  username = 'Administrator'
  groupname = 'Administrators'
else
  username = 'root'
  groupname = 'root'
end

describe 'concat::fragment source' do
  before(:all) do
    @basedir = setup_test_directory
  end

  describe 'when run should read file fragments from local system' do
    let(:pp) do
      <<-MANIFEST
        file { '#{@basedir}/file1':
          content => "file1 contents\n"
        }
        file { '#{@basedir}/file2':
          content => "file2 contents\n"
        }
        concat { '#{@basedir}/foo': }

        concat::fragment { '1':
          target  => '#{@basedir}/foo',
          source  => '#{@basedir}/file1',
          require => File['#{@basedir}/file1'],
        }
        concat::fragment { '2':
          target  => '#{@basedir}/foo',
          content => 'string1 contents',
        }
        concat::fragment { '3':
          target  => '#{@basedir}/foo',
          source  => '#{@basedir}/file2',
          require => File['#{@basedir}/file2'],
        }
      MANIFEST
    end

    it 'idempotent, file matches' do
      idempotent_apply(pp)
      expect(file("#{@basedir}/foo")).to be_file
      expect(file("#{@basedir}/foo").content).to match 'file1 contents'
      expect(file("#{@basedir}/foo").content).to match 'file2 contents'
    end
  end

  describe 'when run should create files containing first match only.' do
    let(:pp) do
      <<-MANIFEST
        file { '#{@basedir}/file1':
          content => "file1 contents\n"
        }
        file { '#{@basedir}/file2':
          content => "file2 contents\n"
        }
        concat { '#{@basedir}/result_file1':
          owner   => '#{username}',
          group   => '#{groupname}',
          mode    => '0644',
        }
        concat { '#{@basedir}/result_file2':
          owner   => '#{username}',
          group   => '#{groupname}',
          mode    => '0644',
        }
        concat { '#{@basedir}/result_file3':
          owner   => '#{username}',
          group   => '#{groupname}',
          mode    => '0644',
        }

        concat::fragment { '1':
          target  => '#{@basedir}/result_file1',
          source  => [ '#{@basedir}/file1', '#{@basedir}/file2' ],
          require => [ File['#{@basedir}/file1'], File['#{@basedir}/file2'] ],
          order   => '01',
        }
        concat::fragment { '2':
          target  => '#{@basedir}/result_file2',
          source  => [ '#{@basedir}/file2', '#{@basedir}/file1' ],
          require => [ File['#{@basedir}/file1'], File['#{@basedir}/file2'] ],
          order   => '01',
        }
        concat::fragment { '3':
          target  => '#{@basedir}/result_file3',
          source  => [ '#{@basedir}/file1', '#{@basedir}/file2' ],
          require => [ File['#{@basedir}/file1'], File['#{@basedir}/file2'] ],
          order   => '01',
        }
      MANIFEST
    end

    it 'idempotent, files match' do
      idempotent_apply(pp)
      expect(file("#{@basedir}/result_file1")).to be_file
      expect(file("#{@basedir}/result_file1").content).to match 'file1 contents'
      expect(file("#{@basedir}/result_file1").content).not_to match 'file2 contents'

      expect(file("#{@basedir}/result_file2")).to be_file
      expect(file("#{@basedir}/result_file2").content).to match 'file2 contents'
      expect(file("#{@basedir}/result_file2").content).not_to match 'file1 contents'

      expect(file("#{@basedir}/result_file3")).to be_file
      expect(file("#{@basedir}/result_file3").content).to match 'file1 contents'
      expect(file("#{@basedir}/result_file3").content).not_to match 'file2 contents'
    end
  end

  describe 'when run should fail if no match on source.' do
    let(:pp) do
      <<-MANIFEST
        concat { '#{@basedir}/fail_no_source':
          owner   => '#{username}',
          group   => '#{groupname}',
          mode    => '0644',
        }

        concat::fragment { '1':
          target  => '#{@basedir}/fail_no_source',
          source => [ '#{@basedir}/nofilehere', '#{@basedir}/nothereeither' ],
          order   => '01',
        }
      MANIFEST
    end

    it 'applies the manifest with resource failures' do
      expect(apply_manifest(pp, expect_failures: true).stderr).to match(%r{Failed to generate additional resources using 'eval_generate'})
      expect(file("#{@basedir}/fail_no_source")).not_to be_directory
    end
  end
end
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
