require 'spec_helper'

describe 'delete_undef_values' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError) }

  describe 'when deleting from an array' do
<<<<<<< HEAD
    [ :undef, '', nil ].each do |undef_value|
      describe "when undef is represented by #{undef_value.inspect}" do
        before do
          pending("review behaviour when being passed undef as #{undef_value.inspect}") if undef_value == ''
          pending("review behaviour when being passed undef as #{undef_value.inspect}") if undef_value == nil
        end
        it { is_expected.to run.with_params([undef_value]).and_return([]) }
        it { is_expected.to run.with_params(['one',undef_value,'two','three']).and_return(['one','two','three']) }
      end

      it "should leave the original argument intact" do
        argument = ['one',undef_value,'two']
        original = argument.dup
        result = subject.call([argument,2])
=======
    [:undef, '', nil].each do |undef_value|
      describe "when undef is represented by #{undef_value.inspect}" do
        before(:each) do
          pending("review behaviour when being passed undef as #{undef_value.inspect}") if undef_value == ''
          pending("review behaviour when being passed undef as #{undef_value.inspect}") if undef_value.nil?
        end
        it { is_expected.to run.with_params([undef_value]).and_return([]) }
        it { is_expected.to run.with_params(['one', undef_value, 'two', 'three']).and_return(%w[one two three]) }
        it { is_expected.to run.with_params(['ớņέ', undef_value, 'ŧשּׁō', 'ŧħґëə']).and_return(%w[ớņέ ŧשּׁō ŧħґëə]) }
      end

      it 'leaves the original argument intact' do
        argument = ['one', undef_value, 'two']
        original = argument.dup
        _result = subject.call([argument, 2])
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        expect(argument).to eq(original)
      end
    end

    it { is_expected.to run.with_params(['undef']).and_return(['undef']) }
  end

  describe 'when deleting from a hash' do
<<<<<<< HEAD
    [ :undef, '', nil ].each do |undef_value|
      describe "when undef is represented by #{undef_value.inspect}" do
        before do
          pending("review behaviour when being passed undef as #{undef_value.inspect}") if undef_value == ''
          pending("review behaviour when being passed undef as #{undef_value.inspect}") if undef_value == nil
        end
        it { is_expected.to run.with_params({'key' => undef_value}).and_return({}) }
        it { is_expected.to run \
          .with_params({'key1' => 'value1', 'undef_key' => undef_value, 'key2' => 'value2'}) \
          .and_return({'key1' => 'value1', 'key2' => 'value2'})
        }
      end

      it "should leave the original argument intact" do
        argument = { 'key1' => 'value1', 'key2' => undef_value }
        original = argument.dup
        result = subject.call([argument,2])
=======
    [:undef, '', nil].each do |undef_value|
      describe "when undef is represented by #{undef_value.inspect}" do
        before(:each) do
          pending("review behaviour when being passed undef as #{undef_value.inspect}") if undef_value == ''
          pending("review behaviour when being passed undef as #{undef_value.inspect}") if undef_value.nil?
        end
        it { is_expected.to run.with_params('key' => undef_value).and_return({}) }
        it {
          is_expected.to run \
            .with_params('key1' => 'value1', 'undef_key' => undef_value, 'key2' => 'value2') \
            .and_return('key1' => 'value1', 'key2' => 'value2')
        }
      end

      it 'leaves the original argument intact' do
        argument = { 'key1' => 'value1', 'key2' => undef_value }
        original = argument.dup
        _result = subject.call([argument, 2])
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        expect(argument).to eq(original)
      end
    end

<<<<<<< HEAD
    it { is_expected.to run.with_params({'key' => 'undef'}).and_return({'key' => 'undef'}) }
=======
    it { is_expected.to run.with_params('key' => 'undef').and_return('key' => 'undef') }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end
end
