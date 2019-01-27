require 'spec_helper'

describe 'validate_integer' do
<<<<<<< HEAD
  after(:all) do
=======
  after(:each) do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    ENV.delete('STDLIB_LOG_DEPRECATIONS')
  end

  # Checking for deprecation warning
<<<<<<< HEAD
  it 'should display a single deprecation' do
    ENV['STDLIB_LOG_DEPRECATIONS'] = "true"
=======
  it 'displays a single deprecation' do
    ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    scope.expects(:warning).with(includes('This method is deprecated'))
    is_expected.to run.with_params(3)
  end

  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
    it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
    it { is_expected.to run.with_params(1, 2, 3, 4).and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }

    [ true, 'true', false, 'false', 'iAmAString', '1test', '1 test', 'test 1', 'test 1 test', 7.0, -7.0, {}, { 'key' => 'value' }, { 1=> 2 }, '', :undef , 'x'].each do |invalid|
      it { is_expected.to run.with_params(invalid).and_raise_error(Puppet::ParseError, /to be an Integer/) }
      it { is_expected.to run.with_params(invalid, 10).and_raise_error(Puppet::ParseError, /to be an Integer/) }
      it { is_expected.to run.with_params(invalid, 10, -10).and_raise_error(Puppet::ParseError, /to be an Integer/) }
      it { is_expected.to run.with_params([0, 1, 2, invalid, 3, 4], 10, -10).and_raise_error(Puppet::ParseError, /to be an Integer/) }
    end

    context 'when running on modern rubies', :unless => RUBY_VERSION == '1.8.7' do
      it { is_expected.to run.with_params([0, 1, 2, {1=>2}, 3, 4], 10, -10).and_raise_error(Puppet::ParseError, /to be an Integer/) }
    end

    context 'when running on ruby, which munges hashes weirdly', :if => RUBY_VERSION == '1.8.7' do
      it { is_expected.to run.with_params([0, 1, 2, {1=>2}, 3, 4], 10, -10).and_raise_error(Puppet::ParseError) }
      it { is_expected.to run.with_params([0, 1, 2, {0=>2}, 3, 4], 10, -10).and_raise_error(Puppet::ParseError) }
    end

    it { is_expected.to run.with_params(1, '').and_raise_error(Puppet::ParseError, /to be unset or an Integer/) }
    it { is_expected.to run.with_params(1, 2, '').and_raise_error(Puppet::ParseError, /to be unset or an Integer/) }
    it { is_expected.to run.with_params(1, 2, 3).and_raise_error(Puppet::ParseError, /second argument to be larger than third argument/) }
=======
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it { is_expected.to run.with_params(1, 2, 3, 4).and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }

    [true, 'true', false, 'false', 'iAmAString', '1test', '1 test', 'test 1', 'test 1 test', 7.0, -7.0, {}, { 'key' => 'value' }, { 1 => 2 }, '', :undef, 'x'].each do |invalid|
      it { is_expected.to run.with_params(invalid).and_raise_error(Puppet::ParseError, %r{to be an Integer}) }
      it { is_expected.to run.with_params(invalid, 10).and_raise_error(Puppet::ParseError, %r{to be an Integer}) }
      it { is_expected.to run.with_params(invalid, 10, -10).and_raise_error(Puppet::ParseError, %r{to be an Integer}) }
      it { is_expected.to run.with_params([0, 1, 2, invalid, 3, 4], 10, -10).and_raise_error(Puppet::ParseError, %r{to be an Integer}) }
    end

    context 'when running on modern rubies', :unless => RUBY_VERSION == '1.8.7' do
      it { is_expected.to run.with_params([0, 1, 2, { 1 => 2 }, 3, 4], 10, -10).and_raise_error(Puppet::ParseError, %r{to be an Integer}) }
    end

    context 'when running on ruby, which munges hashes weirdly', :if => RUBY_VERSION == '1.8.7' do
      it { is_expected.to run.with_params([0, 1, 2, { 1 => 2 }, 3, 4], 10, -10).and_raise_error(Puppet::ParseError) }
      it { is_expected.to run.with_params([0, 1, 2, { 0 => 2 }, 3, 4], 10, -10).and_raise_error(Puppet::ParseError) }
    end

    it { is_expected.to run.with_params(1, '').and_raise_error(Puppet::ParseError, %r{to be unset or an Integer}) }
    it { is_expected.to run.with_params(1, 2, '').and_raise_error(Puppet::ParseError, %r{to be unset or an Integer}) }
    it { is_expected.to run.with_params(1, 2, 3).and_raise_error(Puppet::ParseError, %r{second argument to be larger than third argument}) }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end

  context 'with no range constraints' do
    it { is_expected.to run.with_params(1) }
    it { is_expected.to run.with_params(-1) }
    it { is_expected.to run.with_params('1') }
    it { is_expected.to run.with_params('-1') }
    it { is_expected.to run.with_params([1, 2, 3, 4]) }
    it { is_expected.to run.with_params([1, '2', '3', 4]) }
  end

<<<<<<< HEAD
  context "with a maximum limit of 10" do
    describe 'rejects numbers greater than the limit' do
      it { is_expected.to run.with_params(11, 10).and_raise_error(Puppet::ParseError, /to be smaller or equal/) }
      it { is_expected.to run.with_params(100, 10).and_raise_error(Puppet::ParseError, /to be smaller or equal/) }
      it { is_expected.to run.with_params(2**65, 10).and_raise_error(Puppet::ParseError, /to be smaller or equal/) }
      it { is_expected.to run.with_params([1,2,10,100], 10).and_raise_error(Puppet::ParseError, /to be smaller or equal/) }
