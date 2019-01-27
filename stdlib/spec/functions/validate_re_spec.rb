require 'spec_helper'

describe 'validate_re' do
<<<<<<< HEAD
  after(:all) do
=======
  after(:each) do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    ENV.delete('STDLIB_LOG_DEPRECATIONS')
  end

  # Checking for deprecation warning
<<<<<<< HEAD
  it 'should display a single deprecation' do
    ENV['STDLIB_LOG_DEPRECATIONS'] = "true"
=======
  it 'displays a single deprecation' do
    ENV['STDLIB_LOG_DEPRECATIONS'] = 'true'
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    scope.expects(:warning).with(includes('This method is deprecated'))
    is_expected.to run.with_params('', '')
  end

  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
    it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
    it { is_expected.to run.with_params('').and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
    it { is_expected.to run.with_params('', '', '', 'extra').and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
=======
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it { is_expected.to run.with_params('').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it { is_expected.to run.with_params('', '', '', 'extra').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

    describe 'valid inputs' do
      it { is_expected.to run.with_params('', '') }
      it { is_expected.to run.with_params('', ['']) }
      it { is_expected.to run.with_params('', [''], 'custom error') }
      it { is_expected.to run.with_params('one', '^one') }
<<<<<<< HEAD
      it { is_expected.to run.with_params('one', [ '^one', '^two' ]) }
      it { is_expected.to run.with_params('one', [ '^one', '^two' ], 'custom error') }
    end

    describe 'invalid inputs' do
      it { is_expected.to run.with_params('', []).and_raise_error(Puppet::ParseError, /does not match/) }
      it { is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError, /does not match/) }
      it { is_expected.to run.with_params('', 'two').and_raise_error(Puppet::ParseError, /does not match/) }
      it { is_expected.to run.with_params('', ['two']).and_raise_error(Puppet::ParseError, /does not match/) }
      it { is_expected.to run.with_params('', ['two'], 'custom error').and_raise_error(Puppet::ParseError, /custom error/) }
      it { is_expected.to run.with_params('notone', '^one').and_raise_error(Puppet::ParseError, /does not match/) }
      it { is_expected.to run.with_params('notone', [ '^one', '^two' ]).and_raise_error(Puppet::ParseError, /does not match/) }
      it { is_expected.to run.with_params('notone', [ '^one', '^two' ], 'custom error').and_raise_error(Puppet::ParseError, /custom error/) }

      describe 'non-string inputs' do
        [
          1,             # Fixnum
          3.14,          # Float
          nil,           # NilClass
          true,          # TrueClass
          false,         # FalseClass
          ["10"],        # Array
          :key,          # Symbol
          {:key=>"val"}, # Hash
        ].each do |input|
          it { is_expected.to run.with_params(input, '.*').and_raise_error(Puppet::ParseError, /needs to be a String/) }
        end
=======
      it { is_expected.to run.with_params('one', ['^one', '^two']) }
      it { is_expected.to run.with_params('one', ['^one', '^two'], 'custom error') }
    end

    describe 'invalid inputs' do
      it { is_expected.to run.with_params('', []).and_raise_error(Puppet::ParseError, %r{does not match}) }
      it { is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError, %r{does not match}) }
      it { is_expected.to run.with_params('', 'two').and_raise_error(Puppet::ParseError, %r{does not match}) }
      it { is_expected.to run.with_params('', ['two']).and_raise_error(Puppet::ParseError, %r{does not match}) }
      it { is_expected.to run.with_params('', ['two'], 'custom error').and_raise_error(Puppet::ParseError, %r{custom error}) }
      it { is_expected.to run.with_params('notone', '^one').and_raise_error(Puppet::ParseError, %r{does not match}) }
      it { is_expected.to run.with_params('notone', ['^one', '^two']).and_raise_error(Puppet::ParseError, %r{does not match}) }
      it { is_expected.to run.with_params('notone', ['^one', '^two'], 'custom error').and_raise_error(Puppet::ParseError, %r{custom error}) }
    end

    describe 'non-string inputs' do
      [
        1,             # Fixnum
        3.14,          # Float
        nil,           # NilClass
        true,          # TrueClass
        false,         # FalseClass
        ['10'],        # Array
        :key,          # Symbol
        { :key => 'val' }, # Hash
      ].each do |input|
        it { is_expected.to run.with_params(input, '.*').and_raise_error(Puppet::ParseError, %r{needs to be a String}) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      end
    end
  end
end
