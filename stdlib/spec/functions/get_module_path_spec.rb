require 'spec_helper'

describe 'get_module_path' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Wrong number of arguments, expects one}) }
  it { is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError, %r{Wrong number of arguments, expects one}) }
  it { is_expected.to run.with_params('one', 'two', 'three').and_raise_error(Puppet::ParseError, %r{Wrong number of arguments, expects one}) }
  it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError, %r{Could not find module}) }

<<<<<<< HEAD
=======
  # class Stubmodule
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  class StubModule
    attr_reader :path
    def initialize(path)
      @path = path
    end
  end

  describe 'when locating a module' do
    let(:modulepath) { '/tmp/does_not_exist' }
    let(:path_of_module_foo) { StubModule.new('/tmp/does_not_exist/foo') }

<<<<<<< HEAD
    before(:each) { Puppet[:modulepath] = modulepath }

    context 'when in the default environment' do
      before(:each) { Puppet::Module.expects(:find).with('foo', 'rp_env').returns(path_of_module_foo) }

      it { is_expected.to run.with_params('foo').and_return(path_of_module_foo.path) }

      context 'when the modulepath is a list' do
        before(:each) { Puppet[:modulepath] = modulepath + 'tmp/something_else' }

        it { is_expected.to run.with_params('foo').and_return(path_of_module_foo.path) }
=======
    before(:each) do
      Puppet[:modulepath] = modulepath
    end

    context 'when in the default environment' do
      before(:each) do
        allow(Puppet::Module).to receive(:find).with('foo', 'rp_env').and_return(path_of_module_foo)
      end
      it 'runs against foo' do
        is_expected.to run.with_params('foo').and_return(path_of_module_foo.path)
      end

      it 'when the modulepath is a list' do
        Puppet[:modulepath] = modulepath + 'tmp/something_else'

        is_expected.to run.with_params('foo').and_return(path_of_module_foo.path)
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      end
    end

    context 'when in a non-default default environment' do
      let(:environment) { 'test' }

<<<<<<< HEAD
      before(:each) { Puppet::Module.expects(:find).with('foo', 'test').returns(path_of_module_foo) }

      it { is_expected.to run.with_params('foo').and_return(path_of_module_foo.path) }

      context 'when the modulepath is a list' do
        before(:each) { Puppet[:modulepath] = modulepath + 'tmp/something_else' }

        it { is_expected.to run.with_params('foo').and_return(path_of_module_foo.path) }
=======
      before(:each) do
        allow(Puppet::Module).to receive(:find).with('foo', 'test').and_return(path_of_module_foo)
      end
      it 'runs against foo' do
        is_expected.to run.with_params('foo').and_return(path_of_module_foo.path)
      end

      it 'when the modulepath is a list' do
        Puppet[:modulepath] = modulepath + 'tmp/something_else'
        is_expected.to run.with_params('foo').and_return(path_of_module_foo.path)
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
      end
    end
  end
end
