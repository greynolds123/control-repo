require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.4.0') >= 0
  describe 'validate_legacy' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError) }

    describe 'when passing the type assertion and passing the previous validation' do
<<<<<<< HEAD
      before(:each) do
        scope.expects(:function_validate_foo).with([5]).once
        Puppet.expects(:notice).never
      end
      it 'passes without notice' do
=======
      it 'passes without notice' do
        expect(scope).to receive(:function_validate_foo).with([5]).once
        expect(Puppet).to receive(:notice).never
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
        is_expected.to run.with_params('Integer', 'validate_foo', 5)
      end
    end

    describe 'when passing the type assertion and failing the previous validation' do
<<<<<<< HEAD
      before(:each) do
        scope.expects(:function_validate_foo).with([5]).raises(Puppet::ParseError, 'foo').once
        Puppet.expects(:notice).with(includes('Accepting previously invalid value for target type'))
      end
      it 'passes with a notice about newly accepted value' do
=======
      it 'passes with a notice about newly accepted value' do
        expect(scope).to receive(:function_validate_foo).with([5]).and_raise(Puppet::ParseError, 'foo').once
        expect(Puppet).to receive(:notice).with(include('Accepting previously invalid value for target type'))
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
        is_expected.to run.with_params('Integer', 'validate_foo', 5)
      end
    end

    describe 'when failing the type assertion and passing the previous validation' do
<<<<<<< HEAD
      before(:each) do
        scope.expects(:function_validate_foo).with(['5']).once
        subject.func.expects(:call_function).with('deprecation', 'validate_legacy', includes('Integer')).once
      end
      it 'passes with a deprecation message' do
=======
      it 'passes with a deprecation message' do
        expect(scope).to receive(:function_validate_foo).with(['5']).once
        expect(subject.func).to receive(:call_function).with('deprecation', 'validate_legacy', include('Integer')).once
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
        is_expected.to run.with_params('Integer', 'validate_foo', '5')
      end
    end

    describe 'when failing the type assertion and failing the previous validation' do
<<<<<<< HEAD
      before(:each) do
        scope.expects(:function_validate_foo).with(['5']).raises(Puppet::ParseError, 'foo').once
        subject.func.expects(:call_function).with('fail', includes('Integer')).once
      end
      it 'fails with a helpful message' do
=======
      it 'fails with a helpful message' do
        expect(scope).to receive(:function_validate_foo).with(['5']).and_raise(Puppet::ParseError, 'foo').once
        expect(subject.func).to receive(:call_function).with('fail', include('Integer')).once
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
        is_expected.to run.with_params('Integer', 'validate_foo', '5')
      end
    end

    describe 'when passing in undef' do
<<<<<<< HEAD
      before(:each) do
        scope.expects(:function_validate_foo).with([:undef]).once
        Puppet.expects(:notice).never
      end
      it 'works' do
=======
      it 'works' do
        expect(scope).to receive(:function_validate_foo).with([:undef]).once
        expect(Puppet).to receive(:notice).never
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
        is_expected.to run.with_params('Optional[Integer]', 'validate_foo', :undef)
      end
    end

    describe 'when passing in multiple arguments' do
<<<<<<< HEAD
      before(:each) do
        scope.expects(:function_validate_foo).with([:undef, 1, 'foo']).once
        Puppet.expects(:notice).never
      end
      it 'passes with a deprecation message' do
=======
      it 'passes with a deprecation message' do
        expect(scope).to receive(:function_validate_foo).with([:undef, 1, 'foo']).once
        expect(Puppet).to receive(:notice).never
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
        is_expected.to run.with_params('Optional[Integer]', 'validate_foo', :undef, 1, 'foo')
      end
    end
  end
end
