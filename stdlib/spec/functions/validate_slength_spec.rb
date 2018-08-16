require 'spec_helper'

describe 'validate_slength' do
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
    scope.expects(:warning).with(includes('This method is deprecated'))
    is_expected.to run.with_params('1234567890', 10)
  end
  
  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
    it { is_expected.to run.with_params('').and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
    it { is_expected.to run.with_params('', 2, 3, 'extra').and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
    it { is_expected.to run.with_params('', '').and_raise_error(Puppet::ParseError, /second argument to be a positive Numeric/) }
    it { is_expected.to run.with_params('', -1).and_raise_error(Puppet::ParseError, /second argument to be a positive Numeric/) }
    it { is_expected.to run.with_params('', 1, '').and_raise_error(Puppet::ParseError, /third argument to be unset or a positive Numeric/) }
    it { is_expected.to run.with_params('', 1, -1).and_raise_error(Puppet::ParseError, /third argument to be unset or a positive Numeric/) }
    it { is_expected.to run.with_params('', 1, 2).and_raise_error(Puppet::ParseError, /argument to be equal to or larger than third argument/) }
  end

  context "with a maximum length of 10" do
    describe 'rejects strings longer than the limit' do
      it { is_expected.to run.with_params('1234567890a', 10).and_raise_error(Puppet::ParseError, /Expected length/) }
      it { is_expected.to run.with_params('1234567890abcdef', 10).and_raise_error(Puppet::ParseError, /Expected length/) }
      it { is_expected.to run.with_params([ 'one', '1234567890abcdef' ], 10).and_raise_error(Puppet::ParseError, /Expected length/) }
=======
  it 'displays a single deprecation' do
    ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
    scope.expects(:warning).with(includes('This method is deprecated'))
    is_expected.to run.with_params('1234567890', 10)
  end

  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it { is_expected.to run.with_params('').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it { is_expected.to run.with_params('', 2, 3, 'extra').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it { is_expected.to run.with_params('', '').and_raise_error(Puppet::ParseError, %r{second argument to be a positive Numeric}) }
    it { is_expected.to run.with_params('', -1).and_raise_error(Puppet::ParseError, %r{second argument to be a positive Numeric}) }
    it { is_expected.to run.with_params('', 1, '').and_raise_error(Puppet::ParseError, %r{third argument to be unset or a positive Numeric}) }
    it { is_expected.to run.with_params('', 1, -1).and_raise_error(Puppet::ParseError, %r{third argument to be unset or a positive Numeric}) }
    it { is_expected.to run.with_params('', 1, 2).and_raise_error(Puppet::ParseError, %r{argument to be equal to or larger than third argument}) }
  end

  context 'with a maximum length of 10' do
    describe 'rejects strings longer than the limit' do
      it { is_expected.to run.with_params('1234567890a', 10).and_raise_error(Puppet::ParseError, %r{Expected length}) }
      it { is_expected.to run.with_params('1234567890abcdef', 10).and_raise_error(Puppet::ParseError, %r{Expected length}) }
      it { is_expected.to run.with_params(%w[one 1234567890abcdef], 10).and_raise_error(Puppet::ParseError, %r{Expected length}) }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end

    describe 'accepts strings shorter or equal to the limit' do
      it { is_expected.to run.with_params('1234567890', 10) }
      it { is_expected.to run.with_params('12345', 10) }
<<<<<<< HEAD
      it { is_expected.to run.with_params([ 'one', 'two' ], 10) }
    end

    context "with a minimum length of 5" do
      describe 'rejects strings longer than the upper limit' do
        it { is_expected.to run.with_params('1234567890a', 10, 5).and_raise_error(Puppet::ParseError, /Expected length/) }
        it { is_expected.to run.with_params('1234567890abcdef', 10, 5).and_raise_error(Puppet::ParseError, /Expected length/) }
      end

      describe 'rejects numbers shorter than the lower limit' do
        it { is_expected.to run.with_params('one', 10, 5).and_raise_error(Puppet::ParseError, /Expected length/) }
        it { is_expected.to run.with_params(['12345678', 'two'], 10, 5).and_raise_error(Puppet::ParseError, /Expected length/) }
      end

      describe 'accepts strings of length between and including the limits' do
        it { is_expected.to run.with_params('12345', 10, 5) }
        it { is_expected.to run.with_params('123456', 10, 5) }
        it { is_expected.to run.with_params('1234567', 10, 5) }
        it { is_expected.to run.with_params('12345678', 10, 5) }
        it { is_expected.to run.with_params('123456789', 10, 5) }
        it { is_expected.to run.with_params('1234567890', 10, 5) }
        it { is_expected.to run.with_params(['1233456', '12345678'], 10, 5) }
      end
=======
      it { is_expected.to run.with_params(%w[one two], 10) }
    end
  end

  context 'with a minimum length of 5' do
    describe 'rejects strings longer than the upper limit' do
      it { is_expected.to run.with_params('1234567890a', 10, 5).and_raise_error(Puppet::ParseError, %r{Expected length}) }
      it { is_expected.to run.with_params('1234567890abcdef', 10, 5).and_raise_error(Puppet::ParseError, %r{Expected length}) }
    end

    describe 'rejects numbers shorter than the lower limit' do
      it { is_expected.to run.with_params('one', 10, 5).and_raise_error(Puppet::ParseError, %r{Expected length}) }
      it { is_expected.to run.with_params(%w[12345678 two], 10, 5).and_raise_error(Puppet::ParseError, %r{Expected length}) }
    end

    describe 'accepts strings of length between and including the limits' do
      it { is_expected.to run.with_params('12345', 10, 5) }
      it { is_expected.to run.with_params('123456', 10, 5) }
      it { is_expected.to run.with_params('1234567', 10, 5) }
      it { is_expected.to run.with_params('12345678', 10, 5) }
      it { is_expected.to run.with_params('123456789', 10, 5) }
      it { is_expected.to run.with_params('1234567890', 10, 5) }
      it { is_expected.to run.with_params(%w[1233456 12345678], 10, 5) }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end
  end

  describe 'corner cases' do
<<<<<<< HEAD
    it { pending('this should work'); is_expected.to run.with_params('', 0, 0) }
=======
    it {
      pending('this should work')
      is_expected.to run.with_params('', 0, 0)
    }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    it { is_expected.to run.with_params('1234567890', 10, 10) }
  end

  describe 'empty upper limit is interpreted as infinity' do
<<<<<<< HEAD
    it { pending('not implemented'); is_expected.to run.with_params('1234567890ab', '', 10) }
    it { pending('not implemented'); is_expected.to run.with_params('12345678', '', 10).and_raise_error(Puppet::ParseError, /Expected length/) }
=======
    it {
      pending('not implemented')
      is_expected.to run.with_params('1234567890ab', '', 10)
    }
    it {
      pending('not implemented')
      is_expected.to run.with_params('12345678', '', 10).and_raise_error(Puppet::ParseError, %r{Expected length})
    }
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end
end
