require 'spec_helper'

# This is a reduced version of ruby_spec.rb just to ensure we can subclass as
# documented
<<<<<<< HEAD
$: << './spec/fixtures/modules/inherit_ini_setting/lib'
=======
$LOAD_PATH << './spec/fixtures/modules/inherit_ini_setting/lib'
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
provider_class = Puppet::Type.type(:inherit_ini_setting).provider(:ini_setting)
describe provider_class do
  include PuppetlabsSpec::Files

  let(:tmpfile) { tmpfilename('inherit_ini_setting_test') }

  def validate_file(expected_content, tmpfile)
<<<<<<< HEAD
    File.read(tmpfile).should == expected_content
  end


=======
    expect(File.read(tmpfile)).to eq(expected_content)
  end

>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  before :each do
    File.open(tmpfile, 'w') do |fh|
      fh.write(orig_content)
    end
  end

  context 'when calling instances' do
    let(:orig_content) { '' }

<<<<<<< HEAD
    it 'should parse nothing when the file is empty' do
      provider_class.stubs(:file_path).returns(tmpfile)
      provider_class.instances.should == []
    end

    context 'when the file has contents' do
      let(:orig_content) {
        <<-EOS
# A comment
red = blue
green = purple
        EOS
      }

      it 'should parse the results' do
        provider_class.stubs(:file_path).returns(tmpfile)
        instances = provider_class.instances
        instances.size.should == 2
        # inherited version of namevar flattens the names
        names = instances.map do |instance|
          instance.instance_variable_get(:@property_hash)[:name]
        end
        names.sort.should == [ 'green', 'red' ]
=======
    it 'parses nothing when the file is empty' do
      provider_class.stubs(:file_path).returns(tmpfile)
      expect(provider_class.instances).to eq([])
    end

    context 'when the file has contents' do
      let(:orig_content) do
        <<-EOS
          # A comment
          red = blue
          green = purple
        EOS
      end

      it 'parses the results' do
        provider_class.stubs(:file_path).returns(tmpfile)
        instances = provider_class.instances
        expect(instances.size).to eq(2)
        # inherited version of namevar flattens the names
        names = instances.map do |instance| instance.instance_variable_get(:@property_hash)[:name] end # rubocop:disable Style/BlockDelimiters
        expect(names.sort).to eq(['green', 'red'])
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      end
    end
  end

  context 'when ensuring that a setting is present' do
    let(:orig_content) { '' }

<<<<<<< HEAD
    it 'should add a value to the file' do
      provider_class.stubs(:file_path).returns(tmpfile)
      resource = Puppet::Type::Inherit_ini_setting.new({
        :setting => 'set_this',
        :value   => 'to_that',
      })
=======
    it 'adds a value to the file' do
      provider_class.stubs(:file_path).returns(tmpfile)
      resource = Puppet::Type::Inherit_ini_setting.new(setting: 'set_this', value: 'to_that')
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      provider = described_class.new(resource)
      provider.create
      validate_file("set_this=to_that\n", tmpfile)
    end
  end
end
