require 'spec_helper'

describe 'loadyaml' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{wrong number of arguments}i) }

  context 'when a non-existing file is specified' do
    let(:filename) { '/tmp/doesnotexist' }

<<<<<<< HEAD
    before(:each) do
      File.expects(:exists?).with(filename).returns(false).once
      YAML.expects(:load_file).never
    end
    it { is_expected.to run.with_params(filename, 'default' => 'value').and_return('default' => 'value') }
    it { is_expected.to run.with_params(filename, 'đẽƒằưļŧ' => '٧ẵłựέ').and_return('đẽƒằưļŧ' => '٧ẵłựέ') }
    it { is_expected.to run.with_params(filename, 'デフォルト' => '値').and_return('デフォルト' => '値') }
=======
    it "'default' => 'value'" do
      expect(File).to receive(:exists?).with(filename).and_return(false).once
      expect(YAML).to receive(:load_file).never
      is_expected.to run.with_params(filename, 'default' => 'value').and_return('default' => 'value')
    end
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'when an existing file is specified' do
    let(:filename) { '/tmp/doesexist' }
    let(:data) { { 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値' } }

<<<<<<< HEAD
    before(:each) do
      File.expects(:exists?).with(filename).returns(true).once
      YAML.expects(:load_file).with(filename).returns(data).once
    end
    it { is_expected.to run.with_params(filename).and_return(data) }
=======
    it "returns 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値'" do
      expect(File).to receive(:exists?).with(filename).and_return(true).once
      expect(YAML).to receive(:load_file).with(filename).and_return(data).once
      is_expected.to run.with_params(filename).and_return(data)
    end
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end

  context 'when the file could not be parsed' do
    let(:filename) { '/tmp/doesexist' }

<<<<<<< HEAD
    before(:each) do
      File.expects(:exists?).with(filename).returns(true).once
      YAML.stubs(:load_file).with(filename).once.raises StandardError, 'Something terrible have happened!'
    end
    it { is_expected.to run.with_params(filename, 'default' => 'value').and_return('default' => 'value') }
=======
    it 'filename /tmp/doesexist' do
      expect(File).to receive(:exists?).with(filename).and_return(true).once
      allow(YAML).to receive(:load_file).with(filename).once.and_raise(StandardError, 'Something terrible have happened!')
      is_expected.to run.with_params(filename, 'default' => 'value').and_return('default' => 'value')
    end
  end

  context 'when an existing URL is specified' do
    let(:filename) { 'https://example.local/myhash.yaml' }
    let(:basic_auth) { { :http_basic_authentication => ['', ''] } }
    let(:yaml) { 'Dummy YAML' }
    let(:data) { { 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値' } }

    it {
      expect(OpenURI).to receive(:open_uri).with(filename, basic_auth).and_return(yaml)
      expect(YAML).to receive(:safe_load).with(yaml).and_return(data).once
      is_expected.to run.with_params(filename).and_return(data)
    }
  end

  context 'when an existing URL (with username and password) is specified' do
    let(:filename) { 'https://user1:pass1@example.local/myhash.yaml' }
    let(:url_no_auth) { 'https://example.local/myhash.yaml' }
    let(:basic_auth) { { :http_basic_authentication => ['user1', 'pass1'] } }
    let(:yaml) { 'Dummy YAML' }
    let(:data) { { 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値' } }

    it {
      expect(OpenURI).to receive(:open_uri).with(url_no_auth, basic_auth).and_return(yaml)
      expect(YAML).to receive(:safe_load).with(yaml).and_return(data).once
      is_expected.to run.with_params(filename).and_return(data)
    }
  end

  context 'when an existing URL (with username) is specified' do
    let(:filename) { 'https://user1@example.local/myhash.yaml' }
    let(:url_no_auth) { 'https://example.local/myhash.yaml' }
    let(:basic_auth) { { :http_basic_authentication => ['user1', ''] } }
    let(:yaml) { 'Dummy YAML' }
    let(:data) { { 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値' } }

    it {
      expect(OpenURI).to receive(:open_uri).with(url_no_auth, basic_auth).and_return(yaml)
      expect(YAML).to receive(:safe_load).with(yaml).and_return(data).once
      is_expected.to run.with_params(filename).and_return(data)
    }
  end

  context 'when an existing URL could not be parsed, with default specified' do
    let(:filename) { 'https://example.local/myhash.yaml' }
    let(:basic_auth) { { :http_basic_authentication => ['', ''] } }
    let(:yaml) { 'Dummy YAML' }

    it {
      expect(OpenURI).to receive(:open_uri).with(filename, basic_auth).and_return(yaml)
      expect(YAML).to receive(:safe_load).with(yaml).and_raise StandardError, 'Cannot parse data'
      is_expected.to run.with_params(filename, 'default' => 'value').and_return('default' => 'value')
    }
  end

  context 'when a URL does not exist, with default specified' do
    let(:filename) { 'https://example.local/myhash.yaml' }
    let(:basic_auth) { { :http_basic_authentication => ['', ''] } }
    let(:yaml) { 'Dummy YAML' }

    it {
      expect(OpenURI).to receive(:open_uri).with(filename, basic_auth).and_raise OpenURI::HTTPError, '404 File not Found'
      is_expected.to run.with_params(filename, 'default' => 'value').and_return('default' => 'value')
    }
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  end
end