=======
  context 'with a maximum limit of 10' do
    describe 'rejects numbers greater than the limit' do
      it { is_expected.to run.with_params(11, 10).and_raise_error(Puppet::ParseError, %r{to be smaller or equal}) }
      it { is_expected.to run.with_params(100, 10).and_raise_error(Puppet::ParseError, %r{to be smaller or equal}) }
      it { is_expected.to run.with_params(2**65, 10).and_raise_error(Puppet::ParseError, %r{to be smaller or equal}) }
      it { is_expected.to run.with_params([1, 2, 10, 100], 10).and_raise_error(Puppet::ParseError, %r{to be smaller or equal}) }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    describe 'accepts numbers less or equal to the limit' do
      it { is_expected.to run.with_params(10, 10) }
      it { is_expected.to run.with_params(1, 10) }
      it { is_expected.to run.with_params(-1, 10) }
      it { is_expected.to run.with_params('1', 10) }
      it { is_expected.to run.with_params('-1', 10) }
      it { is_expected.to run.with_params([1, 2, 3, 4], 10) }
      it { is_expected.to run.with_params([1, '2', '3', 4], 10) }
    end
<<<<<<< HEAD

    context "with a minimum limit of -10" do
      describe 'rejects numbers greater than the upper limit' do
        it { is_expected.to run.with_params(11, 10, -10).and_raise_error(Puppet::ParseError, /to be smaller or equal/) }
        it { is_expected.to run.with_params(100, 10, -10).and_raise_error(Puppet::ParseError, /to be smaller or equal/) }
        it { is_expected.to run.with_params(2**65, 10, -10).and_raise_error(Puppet::ParseError, /to be smaller or equal/) }
        it { is_expected.to run.with_params([1,2,10,100], 10, -10).and_raise_error(Puppet::ParseError, /to be smaller or equal/) }
      end

      describe 'rejects numbers smaller than the lower limit' do
        it { is_expected.to run.with_params(-11, 10, -10).and_raise_error(Puppet::ParseError, /to be greater or equal/) }
        it { is_expected.to run.with_params(-100, 10, -10).and_raise_error(Puppet::ParseError, /to be greater or equal/) }
        it { is_expected.to run.with_params(-2**65, 10, -10).and_raise_error(Puppet::ParseError, /to be greater or equal/) }
        it { is_expected.to run.with_params([-10, 1,2,10,-100], 10, -10).and_raise_error(Puppet::ParseError, /to be greater or equal/) }
      end

      describe 'accepts numbers between and including the limits' do
        it { is_expected.to run.with_params(10, 10, -10) }
        it { is_expected.to run.with_params(-10, 10, -10) }
        it { is_expected.to run.with_params(1, 10, -10) }
        it { is_expected.to run.with_params(-1, 10, -10) }
        it { is_expected.to run.with_params('1', 10, -10) }
        it { is_expected.to run.with_params('-1', 10, -10) }
        it { is_expected.to run.with_params([1, 2, 3, 4], 10, -10) }
        it { is_expected.to run.with_params([1, '2', '3', 4], 10, -10) }
      end
=======
  end

  context 'with a minimum limit of -10' do
    describe 'rejects numbers greater than the upper limit' do
      it { is_expected.to run.with_params(11, 10, -10).and_raise_error(Puppet::ParseError, %r{to be smaller or equal}) }
      it { is_expected.to run.with_params(100, 10, -10).and_raise_error(Puppet::ParseError, %r{to be smaller or equal}) }
      it { is_expected.to run.with_params(2**65, 10, -10).and_raise_error(Puppet::ParseError, %r{to be smaller or equal}) }
      it { is_expected.to run.with_params([1, 2, 10, 100], 10, -10).and_raise_error(Puppet::ParseError, %r{to be smaller or equal}) }
    end

    describe 'rejects numbers smaller than the lower limit' do
      it { is_expected.to run.with_params(-11, 10, -10).and_raise_error(Puppet::ParseError, %r{to be greater or equal}) }
      it { is_expected.to run.with_params(-100, 10, -10).and_raise_error(Puppet::ParseError, %r{to be greater or equal}) }
      it { is_expected.to run.with_params(-2**65, 10, -10).and_raise_error(Puppet::ParseError, %r{to be greater or equal}) }
      it { is_expected.to run.with_params([-10, 1, 2, 10, -100], 10, -10).and_raise_error(Puppet::ParseError, %r{to be greater or equal}) }
    end

    describe 'accepts numbers between and including the limits' do
      it { is_expected.to run.with_params(10, 10, -10) }
      it { is_expected.to run.with_params(-10, 10, -10) }
      it { is_expected.to run.with_params(1, 10, -10) }
      it { is_expected.to run.with_params(-1, 10, -10) }
      it { is_expected.to run.with_params('1', 10, -10) }
      it { is_expected.to run.with_params('-1', 10, -10) }
      it { is_expected.to run.with_params([1, 2, 3, 4], 10, -10) }
      it { is_expected.to run.with_params([1, '2', '3', 4], 10, -10) }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end
  end

  it { is_expected.to run.with_params(10, 10, 10) }

  describe 'empty upper limit is interpreted as infinity' do
    it { is_expected.to run.with_params(11, '', 10) }
  end
end
