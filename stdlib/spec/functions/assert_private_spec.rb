require 'spec_helper'

describe 'assert_private' do
  context 'when called from inside module' do
<<<<<<< HEAD
    it "should not fail" do
      scope.expects(:lookupvar).with('module_name').returns('foo')
      scope.expects(:lookupvar).with('caller_module_name').returns('foo')

      is_expected.to run.with_params()
    end
  end

  context "when called from private class" do
=======
    it 'does not fail' do
      scope.expects(:lookupvar).with('module_name').returns('foo')
      scope.expects(:lookupvar).with('caller_module_name').returns('foo')

      is_expected.to run.with_params
    end
  end

  context 'when called from private class' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    before :each do
      scope.expects(:lookupvar).with('module_name').returns('foo')
      scope.expects(:lookupvar).with('caller_module_name').returns('bar')
    end

<<<<<<< HEAD
    it "should fail with a class error message" do
      scope.source.expects(:name).returns('foo::baz')
      scope.source.expects(:type).returns('hostclass')

      is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /Class foo::baz is private/)
    end

    context "with an explicit failure message" do
      it { is_expected.to run.with_params('failure message!').and_raise_error(Puppet::ParseError, /failure message!/) }
    end
  end

  context "when called from private definition" do
    it "should fail with a class error message" do
=======
    it 'fails with a class error message' do
      scope.source.expects(:name).returns('foo::baz')
      scope.source.expects(:type).returns('hostclass')

      is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Class foo::baz is private})
    end

    context 'with an explicit failure message' do
      it { is_expected.to run.with_params('failure message!').and_raise_error(Puppet::ParseError, %r{failure message!}) }
    end
  end

  context 'when called from private definition' do
    it 'fails with a class error message' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
      scope.expects(:lookupvar).with('module_name').returns('foo')
      scope.expects(:lookupvar).with('caller_module_name').returns('bar')
      scope.source.expects(:name).returns('foo::baz')
      scope.source.expects(:type).returns('definition')

<<<<<<< HEAD
      is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /Definition foo::baz is private/)
=======
      is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Definition foo::baz is private})
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    end
  end
end
