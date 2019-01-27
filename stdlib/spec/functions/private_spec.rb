require 'spec_helper'

describe 'private' do
<<<<<<< HEAD
  it 'should issue a warning' do
    scope.expects(:warning).with("private() DEPRECATED: This function will cease to function on Puppet 4; please use assert_private() before upgrading to puppet 4 for backwards-compatibility, or migrate to the new parser's typing system.")
    begin
      subject.call []
    rescue
=======
  it 'issues a warning' do
    scope.expects(:warning).with("private() DEPRECATED: This function will cease to function on Puppet 4; please use assert_private() before upgrading to puppet 4 for backwards-compatibility, or migrate to the new parser's typing system.") # rubocop:disable Metrics/LineLength : unable to cut line to required length
    begin
      subject.call []
    rescue # rubocop:disable Lint/HandleExceptions
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      # ignore this
    end
  end

<<<<<<< HEAD
  context "when called from inside module" do
    it "should not fail" do
=======
  context 'when called from inside module' do
    it 'does not fail' do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      scope.expects(:lookupvar).with('module_name').returns('foo')
      scope.expects(:lookupvar).with('caller_module_name').returns('foo')
      expect {
        subject.call []
      }.not_to raise_error
    end
  end

<<<<<<< HEAD
  context "with an explicit failure message" do
    it "prints the failure message on error" do
=======
  context 'with an explicit failure message' do
    it 'prints the failure message on error' do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      scope.expects(:lookupvar).with('module_name').returns('foo')
      scope.expects(:lookupvar).with('caller_module_name').returns('bar')
      expect {
        subject.call ['failure message!']
<<<<<<< HEAD
      }.to raise_error Puppet::ParseError, /failure message!/
    end
  end

  context "when called from private class" do
    it "should fail with a class error message" do
=======
      }.to raise_error Puppet::ParseError, %r{failure message!}
    end
  end

  context 'when called from private class' do
    it 'fails with a class error message' do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      scope.expects(:lookupvar).with('module_name').returns('foo')
      scope.expects(:lookupvar).with('caller_module_name').returns('bar')
      scope.source.expects(:name).returns('foo::baz')
      scope.source.expects(:type).returns('hostclass')
<<<<<<< HEAD
      expect {
        subject.call []
      }.to raise_error Puppet::ParseError, /Class foo::baz is private/
    end
  end

  context "when called from private definition" do
    it "should fail with a class error message" do
=======
      expect { subject.call [] }.to raise_error Puppet::ParseError, %r{Class foo::baz is private}
    end
  end

  context 'when called from private definition' do
    it 'fails with a class error message' do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      scope.expects(:lookupvar).with('module_name').returns('foo')
      scope.expects(:lookupvar).with('caller_module_name').returns('bar')
      scope.source.expects(:name).returns('foo::baz')
      scope.source.expects(:type).returns('definition')
<<<<<<< HEAD
      expect {
        subject.call []
      }.to raise_error Puppet::ParseError, /Definition foo::baz is private/
=======
      expect { subject.call [] }.to raise_error Puppet::ParseError, %r{Definition foo::baz is private}
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
    end
  end
end
