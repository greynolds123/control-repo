<<<<<<< HEAD
#! /usr/bin/env ruby -S rspec
require 'spec_helper'
require 'tempfile'
provider_class = Puppet::Type.type(:file_line).provider(:ruby)
describe provider_class do
  context "when adding" do
    let :tmpfile do
      tmp = Tempfile.new('tmp')
      path = tmp.path
      tmp.close!
      path
    end
    let :resource do
      Puppet::Type::File_line.new(
        {:name => 'foo', :path => tmpfile, :line => 'foo'}
      )
    end
    let :provider do
      provider_class.new(resource)
    end

    it 'should detect if the line exists in the file' do
      File.open(tmpfile, 'w') do |fh|
        fh.write('foo')
      end
      expect(provider.exists?).to be_truthy
    end
    it 'should detect if the line does not exist in the file' do
      File.open(tmpfile, 'w') do |fh|
        fh.write('foo1')
      end
      expect(provider.exists?).to be_nil
    end
    it 'should append to an existing file when creating' do
      provider.create
      expect(File.read(tmpfile).chomp).to eq('foo')
    end
  end
  context 'when using replace' do
    before :each do
      # TODO: these should be ported over to use the PuppetLabs spec_helper
      #  file fixtures once the following pull request has been merged:
      # https://github.com/puppetlabs/puppetlabs-stdlib/pull/73/files
      tmp = Tempfile.new('tmp')
      @tmpfile = tmp.path
      tmp.close!
      @resource = Puppet::Type::File_line.new(
        {
          :name    => 'foo',
          :path    => @tmpfile,
          :line    => 'foo = bar',
          :match   => '^foo\s*=.*$',
          :replace => false,
        }
      )
      @provider = provider_class.new(@resource)
    end

    it 'should not replace the matching line' do
      File.open(@tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo=blah\nfoo2\nfoo3")
      end
      expect(@provider.exists?).to be_truthy
      @provider.create
      expect(File.read(@tmpfile).chomp).to eql("foo1\nfoo=blah\nfoo2\nfoo3")
    end

    it 'should append the line if no matches are found' do
      File.open(@tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo2")
      end
      expect(@provider.exists?).to be_nil
      @provider.create
      expect(File.read(@tmpfile).chomp).to eql("foo1\nfoo2\nfoo = bar")
    end

    it 'should raise an error with invalid values' do
      expect {
        @resource = Puppet::Type::File_line.new(
          {
            :name     => 'foo',
            :path     => @tmpfile,
            :line     => 'foo = bar',
            :match    => '^foo\s*=.*$',
            :replace  => 'asgadga',
          }
        )
      }.to raise_error(Puppet::Error, /Invalid value "asgadga"\. Valid values are true, false\./)
    end
  end
  context "when matching" do
    before :each do
      # TODO: these should be ported over to use the PuppetLabs spec_helper
      #  file fixtures once the following pull request has been merged:
      # https://github.com/puppetlabs/puppetlabs-stdlib/pull/73/files
      tmp = Tempfile.new('tmp')
      @tmpfile = tmp.path
      tmp.close!
      @resource = Puppet::Type::File_line.new(
        {
          :name  => 'foo',
          :path  => @tmpfile,
          :line  => 'foo = bar',
          :match => '^foo\s*=.*$',
        }
      )
      @provider = provider_class.new(@resource)
    end

    describe 'using match' do
      it 'should raise an error if more than one line matches, and should not have modified the file' do
        File.open(@tmpfile, 'w') do |fh|
          fh.write("foo1\nfoo=blah\nfoo2\nfoo=baz")
        end
        expect(@provider.exists?).to be_nil
        expect { @provider.create }.to raise_error(Puppet::Error, /More than one line.*matches/)
        expect(File.read(@tmpfile)).to eql("foo1\nfoo=blah\nfoo2\nfoo=baz")
      end

      it 'should replace all lines that matches' do
        @resource = Puppet::Type::File_line.new(
          {
            :name     => 'foo',
            :path     => @tmpfile,
            :line     => 'foo = bar',
            :match    => '^foo\s*=.*$',
            :multiple => true,
          }
        )
        @provider = provider_class.new(@resource)
        File.open(@tmpfile, 'w') do |fh|
          fh.write("foo1\nfoo=blah\nfoo2\nfoo=baz")
        end
        expect(@provider.exists?).to be_nil
        @provider.create
        expect(File.read(@tmpfile).chomp).to eql("foo1\nfoo = bar\nfoo2\nfoo = bar")
      end

      it 'should raise an error with invalid values' do
        expect {
          @resource = Puppet::Type::File_line.new(
            {
              :name     => 'foo',
              :path     => @tmpfile,
              :line     => 'foo = bar',
              :match    => '^foo\s*=.*$',
              :multiple => 'asgadga',
            }
          )
        }.to raise_error(Puppet::Error, /Invalid value "asgadga"\. Valid values are true, false\./)
      end

      it 'should replace a line that matches' do
        File.open(@tmpfile, 'w') do |fh|
          fh.write("foo1\nfoo=blah\nfoo2")
        end
        expect(@provider.exists?).to be_nil
        @provider.create
        expect(File.read(@tmpfile).chomp).to eql("foo1\nfoo = bar\nfoo2")
      end
      it 'should add a new line if no lines match' do
        File.open(@tmpfile, 'w') do |fh|
          fh.write("foo1\nfoo2")
        end
        expect(@provider.exists?).to be_nil
        @provider.create
        expect(File.read(@tmpfile)).to eql("foo1\nfoo2\nfoo = bar\n")
      end
      it 'should do nothing if the exact line already exists' do
        File.open(@tmpfile, 'w') do |fh|
          fh.write("foo1\nfoo = bar\nfoo2")
        end
        expect(@provider.exists?).to be_truthy
        @provider.create
        expect(File.read(@tmpfile).chomp).to eql("foo1\nfoo = bar\nfoo2")
      end
    end

    describe 'using after' do
      let :resource do
        Puppet::Type::File_line.new(
          {
            :name  => 'foo',
            :path  => @tmpfile,
            :line  => 'inserted = line',
            :after => '^foo1',
          }
        )
      end

      let :provider do
        provider_class.new(resource)
      end
      context 'match and after set' do
        shared_context 'resource_create' do
          let(:match) { '^foo2$' }
          let(:after) { '^foo1$' }
          let(:resource) {
            Puppet::Type::File_line.new(
              {
                :name  => 'foo',
                :path  => @tmpfile,
                :line  => 'inserted = line',
                :after => after,
                :match => match,
              }
            )
          }
        end
        before :each do
          File.open(@tmpfile, 'w') do |fh|
            fh.write("foo1\nfoo2\nfoo = baz")
          end
        end
        describe 'inserts at match' do
          include_context 'resource_create'
          it {
            provider.create
            expect(File.read(@tmpfile).chomp).to eq("foo1\ninserted = line\nfoo = baz")
          }
        end
        describe 'inserts a new line after when no match' do
          include_context 'resource_create' do
            let(:match) { '^nevergoingtomatch$' }
          end
          it {
            provider.create
            expect(File.read(@tmpfile).chomp).to eq("foo1\ninserted = line\nfoo2\nfoo = baz")
          }
        end
        describe 'append to end of file if no match for both after and match' do
          include_context 'resource_create' do
            let(:match) { '^nevergoingtomatch$' }
            let(:after) { '^stillneverafter' }
          end
          it {
            provider.create
            expect(File.read(@tmpfile).chomp).to eq("foo1\nfoo2\nfoo = baz\ninserted = line")
          }
        end
      end
      context 'with one line matching the after expression' do
        before :each do
          File.open(@tmpfile, 'w') do |fh|
            fh.write("foo1\nfoo = blah\nfoo2\nfoo = baz")
          end
        end

        it 'inserts the specified line after the line matching the "after" expression' do
          provider.create
          expect(File.read(@tmpfile).chomp).to eql("foo1\ninserted = line\nfoo = blah\nfoo2\nfoo = baz")
        end
      end

      context 'with multiple lines matching the after expression' do
        before :each do
          File.open(@tmpfile, 'w') do |fh|
            fh.write("foo1\nfoo = blah\nfoo2\nfoo1\nfoo = baz")
          end
        end

        it 'errors out stating "One or no line must match the pattern"' do
          expect { provider.create }.to raise_error(Puppet::Error, /One or no line must match the pattern/)
        end

        it 'adds the line after all lines matching the after expression' do
          @resource = Puppet::Type::File_line.new(
            {
              :name     => 'foo',
              :path     => @tmpfile,
              :line     => 'inserted = line',
              :after    => '^foo1$',
              :multiple => true,
            }
          )
          @provider = provider_class.new(@resource)
          expect(@provider.exists?).to be_nil
          @provider.create
          expect(File.read(@tmpfile).chomp).to eql("foo1\ninserted = line\nfoo = blah\nfoo2\nfoo1\ninserted = line\nfoo = baz")
        end
      end

      context 'with no lines matching the after expression' do
        let :content do
          "foo3\nfoo = blah\nfoo2\nfoo = baz\n"
        end

        before :each do
          File.open(@tmpfile, 'w') do |fh|
            fh.write(content)
          end
        end

        it 'appends the specified line to the file' do
          provider.create
          expect(File.read(@tmpfile)).to eq(content << resource[:line] << "\n")
        end
=======
require 'spec_helper'

provider_class = Puppet::Type.type(:file_line).provider(:ruby)
#  These tests fail on windows when run as part of the rake task. Individually they pass
describe provider_class, :unless => Puppet::Util::Platform.windows? do
  include PuppetlabsSpec::Files

  let :tmpfile do
    tmpfilename('file_line_test')
  end
  let :content do
    ''
  end
  let :params do
    {}
  end
  let :resource do
    Puppet::Type::File_line.new({
      :name => 'foo',
      :path => tmpfile,
      :line => 'foo',
    }.merge(params))
  end
  let :provider do
    provider_class.new(resource)
  end

  before :each do
    File.open(tmpfile, 'w') do |fh|
      fh.write(content)
    end
  end

  describe 'line parameter' do
    context 'when line exists' do
      let(:content) { 'foo' }

      it 'detects the line' do
        expect(provider).to be_exists
      end
    end
    context 'when line does not exist' do
      let(:content) { 'foo bar' }

      it 'requests changes' do
        expect(provider).not_to be_exists
      end
      it 'appends the line' do
        provider.create
        expect(File.read(tmpfile).chomp).to eq("foo bar\nfoo")
      end
    end
  end

  describe 'match parameter' do
    let(:params) { { :match => '^bar' } }

    describe 'does not match line - line does not exist - replacing' do
      let(:content) { "foo bar\nbar" }

      it 'requests changes' do
        expect(provider).not_to be_exists
      end
      it 'replaces the match' do
        provider.create
        expect(File.read(tmpfile).chomp).to eq("foo bar\nfoo")
      end
    end

    describe 'does not match line - line does not exist - appending' do
      let(:params) { super().merge(:replace => false) }
      let(:content) { "foo bar\nbar" }

      it 'does not request changes' do
        expect(provider).to be_exists
      end
    end

    context 'when does not match line - line exists' do
      let(:content) { "foo\nbar" }

      it 'detects the line' do
        expect(provider).to be_exists
      end
    end

    context 'when matches line - line exists' do
      let(:params) { { :match => '^foo' } }
      let(:content) { "foo\nbar" }

      it 'detects the line' do
        expect(provider).to be_exists
      end
    end

    context 'when matches line - line does not exist' do
      let(:params) { { :match => '^foo' } }
      let(:content) { "foo bar\nbar" }

      it 'requests changes' do
        expect(provider).not_to be_exists
      end
      it 'replaces the match' do
        provider.create
        expect(File.read(tmpfile).chomp).to eq("foo\nbar")
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      end
    end
  end

<<<<<<< HEAD
  context "when removing" do
    before :each do
      # TODO: these should be ported over to use the PuppetLabs spec_helper
      #  file fixtures once the following pull request has been merged:
      # https://github.com/puppetlabs/puppetlabs-stdlib/pull/73/files
      tmp = Tempfile.new('tmp')
      @tmpfile = tmp.path
      tmp.close!
      @resource = Puppet::Type::File_line.new(
        {
          :name   => 'foo',
          :path   => @tmpfile,
          :line   => 'foo',
          :ensure => 'absent',
        }
      )
      @provider = provider_class.new(@resource)
    end
    it 'should remove the line if it exists' do
      File.open(@tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2")
      end
      @provider.destroy
      expect(File.read(@tmpfile)).to eql("foo1\nfoo2")
    end

    it 'should remove the line without touching the last new line' do
      File.open(@tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2\n")
      end
      @provider.destroy
      expect(File.read(@tmpfile)).to eql("foo1\nfoo2\n")
    end

    it 'should remove any occurence of the line' do
      File.open(@tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2\nfoo\nfoo")
      end
      @provider.destroy
      expect(File.read(@tmpfile)).to eql("foo1\nfoo2\n")
    end
  end

  context "when removing with a match" do
    before :each do
      # TODO: these should be ported over to use the PuppetLabs spec_helper
      #  file fixtures once the following pull request has been merged:
      # https://github.com/puppetlabs/puppetlabs-stdlib/pull/73/files
      tmp = Tempfile.new('tmp')
      @tmpfile = tmp.path
      tmp.close!
      @resource = Puppet::Type::File_line.new(
        {
          :name              => 'foo',
          :path              => @tmpfile,
          :line              => 'foo2',
          :ensure            => 'absent',
          :match             => 'o$',
          :match_for_absence => true,
        }
      )
      @provider = provider_class.new(@resource)
    end

    it 'should find a line to match' do
      File.open(@tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2")
      end
      expect(@provider.exists?).to be_truthy
    end

    it 'should remove one line if it matches' do
      File.open(@tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2")
      end
      @provider.destroy
      expect(File.read(@tmpfile)).to eql("foo1\nfoo2")
    end

    it 'should raise an error if more than one line matches' do
      File.open(@tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2\nfoo\nfoo")
      end
      expect { @provider.destroy }.to raise_error(Puppet::Error, /More than one line/)
    end

    it 'should remove multiple lines if :multiple is true' do
      @resource = Puppet::Type::File_line.new(
        {
          :name              => 'foo',
          :path              => @tmpfile,
          :line              => 'foo2',
          :ensure            => 'absent',
          :match             => 'o$',
          :multiple          => true,
          :match_for_absence => true,
        }
      )
      @provider = provider_class.new(@resource)
      File.open(@tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2\nfoo\nfoo")
      end
      @provider.destroy
      expect(File.read(@tmpfile)).to eql("foo1\nfoo2\n")
    end

    it 'should ignore the match if match_for_absence is not specified' do
      @resource = Puppet::Type::File_line.new(
        {
          :name     => 'foo',
          :path     => @tmpfile,
          :line     => 'foo2',
          :ensure   => 'absent',
          :match    => 'o$',
        }
      )
      @provider = provider_class.new(@resource)
      File.open(@tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2")
      end
      @provider.destroy
      expect(File.read(@tmpfile)).to eql("foo1\nfoo\n")
    end

    it 'should ignore the match if match_for_absence is false' do
      @resource = Puppet::Type::File_line.new(
        {
          :name              => 'foo',
          :path              => @tmpfile,
          :line              => 'foo2',
          :ensure            => 'absent',
          :match             => 'o$',
          :match_for_absence => false,
        }
      )
      @provider = provider_class.new(@resource)
      File.open(@tmpfile, 'w') do |fh|
        fh.write("foo1\nfoo\nfoo2")
      end
      @provider.destroy
      expect(File.read(@tmpfile)).to eql("foo1\nfoo\n")
    end

  end

=======
  describe 'append_on_no_match' do
    let(:params) do
      {
        :append_on_no_match => false,
        :match => '^foo1$',
      }
    end

    context 'when matching' do
      let(:content) { "foo1\nbar" }

      it 'requests changes' do
        expect(provider).not_to be_exists
      end
      it 'replaces the match' do
        provider.create
        expect(File.read(tmpfile).chomp).to eql("foo\nbar")
      end
    end
    context 'when not matching' do
      let(:content) { "foo3\nbar" }

      it 'does not affect the file' do
        expect(provider).to be_exists
      end
    end
  end

  describe 'replace_all_matches_not_matching_line' do
    context 'when replace is false' do
      let(:params) do
        {
          :replace_all_matches_not_matching_line => true,
          :replace => false,
        }
      end

      it 'raises an error' do
        expect { provider.exists? }.to raise_error(Puppet::Error, %r{replace must be true})
      end
    end

    context 'when match matches line - when there are more matches than lines' do
      let(:params) do
        {
          :replace_all_matches_not_matching_line => true,
          :match => '^foo',
          :multiple => true,
        }
      end
      let(:content) { "foo\nfoo bar\nbar\nfoo baz" }

      it 'requests changes' do
        expect(provider).not_to be_exists
      end
      it 'replaces the matches' do
        provider.create
        expect(File.read(tmpfile).chomp).to eql("foo\nfoo\nbar\nfoo")
      end
    end

    context 'when match matches line - when there are the same matches and lines' do
      let(:params) do
        {
          :replace_all_matches_not_matching_line => true,
          :match => '^foo',
          :multiple => true,
        }
      end
      let(:content) { "foo\nfoo\nbar" }

      it 'does not request changes' do
        expect(provider).to be_exists
      end
    end

    context 'when match does not match line - when there are more matches than lines' do
      let(:params) do
        {
          :replace_all_matches_not_matching_line => true,
          :match => '^bar',
          :multiple => true,
        }
      end
      let(:content) { "foo\nfoo bar\nbar\nbar baz" }

      it 'requests changes' do
        expect(provider).not_to be_exists
      end
      it 'replaces the matches' do
        provider.create
        expect(File.read(tmpfile).chomp).to eql("foo\nfoo bar\nfoo\nfoo")
      end
    end

    context 'when match does not match line - when there are the same matches and lines' do
      let(:params) do
        {
          :replace_all_matches_not_matching_line => true,
          :match => '^bar',
          :multiple => true,
        }
      end
      let(:content) { "foo\nfoo\nbar\nbar baz" }

      it 'requests changes' do
        expect(provider).not_to be_exists
      end
      it 'replaces the matches' do
        provider.create
        expect(File.read(tmpfile).chomp).to eql("foo\nfoo\nfoo\nfoo")
      end
    end
  end

  context 'when match does not match line - when there are no matches' do
    let(:params) do
      {
        :replace_all_matches_not_matching_line => true,
        :match => '^bar',
        :multiple => true,
      }
    end
    let(:content) { "foo\nfoo bar" }

    it 'does not request changes' do
      expect(provider).to be_exists
    end
  end

  context 'when match does not match line - when there are no matches or lines' do
    let(:params) do
      {
        :replace_all_matches_not_matching_line => true,
        :match => '^bar',
        :multiple => true,
      }
    end
    let(:content) { 'foo bar' }

    it 'requests changes' do
      expect(provider).not_to be_exists
    end
    it 'appends the line' do
      provider.create
      expect(File.read(tmpfile).chomp).to eql("foo bar\nfoo")
    end
  end
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
end
