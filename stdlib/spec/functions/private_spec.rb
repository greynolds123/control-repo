require 'spec_helper'

describe 'private' do
  it 'issues a warning' do
<<<<<<< HEAD
    scope.expects(:warning).with("private() DEPRECATED: This function will cease to function on Puppet 4; please use assert_private() before upgrading to puppet 4 for backwards-compatibility, or migrate to the new parser's typing system.") # rubocop:disable Metrics/LineLength : unable to cut line to required length
    begin
      subject.call []
=======
    expect(scope).to receive(:warning).with("private() DEPRECATED: This function will cease to function on Puppet 4; please use assert_private() before upgrading to puppet 4 for backwards-compatibility, or migrate to the new parser's typing system.") # rubocop:disable Metrics/LineLength : unable to cut line to required length
    begin
      subject.execute
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    rescue # rubocop:disable Lint/HandleExceptions
      # ignore this
    end
  end

  context 'when called from inside module' do
    it 'does not fail' do
<<<<<<< HEAD
      scope.expects(:lookupvar).with('module_name').returns('foo')
      scope.expects(:lookupvar).with('caller_module_name').returns('foo')
      expect {
        subject.call []
=======
      expect(scope).to receive(:lookupvar).with('module_name').and_return('foo')
      expect(scope).to receive(:lookupvar).with('caller_module_name').and_return('foo')
      expect {
        subject.execute
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      }.not_to raise_error
    end
  end

  context 'with an explicit failure message' do
    it 'prints the failure message on error' do
<<<<<<< HEAD
      scope.expects(:lookupvar).with('module_name').returns('foo')
      scope.expects(:lookupvar).with('caller_module_name').returns('bar')
      expect {
        subject.call ['failure message!']
      }.to raise_error Puppet::ParseError, %r{failure message!}
=======
      expect(scope).to receive(:lookupvar).with('module_name').and_return('foo')
      expect(scope).to receive(:lookupvar).with('caller_module_name').and_return('bar')
      expect {
        subject.execute('failure message!')
      }.to raise_error(Puppet::ParseError, %r{failure message!})
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    end
  end

  context 'when called from private class' do
    it 'fails with a class error message' do
<<<<<<< HEAD
      scope.expects(:lookupvar).with('module_name').returns('foo')
      scope.expects(:lookupvar).with('caller_module_name').returns('bar')
      scope.source.expects(:name).returns('foo::baz')
      scope.source.expects(:type).returns('hostclass')
      expect { subject.call [] }.to raise_error Puppet::ParseError, %r{Class foo::baz is private}
=======
      expect(scope).to receive(:lookupvar).with('module_name').and_return('foo')
      expect(scope).to receive(:lookupvar).with('caller_module_name').and_return('bar')
      expect(scope.source).to receive(:name).and_return('foo::baz')
      expect(scope.source).to receive(:type).and_return('hostclass')
      expect { subject.execute }.to raise_error(Puppet::ParseError, %r{Class foo::baz is private})
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    end
  end

  context 'when called from private definition' do
    it 'fails with a class error message' do
<<<<<<< HEAD
      scope.expects(:lookupvar).with('module_name').returns('foo')
      scope.expects(:lookupvar).with('caller_module_name').returns('bar')
      scope.source.expects(:name).returns('foo::baz')
      scope.source.expects(:type).returns('definition')
      expect { subject.call [] }.to raise_error Puppet::ParseError, %r{Definition foo::baz is private}
=======
      expect(scope).to receive(:lookupvar).with('module_name').and_return('foo')
      expect(scope).to receive(:lookupvar).with('caller_module_name').and_return('bar')
      expect(scope.source).to receive(:name).and_return('foo::baz')
      expect(scope.source).to receive(:type).and_return('definition')
      expect { subject.execute }.to raise_error(Puppet::ParseError, %r{Definition foo::baz is private})
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    end
  end
end
