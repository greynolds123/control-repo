require 'spec_helper'

<<<<<<< HEAD
describe 'chomp' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError) }
=======
describe 'chomp', :if => Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') < 0 do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Wrong number of arguments given}) }
  it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, %r{Requires either array or string}) }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  it {
    pending('Current implementation ignores parameters after the first.')
    is_expected.to run.with_params('a', 'b').and_raise_error(Puppet::ParseError)
  }
  it { is_expected.to run.with_params('one').and_return('one') }
  it { is_expected.to run.with_params("one\n").and_return('one') }
  it { is_expected.to run.with_params("one\n\n").and_return("one\n") }
<<<<<<< HEAD
  it { is_expected.to run.with_params(%W[one\n two three\n]).and_return(%w[one two three]) }
=======
  it { is_expected.to run.with_params(["one\n", 'two', "three\n"]).and_return(['one', 'two', 'three']) }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c

  it { is_expected.to run.with_params(AlsoString.new('one')).and_return('one') }
  it { is_expected.to run.with_params(AlsoString.new("one\n")).and_return('one') }
  it { is_expected.to run.with_params(AlsoString.new("one\n\n")).and_return("one\n") }
<<<<<<< HEAD
  it { is_expected.to run.with_params([AlsoString.new("one\n"), AlsoString.new('two'), "three\n"]).and_return(%w[one two three]) }
=======
  it { is_expected.to run.with_params([AlsoString.new("one\n"), AlsoString.new('two'), "three\n"]).and_return(['one', 'two', 'three']) }

  it { is_expected.to run.with_params([1, 2, 3]).and_return([1, 2, 3]) }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c

  context 'with UTF8 and double byte characters' do
    it { is_expected.to run.with_params("ůťƒ8\n\n").and_return("ůťƒ8\n") }
    it { is_expected.to run.with_params("ネット\n\n").and_return("ネット\n") }
  end
end