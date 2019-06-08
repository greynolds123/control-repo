require 'spec_helper'

describe 'delete_regex' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params([], 'two') }
  it { is_expected.to run.with_params({}, 'two') }
  it { is_expected.to run.with_params([], 'two', 'three').and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params([], 'two', 'three', 'four').and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(1, 'two').and_raise_error(TypeError) }

  describe 'deleting from an array' do
    it { is_expected.to run.with_params([], '').and_return([]) }
    it { is_expected.to run.with_params([], 'two').and_return([]) }
    it { is_expected.to run.with_params(['two'], 'two').and_return([]) }
<<<<<<< HEAD
    it { is_expected.to run.with_params(%w[two two], 'two').and_return([]) }
    it { is_expected.to run.with_params(%w[one two three], '^t.*').and_return(['one']) }
    it { is_expected.to run.with_params(%w[ab b c b], 'b').and_return(%w[ab c]) }
    it { is_expected.to run.with_params(%w[one two three], 'four').and_return(%w[one two three]) }
    it { is_expected.to run.with_params(%w[one two three], 'e').and_return(%w[one two three]) }
    it { is_expected.to run.with_params(%w[one two three], 'two').and_return(%w[one three]) }
    it { is_expected.to run.with_params(%w[two one two three two], 'two').and_return(%w[one three]) }
=======
    it { is_expected.to run.with_params(['two', 'two'], 'two').and_return([]) }
    it { is_expected.to run.with_params(['one', 'two', 'three'], '^t.*').and_return(['one']) }
    it { is_expected.to run.with_params(['ab', 'b', 'c', 'b'], 'b').and_return(['ab', 'c']) }
    it { is_expected.to run.with_params(['one', 'two', 'three'], 'four').and_return(['one', 'two', 'three']) }
    it { is_expected.to run.with_params(['one', 'two', 'three'], 'e').and_return(['one', 'two', 'three']) }
    it { is_expected.to run.with_params(['one', 'two', 'three'], 'two').and_return(['one', 'three']) }
    it { is_expected.to run.with_params(['two', 'one', 'two', 'three', 'two'], 'two').and_return(['one', 'three']) }
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
    it { is_expected.to run.with_params(['abracadabra'], 'abr').and_return(['abracadabra']) }
    it { is_expected.to run.with_params(['abracadabra'], '^.*jimbob.*$').and_return(['abracadabra']) }
  end

  describe 'deleting from an array' do
    it { is_expected.to run.with_params({}, '').and_return({}) }
    it { is_expected.to run.with_params({}, 'key').and_return({}) }
    it { is_expected.to run.with_params({ 'key' => 'value' }, 'key').and_return({}) }
    it {
      is_expected.to run \
        .with_params({ 'key1' => 'value1', 'key2' => 'value2', 'key3' => 'value3' }, 'key2') \
        .and_return('key1' => 'value1', 'key3' => 'value3')
    }
    it {
      is_expected.to run \
<<<<<<< HEAD
        .with_params({ 'key1' => 'value1', 'key2' => 'value2', 'key3' => 'value3' }, %w[key1 key2]) \
=======
        .with_params({ 'key1' => 'value1', 'key2' => 'value2', 'key3' => 'value3' }, ['key1', 'key2']) \
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
        .and_return('key3' => 'value3')
    }
  end

  it 'leaves the original array intact' do
<<<<<<< HEAD
    argument1 = %w[one two three]
    original1 = argument1.dup
    subject.call([argument1, 'two'])
=======
    argument1 = ['one', 'two', 'three']
    original1 = argument1.dup
    subject.execute(argument1, 'two')
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
    expect(argument1).to eq(original1)
  end
  it 'leaves the original hash intact' do
    argument1 = { 'key1' => 'value1', 'key2' => 'value2', 'key3' => 'value3' }
    original1 = argument1.dup
<<<<<<< HEAD
    subject.call([argument1, 'key2'])
=======
    subject.execute(argument1, 'key2')
>>>>>>> f661b3a03526f113b1823084ffd4808cf261cf70
    expect(argument1).to eq(original1)
  end
end
