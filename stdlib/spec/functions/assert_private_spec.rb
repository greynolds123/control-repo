require 'spec_helper'

describe 'assert_private' do
  context 'when called from inside module' do
    it 'does not fail' do
<<<<<<< HEAD
      scope.expects(:lookupvar).with('module_name').returns('foo')
      scope.expects(:lookupvar).with('caller_module_name').returns('foo')
=======
      expect(scope).to receive(:lookupvar).with('module_name').and_return('foo')
      expect(scope).to receive(:lookupvar).with('caller_module_name').and_return('foo')
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8

      is_expected.to run.with_params
    end
  end

  context 'when called from private class' do
<<<<<<< HEAD
    before :each do
      scope.expects(:lookupvar).with('module_name').returns('foo')
      scope.expects(:lookupvar).with('caller_module_name').returns('bar')
    end

    it 'fails with a class error message' do
      scope.source.expects(:name).returns('foo::baz')
      scope.source.expects(:type).returns('hostclass')
=======
    it 'fails with a class error message' do
      expect(scope).to receive(:lookupvar).with('module_name').and_return('foo')
      expect(scope).to receive(:lookupvar).with('caller_module_name').and_return('bar')
      expect(scope.source).to receive(:name).and_return('foo::baz')
      expect(scope.source).to receive(:type).and_return('hostclass')
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8

      is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Class foo::baz is private})
    end

<<<<<<< HEAD
    context 'with an explicit failure message' do
      it { is_expected.to run.with_params('failure message!').and_raise_error(Puppet::ParseError, %r{failure message!}) }
=======
    it 'fails with an explicit failure message' do
      is_expected.to run.with_params('failure message!').and_raise_error(Puppet::ParseError, %r{failure message!})
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    end
  end

  context 'when called from private definition' do
    it 'fails with a class error message' do
<<<<<<< HEAD
      scope.expects(:lookupvar).with('module_name').returns('foo')
      scope.expects(:lookupvar).with('caller_module_name').returns('bar')
      scope.source.expects(:name).returns('foo::baz')
      scope.source.expects(:type).returns('definition')
=======
      expect(scope).to receive(:lookupvar).with('module_name').and_return('foo')
      expect(scope).to receive(:lookupvar).with('caller_module_name').and_return('bar')
      expect(scope.source).to receive(:name).and_return('foo::baz')
      expect(scope.source).to receive(:type).and_return('definition')
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8

      is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Definition foo::baz is private})
    end
  end
end
