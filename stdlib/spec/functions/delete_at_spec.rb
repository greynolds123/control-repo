require 'spec_helper'

describe 'delete_at' do
  it { is_expected.not_to eq(nil) }
<<<<<<< HEAD
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params('one', 1).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(1, 1).and_raise_error(Puppet::ParseError) }
  it { is_expected.to run.with_params(['one'], 'two').and_raise_error(Puppet::ParseError) }
=======
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Wrong number of arguments}) }
  it { is_expected.to run.with_params('one', 1).and_raise_error(Puppet::ParseError, %r{Requires array}) }
  it { is_expected.to run.with_params(1, 1).and_raise_error(Puppet::ParseError, %r{Requires array}) }
  it { is_expected.to run.with_params(['one'], 'two').and_raise_error(Puppet::ParseError, %r{You must provide non-negative numeric}) }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  it {
    pending('Current implementation ignores parameters after the first two.')
    is_expected.to run.with_params(['one'], 0, 1).and_raise_error(Puppet::ParseError)
  }

  describe 'argument validation' do
<<<<<<< HEAD
    it { is_expected.to run.with_params([0, 1, 2], 3).and_raise_error(Puppet::ParseError) }
=======
    it { is_expected.to run.with_params([0, 1, 2], 3).and_raise_error(Puppet::ParseError, %r{Given index exceeds size of array}) }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
  end

  it { is_expected.to run.with_params([0, 1, 2], 1).and_return([0, 2]) }
  it { is_expected.to run.with_params([0, 1, 2], -1).and_return([0, 1]) }
  it { is_expected.to run.with_params([0, 1, 2], -4).and_return([0, 1, 2]) }
<<<<<<< HEAD
  it { is_expected.to run.with_params(%w[ƒờở βāř ьầż], 1).and_return(%w[ƒờở ьầż]) }
=======
  it { is_expected.to run.with_params(['ƒờở', 'βāř', 'ьầż'], 1).and_return(['ƒờở', 'ьầż']) }
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c

  it 'leaves the original array intact' do
    argument = [1, 2, 3]
    original = argument.dup
<<<<<<< HEAD
    _result = subject.call([argument, 2])
=======
    _result = subject.execute(argument, 2)
>>>>>>> 1de4402b3b517d4a5ec3b988913cd26786d0111c
    expect(argument).to eq(original)
  end
end
