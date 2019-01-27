require 'spec_helper'

describe 'get_module_path' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /Wrong number of arguments, expects one/) }
  it { is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError, /Wrong number of arguments, expects one/) }
  it { is_expected.to run.with_params('one', 'two', 'three').and_raise_error(Puppet::ParseError, /Wrong number of arguments, expects one/) }
  it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError, /Could not find module/) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Wrong number of arguments, expects one}) }
  it { is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError, %r{Wrong number of arguments, expects one}) }
  it { is_expected.to run.with_params('one', 'two', 'three').and_raise_error(Puppet::ParseError, %r{Wrong number of arguments, expects one}) }
  it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError, %r{Could not find module}) }
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19

  class StubModule
    attr_reader :path
    def initialize(path)
      @path = path
    end
  end

  describe 'when locating a module' do
<<<<<<< HEAD
    let(:modulepath) { "/tmp/does_not_exist" }
    let(:path_of_module_foo) { StubModule.new("/tmp/does_not_exist/foo") }

    before(:each) { Puppet[:modulepath] = modulepath }

    context 'in the default environment' do
=======
    let(:modulepath) { '/tmp/does_not_exist' }
    let(:path_of_module_foo) { StubModule.new('/tmp/does_not_exist/foo') }

    before(:each) { Puppet[:modulepath] = modulepath }

    context 'when in the default environment' do
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      before(:each) { Puppet::Module.expects(:find).with('foo', 'rp_env').returns(path_of_module_foo) }

      it { is_expected.to run.with_params('foo').and_return(path_of_module_foo.path) }

      context 'when the modulepath is a list' do
        before(:each) { Puppet[:modulepath] = modulepath + 'tmp/something_else' }

        it { is_expected.to run.with_params('foo').and_return(path_of_module_foo.path) }
      end
    end

<<<<<<< HEAD
    context 'in a non-default default environment' do
      let(:environment) { 'test' }
=======
    context 'when in a non-default default environment' do
      let(:environment) { 'test' }

>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
      before(:each) { Puppet::Module.expects(:find).with('foo', 'test').returns(path_of_module_foo) }

      it { is_expected.to run.with_params('foo').and_return(path_of_module_foo.path) }

      context 'when the modulepath is a list' do
        before(:each) { Puppet[:modulepath] = modulepath + 'tmp/something_else' }

        it { is_expected.to run.with_params('foo').and_return(path_of_module_foo.path) }
      end
    end
  end
end
