require 'spec_helper'

describe 'loadyaml' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(ArgumentError, /wrong number of arguments/i) }

  context 'when a non-existing file is specified' do
    let(:filename) { '/tmp/doesnotexist' }
    before {
      File.expects(:exists?).with(filename).returns(false).once
      YAML.expects(:load_file).never
    }
    it { is_expected.to run.with_params(filename, {'default' => 'value'}).and_return({'default' => 'value'}) }
=======
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{wrong number of arguments}i) }

  context 'when a non-existing file is specified' do
    let(:filename) { '/tmp/doesnotexist' }

    before(:each) do
      File.expects(:exists?).with(filename).returns(false).once
      YAML.expects(:load_file).never
    end
    it { is_expected.to run.with_params(filename, 'default' => 'value').and_return('default' => 'value') }
    it { is_expected.to run.with_params(filename, 'đẽƒằưļŧ' => '٧ẵłựέ').and_return('đẽƒằưļŧ' => '٧ẵłựέ') }
    it { is_expected.to run.with_params(filename, 'デフォルト' => '値').and_return('デフォルト' => '値') }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  end

  context 'when an existing file is specified' do
    let(:filename) { '/tmp/doesexist' }
<<<<<<< HEAD
    let(:data) { { 'key' => 'value' } }
    before {
      File.expects(:exists?).with(filename).returns(true).once
      YAML.expects(:load_file).with(filename).returns(data).once
    }
=======
    let(:data) { { 'key' => 'value', 'ķęŷ' => 'νậŀųề', 'キー' => '値' } }

    before(:each) do
      File.expects(:exists?).with(filename).returns(true).once
      YAML.expects(:load_file).with(filename).returns(data).once
    end
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    it { is_expected.to run.with_params(filename).and_return(data) }
  end

  context 'when the file could not be parsed' do
    let(:filename) { '/tmp/doesexist' }
<<<<<<< HEAD
    before {
      File.expects(:exists?).with(filename).returns(true).once
      YAML.stubs(:load_file).with(filename).once.raises StandardError, 'Something terrible have happened!'
    }
    it { is_expected.to run.with_params(filename, {'default' => 'value'}).and_return({'default' => 'value'}) }
=======

    before(:each) do
      File.expects(:exists?).with(filename).returns(true).once
      YAML.stubs(:load_file).with(filename).once.raises StandardError, 'Something terrible have happened!'
    end
    it { is_expected.to run.with_params(filename, 'default' => 'value').and_return('default' => 'value') }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  end
end
